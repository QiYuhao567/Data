*************************************************************************************
***Title：From Data to Integration: How a New Factor of Production Drives  the Integrated Development of Science and Technology Innovation with Industrial Innovation
***Author：Jiying Wu, Yuhao Qi


*************************************************************************************
//DML
*ssc install ddml, replace
*ssc install pystacked, replace

*only included the control variable's first-order term
use "data.dta", clear
global Y Integ
global D Data
global X Fis Inf Pop Env Open
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*added the quadratic terms of the control variable
use "data.dta", clear
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*includes province fixed effects
use "data.dta", clear
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*includes both fixed effects
use "data.dta", clear
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.id i.year
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*************************************************************************************
///Endogeneity assessment, instrumental variable (iv) 
//iv = the number of post offices in 1984 * the prior year's national information technology service revenue
use "data.dta", clear
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.id i.year
global Z iv
set seed 42 
ddml init iv, kfolds(5)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Z|X]: pystacked $Z $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

//explanatory variable (Data) lagged one period
use "data.dta", clear
gen L_Data = L.Data

global Y Integ
global D L_Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*************************************************************************************
///Robustness verification
//Alternative measurement approaches
*Dependent variable
use "data.dta", clear
global Y Integ_new
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*Independent variable
use "data.dta", clear
global Y Integ
global D Data_new
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


//Adjust the sample size
use "data.dta", clear
keep if city == 0 

global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


//Removal of outlier effects
*1% winsorized
use "shrink tail_1%.dta", clear
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*5% winsorized
use "shrink tail_5%.dta", clear
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*************************************************************************************
///Mechanism tests
*Lab
use "data.dta", clear
global Y Lab
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*Fin
use "data.dta", clear
global Y Fin
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*Ip protection
use "data.dta", clear
global Y Kpp
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*************************************************************************************
///Heterogeneity
//geographical area
use "data.dta", clear
keep if inlist(M_Geo,1)
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


use "data.dta", clear
keep if inlist(M_Geo,0)
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


//marketization degree
use "data.dta", clear
keep if inlist(M_Mar,1)
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

use "data.dta", clear
keep if inlist(M_Mar,0)
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


//digital infrastructure
use "data.dta", clear
keep if inlist(M_Inf,1)
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

use "data.dta", clear
keep if inlist(M_Inf,0)
global Y Integ
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

//Inter-group difference test. Add the interaction term of the data elements and the group dummy variables, and check whether the coefficient of the interaction term is significant.

*geographical area
use "data.dta", clear
gen Data_Geo = Data * M_Geo

global Y Integ
global D Data_Geo
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*marketization degree
use "data.dta", clear
gen Data_Mar = Data * M_Mar

global Y Integ
global D Data_Mar
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*digital infrastructure
use "data.dta", clear
gen Data_Inf = Data * M_Inf

global Y Integ
global D Data_Inf
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust