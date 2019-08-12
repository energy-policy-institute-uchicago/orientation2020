#!/bin/bash


cat <<EOF
                                                                ..
    .eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$$$$$                 .d$$e.
    4$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.          .$$$$*
    4$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$e.     z$$$$*"
    4$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   d$$$$$$$F
    4$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$d$$$$$$$*
    4$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    ^$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F""
     4$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F
    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F
     ^*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
        *$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
         ^*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
             *$$$P***$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$P
                       "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$L
                         "" "$$$$$$$$$$$$$$$$"""   ^"$$$.
                              "$$$$*"     ""         *$$$F
                                "P"                   "*$$
                                                        ^"* 
.##..##...####............####....####...##..##..##..##..######..##..##......... 
.##..##..##..............##..##..##..##..##..##..###.##....##.....####.......... 
.##..##...####...........##......##..##..##..##..##.###....##......##........... 
.##..##......##..........##..##..##..##..##..##..##..##....##......##........... 
..####....####............####....####....####...##..##....##......##........... 
................................................................................ 
.#####....####...##...##..##..##..##.......####....####...#####...######..#####..
.##..##..##..##..##...##..###.##..##......##..##..##..##..##..##..##......##..##.
.##..##..##..##..##.#.##..##.###..##......##..##..######..##..##..####....#####..
.##..##..##..##..#######..##..##..##......##..##..##..##..##..##..##......##..##.
.#####....####....##.##...##..##..######...####...##..##..#####...######..##..##.
.................................................................................
                                                                                                                  
EOF

##############################################################################
############ DOWNLOAD CONTINENTAL US DATA FROM US CENSUS BUREAU ##############
# This bash script file will download shapelile data from the US Census Bureau
# and the NREL solar data stations. The used link will get all county data with 
# a 20-m resolution. 
# 
# If it does not exists, the script will create a /data folder in the $pwd 
# (where you are running this code). All data will be stored there. Once files 
# are stored locally they are stored to SQL using a $DBURL and a $SCHEMA_NAME.
#
# IMPORTANT: The $DBURL is a environment variable that must be defined in the 
# .bashrc (.bash-profile, you mac people or .zshrc, you cool people). The URL
# can be defined like this in you configuration: 
# export DBURL="postgres://[user]:[pass]@[host]:[port]/[dbname]"
##############################################################################

DBURL="postgresql://newbies:174Tl6rBBrohpgJ5BFsN4b7CnoGbxh@localhost:9000/orientation2019"
PWD=$(pwd)
RUN_DB="psql $DBURL"
SCHEMA="us_geoms_raw_data"

# Create /data directory if it does not exist in path
if [[ ! -d $PWD/data ]]
then 
    mkdir $PWD/data
fi

# Dowload geographical data
wget -P data http://www2.census.gov/geo/tiger/GENZ2017/shp/cb_2017_us_county_20m.zip 

# Extract anything that it is compressed (zip) - recusively. 
for FILE in $PWD/data/*.zip
do
    unzip $FILE -d $PWD/data
done

# Upload to SQL: Create table schema

$RUN_DB -c "DROP SCHEMA IF EXISTS $SCHEMA CASCADE; CREATE SCHEMA $SCHEMA;" 

# Upload to SQL: Create ddl's statements 

if [[ ! -d $PWD/data/ddl ]]
then 
    mkdir -p $PWD/data/ddl
fi

SQL_DIR=$PWD/data/ddl

for FILE in $PWD/data/*.csv
do
    cat $FILE | cut -d ',' -f 1-5 | tr '\r' ' '  > $PWD/data/$(basename "$FILE" .csv)_corrected.csv
    cat  $PWD/data/$(basename "$FILE" .csv)_corrected.csv | csvsql -i postgresql --tables $(basename "$FILE" .csv)_corrected --no-constraints --db-schema $SCHEMA >> $SQL_DIR/table_schema_$(basename "$FILE" .csv).sql
    rm $FILE
done

for FILE in $PWD/data/*.shp
do
    shp2pgsql -w -s 4269  "$FILE" "$SCHEMA.$(basename "$FILE" .shp)" postgres >> $SQL_DIR/table_schema_$(basename "$FILE" .csv).sql

done

# Upload to SQL: Create table

for FILE in $SQL_DIR/*.sql
do
    $RUN_DB -f $FILE
done

# Upload to SQL: Populate tables

for FILE in $PWD/data/*.csv
do
    cat $FILE | $RUN_DB -c "\copy "$SCHEMA.$(basename "$FILE" .csv )" FROM STDIN WITH CSV HEADER DELIMITER ','"

done 


