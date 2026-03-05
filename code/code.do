*************************************************************************************
//双重机器学习法
*ssc install ddml, replace
*ssc install pystacked, replace //安装相关命令

*仅控制变量一次项
use "data.dta", clear
global Y Merge
global D Data
global X Fis Inf Pop Env Open
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*加入控制变量二次项
use "data.dta", clear
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*加入个体固定效应
use "data.dta", clear
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*加入时间固定效应
use "data.dta", clear
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.id i.year
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*************************************************************************************
///内生性检验,工具变量法
//1984邮电局数量*上一年全国信息技术服务收入
use "data.dta", clear
global Y Merge
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


*************************************************************************************
///稳健性检验
//调整测度方式
*更换被解释变量
use "data.dta", clear
global Y Merge_new
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*更换解释变量
use "data.dta", clear
global Y Merge
global D Data_new
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


//剔除直辖市
use "data.dta", clear
keep if city == 0 
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


//缩尾处理
*1%缩尾
use "shrink tail_1%.dta", clear
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust

*5%缩尾
use "shrink tail_5%.dta", clear
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*************************************************************************************
///中介效应检验
*劳动者素质
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

*金融发展水平
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

*知识产权保护
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
///异质性分析
*地理区位异质性
use "data.dta", clear
keep if inlist(M_Geo,1)
global Y Merge
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
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*市场化指数异质性
use "data.dta", clear
keep if inlist(M_Mar,1)
global Y Merge
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
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust


*数字基础设施异质性
use "data.dta", clear
keep if inlist(M_Inf,1)
global Y Merge
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
global Y Merge
global D Data
global X Fis Inf Pop Env Open Fis2 Inf2 Pop2 Env2 Open2 i.year i.id
set seed 42 
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust
