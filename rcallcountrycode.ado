*! version 0.1.0 16feb2019 Luís Fonseca, https://github.com/luispfonseca
*! -rcallcountrycode- Call R's countrycode package from Stata using rcall

program define rcallcountrycode
	
	syntax varname(max=1), From(string) To(string) GENerate(string) [Marker]

	* confirm that rcall is installed
	cap which rcall
	if c(rc) {
		di as error "The package Rcall is required for this package to work. Follow the instructions in https://github.com/haghish/rcall"
		di as error "The following commands should work:"
		di as error `"net install github, from("https://haghish.github.io/github/") replace"'
		di as error "gitget rcall"
		exit
	}
	else { // additional checks of dependencies
		rcall_check countrycode>=1.1.0, r(2.10) rcall(1.3.3)
		// 1.1.0 is current version of country code. have not tested earlier versions
		// 2.10 is what countrycode authors specify as the R version required
		// 1.3.3 is the current version of rcall. have not tested earlier versions
	}

	* avoid naming conflicts
	capture confirm new variable `generate'
	if c(rc) {
		di as error "You already have a variable named `generate'. Please rename it or use option gen(varname)"
		exit
	}
	if "`marker'" != "" {
		local markervar marker // could be changed to marker_`generate' for example
		capture confirm new variable `markervar'
		if c(rc) {
			di as error "You already have a variable named `markervar'. Please rename it or drop it if you want to call the marker option"
			exit
		}
	}

	* preserve dataset to later merge
	preserve

	* prepare list of unique names to send; use gduplicates if possible
	di "Preparing data to send to R"
	tokenize "`varlist'"
	local namevar `1'
	keep `namevar'
	cap which gduplicates
	if !c(rc) {
		local g "g"
	}
	else {
		di "The gtools package is not required, but it is recommended for speed gains. To install, follow the instructions in https://github.com/mcaceresb/stata-gtools"
	}
	qui `g'duplicates drop

	* call R
	di "Calling R..."
	cap noi rcall vanilla: ///
	library(countrycode); ///
	print(paste0("Using countrycode package version: ", packageVersion("countrycode"))); ///
	data <- st.data(); ///
	data\$`generate' <- countrycode(data\$`namevar', "`from'", "`to'"); ///
	st.load(data)

	if c(rc) {
		di as error "Error when calling R. Check the error message above"
		exit
	}

	* create marker if option is called
	if "`marker'" != "" {
		qui gen `markervar' = 0
		qui replace `markervar' = 1 if !mi(`namevar') & !mi(`generate')
	}

	* store in temporary file
	tempfile Routput
	qui save "`Routput'"

	* show diagnostic if any non-matches
	qui keep if mi(`generate') & !mi(`namevar')
	if _N > 0 {
		di "countrycode could not find unique matches for the following cases:"
		list `namevar'
		di "If no error happened, then it likely found either 0 matches or more than 1 for these cases"
	}

	* merge results
	di "Merging the data"
	restore
	* use fmerge if it exists and dataset is large enough
	cap which fmerge
	if !c(rc) & _N > 100000 {
		local f "f"
	}
	else { // preserve sort order destroyed by merge, keep consistency with fmerge which does not sort
		tempvar numobs
		gen `numobs' = _n 
	}
	qui `f'merge m:1 `namevar' using "`Routput'", nogenerate assert(match)

	if "`f'" == "" {
		sort `numobs'
	}

	cap erase "`Routput'"
	
end
