DROP VIEW IF EXISTS `Q_CheckPolicyData`;
CREATE VIEW `Q_CheckPolicyData` AS
SELECT 
    `MonetInputs4`.`PolNo`,
    `MonetInputs4`.`Status`,
    `MonetInputs4_Prev`.`Status`,
    IF(`MonetInputs4`.`FibStat` = `MonetInputs4_Prev`.`FibStat`, 0, 1) AS `Check_FIBStat`,
    IF(STR_TO_DATE(`MonetInputs4`.`commencement date`, '%d-%m-%Y') = STR_TO_DATE(`MonetInputs4_Prev`.`commencement date`, '%d-%m-%Y'), 0, 1) AS `Check_CommDate`,
    IF(`MonetInputs4`.`product` = `MonetInputs4_Prev`.`product`, 0, 1) AS `Check_product`,
    IF(`MonetInputs4`.`book` = `MonetInputs4_Prev`.`book`, 0, 1) AS `Check_book`,
    IF(`MonetInputs4`.`AgeEnt1` = `MonetInputs4_Prev`.`AgeEnt1`, 0, 1) AS `Check_Age`,
    IF(`MonetInputs4`.`Sex1` = `MonetInputs4_Prev`.`Sex1`, 0, 1) AS `Check_Sex`,
    IF(`MonetInputs4`.`ProfessionalClass` = `MonetInputs4_Prev`.`ProfessionalClass` OR (ISNULL(`MonetInputs4`.`ProfessionalClass`) AND ISNULL(`MonetInputs4_Prev`.`ProfessionalClass`)), 0, 1) AS `Check_Prof`,
    IF(`MonetInputs4`.`Term` = `MonetInputs4_Prev`.`Term`, 0, 1) AS `Check_Term`,
    IF(`MonetInputs4`.`StartMthMP` = `MonetInputs4_Prev`.`StartMthMP`, 0, 1) AS `Check_StartMP`,
    IF(`MonetInputs4`.`WaitingTime` = `MonetInputs4_Prev`.`WaitingTime`, 0, 1) AS `Check_Wait`,
    IF(`MonetInputs4`.`BeneDuration` = `MonetInputs4_Prev`.`BeneDuration`, 0, 1) AS `Check_Dur`,
    IF(`MonetInputs4`.`SumAssuredEnt` = `MonetInputs4_Prev`.`SumAssuredEnt`, 0, 1) AS `Check_SA`,
    IF(`MonetInputs4`.`SPadd` = `MonetInputs4_Prev`.`SPadd` OR (ISNULL(`MonetInputs4`.`SPadd`) AND ISNULL(`MonetInputs4_Prev`.`SPadd`)), 0, 1) AS `Check_SPadd`,
    IF(`MonetInputs4`.`MonthlyPremium` = `MonetInputs4_Prev`.`MonthlyPremium`, 0, 1) AS `Check_MP`,
    IF(`MonetInputs4`.`PremFreq` = `MonetInputs4_Prev`.`PremFreq`, 0, 1) AS `Check_Freq`,
    IF(`MonetInputs4`.`DisableDef` = `MonetInputs4_Prev`.`DisableDef`, 0, 1) AS `Check_Def`,
    IF(`MonetInputs4`.`BenefitDef` = `MonetInputs4_Prev`.`BenefitDef`, 0, 1) AS `Check_BeneDef`,
    IF(`MonetInputs4`.`MthOwnOccupation` = `MonetInputs4_Prev`.`MthOwnOccupation`, 0, 1) AS `Check_MthOwn`,
    IF(`MonetInputs4`.`MethPartial` = `MonetInputs4_Prev`.`MethPartial`, 0, 1) AS `Check_MethPart`,
    IF(`MonetInputs4`.`Mental` = `MonetInputs4_Prev`.`Mental`, 0, 1) AS `Check_Mental`,
    IF(`MonetInputs4`.`WoP` = `MonetInputs4_Prev`.`WoP`, 0, 1) AS `Check_WoP`
FROM 
    `MonetInputs4` 
    INNER JOIN `MonetInputs4_Prev` ON `MonetInputs4`.`PolNo` = `MonetInputs4_Prev`.`PolNo`
WHERE 
    (((`MonetInputs4`.`Status`) = "disable") AND ((`MonetInputs4_Prev`.`Status`) = "disable"));