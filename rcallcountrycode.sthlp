{smcl}
{* *! version 0.1.9  16jul2019}{...}
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
{opt rcallcountrycode} {it:varname} [, {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt f:rom}(geocode)}coding scheme of origin (default is country.name.en){p_end}
{synopt:{opt t:o}(geocode)}coding scheme of destination (default is country.name.en){p_end}
{synopt:{opt gen:erate}({it:varname})}variable to store standardized names (default is std_country){p_end}
{synopt:{opt m:arker}}creates an indicator variable for whether a match was found{p_end}
{synopt:{opt debug}}keeps intermediate files to help debugging{p_end}
{synopt:{opt codelist}}can be called instead of {it:varname} to obtain the list of available origin and destination codes{p_end}
{synopt:{opt checkr:call}}Runs rcall_check to ensure rcall is working correctly and the required R packages are installed{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rcallcountrycode} uses {browse "https://github.com/haghish/rcall":rcall} to interact with the R package {browse "https://github.com/vincentarelbundock/countrycode":countrycode}. It is a substitute for the {cmd:kountry} package from SSC.
There are two main advantages of {cmd:rcallcountrycode}: 1) {browse "https://github.com/vincentarelbundock/countrycode":countrycode} is more up to date and has more functions than {cmd:kountry}; 2) it also faster when dealing with large datasets, though not with small ones. The main disadvantage is that it requires more dependencies, including having R installed. See {browse "https://github.com/luispfonseca/rcallcountrycode"} for more information. It does not currently implement
{p_end}

{pstd}
I'd like to thank the authors of both packages. {browse "https://github.com/vincentarelbundock/countrycode":countrycode} was written by Vincent Arel-Bundock, Nils Enevoldsen, and CJ Yetman. {browse "https://github.com/haghish/rcall":rcall} was written by E. F. Haghish.
{p_end}

{marker examples}{...}
{title:Examples}

{pstd}Standardize country names stored in a variable named country (both are equivalent){p_end}
{phang2}{cmd:rcallcountrycode country, gen(countryname_en)}{p_end}
{phang2}{cmd:rcallcountrycode country, from(country.name) to(country.name) gen(countryname_en)}{p_end}

{pstd}Obtain ISO2 country codes{p_end}
{phang2}{cmd:rcallcountrycode country, from(country.name) to(iso2c) gen(iso2code)}{p_end}

{pstd}Translate country names to German{p_end}
{phang2}{cmd:rcallcountrycode country, from(country.name) to(country.name.de) gen(countryname_de)}{p_end}

{pstd}Obtain list of available origin and destination codes{p_end}
{phang2}{cmd:rcallcountrycode codelist}{p_end}

{title:List of codes as of writing}

Origin and destination
{pstd}country.name: country name (English){p_end}
{pstd}country.name.de: country name (German){p_end}
{pstd}cowc: Correlates of War character{p_end}
{pstd}cown: Correlates of War numeric{p_end}
{pstd}ecb: European Central Bank{p_end}
{pstd}eurostat:  Eurostat{p_end}
{pstd}fao: Food and Agriculture Organization of the United Nations numerical code{p_end}
{pstd}fips: FIPS 10-4 (Federal Information Processing Standard){p_end}
{pstd}gaul: Global Administrative Unit Layers{p_end}
{pstd}genc2c: GENC 2-letter code{p_end}
{pstd}genc3c: GENC 3-letter code{p_end}
{pstd}genc3n: GENC numeric code{p_end}
{pstd}gwc: Gleditsch & Ward character{p_end}
{pstd}gwn: Gleditsch & Ward numeric{p_end}
{pstd}imf: International Monetary Fund{p_end}
{pstd}ioc: International Olympic Committee{p_end}
{pstd}iso2c: ISO-2 character{p_end}
{pstd}iso3c: ISO-3 character{p_end}
{pstd}iso2n: ISO-2 numeric{p_end}
{pstd}iso3n: ISO-3 numeric{p_end}
{pstd}p4n: Polity IV numeric country code{p_end}
{pstd}p4c: Polity IV character country code{p_end}
{pstd}un: United Nations M49 numeric codes{p_end}
{pstd}unpd: United Nations Procurement Division{p_end}
{pstd}vdem: Varieties of Democracy (V-Dem version 8, April 2018){p_end}
{pstd}wb: World Bank (very similar but not identical to iso3c){p_end}
{pstd}wvs: World Values Survey numeric code{p_end}

Origin and destination
{pstd}ar5: IPCC's regional mapping used both in the Fifth Assessment Report (AR5) and for the Reference Concentration Pathways (RCP){p_end}
{pstd}continent: Continent as defined in the World Bank Development Indicators{p_end}
{pstd}cow.name: Correlates of War country name{p_end}
{pstd}ecb.name: European Central Bank country name{p_end}
{pstd}eurocontrol_pru:  European Organisation for the Safety of Air Navigation{p_end}
{pstd}eurocontrol_statfor:  European Organisation for the Safety of Air Navigation{p_end}
{pstd}eurostat.name:  Eurostat country name{p_end}
{pstd}eu28: Member states of the European Union (as of December 2015), without special territories{p_end}
{pstd}fao.name: Food and Agriculture Organization of the United Nations country name{p_end}
{pstd}fips.name: FIPS 10-4 Country name{p_end}
{pstd}genc.name: Geopolitical Entities, Names and Codes standard country names{p_end}
{pstd}icao: International Civil Aviation Organization{p_end}
{pstd}icao_region: International Civil Aviation Organization (Region){p_end}
{pstd}ioc.name: International Olympic Committee country name{p_end}
{pstd}iso.name.en: ISO English short name{p_end}
{pstd}iso.name.fr: ISO French short name{p_end}
{pstd}p4.name: Polity IV country name{p_end}
{pstd}region: Regions as defined in the World Bank Development Indicators{p_end}
{pstd}un.name.ar: United Nations Arabic country name{p_end}
{pstd}un.name.en: United Nations English country name{p_end}
{pstd}un.name.es: United Nations Spanish country name{p_end}
{pstd}un.name.fr: United Nations French country name{p_end}
{pstd}un.name.ru: United Nations Russian country name{p_end}
{pstd}un.name.zh: United Nations Chinese country name{p_end}
{pstd}unpd.name: United Nations Procurement Division country name{p_end}
{pstd}wvs.name: World Values Survey numeric code country name{p_end}
{pstd}cldr.*: 622 country name variants from the UNICODE CLDR project.{p_end}

{title:Author}

{pstd}Luís Fonseca, London Business School.

{pstd}Website: {browse "https://luispfonseca.com"}

{title:Website}

{pstd}{cmd:rcallcountrycode} is maintained at {browse "https://github.com/luispfonseca/stata-rcallcountrycode"}{p_end}
