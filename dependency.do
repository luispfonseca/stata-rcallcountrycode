* Installing dependencies for stata-rcallcountrycode
* Installing rcall for Stata
github install haghish/rcall, stable
* Installing countrycode package in R
rcall vanilla: ///
	install.packages("countrycode", repos="https://cran.us.r-project.org"); ///
	install.packages("haven", repos="https://cran.us.r-project.org")
* Final checks
rcall_check countrycode>=1.1.0 haven>=2.1.0, r(3.2) rcall(1.3.3)
