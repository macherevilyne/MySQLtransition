DROP TABLE IF EXISTS `Policydata_to_Quantum_ORIGINAL`;
CREATE TABLE IF NOT EXISTS `Policydata_to_Quantum_ORIGINAL` AS
SELECT Policydata_NewReport.`Policy Number` AS `Policy Nr`,
       Policydata_NewReport.`Product Name` AS Product,
       Policydata_NewReport.`Insured1 Surname` AS `Insured life 1 Surname`,
       Policydata_NewReport.`Insured1 Initials` AS Initials1,
       Policydata_NewReport.`Insured1 date of birth` AS DOB1,
       CONCAT(UPPER(SUBSTRING(`Insured1 Gender`, 1, 1)), LOWER(SUBSTRING(`Insured1 Gender`, 2))) AS Gender1,
       C_Flags.Converted AS Smoke1,
       Policydata_NewReport.`Insured1 Height` AS Height1,
       Policydata_NewReport.`Insured1 Weight` AS Weight1,
       Policydata_NewReport.`Insured1 Income` AS Income1,
       Policydata_NewReport.`Insured1 Assets` AS Assets1,
       C_Occupation.Converted AS OccupationLevel1,
       C_Education.Converted AS EducationLevel1,
       IF((`productgroup`="SURVIVING_DEPENDANTS")
              And `benefitterm`=2147483647,"Yes",
           IF(ISNULL(`Insured2 Surname`),"No","Yes")) AS `Joined lives`,
       Policydata_NewReport.`Insured2 Surname` AS `Insured life 2 Surname`,
       Policydata_NewReport.`Insured2 Initials` AS `Insured life 2 Initials`,
       IF((`productgroup`="SURVIVING_DEPENDANTS") And `benefitterm`=2147483647,`date of birth first beneficiary`,`Insured2 date of birth`) AS DOB2,
       IF((`productgroup`="SURVIVING_DEPENDANTS") And `benefitterm`=2147483647,
           CONCAT(UPPER(SUBSTRING(`gender first beneficiary`, 1, 1)), LOWER(SUBSTRING(`gender first beneficiary`, 2))),
           CONCAT(UPPER(SUBSTRING(`Insured2 gender`, 1, 1)), LOWER(SUBSTRING(`Insured2 gender`, 2)))) AS Gender2,
       C_Flags_1.Converted AS Smoke2,
       Policydata_NewReport.`Insured2 Height` AS Height2,
       Policydata_NewReport.`Insured2 Weight` AS Weight2,
       Policydata_NewReport.`Insured2 Income` AS Income2,
       Policydata_NewReport.`Insured2 Assets` AS Assets2,
       C_Occupation_1.Converted AS OccupationLevel2,
       C_Education_1.Converted AS EducationLevel2,
       Policydata_NewReport.`Insurer name` AS `Underwritten by`,
       C_Flags_2.Converted AS BMIOverride,
       Policydata_NewReport.mortaged AS `Type of application`,
       Policydata_NewReport.`Policy Start date` AS DOC,
       ROUND((`Premium Payment Duration`)/12+0.499,0) AS `Term (years)`,
       IF(`productgroup`="FUNERAL",99,ROUND(`Policy Term`/12+0.499,0)) AS `Term Cover`,
       IF(`Payment method`="MONTHLY" Or `Payment method`="SINGLE_MONTHLY",`Premium Payment Duration`,IF(`Payment method`="ANNUALLY" Or `Payment method`="SINGLE_ANNUALLY",ROUND(`Premium Payment Duration`/12-0.499,0),0)) AS Term,
       Policydata_NewReport.`Insured1 Sum assured` AS `Insured life 1 SA`,
       IF(`Product Calculation Engine`=3 Or `Product Calculation Engine`=4 Or `Product Calculation Engine`=6 Or `Product Calculation Engine`=10 Or `Product Calculation Engine`=12,"Level",`C_CoverType`.`Converted`) AS `Insured life 1 Type`,
       `Insured1 Annuity interest percentage`/100 AS `Annuity percentage 1`,
       Policydata_NewReport.`Insured2 Sum assured` AS `Insured life 2 SA`,
       C_CoverType_1.Converted AS `Insured life 2 Type`,
       `Insured2 Annuity interest percentage`/100 AS `Annuity percentage 2`,
       `Insured1 Extra mortality rate`/100 AS `OS 1`,
       `Insured2 Extra mortality rate`/100 AS `OS 2`,
       `Insured1 Extra mortality rate`/100 AS `PI 1`,
       `Insured2 Extra mortality rate`/100 AS `PI 2`,
       Policydata_NewReport.`Insured premium periodic` AS TP,
       C_Freq.Converted AS Freq,
       Policydata_NewReport.`Insured premium single` AS `TP Single`,
       Policydata_NewReport.`Insurer premium periodic` AS QP,
       Policydata_NewReport.`Insurer premium single` AS `QP Single`,
       IF(`Policy Status`="ENDED" And `productgroup`="FUNERAL","Issued",IF(`Policy Status`="CANCELLED",IF(`Policy Cancellation Reason`="DECEASED","Cancelled Policy - death claim",IF(`Policy Cancellation Reason`="PREMIUM_ARREAR","Cancelled Policy - premiums unpaid",`C_Status`.`Converted`)),`C_Status`.`Converted`)) AS `Internal status`,
       UCASE(`Policydata_NewReport`.`PremiumPayer=PolicyHolder`) AS `PremiumPayer=PolicyHolder`,
       UCASE(`Policydata_NewReport`.`PremiumPayerIDAvailable`) AS PremiumPayerIDAvailable,
       IF(`productgroup`="SURVIVING_DEPENDANTS",IF(`benefitterm`=2147483646,0,IF(`benefitterm`=2147483647,99,`benefitterm`/12)),0) AS TermOfBenefit,
       Policydata_NewReport.`Product Calculation Engine` AS CalcEngine_direct,
       IF(`Product Calculation engine`>0 And `Product Calculation engine`<11,`Product Calculation engine`,`C_CalcEngine`.`Converted`) AS CalcEngine,
       IF(`Policy Status`="REVOKED",
           STR_TO_DATE(`Policy Start Date`, '%d-%m-%Y'),
           IF(`Policy Status`="ENDED" And `productgroup`<>"FUNERAL",
               DATE_ADD(STR_TO_DATE(`Policy Start Date`, '%d-%m-%Y'), INTERVAL `Policy Term` MONTH),
               STR_TO_DATE(`Policy Start Date`, '%d-%m-%Y')
           )
       ) AS `Cancel Date`,
       C_Flags_5.Converted AS `Terminal Illness`,
       Policydata_NewReport.guaranteedloading AS `bGuaranteed Loading`,
       Policydata_NewReport.`Insured1 sum assured at enddate` AS `Insured Life 1 SA Enddate`,
       Policydata_NewReport.`Policy Terms` AS policyTerm,
       IF(`productgroup`="SURVIVING_DEPENDANTS",`C_Flags_6`.`Converted`,`C_Flags_7`.`Converted`) AS optionChild,
       Policydata_NewReport.`sum assured children` AS optionChildSA,
       Policydata_NewReport.`final age of claimpayment` AS optionChildAge,
       C_Flags_8.Converted AS optionPremiumWaiver,
       C_Flags_9.Converted AS optionAccident,
       C_Flags_10.Converted AS optionSurrender,
       Policydata_NewReport.productgroup
FROM (((((((((((((((((Policydata_NewReport LEFT JOIN C_Flags
           ON Policydata_NewReport.`Insured1 Smoker Status` = C_Flags.Original) LEFT JOIN C_Occupation
           ON Policydata_NewReport.`Insured1 OccupationLevel` = C_Occupation.Original) LEFT JOIN C_Education
           ON Policydata_NewReport.`Insured1 EducationLevel` = C_Education.Original) LEFT JOIN C_Flags AS C_Flags_1
    ON Policydata_NewReport.`Insured2 Smoker Status` = C_Flags_1.Original) LEFT JOIN C_Occupation AS C_Occupation_1
    ON Policydata_NewReport.`Insured2 OccupationLevel` = C_Occupation_1.Original) LEFT JOIN C_Education AS C_Education_1
    ON Policydata_NewReport.`Insured2 EducationLevel` = C_Education_1.Original) LEFT JOIN C_Flags AS C_Flags_2
    ON Policydata_NewReport.`BMI override` = C_Flags_2.Original) LEFT JOIN C_CoverType
    ON Policydata_NewReport.`Insured1 Type of cover` = C_CoverType.Original) LEFT JOIN C_CoverType AS C_CoverType_1
    ON Policydata_NewReport.`Insured2 Type of cover` = C_CoverType_1.Original) LEFT JOIN C_Freq
    ON Policydata_NewReport.`Payment method` = C_Freq.Original) LEFT JOIN C_Status
    ON Policydata_NewReport.`Policy Status` = C_Status.Original) LEFT JOIN C_Flags AS C_Flags_5
    ON Policydata_NewReport.`Option Terminal Illness` = C_Flags_5.Original) LEFT JOIN C_Flags AS C_Flags_6
    ON Policydata_NewReport.`Option Surviving Dependants Children` = C_Flags_6.Original) LEFT JOIN C_Flags AS C_Flags_7
    ON Policydata_NewReport.`Option Surviving Deceased Children` = C_Flags_7.Original) LEFT JOIN C_Flags AS C_Flags_8
    ON Policydata_NewReport.`Option Premium Exemption Disability` = C_Flags_8.Original) LEFT JOIN C_Flags AS C_Flags_9
    ON Policydata_NewReport.`Option Accident cover` = C_Flags_9.Original) LEFT JOIN C_Flags AS C_Flags_10
    ON Policydata_NewReport.`Option Surrender value` = C_Flags_10.Original) LEFT JOIN C_CalcEngine
        ON Policydata_NewReport.`Policy Terms` = C_CalcEngine.Original;