clear

cd "D:\Rati\Blog\Blog 17\data"

use CB2019_Georgia_response_30Jan2020.dta

******************* DV   *******************
/// havejob base on the EMPLSIT

//// EMPLSIT => havejob 
/* 1 = empl 0 = no */
gen havejob = EMPLSIT
recode havejob (5/6 = 1) (1/4 = 0) (7/8 = 0) (-9 / -1 = . )


******************* IV   *******************

/// demographic vars: sett, age, gender, education,  minority
/// knowleadge of English: english
/// knowleadge of computer: computer

/// =================================================================================
/// recoding demographic variables 
/// =================================================================================

/// STRATUM
gen sett = STRATUM

/// RESPAGE
gen age = RESPAGE

recode age (18/24 = 1) (25/34 =2)  (35/44 =3 ) (45/54 =4) (55/64 =5 ) (65/74 =6) (74/200 = 7)

/// gender
/// recoding Female from 2 to 0
gen gender = RESPSEX
recode gender (2=0) /// female = 0 


//// RESPEDU  => education 
/*  1 = secondary or lower 2 = secodanry technical 3 = higher */
gen education = RESPEDU
recode education (1/4 = 1) (5 = 2) (6/8 = 3) (-9 / -1 = .)

///  ETHNIC -- Ethnicity of the respondent  => minority
/* 0 = Georgian   1 = Non-Georgian   */
gen minority = ETHNIC
recode minority (4 / 7 = 1)  (3 =0) (2=1) (1=1) (-9 / -1 = .)


/// =================================================================================
/// reported language knowleadge
/// =================================================================================
/// dummy of knowleadge at least one foreign langauge above Beginner (KNOWRUS KNOWENG KNOWOTH)
gen language = 0

replace language = 1 if KNOWRUS > 2 | KNOWENG  > 2 | KNOWOTH  > 2

/// =================================================================================
/// reported language of English
/// =================================================================================
gen english = KNOWENG
recode english (-2/-1 = 0) (1 = 0 ) (2/4 = 1)


/// =================================================================================
/// reported language of computer
/// =================================================================================
gen computer = COMPABL
recode computer (-2/-1 = 0) (1 = 0 ) (2/4 = 1)


//// Weighting

svyset PSU [pweight=INDWT], strata(SUBSTRATUM) fpc(NPSUSS) singleunit(certainty) || ID, fpc(NHHPSU) || _n, fpc(NADHH)



stop

  
 /// =========================================================================================================================
/// MODEL 1 - Only demopgrahpic sett age gender education  minority 
/// =========================================================================================================================
svy: logit  havejob i.sett i.age gender  minority i.education 
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)


svy: logit  havejob i.sett i.age gender  minority i.education 
margins, at(sett=(1 2 3))
marginsplot
 
svy: logit  havejob i.sett i.age gender  minority i.education 
margins, at(age=(1 2 3 4 5 6 7 ))
marginsplot
 
svy: logit  havejob i.sett i.age gender  minority i.education 
margins, at(gender=(0 1))
marginsplot

svy: logit  havejob i.sett i.age gender  minority i.education 
margins, at(minority=(0 1))
marginsplot
 

svy: logit  havejob i.sett i.age gender  minority i.education 
margins, at(education=(1 2 3 ))
marginsplot 



 /// =========================================================================================================================
/// MODEL 2 - demopgrahpic (sett age gender education  minority )  + knowleadge of English
/// =========================================================================================================================

svy: logit  havejob i.sett i.age gender  minority i.education english
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)

svy: logit  havejob i.sett i.age gender  minority i.education english
margins, at(english=(0 1))
marginsplot

 /// =========================================================================================================================
/// MODEL 3 - demopgrahpic (sett age gender education  minority )  + knowleadge of Computer
/// =========================================================================================================================

svy: logit  havejob i.sett i.age gender  minority i.education computer
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)


svy: logit  havejob i.sett i.age gender  minority i.education computer
margins, at(computer=(0 1))
marginsplot
