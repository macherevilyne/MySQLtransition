DROP VIEW IF EXISTS `Q_UPR_FIBAS_Split`;
CREATE VIEW `Q_UPR_FIBAS_Split` AS
SELECT 
    STR_TO_DATE('{ValDat}', '%d-%m-%Y') AS `ValDate`,
    `Q_FIBAS_UPR_ByProdGroup`.`product group`,
    SUM(`Q_FIBAS_UPR_ByProdGroup`.`UPR`) AS `SumOfUPR`
FROM 
    `Q_FIBAS_UPR_ByProdGroup`
GROUP BY 
    `Q_FIBAS_UPR_ByProdGroup`.`product group`;