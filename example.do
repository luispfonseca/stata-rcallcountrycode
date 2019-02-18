cap program drop rcallcountrycode
qui do rcallcountrycode.ado

clear

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

* clean up the country name
rcallcountrycode country, from(country.name) to(country.name) gen(countryname_en) marker

* get the ISO2 country codes
rcallcountrycode country, from(country.name) to(iso2c) gen(iso3code)

* get the country names in german
rcallcountrycode country, from(country.name) to(country.name.de) gen(countryname_de)

* get list of available codes from R
rcallcountrycode codelist


*** syntax errors and warnings ***
drop marker
* calling codelist with options (should ignore all the options, don't call errors)
* when no variable codelist exists
cap noi rcallcountrycode codelist, from(country.name) to(country.name) gen(noname)
assert c(rc) == 0
* when variable codelist exists
gen codelist = ""
cap noi rcallcountrycode codelist, from(country.name) to(country.name) gen(noname)
assert c(rc) == 198

* calling 2 variables
gen othervar = ""
cap noi rcallcountrycode country othervar, from(country.name) to(country.name) gen(noname)
assert c(rc) == 103

* calling no variable
cap noi rcallcountrycode , from(country.name) to(country.name) gen(noname)
assert c(rc) == 100

* calling no options and only some
cap noi rcallcountrycode country
assert c(rc) == 198
cap noi rcallcountrycode country, from(country.name)
assert c(rc) == 198
cap noi rcallcountrycode country, from(country.name) to(country.name)
assert c(rc) == 198
cap noi rcallcountrycode country, gen(noname) marker
assert c(rc) == 198

* existing variable in generate
cap noi rcallcountrycode country, from(country.name) to(country.name) gen(othervar)
assert c(rc) == 198

* conflict with marker name
gen marker = ""
cap noi rcallcountrycode country, from(country.name) to(country.name) gen(noname) marker
assert c(rc) == 198


