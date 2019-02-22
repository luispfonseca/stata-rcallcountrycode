{smcl}
{* *! version 0.1.6  20feb2019}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "rcallcountrycode##syntax"}{...}
{viewerjumpto "Description" "rcallcountrycode##description"}{...}
{viewerjumpto "Examples" "rcallcountrycode##examples"}{...}
{title:Title}

{phang}
{bf:rcallcountrycode} {hline 2} Call R's countrycode package from Stata using rcall

{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{opt rcallcountrycode} {it:varname}, {opt f:rom}(geocode) {opt t:o}(code) {opt gen:erate}({it:varname}) [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt m:arker}}creates an indicator variable for whether a match was found{p_end}
{synopt:{opt debug}}does not delete intermediate files to help debugging{p_end}
{synopt:{opt codelist}}can be called instead of {it:varname} to obtain the list of available origin and destination codes{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rcallcountrycode} uses {browse "https://github.com/haghish/rcall":rcall} to interact with the R package {browse "https://github.com/vincentarelbundock/countrycode":countrycode}. It is a substitute for the {cmd:kountry} package from SSC.
There are two main advantages of {cmd:rcallcountrycode}: 1) {browse "https://github.com/vincentarelbundock/countrycode":countrycode} is more up to date and has more functions than {cmd:kountry}; 2) it also faster when dealing with large datasets (but not for small ones). The main disadvantage is that it requires more dependencies, including having R installed. See {browse "https://github.com/luispfonseca/rcallcountrycode"} for more information.
{p_end}

{pstd}
I'd like to thank the authors of both packages. {browse "https://github.com/vincentarelbundock/countrycode":countrycode} was written by Vincent Arel-Bundock, Nils Enevoldsen, and CJ Yetman. {browse "https://github.com/haghish/rcall":rcall} was written by E. F. Haghish.
{p_end}

{marker examples}{...}
{title:Examples}

{pstd}Standardize country names stored in a variable named country{p_end}
{phang2}{cmd:rcallcountrycode country, from(country.name) to(country.name) gen(countryname_en)}{p_end}

{pstd}Obtain ISO2 country codes{p_end}
{phang2}{cmd:rcallcountrycode country, from(country.name) to(iso2c) gen(iso2code)}{p_end}

{pstd}Translate country names to German{p_end}
{phang2}{cmd:rcallcountrycode country, from(country.name) to(country.name.de) gen(countryname_de)}{p_end}

{pstd}Obtain list of available origin and destination codes{p_end}
{phang2}{cmd:rcallcountrycode codelist}{p_end}

{title:Author}

{pstd}Luís Fonseca, London Business School.

{pstd}Website: {browse "https://luispfonseca.com"}

{title:Website}

{pstd}{cmd:rcallcountrycode} is maintained at {browse "https://github.com/luispfonseca/rcallcountrycode"}{p_end}
