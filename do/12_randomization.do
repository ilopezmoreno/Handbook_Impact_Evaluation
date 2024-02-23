clear

// Handbook on Impact Evaluation
// Chapter 12. 
// Randomized Impact Evaluation 

/*
Randomization works in the ideal scenario where individuals or households are assigned to treatment randomly, eliminating selection bias. 

In an attempt to obtain an estimate of the impact of a certain program, comparing the same treated individuals over time does not provide a 
consistent estimate of the program's impact, because other factors besides the program may affect outcomes. 

However, comparing the outcome of the treated individuals with that of a similar control group can provide an estimate of the program's impact. 

This comparison works well with randomization because the assignment of individuals or groups to the treatment and comparison groups is random. 

An unbiased estimate of the impact of the program in the sample will be obtained when the design and implementation of the randomized evaluation are appropriate. 

This exercise demonstrates randomized impact estimation with different scenarios. 

In this chapter, the randomization impact evaluation is demonstrated from top down—that is, from program placement to program participation.
*/














*** 1 - Impacts of Program Placement in Villages ***

/*

For this exercise, use the 1998 household data hh_98.dta.
Assume that microcredit programs are randomly assigned to villages, and further assume no differences between treated and control villages. 
You want to ascertain the impact of program placement on household's per capita total annual expenditures.
Open the data set and create the log form of two variables—outcome ("exptot") and 
household's land before joining the microcredit program ("hhland," which is changed to acre from decimal by dividing by 100).

*/


* For this exercise, use the 1998 household data hh_98.dta.
use C:/Users/d57917il/Documents/GitHub/Handbook_Impact_Evaluation/data/hh_98.dta



/* Create the log form of two variables 
— outcome (“exptot”) and 
— household’s land before joining the microcredit program “hhland,” 
which is changed to acre from decimal by dividing by 100 */
gen lexptot=ln(1+exptot)
gen lnland=ln(1+hhland/100)
summarize exptot lexptot hhland lnland


/* Then a dummy variable is created for microcredit program placement in villages. 
Two program placement variables are created: 
one for male programs and the other for female programs. */
gen vill=thanaid*10+villid
egen progvillm=max(dmmfd), by(vill)
egen progvillf=max(dfmfd), by(vill)








/* Now use the simplest method to calculate average treatment effect of village program placement. 
It is done by using the Stata “ttest” command.
This command compares the outcome between treated and control villages. */

ttest lexptot, by(progvillf)

/*

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       0 |      67    8.328525    .0644093    .5272125    8.199927    8.457122
       1 |   1,062    8.458371    .0157201    .5122923    8.427525    8.489217
---------+--------------------------------------------------------------------
Combined |   1,129    8.450665    .0152934    .5138679    8.420659    8.480672
---------+--------------------------------------------------------------------
    diff |           -.1298466    .0646421               -.2566789   -.0030142 <---------------------------
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =  -2.0087
H0: diff = 0                                     Degrees of freedom =     1127

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.0224         Pr(|T| > |t|) = 0.0448          Pr(T > t) = 0.9776


The result are showing that the difference of outcomes between treated and control villages is significant. 
(-.1298466)
Which means that female program placement in villages improves per capita expenditure. 

*/ 






/* Alternately, you can run the simplest equation that 
regresses per capita expenditure against the village program dummy: */

reg lexptot progvillf

/*

      Source |       SS           df       MS      Number of obs   =     1,129
-------------+----------------------------------   F(1, 1127)      =      4.03
       Model |  1.06259118         1  1.06259118   Prob > F        =    0.0448
    Residual |  296.797338     1,127  .263351676   R-squared       =    0.0036
-------------+----------------------------------   Adj R-squared   =    0.0027
       Total |   297.85993     1,128  .264060221   Root MSE        =    .51318

------------------------------------------------------------------------------
     lexptot | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
   progvillf |   .1298466   .0646421     2.01   0.045     .0030142    .2566789   <---------------------------
       _cons |   8.328525   .0626947   132.84   0.000     8.205513    8.451536
------------------------------------------------------------------------------

*/

/* The result gives the same effect (0.1298), and it is statistically significant. 

The previous regression estimated the overall impact of the village programs on the per capita expenditure of households. 
It may be different from the impact on the expenditure after holding other factors constant — that is, 
specifying the model adjusted for covariates that affect the outcomes of interest. */





/* Now, regress the same outcome (log of per capita household expenditures) 
against the village program dummy plus other factors that may influence the expenditure. */

reg lexptot progvillf sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw=weight]

/*

Linear regression                               Number of obs     =      1,129
                                                F(12, 1116)       =      20.16
                                                Prob > F          =     0.0000
                                                R-squared         =     0.2450
                                                Root MSE          =     .46179

------------------------------------------------------------------------------
             |               Robust
     lexptot | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
   progvillf |  -.0455621   .1046759    -0.44   0.663    -.2509458    .1598217   <---------------------------
     sexhead |  -.0373236   .0643335    -0.58   0.562    -.1635519    .0889047
     agehead |   .0030636   .0012859     2.38   0.017     .0005405    .0055867
    educhead |   .0486414   .0057184     8.51   0.000     .0374214    .0598614
      lnland |   .1912535   .0389079     4.92   0.000     .1149127    .2675943
     vaccess |  -.0358233   .0498939    -0.72   0.473    -.1337197    .0620731
       pcirr |   .1189407   .0608352     1.96   0.051    -.0004236     .238305
        rice |   .0069748   .0110718     0.63   0.529    -.0147491    .0286987
       wheat |   -.029278   .0196866    -1.49   0.137    -.0679049     .009349
        milk |   .0141328   .0072647     1.95   0.052    -.0001211    .0283867
         oil |   .0083345   .0038694     2.15   0.031     .0007424    .0159265
         egg |   .1115221   .0612063     1.82   0.069    -.0085702    .2316145
       _cons |   7.609248   .2642438    28.80   0.000     7.090777    8.127718
------------------------------------------------------------------------------


*/

/* After considering other covariates, the results indicate that the variable "progvillf" 
(that measures the impact of the program) is no longer statistically significant. */























































*** 2 - Impacts of Program Participation *** 

/* 

Even though microcredit program assignment is random across villages, the participation may not be. 
Only those households that have fewer than 50 decimals of land can participate in microcredit programs (so-called target groups). 

As before, start this exercise with the simplest method to calculate average treatment effect of program participation for females. 
It is done by using the Stata “ttest” command, which compares the outcome between treated and control villages. */


ttest lexptot, by(dfmfd)

/*

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       0 |     534    8.447977     .023202    .5361619    8.402398    8.493555
       1 |     595    8.453079    .0202292    .4934441    8.413349    8.492808
---------+--------------------------------------------------------------------
Combined |   1,129    8.450665    .0152934    .5138679    8.420659    8.480672
---------+--------------------------------------------------------------------
    diff |            -.005102    .0306448               -.0652292    .0550253   <---------------------------
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =  -0.1665
H0: diff = 0                                     Degrees of freedom =     1127

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.4339         Pr(|T| > |t|) = 0.8678          Pr(T > t) = 0.5661

 

 The result are showing that the difference of outcomes between participants and nonparticipant is insignificant.

*/

 



* Alternately, you can run the simple regression model—outcome against female participation:
reg lexptot dfmfd

/*
      Source |       SS           df       MS      Number of obs   =     1,129
-------------+----------------------------------   F(1, 1127)      =      0.03
       Model |  .007325582         1  .007325582   Prob > F        =    0.8678
    Residual |  297.852604     1,127  .264288025   R-squared       =    0.0000
-------------+----------------------------------   Adj R-squared   =   -0.0009
       Total |   297.85993     1,128  .264060221   Root MSE        =    .51409

------------------------------------------------------------------------------
     lexptot | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       dfmfd |    .005102   .0306448     0.17   0.868    -.0550253    .0652292   <---------------------------
       _cons |   8.447977   .0222468   379.74   0.000     8.404327    8.491626
------------------------------------------------------------------------------


The regression illustrates that the effect of female participation in microcredit programs is not different from zero.

*/ 





* Now, similarly to the regression of village program placement, include other household -and village- level covariates 
* in the female participation equation:

reg lexptot dfmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw=weight]

/*

Linear regression                               Number of obs     =      1,129
                                                F(12, 1116)       =      19.72
                                                Prob > F          =     0.0000
                                                R-squared         =     0.2478
                                                Root MSE          =     .46093

------------------------------------------------------------------------------
             |               Robust
     lexptot | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       dfmfd |   .0654911   .0348852     1.88   0.061    -.0029569     .133939   <---------------------------
     sexhead |  -.0331386   .0647884    -0.51   0.609    -.1602593    .0939822
     agehead |   .0031133    .001314     2.37   0.018      .000535    .0056915
    educhead |   .0493265   .0060583     8.14   0.000     .0374395    .0612134
      lnland |   .2058408   .0421675     4.88   0.000     .1231043    .2885774
     vaccess |  -.0295222   .0501813    -0.59   0.556    -.1279825    .0689381
       pcirr |   .1080647   .0610146     1.77   0.077    -.0116515    .2277809
        rice |   .0057045   .0112967     0.50   0.614    -.0164607    .0278696
       wheat |  -.0295285   .0195434    -1.51   0.131    -.0678744    .0088174
        milk |   .0136748   .0073334     1.86   0.062    -.0007139    .0280636
         oil |   .0079069   .0038484     2.05   0.040      .000356    .0154579
         egg |   .1129842   .0612986     1.84   0.066    -.0072893    .2332577
       _cons |   7.560953    .278078    27.19   0.000     7.015339    8.106568
------------------------------------------------------------------------------

The results show that female participation impact to household expenditure has now changed from insignificant to significant (10 percent level).

*/







































































*** 3 - Capturing Both Program Placement and Participation *** 

* The previous two exercises showed in separate regressions the effects of program placement and program participation. 

* However, these two effects can be combined in the same regression, which gives a more unbiased estimate.


reg lexptot dfmfd progvillf sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg [pw=weight]

/*

Linear regression                               Number of obs     =      1,129
                                                F(13, 1115)       =      18.34
                                                Prob > F          =     0.0000
                                                R-squared         =     0.2490
                                                Root MSE          =     .46079

------------------------------------------------------------------------------
             |               Robust
     lexptot | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       dfmfd |   .0737423   .0359919     2.05   0.041     .0031228    .1443618    <---------------------------
   progvillf |  -.0747142    .107158    -0.70   0.486    -.2849682    .1355397
     sexhead |  -.0377076   .0641847    -0.59   0.557    -.1636439    .0882288
     agehead |   .0030077   .0012831     2.34   0.019     .0004901    .0055254
    educhead |   .0499607   .0057753     8.65   0.000      .038629    .0612924
      lnland |   .2040906    .040482     5.04   0.000     .1246611    .2835201
     vaccess |  -.0348664   .0494669    -0.70   0.481    -.1319252    .0621924
       pcirr |   .1071558   .0609133     1.76   0.079    -.0123617    .2266734
        rice |   .0053896    .011106     0.49   0.628    -.0164013    .0271806
       wheat |   -.028722   .0196859    -1.46   0.145    -.0673476    .0099036
        milk |   .0137693   .0072876     1.89   0.059    -.0005297    .0280683
         oil |   .0077801   .0038339     2.03   0.043     .0002576    .0153025
         egg |   .1137676   .0614016     1.85   0.064    -.0067082    .2342433
       _cons |    7.64048   .2627948    29.07   0.000     7.124852    8.156108
------------------------------------------------------------------------------

The results show no significant effect of program placement 
but a positive significant effect (7.3 percent) of female program participants (t = 2.05).

*/




















































*** 4 - Impacts of Program Participation in Program Villages *** 

* Now, see if program participation matters for households living in program villages. 
* Start with the simple model, and restrict the sample to program villages:
reg lexptot dfmfd if progvillf==1 [pw=weight]



/* 

Linear regression                               Number of obs     =      1,062
                                                F(1, 1060)        =       3.57
                                                Prob > F          =     0.0590
                                                R-squared         =     0.0044
                                                Root MSE          =     .51788

------------------------------------------------------------------------------
             |               Robust
     lexptot | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       dfmfd |  -.0700156   .0370416    -1.89   0.059    -.1426987    .0026675    <---------------------------
       _cons |   8.519383   .0294207   289.57   0.000     8.461653    8.577112
------------------------------------------------------------------------------


The result shows that the impact of female participation in microcredit programs 
on household expenditure in program villages is in fact negative. 
Female participation lowers per capita expenditure of households in program villages by 7.0 percent. */ 


* Now regress the extended model (that is, including other variables that influence the total expenditures)
reg lexptot dfmfd sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg if progvillf==1 [pw=weight]

/*


Linear regression                               Number of obs     =      1,062
                                                F(12, 1049)       =      18.69
                                                Prob > F          =     0.0000
                                                R-squared         =     0.2567
                                                Root MSE          =      .4498

------------------------------------------------------------------------------
             |               Robust
     lexptot | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       dfmfd |   .0670471   .0354779     1.89   0.059    -.0025687    .1366629    <---------------------------
     sexhead |   -.050392   .0656695    -0.77   0.443    -.1792505    .0784666
     agehead |   .0025747    .001273     2.02   0.043     .0000768    .0050727
    educhead |   .0542814   .0056875     9.54   0.000     .0431212    .0654416
      lnland |   .1641575   .0337974     4.86   0.000     .0978392    .2304758
     vaccess |  -.0389844   .0498359    -0.78   0.434    -.1367739    .0588051
       pcirr |   .1246202   .0592183     2.10   0.036     .0084203    .2408201
        rice |   .0006952   .0103092     0.07   0.946    -.0195338    .0209243
       wheat |  -.0299271   .0214161    -1.40   0.163    -.0719504    .0120963
        milk |   .0150224   .0068965     2.18   0.030     .0014899    .0285548
         oil |   .0076239   .0038719     1.97   0.049     .0000263    .0152215
         egg |    .105906   .0598634     1.77   0.077    -.0115597    .2233717
       _cons |   7.667193   .2737697    28.01   0.000     7.129995    8.204392
------------------------------------------------------------------------------

By keeping all other variables constant, you can see that female participation becomes positive and is significant at the 10 percent level.

*/































*** 5 - Measuring Spillover Effects of Microcredit Program Placement ***

/* 
This exercise investigates whether program placement in villages has any impact on nonparticipants. 
This test is similar to what was done at the beginning, but it excludes program participants. 
Start with the simple model and restrict the sample to program villages */

reg lexptot progvillf if dfmfd==0 [pw=weight]

/*

Linear regression                               Number of obs     =        534
                                                F(1, 532)         =       0.00
                                                Prob > F          =     0.9525
                                                R-squared         =     0.0000
                                                Root MSE          =     .55686

------------------------------------------------------------------------------
             |               Robust
     lexptot | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
   progvillf |  -.0074135   .1243228    -0.06   0.952    -.2516373    .2368103    <---------------------------
       _cons |   8.526796   .1207848    70.59   0.000     8.289523     8.76407
------------------------------------------------------------------------------

The result does not show any spillover effects.

*/



* Next, run the extended model regression.
reg lexptot progvillf sexhead agehead educhead lnland vaccess pcirr rice wheat milk oil egg if dfmfd==0 [pw=weight]

/*

Linear regression                               Number of obs     =        534
                                                F(12, 521)        =      17.48
                                                Prob > F          =     0.0000
                                                R-squared         =     0.3254
                                                Root MSE          =     .46217

------------------------------------------------------------------------------
             |               Robust
     lexptot | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
   progvillf |  -.0667122   .1048541    -0.64   0.525     -.272701    .1392766    <---------------------------
     sexhead |  -.0308585   .0919099    -0.34   0.737    -.2114181    .1497011
     agehead |   .0037746   .0017717     2.13   0.034     .0002941    .0072551
    educhead |   .0529039   .0068929     7.68   0.000     .0393625    .0664453
      lnland |   .2384333   .0456964     5.22   0.000     .1486614    .3282053
     vaccess |   .0019065   .0678193     0.03   0.978    -.1313265    .1351394
       pcirr |   .0999683   .0876405     1.14   0.255    -.0722039    .2721405
        rice |   .0118292   .0171022     0.69   0.489    -.0217686     .045427
       wheat |  -.0111823   .0263048    -0.43   0.671    -.0628588    .0404942
        milk |   .0084113   .0096439     0.87   0.384    -.0105344     .027357
         oil |   .0077888   .0050891     1.53   0.127    -.0022089    .0177866
         egg |   .1374734   .0815795     1.69   0.093    -.0227918    .2977386
       _cons |   7.347734   .3449001    21.30   0.000     6.670168      8.0253
------------------------------------------------------------------------------

As can be seen from the output, program placement in villages shows no spillover effect after including the control variables

*/





/*

Further Exercises

Do the same exercise using male participation ("dmmfd"). Discuss the results. */

