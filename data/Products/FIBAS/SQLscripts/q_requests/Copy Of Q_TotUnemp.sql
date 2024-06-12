DROP VIEW IF EXISTS `Copy Of Q_TotUnemp`;
CREATE VIEW `Copy Of Q_TotUnemp` AS
SELECT 
    `Policies`.`Quantum status`,
    `Policies`.`premium payment`,
    `Policies`.`WW`,
    SUM(`Policies`.`RP premium WW`) AS `SumOfRP premium WW`,
    SUM(`Policies`.`RP net premium WW`) AS `SumOfRP net premium WW`,
    AVG(`Policies`.`total_term`) AS `AvgOftotal_term`
FROM 
    `Policies`
GROUP BY 
    `Policies`.`Quantum status`, 
    `Policies`.`premium payment`, 
    `Policies`.`WW`
HAVING 
    `Policies`.`Quantum status` = "Active" AND 
    `Policies`.`WW` = "Yes";