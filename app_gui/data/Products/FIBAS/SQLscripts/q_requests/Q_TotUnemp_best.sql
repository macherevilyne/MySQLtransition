DROP VIEW IF EXISTS `Q_TotUnemp_best`;
CREATE VIEW `Q_TotUnemp_best` AS
SELECT 
    `Policies`.`Quantum status`,
    `Policies`.`premium payment`,
    `Policies`.`WW`,
    `Policies`.`RP premium WW`,
    `Policies`.`RP net premium WW`,
    `Policies`.`total_term`,
    `Policies`.`cover`,
    `Policies`.`commencement date`
FROM 
    `Policies`
GROUP BY 
    `Policies`.`Quantum status`,
    `Policies`.`premium payment`,
    `Policies`.`WW`,
    `Policies`.`RP premium WW`,
    `Policies`.`RP net premium WW`,
    `Policies`.`total_term`,
    `Policies`.`cover`,
    `Policies`.`commencement date`
HAVING 
    ((`Policies`.`Quantum status` = "active") AND (`Policies`.`WW` = "Yes"))
ORDER BY 
    `Policies`.`commencement date`;