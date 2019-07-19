*! version 0.1.8 13jun2019 Luís Fonseca, https://github.com/luispfonseca
*! -rcallcountrycode- Call R's countrycode package from Stata using rcall

program define rcallcountrycode
	version 14
	
	syntax anything, [From(string) To(string) GENerate(string) Marker debug CHECKrcall]

	* confirm that rcall is installed only after all errors and conflicts checked
	cap which rcall
	if c(rc) {
		di as error "The package Rcall is required for this package to work. Follow the instructions in https://github.com/haghish/rcall"
		di as error "The following commands should work:"
		di as error `"net install github, from("https://haghish.github.io/github/") replace"'
		di as error "gitget rcall"
		error 9
	}
	if "`checkrcall'" != "" { // additional checks of dependencies
		rcall_check countrycode>=1.1.0 haven>=2.1.0, r(3.2) rcall(1.3.3)
		// 1.1.0 is current version of country code. have not tested earlier versions
		// 2.10 is what countrycode authors specify as the R version required
		// 1.3.3 is the current version of rcall. have not tested earlier versions
		// 2.1.0 is the version of haven when command was first written, seems to work
		// 3.2 is the R version required by haven as of writing
		di "rcall and dependencies seem to be working fine. You should be able to run rcallcountrycode without issues."
		exit
	}

	* check only one variable is passed
	local numargs : word count `anything'
	if `numargs' != 1 {
		di as error "pass only one variable"
		error 103
	}

	* default options
	if "`anything'" != "codelist" {
		if "`from'" == "" {
			local from "country.name"
		}
		if "`to'" == "" {
			local to "country.name"
		}
		if "`generate'" == "" {
			local generate "std_country"
		}
	} 

	* avoid naming conflicts
	capture confirm new variable `generate'
	if c(rc) & "`anything'" != "codelist" {
		di as error "You already have a variable named `generate'. Please rename it or provide a different name to option gen(varname)"
		error 198
	}
	if "`marker'" != "" & "`anything'" != "codelist" {
		local markervar marker // could be changed to marker_`generate' for example
		capture confirm new variable `markervar'
		if c(rc) {
			di as error "You already have a variable named `markervar'. Please rename it or drop it if you want to call the marker option"
			error 198
		}
	}

	if "`anything'" == "codelist" {
		capture confirm variable codelist
		if !c(rc) {
			di as error "You already have a variable named codelist. Please rename it or drop it if you want to call the codelist option"
			error 198
		}
	}

	* if passed, calling codelist from R. passed the same way as a variable to simplify syntax. inelegant (to do: move option to after the comma, requiring no variable passed)
	if "`anything'" == "codelist" {
		* call R
		rcall vanilla: ///
		library(countrycode); ///
		codelisttext <- utils:::.getHelpFile(help(codelist)); ///
		print(codelisttext)

		exit
	}

	* store dataset to later merge, or restore if error
	preserve

	* prepare list of unique names to send; use gduplicates if possible
	di as result "Preparing data to send to R"
	tokenize "`anything'"
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
	qui drop if mi(`namevar')

	qui save _Rdatarcallcountrycode_in, replace

	* call R
	di as result "Calling R..."
	cap noi rcall vanilla: ///
	library(countrycode); ///
	print(paste0("Using countrycode package version: ", packageVersion("countrycode"))); ///
	library(haven); ///
	data <- haven::read_dta("_Rdatarcallcountrycode_in.dta"); ///
	data\$`generate' <- countrycode(data\$`namevar', "`from'", "`to'"); ///
	haven::write_dta(data, "_Rdatarcallcountrycode_out.dta"); ///
	rm(list=ls())
	
	if c(rc) {
		di as error "Error when calling R. Check the error message above"
		di as error "Restoring original data"
		restore
		error 
	}
	if "`debug'" == "" {
		cap erase _Rdatarcallcountrycode_in.dta
	}

	* import the output
	capture confirm file _Rdatarcallcountrycode_out.dta
	if c(rc) {
		di as error "Restoring original data because file with the converted data was not found. Report to https://github.com/luispfonseca/stata-rcallcountrycode/issues"
		restore
		error 601
	}
	use _Rdatarcallcountrycode_out, clear
	if "`debug'" == "" {
		cap erase _Rdatarcallcountrycode_out.dta
	}

	* create marker if option is called
	if "`marker'" != "" {
		qui gen byte `markervar' = 0
		qui replace `markervar' = 1 if !mi(`namevar') & !mi(`generate')
	}

	* imported dataset unfortunately changes string formatting. this is a workaround
	cap destring `generate', replace
	if substr("`:type `generate''" , 1, 3) == "str" {
		tempvar lengthgen
		qui gen byte `lengthgen' = length(`generate')
		qui sum `lengthgen'
		format `generate' %`r(max)'s
	}

	* store in dta file
	qui	save _Rdatarcallcountrycode_instata, replace

	* show diagnostic if any non-matches
	qui keep if mi(`generate') & !mi(`namevar')
	if _N > 0 {
		di as result "countrycode could not find unique matches for the following cases:"
		list `namevar'
		di as result "If no error happened, then it likely found either 0 matches or more than 1 for these cases"
	}

	* merge results
	di as result "Merging the data"
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
	tempvar merge_results
	qui `f'merge m:1 `namevar' using _Rdatarcallcountrycode_instata, gen(`merge_results')

	if "`debug'" == "" {
		cap erase _Rdatarcallcountrycode_instata.dta
	}

	* check merging occurred as expected
	cap assert `merge_results' == 3 | (`merge_results' == 1 & mi(`namevar')) // asserts proper matching: everything matched, except for empty inputs
	if c(rc) == 9 { // more helpful message if assertion fails
		di as error "Merging of data did not work as expected. Please provide a minimal working example at https://github.com/luispfonseca/stata-rcallcountrycode/issues"
		di as error "There was a problem with these entries:"
		tab `namevar' if !(`merge_results' == 3 | (`merge_results' == 1 & mi(`namevar')))
		di as error "Restoring original data"
		restore
		error 9
	}

	* restore original sort when calling merge
	if "`f'" == "" {
		sort `numobs'
	}

end
