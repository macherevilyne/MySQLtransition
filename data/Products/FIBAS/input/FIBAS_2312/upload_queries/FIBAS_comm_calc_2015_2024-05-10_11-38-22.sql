DROP VIEW IF EXISTS `FIBAS comm calc 2015`;
CREATE VIEW `FIBAS comm calc 2015` AS
SELECT 
    `Policies`.`policy number`,
    IF(`Policies`.`policy terms`="QL_GG_03_2015", 2015, 0) AS `book`,
    `Policies`.`commencement date`,
    `Policies`.`RP premium` + IF(ISNULL(`Policies`.`RP premium FIB`), 0, `Policies`.`RP premium FIB`) AS `RP`,
    `Policies`.`RP net premium` + IF(ISNULL(`Policies`.`RP net premium FIB`), 0, `Policies`.`RP net premium FIB`) AS `RP net`,
    `Policies`.`premium payment`,
    `Policies`.`SP premium` AS `SP`,
    `Policies`.`SP net premium` AS `SP net`,
    `Policies`.`total_term`,
    `Policies`.`cancellation date`,
    "n.a." AS `Status Date`,
    `Policies`.`Quantum status`
FROM 
    `Policies`
WHERE 
    (IF(`Policies`.`policy terms`="QL_GG_03_2015", 2015, 0) = 2015) AND 
    (STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') IS NOT NULL) AND 
    (`Policies`.`Quantum status` = "Active")
    OR
    (IF(`Policies`.`policy terms`="QL_GG_03_2015", 2015, 0) = 2015) AND 
    (STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') IS NOT NULL) AND 
    (`Policies`.`Quantum status` = "Lapsed")
ORDER BY 
    `Policies`.`policy number`;