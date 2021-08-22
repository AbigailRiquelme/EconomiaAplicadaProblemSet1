*****************************
*     Problem Set #2       * 
*      Integrantes:         *
* - Malena Hedemann         *
* - Abigail Riquelme        *
* - Camila Sury             *
*****************************

* Working directory 

global main "\Users\Abi\Desktop\2021\2021\Otoño\Economía Aplicada\Tutorial 2"
global output "$main\output"
global input "$main\input"

use "$input\China_Data", clear
cd "$output" 

****** 1 ******

* En primer lugar, agregamos labels a las variables: 

label variable village_pop "Village population"

label variable income_pc "Rural per capita net income (yuan)"

label variable subsidy_rate "Subsidy rate (per 1,000)"

label variable poor_housing_rate "Poor housing (per 100 HHs)"

label variable poor_reg_rate "Registered poor households (per 100 HHs)"

label variable disability_rate "Disability rate (per 1,000)"

label variable gov_officials "Number of village officials"

* cómo hacer las comillas
label variable high_gov_quality "Village officials with high school and above education (percent)"

label variable mid_gov_quality "Village officials with middle school education (percent)"

label variable low_gov_quality "Village officials with primary school and below education (percent)"

label variable ag_rate "Agricultural households (per 100 households)"

label variable business_income_pc "Per capita business revenue (yuan)"

label variable fiscal_rev_pc "Village government fiscal revenue per capita (yuan)"

label variable fiscal_exp_pc "Village government fiscal expenditure per capita (yuan)"

label variable col_revenue_pc "Government collective revenue (yuan)"

label variable trained_labor_rate "Trained laborers (per 100)"

label variable safe_water_rate "HHs with computers (per 100 HHs)"

label variable computer_rate "HHs with rural cooperative medical insurance (100 HHs)"

label variable med_ins_rate "HHs with rural cooperative medical insurance (100 HHs)"

label variable enroll_rate "Social enrollment rate for children aged 7-13 (percent)"

* Realizamos la tabla de estadísticas descriptiva 

tabstat village_pop income_pc subsidy_rate poor_housing_rate poor_reg_rate disability_rate gov_officials high_gov_quality mid_gov_quality low_gov_quality ag_rate business_income_pc fiscal_rev_pc fiscal_exp_pc col_revenue_pc trained_labor_rate safe_water_rate computer_rate med_ins_rate enroll_rate, save statistics(n mean sd) columns(statistics)

matrix A=r(StatTotal)

mat A=A'

mat list A

frmttable using Table2, varlabels tex statmat(A) sdec(0,0,0) ctitles("Variable","Observations", "Mean", "Standard" "" "" \ "" "" "" " deviation") title(Table 2: Summary Statistics of NFS Villages) note(These statistics are based on our analysis of 255 villages from the National Fixed-Point Survey (NFS) from 2000-2011 in 19 provinces)   replace 

* Realizamos la tabla con esttab

estpost tabstat village_pop income_pc subsidy_rate poor_housing_rate poor_reg_rate disability_rate gov_officials high_gov_quality mid_gov_quality low_gov_quality ag_rate business_income_pc fiscal_rev_pc fiscal_exp_pc col_revenue_pc trained_labor_rate safe_water_rate computer_rate med_ins_rate enroll_rate, statistics(n mean sd) columns(statistics)

esttab . using prueba.tex, replace cells("count mean sd ") nonumber collabels("Observations" "Mean" "Standard \\ deviation") title("titulo") noobs label

* prueba para ver si se puede poner standar (espacio) deviation

esttab . using prueba.tex, replace cells("count mean sd ") nonumber collabels("Observations" "Mean" `"Standard"'5`"deviation"') title("summary stats") noobs label













****** 2 ******

* omitimos low_gov_quality por el problema de multicolinealidad perfecta



