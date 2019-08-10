# How to install - :apple: OS

## Homebrew: A Mac's package manager :package:

Most of the Unix-based systems have a package manager to install libraries, or
even GUI software. Nonetheless, Mac does not have a native package manager,
Homebrew fills this gap and will make your life easier, even for other tasks
beyond library installation.   

To install [Homebrew][1], run this line in your terminal: 
``` 
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
```

With Homebrew installed you can use its different formulas (in Homebrew
parlance) to install programs and libraries, like: `brew install
[library-or-package]`:

 - Git (installed by default in Mac, but run `xcode-select --install` to update
   git, install compilers and other GNU tools). 
 - psql: `brew install psql`
 - Python: `brew install python3` (MacOS includes Python, but that is the system
   Python and it's better not to mess with it). 
 - R: `brew install r`

But Homebrew is not limited to libraries, it also handles other common programs,
like Chrome, or Spotify. You can use it to install other useful tools:
 
 - Sublime Text: `brew cask install sublime-text`
 - RStudio: `brew cask install rstudio`
 - DBeaver: `brew tap caskroom/versions; brew cask install dbeaver-community`
 
Homebrew does not install this libraries directly to the Applications folder, it
rather symlink them from the `/opt/homebrew-cask/Caskroom` path to the
`/Applications` directory. Same happens with the installed libraries, but these
are symlink'd from `/usr/local/Cellar` to `/usr/local/bin`. This is helpful
because we can alternate between different library versions (see `brew switch`)

## Python :snake: environment tools

Different python versions imply different library availability and python new
functionalities. Working in different projects not only involves different
versions of Python, but also several different libraries versions. Not being
careful with Python installations can lead to ugly scenarios where [we cannot
control the python version we are running][6]. 

To avoid this, we have a myriad of options depending on the user expertise
level.

_Another reason of why having environments is a good idea is for_
_reproducibility. We want your code to run successfully in any machine, and_
_having the right libraries is pivotal to this._

### 1. Anaconda (for beginners)

Anaconda's Python distribution includes a handy environment manager called
`conda`. Conda is able to take care of different aspects of our environment,
like Python version and the libraries that the environment should have. 

 - Installation [instructions][2] 
 - [Documentation][3]

Once installed, you can create a new virtual environment (`my_new_env`) with all
the requested libraries in the `requirements.txt`: 

```
conda env install -n my_new_env -f requirements.txt
```

Another neat feature of Conda is the existence of its own libraries manager that
serves as an alternative to `pip`. Just as Python's builtin libraries manager,
conda can install any package in the conda distribution:

```
conda install <your package name here>. 
```

This package manager has some advantages over `pip`. First, conda relies on its
own compilers, hence it facilitates the installation of packages that need
C compilers (although, you will need to install `gcc` via Brew) and with other
ugly dependencies. Second, it has _faster_ mathematical libraries like `numpy`
since uses BLAS for compilling (faster linear algebra operation in the processor
for Intel processors). Third, it also gives a more intuitive use of package
installation. 

Nonetheless, not all packages available via `pip` are in `conda`, so you will
have you use `pip` and probably face some small conflicts (this is rare). 


### 2. Miniconda (for beginners without much space disk left)

The Anaconda suite can be a heavy package for some space-limited users. One
available option is Miniconda, a lighter version of Anaconda which also includes
the environment manager `conda`.

 - Installation [instructions][4]


### 3. `pyenv` + `virtualenv` (only if you live dangerously)

If you do not want to use Condas's Python distribution, you can manage your
environments using `pyenv` and `virtualenv`. To install both you have to use
Homebrew: 

``` 
brew install pyenv
brew install pyenv-virtualenv
```

Once both libraries are installed, the next step is to link both libraries to
let the computer know where are the `pyenv` python versions installed. This can
be done by running this (assuming you use bash): 

```
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash-profile
```

 - [Instructions][5]

`pyenv` is a powerful library that has a lot of options, it is versatile and
allow a smooth deployment. Although, sometimes is hard to use, and is not very
friendly during development. `pip` + `virtualenv`, both Python libraries is
other available option.  

[1]:https://brew.sh 

[2]:https://docs.anaconda.com/anaconda/install/mac-os/

[3]:https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html

[4]:https://conda.io/en/latest/miniconda.html

[5]: https://github.com/pyenv/pyenv-virtualenv

[6]: https://xkcd.com/1987/
