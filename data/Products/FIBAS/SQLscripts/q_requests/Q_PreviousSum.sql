DROP VIEW IF EXISTS `Q_PreviousSum`;
CREATE VIEW `Q_PreviousSum` AS
SELECT 
    `Q_Previous`.`Status` AS `Выражение1`,
    COUNT(`Q_Previous`.`policy number`) AS `NumberOfPolicies`,
    SUM(`Q_Previous`.`Reserve_active_part` + `Q_Previous`.`Reserve_nonactive_part`) AS `Reserve`,
    SUM(`Q_Previous`.`Reserve_active_part`) AS `Reserve_activ`,
    SUM(`Q_Previous`.`Reserve_nonactive_part`) AS `Reserve_nonactive`
FROM 
    `Q_Previous`
GROUP BY 
    `Q_Previous`.`Status`;