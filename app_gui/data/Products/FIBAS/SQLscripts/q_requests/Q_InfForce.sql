DROP VIEW IF EXISTS `Q_InfForce`;
CREATE VIEW `Q_InfForce` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`Quantum status`,
    `Policies`.`commencement date`
FROM 
    `Policies`
WHERE 
    (((`Policies`.`Quantum status`) = "Active")
    AND (STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') < STR_TO_DATE(`comm_date`, '%d-%m-%Y')));