*****************************
*     Problem Set #1        * 
*      Integrantes:         *
* - Malena Hedemann         *
* - Abigail Riquelme        *
* - Camila Sury             *
*****************************

* Working directory 

global main "C:\Users\Abi\Desktop\2021\2021\Otoño\Economía Aplicada\Tutorial 1\Tutorial 1"
global output "$main\output"
global input "$main\input"

use "$input\China_data", clear
save "$output\China", replace

****** 1 ******

* Primero obtenemos los nombres de todas las variables de nuestra base, exceptuando la variable "village_id"

ds village_id, not

* generamos una nueva base de datos que contiene el promedio de cada variable por village_id

collapse (mean)`r(varlist)', by(village_id)

****** 2 ******

* Observando la base original identificamos 6 variables dummies: 
* cgvo, cgvo_occur, terrain, econ_zone, suburb, poor_village 

* usamos cw para eliminar las observaciones que tienen missing???? preguntar 



foreach v of varlist cgvo cgvo_occur terrain econ_zone suburb poor_village {
   replace `v'=1 if `v'>0 
}


****** 3 ******

*Genere una variable que asigne a cada aldea un número del 1 (menor) al 5 (mayor) según su posición en la distribución del ingreso. Luego, genere una variable similar clasificando la tasa de subsidio que recibe la aldea. Con el objetivo de analizar visualmente si el subsidio es mayor para aquellos pueblos de menores ingresos, presentar una tabla y comentar brevemente los resultados.

egen income_gr=cut(income_pc), group(5)

* para cambiar la numeración 

recode income_gr (0=1) (1=2) (2=3) (3=4) (4=5)


* hay que usar subsidy rate o I subsidy rate???  hacer todo con subsidy_rate

egen sub_gr=cut(subsidy_rate), group(5)

* para cambiar la numeración 

recode sub_gr (0=1) (1=2) (2=3) (3=4) (4=5)

* para descargar las tablas usar outreg2

* una posible tabla 

tabstat sub_gr, stats() by(income_gr)


* otra posible tabla 

tabulate sub_gr income_gr


* otra posible tabla, 

bysort income_gr: tabulate sub_gr

* en este caso los grupos muestran que para por ejemplo, income_gr=0 la cantidad de 
* aldeas que tienen tasas de subsidios altas 

* otra tabla (solo con las frecuencias)

table sub_gr, contents(freq) by(income_gr) 
 
* gráficamente 

graph twoway scatter l_subsidy_rate income_pc

* o un histograma 

hist l_subsidy_rate , title(Subsidios) by(income_gr)

*** VER DE CAMBIAR EL TEMA DE LOS GRÁFICOS 

***** 4 *****

* Informe la correlación entre los ingresos de una aldea y la tasa de subsidio. Pruebe si esta correlación es estadísticamente significativa (comando pwcorr). Presente un gráfico por aldeas tratadas y no tratadas (“cgvo_occur”). Además, informe la correlación y su importancia entre la tasa de subsidio de la aldea y las características de la aldea. Comentario.

corr income_pc subsidy_rate

* rdo:  -0.2593

* evaluamos si la correlación es estadisticamente significativa 

pwcorr income_pc subsidy_rate, obs sig

* observamos que la correlación es significatica al 1%! el p valor asociado es de 0.0000

* gráfico por aldeas tratadas y no tratadas --> cgvo_occur

graph twoway scatter income_pc subsidy_rate, by(cgvo_occur)


* correlación entre la tasa de subsidio de la aldea y las características de la aldea 


***************** PARENTESIS **************************

* instalamos paquete para hacer una tabla de correlaciones

ssc install cpcorr

* lo hacemos con esta función para que quede más linda la tabla

* preguntar! por qué da distinto con corr subsidy_rate village_pop y con cpcorr subsidy_rate village_pop

cpcorr village_pop poor_housing_rate ag_rate business_income_pc fiscal_rev_pc fiscal_exp_pc col_revenue_pc gov_officials high_gov_quality mid_gov_quality low_gov_quality terrain econ_zone suburb town_center poor_village trained_labor_rate safe_water_rate computer_rate clinic_rate med_ins_rate \ subsidy_rate, sig 
*chequear lo de significatividad

***************** PARENTESIS **************************


* hacemos la tabla de correlaciones con su sugnificatividad 

pwcorr village_pop poor_housing_rate ag_rate business_income_pc fiscal_rev_pc fiscal_exp_pc col_revenue_pc gov_officials high_gov_quality mid_gov_quality low_gov_quality terrain econ_zone suburb town_center poor_village trained_labor_rate safe_water_rate computer_rate clinic_rate med_ins_rate subsidy_rate


* con las que resultan interesantes podemos armar un gráfico

graph matrix village_pop poor_housing_rate ag_rate business_income_pc, half

* falta el comentario 


***** 5 *****

* 5. En el ejercicio 2) se le pidió que verificara visualmente si la tasa de subsidio es mayor para las aldeas tratadas (aquellas aldeas que formaban parte del programa CGVO). Realice una prueba de comparación de medias para comprobar si esta diferencia es estadísticamente significativa. El comando relevante es "ttest". Además, pruebe si la tasa de pobreza, la tasa de discapacidad, la población subsidiada y la tasa de vivienda deficiente es menor para las aldeas tratadas.


* realizamos un ttest para la comparación de medias según si fueron tratados o no 

ttest subsidy_rate, by(cgvo_occur)

* dado que la hipótesis nula del test postula igualdad de medias podemos decir que no hay diferencias significativas entre las medias de subsidios para grupos tratados y no tratados decido a que el p valor que obtenemos es de Pr(T < t) = 0.2254


***** 6 ***** 

*6. Cuando se trabaja con datos, es frecuente encontrar variables u observaciones con valores "irregulares" (por ejemplo, ingresos con valores negativos o gastos superiores a los ingresos). Explique cómo encontraría errores en las variables de este conjunto de datos. ¿Hay alguna observación o variable que crea que es "sospechosa"?

* podriamos usar preserve y ver si al quedarnos, por ejemplo, con el ingreso positivo se eliminan observaciones y luego usar restore para no realizar cambios permanentes en la base de datos 

preserve
drop if income_pc<0
restore

* se puede extener a las demás variables económicas o sobre las características de cada village



***** 7 ***** 

* ya están los posibles gráficos antes! podriamos hacer alguno con las características de cada aldea y comparar los grupos tratados y los no tratados 

* posibles variables: village_pop poor_housing_rate ag_rate business_income_pc fiscal_rev_pc fiscal_exp_pc col_revenue_pc gov_officials high_gov_quality mid_gov_quality low_gov_quality terrain econ_zone suburb town_center poor_village trained_labor_rate safe_water_rate computer_rate clinic_rate med_ins_rate 

graph twoway scatter income_pc village_pop, by(cgvo_occur)

* también podria ser algún histograma (también están en las primeras lineas de código)





















