DROP VIEW IF EXISTS `Kopie von Q_NewBusiness`;
CREATE VIEW `Kopie von Q_NewBusiness` AS
SELECT 
    `Q_Now`.`Status`, 
    COUNT(`Q_Now`.`policy number`) AS `NumberOfPolilcies`,
    SUM(`Q_Now`.`Reserve_active_part` + `Q_Now`.`Reserve_nonactive_part`) AS `Reserve`,
    SUM(`Q_Now`.`Reserve_active_part`) AS `Reserve_active`,
    SUM(`Q_Now`.`Reserve_nonactive_part`) AS `Reserve_nonactive`
FROM 
    `Q_Now` 
    LEFT JOIN `Q_Previous` ON `Q_Now`.`policy number` = `Q_Previous`.`policy number`
WHERE 
    `Q_Previous`.`policy number` IS NULL
GROUP BY 
    `Q_Now`.`Status`;