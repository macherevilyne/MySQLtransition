DROP TABLE IF EXISTS `Monet Inputs ExpDeath`;
CREATE TABLE IF NOT EXISTS `Monet Inputs ExpDeath` AS
SELECT Policydata_to_Quantum_ORIGINAL.`Policy Nr` AS PolNo,
       TIMESTAMPDIFF(MONTH,STR_TO_DATE('{date_data_extract}', '%d-%m-%Y'),STR_TO_DATE(`DOC`, '%d-%m-%Y')) AS PeriodIF,
       IF(`CalcEngine`>=5 Or ISNULL(`CalcEngine`),"TermNew","Term") AS Product,
       Policydata_to_Quantum_ORIGINAL.`Joined lives` AS Joined,
       Policydata_to_Quantum_ORIGINAL.Gender1 AS Sex1,
       Policydata_to_Quantum_ORIGINAL.Gender2 AS Sex2,
       "Netherlands" AS Country,
       YEAR(STR_TO_DATE(`DOC`, '%d-%m-%Y'))-YEAR(STR_TO_DATE(`DOB1`, '%d-%m-%Y')) AS AgeEnt1,
       IF(ISNULL(`DOB2`),0,YEAR(STR_TO_DATE(`DOC`, '%d-%m-%Y'))-YEAR(STR_TO_DATE(`DOB2`, '%d-%m-%Y'))) AS AgeEnt2,
       IF(`Smoke1`="No","NonSmoker","Smoker") AS Smoker1,
       IF(`Smoke2`="No","NonSmoker","Smoker") AS Smoker2,
       IF(`Freq`="Monthly",12,IF(`Freq`="Yearly",1,IF(`Freq`="Single",99,99999))) AS PremFreq,
       IF(ISNULL(`QP Single`),0,`QP Single`) AS SPadd,
       IF(`CalcEngine`=3 Or `CalcEngine`=10 Or `CalcEngine`=12 Or `CalcEngine`=21,12*`Insured life 1 SA`*IF(`TermOfBenefit`=0,`Term Cover`,IF(`TermOfBenefit`=99,85-TIMESTAMPDIFF(YEAR,STR_TO_DATE(`DOB2`, '%d-%m-%Y'),STR_TO_DATE('{date_data_extract}', '%d-%m-%Y')),`TermOfBenefit`)),`Insured life 1 SA`) AS SumAssuredEnt,
       Policydata_to_Quantum_ORIGINAL.`Term (years)` AS TermPrem,
       Policydata_to_Quantum_ORIGINAL.`Term Cover` AS Term,
       IF(`CalcEngine`=3 Or `CalcEngine`=10 Or `CalcEngine`=12 Or `CalcEngine`=21,IF(`TermOfBenefit`<`Term Cover` And `TermOfBenefit`>0,"Level","Reducing"),IF(`Insured life 1 Type`="Level","Level",IF(`Insured life 1 Type`="StraightLine","Reducing",IF(`Insured life 1 Type`="Annuity","Mortgage",IF(`Insured life 1 Type`="Annuity Increasing","Increasing",IF(`Insured life 1 Type`="Linear Increasing","Linear","")))))) AS BenefitType,
       IF(ISNULL(Policydata_to_Quantum_ORIGINAL.`Annuity percentage 1`),0,Policydata_to_Quantum_ORIGINAL.`Annuity percentage 1`) AS MortgageRate,
       Policydata_to_Quantum_ORIGINAL.`Insured life 2 SA` AS SumAssuredEnt2,
       IF(`Insured life 2 Type`="Level","Level",IF(`Insured life 2 Type`="StraightLine","Reducing",IF(`Insured life 2 Type`="Annuity","Mortgage",IF(`Insured life 2 Type`="Annuity Increasing","Increasing",IF(`Insured life 2 Type`="Linear Increasing","Linear",""))))) AS BenefitType2,
       IF(ISNULL(Policydata_to_Quantum_ORIGINAL.`Annuity percentage 2`),0,Policydata_to_Quantum_ORIGINAL.`Annuity percentage 2`) AS MortgageRate2,
       IFNULL(`Insured Life 1 SA Enddate`,0) AS SumAssuredEnd,
       1 AS `Count`,
       IF(ISNULL(`QP`),0,`QP`*(SELECT `PremFreq`)) AS AnnualPremium,
       "False" AS CalcPremium,
       Policydata_to_Quantum_ORIGINAL.DOC,
       DATE_ADD(STR_TO_DATE(`DOC`, '%d-%m-%Y'), INTERVAL `Term` YEAR) AS EndDate,
       Policydata_to_Quantum_ORIGINAL.`Internal status`,
       IF(ISNULL(`Cancel Date`) Or STR_TO_DATE(`Cancel Date`, '%Y-%m-%d')>STR_TO_DATE('{ValDat}', '%d-%m-%Y'),
            TIMESTAMPDIFF(MONTH,STR_TO_DATE(`DOC`, '%d-%m-%Y'),IF(TIMESTAMPDIFF(MONTH,STR_TO_DATE('{ValDat}', '%d-%m-%Y'),(SELECT `EndDate`))>=0,STR_TO_DATE('{ValDat}', '%d-%m-%Y'),(SELECT `EndDate`))),
            TIMESTAMPDIFF(MONTH,STR_TO_DATE(`DOC`, '%d-%m-%Y'), STR_TO_DATE(`Cancel Date`, '%Y-%m-%d'))) AS TimeIF,
       IF(ISNULL(`Policydata_to_Quantum_ORIGINAL`.`CalcEngine`),16,`Policydata_to_Quantum_ORIGINAL`.`CalcEngine`) AS CalcEngine,
       Policydata_to_Quantum_ORIGINAL.`bGuaranteed Loading` AS Guarantee,
       Policydata_to_Quantum_ORIGINAL.`Type of application` AS ApplicationType,
       IF(`CalcEngine`<5 Or `CalcEngine`=6,0.12,IF(`CalcEngine`<8,0.06,IF(`CalcEngine`=14 Or `CalcEngine`=15 Or (`CalcEngine`>=17 And `CalcEngine`<=21),0.03,IF(`CalcEngine`=22 Or `CalcEngine`=23,0.036,IF(`CalcEngine`=16 Or ISNULL(`CalcEngine`),IF((SELECT `BenefitType`)="Level",0.03,0.05),0))))) AS CommissionSP,
       IF(`CalcEngine`<5 Or `CalcEngine`=6,0.1,IF(`CalcEngine`<8,0.06,IF(`CalcEngine`=14 Or `CalcEngine`=15 Or (`CalcEngine`>=17 And `CalcEngine`<=21),0.03,IF(`CalcEngine`=22 Or `CalcEngine`=23,0.036,IF(`CalcEngine`=16 Or ISNULL(`CalcEngine`),IF((SELECT `BenefitType`)="Level",0.03,0.05),0))))) AS CommissionRP,
       0 AS AddPrem,
       IF(`calcEngine`=5 Or `calcEngine`=7 Or (`CalcEngine`>=17 And `CalcEngine`<=23) Or ((`CalcEngine`=16 Or ISNULL(`CalcEngine`)) And (SELECT `BenefitType`)="Level"),IF(`Term (years)`<25,`Term (years)`,25),`Term (years)`) AS TermComm,
       IF(`CalcEngine`<3,"HanRe2009_q75r400",IF(`CalcEngine`=5 Or `CalcEngine`=7 Or `CalcEngine`=9,"NewPricing2010_q75r400",IF(`CalcEngine`=11,"NewPricingUnisex_q75r400",IF(`CalcEngine`=14 Or `CalcEngine`=15 Or `CalcEngine`=16 Or ISNULL(`CalcEngine`),"PricingUnisex2013_q75r400",IF((`CalcEngine`>=17 And `CalcEngine`<=23),"PricingUnisex2018_q75r400",IF('{fib_reinsured}'="Y" And (`CalcEngine`=3 Or `CalcEngine`=10 Or `CalcEngine`=12),IF(STR_TO_DATE(`DOC`, '%d-%m-%Y')<STR_TO_DATE("01.01.2010", '%d.%m.%Y'),"HanRe2009_q75r400",IF(STR_TO_DATE(`DOC`, '%d-%m-%Y')<STR_TO_DATE("01.01.2013", '%d.%m.%Y'),"NewPricing2010_q75r400",IF(STR_TO_DATE(`DOC`, '%d-%m-%Y')<STR_TO_DATE("01.01.2014", '%d.%m.%Y'),"NewPricingUnisex_q75r400","PricingUnisex2013_q75r400"))),"NotReinsured")))))) AS RIModel,
       Policydata_to_Quantum_ORIGINAL.`OS 1` AS MortLoad1,
       Policydata_to_Quantum_ORIGINAL.`OS 2` AS MortLoad2
FROM Policydata_to_Quantum_ORIGINAL
WHERE ((Policydata_to_Quantum_ORIGINAL.`Internal status`="Issued"
    Or Policydata_to_Quantum_ORIGINAL.`Internal status`="Cleared to issue"
    Or Policydata_to_Quantum_ORIGINAL.`Internal status` Like "Cancelled Policy*")
    And Policydata_to_Quantum_ORIGINAL.DOC Is Not Null
    And TIMESTAMPDIFF(MONTH,STR_TO_DATE(`DOC`, '%d-%m-%Y'),STR_TO_DATE('{date_data_extract}', '%d-%m-%Y'))<=0)
ORDER BY Policydata_to_Quantum_ORIGINAL.`Policy Nr`;
CREATE INDEX idx_PolNo_ExpDeath ON `Monet Inputs ExpDeath` (PolNo);