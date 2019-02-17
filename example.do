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
"not a real country"
end
compress

* clean up the country name
rcallcountrycode country, from(country.name) to(country.name) gen(countryname_en) marker

* get the ISO3 country codes
rcallcountrycode country, from(country.name) to(iso3c) gen(iso3code)

* get the country names in german
rcallcountrycode country, from(country.name) to(country.name.de) gen(countryname_de)

* get list of available codes from R
rcallcountrycode codelist
