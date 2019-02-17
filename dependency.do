* Installing dependencies for stata-rcallcountrycode
* Installing rcall for Stata
gitget rcall
* Installing countrycode package in R
rcall vanilla: install.packages("countrycode", repos="https://cran.us.r-project.org")
* Final checks
rcall_check countrycode>=1.1.0, r(2.10) rcall(1.3.3)
