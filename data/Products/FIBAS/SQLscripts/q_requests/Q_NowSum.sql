DROP VIEW IF EXISTS `Q_NowSum`;
CREATE VIEW `Q_NowSum` AS
SELECT 
    `Q_Now`.`Status` AS `Expression1`,
    COUNT(`Q_Now`.`policy number`) AS `NumberOfPolicies`,
    SUM(`Q_Now`.`Reserve_nonactive_part` + `Q_Now`.`Reserve_active_part`) AS `Reserve`,
    SUM(`Q_Now`.`Reserve_active_part`) AS `Reserve_activ`,
    SUM(`Q_Now`.`Reserve_nonactive_part`) AS `Reserve_nonactive`
FROM 
    `Q_Now`
GROUP BY 
    `Q_Now`.`Status`;