DROP VIEW IF EXISTS `Q_Previous`;
CREATE VIEW `Q_Previous` AS
SELECT 
    IF(`MonetResultsNotAcceptPreviousYear`.`PolNo` IS NOT NULL, "not accepted",
        IF(`MonetResultsAllPreviousYear`.`status` = "disable", "accepted", "active")) AS `Status`,
    `PoliciesPreviousYear`.`policy number` AS `policy number`,
    IF(
        `MonetResultsNotAcceptPreviousYear`.PolNo IS NOT NULL,
        `MonetResultsNotAcceptPreviousYear`.`ReserveCalcValDat`,
        IF(
            `MonetResultsAllPreviousYear`.`status` = "disable",
            `MonetResultsAllPreviousYear`.`ReserveCalcValDat`,
            0
        )
    ) AS `Reserve_nonactive_part`,
    IF(
        `MonetResultsAllPreviousYear`.`status` <> "disable",
        `MonetResultsAllPreviousYear`.`ReserveCalcValDat`,
        0
    ) AS `Reserve_active_part`
FROM 
    (
        `MonetResultsAllPreviousYear` 
        LEFT JOIN `MonetResultsNotAcceptPreviousYear` 
        ON `MonetResultsAllPreviousYear`.`PolNo` = `MonetResultsNotAcceptPreviousYear`.`PolNo`
    )
    INNER JOIN `PoliciesPreviousYear` 
    ON `MonetResultsAllPreviousYear`.`PolNo` = `PoliciesPreviousYear`.`policy number`
WHERE 
    (STR_TO_DATE(`PoliciesPreviousYear`.`commencement date`, '%d-%m-%Y') <= STR_TO_DATE(`CommDatePrevious`, '%d-%m-%Y'));