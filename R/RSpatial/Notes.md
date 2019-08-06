## Powerpoint Outline

* Slide 1: Before `sf` - Predating the simple features package, spatial vector data in package `sp` is difficult to work with by its S4 nature, where objects store spatial geometries separately from associated attribute data, matching by order. The `sp` implementation is hard to maintain because it contains incremental changes from a baseline that predated the industry-standard (simple features). 
* Slide 2: Simple features is a standard interface for access and manipulation of spatial vector data (points, lines, polygons). Tidy data is defined as 
   1. Each variable forms a column
   2. Each observation forms a row
   3. Each type of observational unit forms a table
   Tidy rule for simple feature means each feature forms a row.  asingle column contains the geometry for each observation, thereby representing the spatial feature in a classic tidy dataframe. 
* Slide 3: reading in and basic shaping
   * Types of geometries
   * Coordinate reference system
* Slide 4: logical binary geometry predicates - st_intersects, st_disjoint, etc
* slide 5: Higher level - summarise, interpolate, st_join
* Slide 6: Manipulating geometries
* Slide 7: Use the vignette and Github issues


TO DO
* Explain what geometries are and the different types
* Explain what rasters are

What do we want to do:
1. Learn what is available
   * https://github.com/edzer/UseR2017/blob/master/tutorial.Rmd
   * `methods("sf")`
      * reading in and basic shaping (st_as_sf, as(x, "Spatial"))
      * logical binary geometry predicates - st_intersects, st_disjoint, etc
      * geometry generating logical operators - st_intersection etc
      * higher level - summarise, interpolate, st_join
      * manipulating geometries
   * simple features vignette
   * simple features Github issues

http://www.maths.lancs.ac.uk/~rowlings/Teaching/UseR2012/crime.html crime
http://www.rspatial.org/cases/rst/3-speciesdistribution.html wild potatoes
