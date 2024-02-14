DROP VIEW IF EXISTS `Copy Of Q_NewBusiness`;
CREATE VIEW `Copy Of Q_NewBusiness` AS
SELECT 
    COUNT(`MonetResultsAll`.`PolNo`) AS `CountOfPolNo`,
    SUM(`MonetResultsAll`.`ReserveCalcValDat`) AS `SumOfReserveCalcValDat`,
    `MonetResultsAll`.`Status`
FROM 
    `MonetResultsAll` 
    INNER JOIN `Policies` ON `MonetResultsAll`.`PolNo` = `Policies`.`policy number`
WHERE 
    STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') >= STR_TO_DATE(`begin_date`, '%d-%m-%Y') AND 
    STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') < STR_TO_DATE(`end_date`, '%d-%m-%Y')
GROUP BY 
    `MonetResultsAll`.`Status`;