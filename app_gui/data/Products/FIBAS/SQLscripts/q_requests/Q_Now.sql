DROP VIEW IF EXISTS `Q_Now`;
CREATE VIEW `Q_Now` AS
SELECT 
    IF(`MonetResultsNotAccept`.`PolNo` IS NOT NULL, "not accepted",
       IF(`MonetResultsAll`.`status` = "disable", "accepted", "active")) AS `Status`,
    `Policies`.`policy number` AS `policy number`,
    IF(`MonetResultsNotAccept`.`PolNo` IS NOT NULL, `MonetResultsNotAccept`.`ReserveCalcValDat`,
       IF(`MonetResultsAll`.`status` = "disable", `MonetResultsAll`.`ReserveCalcValDat`, 0)) AS `Reserve_nonactive_part`,
    IF(`MonetResultsAll`.`status` <> "disable", `MonetResultsAll`.`ReserveCalcValDat`, 0) AS `Reserve_active_part`
FROM 
    (`MonetResultsAll`
    LEFT JOIN `MonetResultsNotAccept` ON `MonetResultsAll`.`PolNo` = `MonetResultsNotAccept`.`PolNo`)
    INNER JOIN `Policies` ON `MonetResultsAll`.`PolNo` = `Policies`.`policy number`
WHERE 
    (STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') <= STR_TO_DATE(`CommDate`, '%d-%m-%Y'));