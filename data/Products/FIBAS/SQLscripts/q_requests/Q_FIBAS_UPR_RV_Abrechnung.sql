DROP VIEW IF EXISTS `Q_FIBAS_UPR_RV_Abrechnung`;
CREATE VIEW `Q_FIBAS_UPR_RV_Abrechnung` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`Quantum status`,
    `Policies`.`product group`,
    `Policies`.`premium payment`,
    `Policies`.`SP commencement date`,
    `Policies`.`SP term`,
    `Policies`.`SP net premium`,
    TIMESTAMPDIFF(MONTH, STR_TO_DATE(`Policies`.`SP commencement date`, '%d-%m-%Y'), STR_TO_DATE('{ValDat}', '%d-%m-%Y')) AS `PeriodIF`,
    IF(`Policies`.`product` LIKE "%2010%", 0.25,
       IF(`Policies`.`product` LIKE "%2011%" OR `Policies`.`product` = "TAF GoedGezekerd AOV", 0,
          IF(`Policies`.`policy terms` = "QL_MLBK_03_2014", 0.0755, 0.1))) AS `CommRate`,
    (`Policies`.`SP term` - (SELECT `PeriodIF`)) / `Policies`.`SP term` * `Policies`.`SP net premium` * (1 - (SELECT `CommRate`)) AS `UPR`
FROM 
    `Policies`
WHERE 
    (((`Policies`.`Quantum status`) = "Active")
    AND ((`Policies`.`premium payment`) <> "Monthly premium")
    AND ((STR_TO_DATE(`Policies`.`SP commencement date`, '%d-%m-%Y')) < STR_TO_DATE('{ValDat}', '%Y-%m-%d %H:%i:%s')));