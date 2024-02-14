DROP VIEW IF EXISTS `Q_ClaimsAnalysis`;
CREATE VIEW `Q_ClaimsAnalysis` AS
SELECT 
    `Claims`.*,
    YEAR(STR_TO_DATE(`gebeurtenis_datum`, '%d-%m-%Y')) AS `OY`,
    `Policies`.`product`,
    IF(`Policies`.`product` LIKE "%Maand%", "MLB", "ZSP") AS `prod`,
    IF(`Policies`.`product` LIKE "%2010%", 2010, IF(`product` LIKE "%2011%", 2011, 200809)) AS `book`,
    `Policies`.`cover code`,
    `Policies`.`benefit_duration`,
    IF(`Policies`.`cover code` LIKE "%80%", "P80", IF(`Policies`.`cover code` LIKE "%voll%", "F35", "P35")) AS `cover`,
    IF(`Policies`.`cover code` LIKE "%gang%", "Any", IF(`Policies`.`cover code` LIKE "%beroep%", "Own", "Suitable")) AS `occup`
FROM 
    `Claims` 
    LEFT JOIN `Policies` ON `Claims`.`eerste_polis_nummer` = Policies.`policy number`
WHERE 
    (((YEAR(STR_TO_DATE(`gebeurtenis_datum`, '%d-%m-%Y'))) = 2011));