# RCALLCOUNTRYCODE: Call R's countrycode package from Stata using rcall
- Current version: 0.1.9 16jul2019
- Contents: [`updates`](#updates) [`description`](#description) [`install`](#install) [`usage`](#usage) [`to do`](#to-do) [`author`](#author)

-----------

## Updates
* **0.1.9 13jun2019**  
(Since 0.1.0):
	- bug fixes for encoding issues, diacritics
	- handles moving of data with R package [`haven`](https://github.com/tidyverse/haven)
	- improved error checking and handling
	- adds codelist option to get available codes from `countrycode`
	- set default arguments for options `from`, `to` and `gen`
* **0.1.0 16feb2019**:
	- first version of the command

## Description
This command uses [`rcall`](https://github.com/haghish/rcall) to call R's [`countrycode`](https://github.com/vincentarelbundock/countrycode). It is a substitute for the [`kountry`](http://fmwww.bc.edu/repec/bocode/k/kountry.html) package from SSC.

I'd like to thank the authors of both packages:
* [`countrycode`](https://github.com/vincentarelbundock/countrycode) was written by [Vincent Arel-Bundock](http://arelbundock.com/), [Nils Enevoldsen](https://nilsenevoldsen.com/), and [CJ Yetman](https://github.com/cjyetman).
* [`rcall`](https://github.com/haghish) was written by [E. F. Haghish](http://www.haghish.com/)

There are a few advantages to using `rcallcountrycode` relative to `kountry`:

* it gets the functionalities of [`countrycode`](https://github.com/vincentarelbundock/countrycode) for R, which has a broader and more up-to-date coverage on country names in different formats and languages
* it scales well with the size of the dataset. See the benchmark ([Win7](benchmark/benchmark.log)/[Linux](benchmark/benchmark_linux.log)) for a comparison between `rcallcountrycode` and `kountry`. 
	* Because it asks R to convert only the unique strings in the dataset (which should not exceed the number of countries in the world in most use cases), applying it to a dataset of 200 or 200000 observations makes little difference. The current version of `kountry` does not scale well in large datasets. 
	* In the current benchmark (v0.1.5), I add repeated country names 2000 times to a list of 196 countries.  `rcallcountrycode`, which is much slower in the small dataset, only takes around 10%/50% (Win7/Linux) longer to run in the larger dataset. `kountry` takes 1000+ *times* longer than it does in the small dataset. 

|              Machine             |        Dataset       | `rcallcountrycode` | `kountry` |
|:--------------------------------:|:--------------------:|:------------------:|:---------:|
|  Win 7, 4-core 3.60GHz, 32GB RAM |     196 countries    |      4.09 sec      |  0.02 sec |
|  Win 7, 4-core 3.60GHz, 32GB RAM | 196 countries x 2000 |      4.54 sec      | 17.88 sec |
| Ubuntu, 2-core 2.20GHz, 16GB RAM |     196 countries    |      1.44 sec      |  0.01 sec |
| Ubuntu, 2-core 2.20GHz, 16GB RAM | 196 countries x 2000 |      2.19 sec      | 21.27 sec |

The main disadvantage is that `rcallcountrycode` requires additional dependencies, while `kountry` can be run directly after installing it from SSC without any additional work.

## Install

### Easier
1. Install R first (see below how)
2. Install [`rcall`](https://github.com/haghish/rcall) with the method recommended by its author: install the [`github`](https://github.com/haghish/github) package for Stata and then install `rcall`:
```
net install github, from("https://haghish.github.io/github/") replace
gitget rcall
```
3. Install `rcallcountrycode`:
```
github install luispfonseca/stata-rcallcountrycode
```
These steps should take care of all the dependencies automatically.

### Harder
1. Install R first (see below how)
2. Install this package:
```
cap ado uninstall rcallcountrycode
local github "https://raw.githubusercontent.com"
net install rcallcountrycode, from(`github'/luispfonseca/stata-rcallcountrycode/master/)
```
3. Make sure you install all the dependencies

### Dependencies
For this command to work, you need the following:

#### R
You need to have R installed. You can download RStudio [here](https://www.rstudio.com/products/rstudio/download/), which will install R on your computer and give you a graphical interface. 

If you are not using `github install` to install `rcallcountrycode`, you also need to install the [`countrycode`](https://github.com/vincentarelbundock/countrycode) and [`haven`](https://github.com/tidyverse/haven) packages in R:
```
install.packages("countrycode")
install.packages("haven")
```

#### Stata
Install [`rcall`](https://github.com/haghish/rcall) following the instructions in the page. The following commands currently work:
```
net install github, from("https://haghish.github.io/github/") replace
gitget rcall
```

Some commands from [`gtools`](https://github.com/mcaceresb/stata-gtools) by Mauricio Caceres Bravo are used to speed up this command when available, but are not required. Follow the instructions in the link to install, especially if you are dealing with large datasets.

## Usage
``` stata
input str20 country
"portugal"
"united kingdom"
"france"
"italy"
"spain"
"germany"
"germany"
"italy"
"switzerland"
"curaçao"
"côte d'ivoire"
"namibia"
""
"not a real country"
end
compress

* standardize country names stored in a variable named country (both are equivalent)
rcallcountrycode country, gen(countryname_en)
rcallcountrycode country, from(country.name) to(country.name) gen(countryname_en)

* get the ISO2 country codes
rcallcountrycode country, from(country.name) to(iso2c) gen(iso2code)

* get the country names in german
rcallcountrycode country, from(country.name) to(country.name.de) gen(countryname_de)

* get list of available codes from R
rcallcountrycode codelist
```

## To do:
* Provide better diagnostics for non-matches

## Author
Luís Fonseca
<br>London Business School
<br>lfonseca london edu
<br>https://luispfonseca.com
