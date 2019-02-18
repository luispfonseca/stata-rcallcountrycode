cap noi program drop rcallcountrycode
qui do ../rcallcountrycode.ado

log using benchmark.log, replace

which kountry

* list of countries from https://gist.github.com/kalinchernev/486393efcca01623b18d
import delimited list_of_countries.csv, clear varnames(1)
save list_of_countries, replace

timer clear

* doing with a list of countries, each country once, 196 observations
describe, short
timeit 1: qui rcallcountrycode country, from(country.name.en) to(country.name.en) gen(r_name) marker
timeit 2: qui kountry country, from(other) marker
timer list

* compare results. lowercase is rcallcountrycode; uppercase is kountry
tab marker MARKER

* now with the same list, duplicated many times, as in a large dataset
* 392k rows with 196 countries. with gtools and ftools installed
clear
forvalues k = 1/2000 {
	append using list_of_countries
}

* compare results
describe, short
timeit 3: qui rcallcountrycode country, from(country.name.en) to(country.name.en) gen(r_name) marker
timeit 4: qui kountry country, from(other) marker
timer list

* Compare relative performances as dataset increases 2000 times:
di "rcallcountrycode's time of execution increased by a relative factor of"
di r(t3)/r(t1) - 1
di "rcallcountrycode's time of execution increased by a relative factor of"
di r(t4)/r(t2) - 1

log close
