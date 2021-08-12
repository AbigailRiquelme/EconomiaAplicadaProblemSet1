*****************************
*     Problem Set #1        * 
*      Integrantes:         *
* - Malena Hedemann         *
* - Abigail Riquelme        *
* - Camila Sury             *
*****************************
* En la correlación estamos supondiendo el alpha igual a cero. 


* Working directory 

global main "C:\Users\Abi\Desktop\2021\2021\Otoño\Economía Aplicada\Tutorial 1\Tutorial 1"
global output "$main\output"
global input "$main\input"

use "$input\China_data", clear
save "$output\China", replace

****** 1 ******

* Primero obtenemos los nombres de todas las variables de nuestra base, exceptuando la variable "village_id"

ds village_id, not

* Generamos una nueva base de datos que contiene el promedio de cada variable por village_id

collapse (mean)`r(varlist)', by(village_id)

****** 2 ******

* Observando la base original identificamos 6 variables dummies: 
* cgvo, cgvo_occur, terrain, econ_zone, suburb, poor_village 


foreach v of varlist cgvo cgvo_occur terrain econ_zone suburb poor_village {
   replace `v'=1 if `v'>0 
}


****** 3 ******

* Generamos la variable "income_gr", esta le asigna un número del 0 (menor) al 4 (mayor) a cada village según su posición en la distribución del ingreso:

egen income_gr=cut(income_pc), group(5)

* Por default el comando anterior numera del 0 al 4, por lo tanto, cambiamos la numeración del 1 al 5:

recode income_gr (0=1) (1=2) (2=3) (3=4) (4=5)

* Generamos la variable "sub_gr", esta le asigna un número del 0 (menor) al 4 (mayor) a cada village según su posición en la distribución de la tasa de subsidio que reciben:

egen sub_gr=cut(subsidy_rate), group(5)

* Por default el comando anterior numera del 0 al 4, por lo tanto, cambiamos la numeración del 1 al 5: 

recode sub_gr (0=1) (1=2) (2=3) (3=4) (4=5)

* Decidimos realizar una tabla que compare las medias del subsidio recibido para cada uno de los valores tomados por la variable income_gr, es decir, para cada uno de los grupos de ingresos:

tabstat subsidy_rate, stats() by(income_gr)

* También consideramos realizar una tabla que muestre la cantidad de observaciones correspondientes a los distintos grupos de tasas de subsidios para los grupos de ingresos, es decir, la frecuencia de los distintos valores que toma la variable "sub_gr" para cada uno de los valores que toma la variable "income_gr"

bysort income_gr: tabulate sub_gr

* Gráficos

* Para realizar un análisis más visual consideramos relevante realizar un gráfico de dispersión entre la tasa de subsidio que reciebn las village y el ingreso:

graph twoway scatter subsidy_rate income_pc, scheme(mrc)
 
* También es informativo realizar un gráfico de barras de la tasa de subsidio media para cada uno de los valores que toma la variable "income_gr":

graph bar subsidy_rate, over(income_gr) scheme(mrc)


***** 4 *****

* Evaluamos si la correlación entre el ingreso y la tasa de subsidio es estadisticamente significativa 

pwcorr income_pc subsidy_rate, obs sig

* Observamos que la correlación es significatica al 1%, debido a que p valor asociado es de 0.0000.

* A continuación realizamos un gráfico que compara la relación entre ingreso y subsidio para las aldeas tratadas y no tratadas: 

graph twoway scatter  subsidy_rate income_pc, by(cgvo_occur) scheme(mrc)


* A continuación calculamos la correlación entre la tasa de subsidio y las variables relacionadas a las características de cada village: 

pwcorr subsidy_rate village_pop poor_housing_rate ag_rate business_income_pc fiscal_rev_pc fiscal_exp_pc col_revenue_pc gov_officials high_gov_quality mid_gov_quality low_gov_quality terrain econ_zone suburb town_center poor_village trained_labor_rate safe_water_rate computer_rate clinic_rate med_ins_rate, sig 



***** 5 *****

* Queremos ver si la tasa de subsidio es mayor para las aldeas tratadas (aquellas aldeas que formaban parte del programa CGVO). 

* testeamos que la diferencia entre mean(0)-mean(1) --> Ha: diff < 0, porque sería que mean(tratadas)>mean(no tratadas)

*grafico de medias 

graph bar subsidy_rate, by(cgvo_occur)

* realizamos un ttest para la comparación de medias según si fueron tratados o no 

ttest subsidy_rate, by(cgvo_occur)

* dado que la hipótesis nula del test postula igualdad de medias podemos decir que no hay diferencias significativas entre las medias de subsidios para grupos tratados y no tratados decido a que el p valor que obtenemos es de Pr(T < t) = 0.2254

ttest poor_housing_rate, by(cgvo_occur)

* preguntar: si es esta (porque dice reg)

* esta bien 
ttest poor_reg_rate, by(cgvo_occur)

ttest disability_rate, by(cgvo_occur)

ttest subsidy_pop, by(cgvo_occur)


***** 6 ***** 

* Podriamos usar preserve y ver si al quedarnos, por ejemplo, con el ingreso positivo se eliminan observaciones y luego usar restore para no realizar cambios permanentes en la base de datos 

preserve
drop if  subsidy_pop<0
restore

* se puede extener a las demás variables económicas o sobre las características de cada village

* hacer graficos y ver outliers

* graficos, histogramas, tabla 

*Variables sospechosas: 

* Años

* early_leave


***** 7 ***** 

* Consideramos interesante realizar un gráfico con aquellas correlaciones que resultados estadísticamente significativas al 1% y que no son dummies: 

graph matrix subsidy_rate village_pop gov_officials low_gov_quality clinic_rate, half scheme(mrc)

* gráfico entre el ingreso y la variable village_pop por grupos tratados y no tratados

graph twoway scatter income_pc village_pop, by(cgvo_occur)


* 

graph twoway scatter poor_reg_rate subsidy_rate gov_officials , by(cgvo_occur) scheme(mrc)

* Histograma 

hist subsidy_rate, by(cgvo_occur)  norm  scheme(mrc)

* Boxplot

graph box subsidy_rate, by(cgvo_occur)















