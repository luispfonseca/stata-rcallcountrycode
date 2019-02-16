# RCALLCOUNTRYCODE: Call R's countrycode package from Stata using rcall
- Current version: 0.1.0 16feb2019
- Contents: [`updates`](#updates) [`description`](#description) [`install`](#install) [`usage`](#usage) [`to do`](#to-do) [`author`](#author)

-----------

## Updates
* **0.1.0 16feb2019**:
	- first version of the command

## Description
This command uses [`rcall`](https://github.com/haghish/rcall) to call R's [`countrycode`](https://github.com/vincentarelbundock/countrycode). It is a substitute for the [`kountry`](http://fmwww.bc.edu/repec/bocode/k/kountry.html) package from SSC.

I'd like to thank the authors of both packages:
* [`countrycode`](https://github.com/vincentarelbundock/countrycode) was written by [Vincent Arel-Bundock](http://arelbundock.com/), [Nils Enevoldsen](https://nilsenevoldsen.com/), and [CJ Yetman](cjyetman.com).
* [`rcall`](https://github.com/haghish) was written by [E. F. Haghish](http://www.haghish.com/)

There are a few advantages to using `rcallcountrycode` relative to `kountry`:

* it gets the functionalities of [`countrycode`](https://github.com/vincentarelbundock/countrycode) for R, which might have broader and more up-to-date coverage on country names in different formats and languages
* it scales well with the size of the dataset. 
	* Because it asks R to convert only the unique strings in the dataset (which should not exceed the number of countries in the world in most use cases), applying it to a dataset of 200 or 200000 observations makes little difference. The current version of `kountry` does not scale well in large datasets.

The main disadvantage is that `rcallcountrycode` requires additional dependencies, while `kountry` can be run directly after installing it from SSC without any additional work.

## Install
```
cap ado uninstall rcallcountrycode
net install rcallcountrycode, from("https://raw.githubusercontent.com/luispfonseca/stata-rcallcountrycode/master/")
```

Alternatively, if you have installed [haghish's github package for stata](https://github.com/haghish/github), just execute:
```
github install luispfonseca/stata-rcallcountrycode
```

### Dependencies
For this command to work, you need the following:

#### R
You need to have R installed. You can download RStudio [here](https://www.rstudio.com/products/rstudio/download/), which will install R on your computer and give you a graphical interface. 

You also need to install [`countrycode`](https://github.com/vincentarelbundock/countrycode). Follow the instructions in that page:

> From the R console, type `install.packages("countrycode")`

#### Stata
Install [`rcall`](https://github.com/haghish/rcall) following the instructions in that page. The following commands currently work:
```
net install github, from("https://haghish.github.io/github/") replace
gitget rcall
```

Some commands from [`gtools`](https://github.com/mcaceresb/stata-gtools) by Mauricio Caceres Bravo and [`ftools`](https://github.com/sergiocorreia/ftools) by Sergio Correia are used to speed up the command when available. Follow the instructions in their pages to install them, especially if you are dealing with large datasets.

## Usage
```
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
"not a real country"
end
compress

* clean up the country name
rcallcountrycode country, from(country.name) to(country.name) gen(countryname_en) marker

* get the ISO3 country codes
rcallcountrycode country, from(country.name) to(iso3c) gen(iso3code)

* get the country names in german
rcallcountrycode country, from(country.name) to(country.name.de) gen(countryname_de)
```

## To do:
* Write help file
* Provide better diagnostics for non-matches

## Author
Luís Fonseca
<br>London Business School
<br>lfonseca london edu
<br>https://luispfonseca.com
