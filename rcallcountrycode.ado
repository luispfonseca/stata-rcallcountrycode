*! version 0.1.6 20feb2019 Luís Fonseca, https://github.com/luispfonseca
*! -rcallcountrycode- Call R's countrycode package from Stata using rcall

program define rcallcountrycode
	version 14
	
	syntax anything, [From(string) To(string) GENerate(string) Marker debug]

	* check only one variable is passed
	local numargs : word count `anything'
	if `numargs' != 1 {
		di as error "pass only one variable"
		error 103
	}

	* if codelist not passed, require passing of some of the options
	if "`anything'" != "codelist" & ("`from'" == "" | "`to'" == "" | "`generate'" == "") {
		di as error "options from(), to() and generate() are required"
    	qui error 198
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


	* confirm that rcall is installed only after all errors and conflicts checked
	cap which rcall
	if c(rc) {
		di as error "The package Rcall is required for this package to work. Follow the instructions in https://github.com/haghish/rcall"
		di as error "The following commands should work:"
		di as error `"net install github, from("https://haghish.github.io/github/") replace"'
		di as error "gitget rcall"
		error 9
	}
	else { // additional checks of dependencies
		rcall_check countrycode>=1.1.0, r(2.10) rcall(1.3.3)
		// 1.1.0 is current version of country code. have not tested earlier versions
		// 2.10 is what countrycode authors specify as the R version required
		// 1.3.3 is the current version of rcall. have not tested earlier versions
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
	tempfile origdata
	qui save "`origdata'", replace

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

	qui export delimited _Rdatarcallcountrycode_in.csv, replace

	* call R
	di as result "Calling R..."
	cap noi rcall vanilla: ///
	library(countrycode); ///
	print(paste0("Using countrycode package version: ", packageVersion("countrycode"))); ///
	data <- read.csv("_Rdatarcallcountrycode_in.csv", fileEncoding = "utf8", na.strings = ""); ///
	data\$`generate' <- countrycode(data\$`namevar', "`from'", "`to'"); ///
	write.csv(data, file= "_Rdatarcallcountrycode_out.csv", row.names=FALSE, fileEncoding="utf8", na = "")
	
	if c(rc) {
		di as error "Error when calling R. Check the error message above"
		di as error "Restoring original data"
		use "`origdata'", clear
		cap erase "`origdata'"
		error 
	}
	if "`debug'" == "" {
		cap erase _Rdatarcallcountrycode_in.csv
	}

	* import the csv (moved away from st.load() due to issue #1 with encodings and accents)
	capture confirm file _Rdatarcallcountrycode_out.csv
	if c(rc) {
		di as error "Restoring original data because file with the converted data was not found. Report to https://github.com/luispfonseca/stata-rcallcountrycode/issues"
		use "`origdata'", clear
		cap erase "`origdata'"
		error 601
	}
	qui import delimited _Rdatarcallcountrycode_out.csv, clear encoding("utf-8") varnames(1)   case(preserve)
	if "`debug'" == "" {
		cap erase _Rdatarcallcountrycode_out.csv
	}

	* create marker if option is called
	if "`marker'" != "" {
		qui gen `markervar' = 0
		qui replace `markervar' = 1 if !mi(`namevar') & !mi(`generate')
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
	use "`origdata'", clear

	* use fmerge if it exists and dataset is large enough
	cap which fmerge
	if !c(rc) & _N > 100000 {
		local f "f"
	}
	else { // preserve sort order destroyed by merge, keep consistency with fmerge which does not sort
		tempvar numobs
		gen `numobs' = _n 
	}
	qui `f'merge m:1 `namevar' using _Rdatarcallcountrycode_instata

	if "`debug'" == "" {
		cap erase _Rdatarcallcountrycode_instata.dta
	}

	* check merging occurred as expected
	cap assert _merge == 3 | (_merge == 1 & mi(`namevar')) // asserts proper matching: everything matched, except for empty inputs
	if c(rc) == 9 { // more helpful message if assertion fails
		di as error "Merging of data did not work as expected. Please provide a minimal working example at https://github.com/luispfonseca/stata-rcallcountrycode/issues"
		di as error "There was a problem with these entries:"
		tab `namevar' if !(_merge == 3 | (_merge == 1 & mi(`namevar')))
		di as error "Restoring original data"
		use "`origdata'", clear
		cap erase "`origdata'"
		error 9
	}

	drop _merge

	* restore original sort when calling merge
	if "`f'" == "" {
		sort `numobs'
	}

	cap erase "`origdata'"

end
