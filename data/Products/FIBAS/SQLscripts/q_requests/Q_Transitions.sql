DROP VIEW IF EXISTS `Q_Transitions`;
CREATE VIEW `Q_Transitions` AS
SELECT 
    `Q_Previous`.`policy number`,
    `Q_Previous`.`Status` AS `Status1`,
    IF(`Q_Now`.`policy number` IS NULL, "left", `Q_Now`.`Status`) AS `Status2`,
    `Q_Previous`.`Reserve_active_part` AS `Reserve_active_part1`,
    `Q_Now`.`Reserve_active_part` AS `Reserve_active_part2`,
    `Q_Previous`.`Reserve_nonactive_part` AS `Reserve_nonactive_part1`,
    `Q_Now`.`Reserve_nonactive_part` AS `Reserve_nonactive_part2`
FROM 
    `Q_Previous` 
LEFT JOIN 
    `Q_Now` ON `Q_Previous`.`policy number` = `Q_Now`.`policy number`
ORDER BY 
    `Q_Previous`.Status,
    IF(`Q_Now`.`policy number` IS NULL, "left", `Q_Now`.`Status`);