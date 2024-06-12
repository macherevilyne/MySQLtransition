DROP VIEW IF EXISTS `Q_Unemployment_Premium`;
CREATE VIEW `Q_Unemployment_Premium` AS
SELECT 
    `Policies`.`Quantum status`,
    `Policies`.`cover`,
    `Policies`.`WW`,
    `Policies`.`policy terms`,
    SUM(`Policies`.`RP net premium WW`) AS `SumOfRP net premium WW`
FROM 
    `Policies`
WHERE 
    STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') < STR_TO_DATE('{ValDat}', '%d-%m-%Y')
GROUP BY 
    `Policies`.`Quantum status`,
    `Policies`.`cover`,
    `Policies`.`WW`,
    `Policies`.`policy terms`
HAVING 
    `Policies`.`Quantum status` = 'Active' AND `Policies`.`WW` = 'yes';