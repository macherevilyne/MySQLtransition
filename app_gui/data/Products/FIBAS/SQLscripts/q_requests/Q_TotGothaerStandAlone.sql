DROP VIEW IF EXISTS `Q_TotGothaerStandAlone`;
CREATE VIEW `Q_TotGothaerStandAlone` AS
SELECT 
    `Policies`.`Quantum status`,
    `Policies`.`premium payment`,
    `Policies`.`product`,
    SUM(`Policies`.`RP premium`) AS `SummevonRP premium`,
    SUM(`Policies`.`RP net premium`) AS `SummevonRP net premium`,
    AVG(`Policies`.`total_term`) AS `Mittelwertvontotal_term`,
    `Policies`.`policy terms`
FROM 
    `Policies`
GROUP BY 
    `Policies`.`Quantum status`,
    `Policies`.`premium payment`,
    `Policies`.`product`,
    `Policies`.`policy terms`
HAVING 
    ((`Policies`.`Quantum status` = "Active") AND (`Policies`.`product` = "TAF Werkloosheidsplan 2011"));