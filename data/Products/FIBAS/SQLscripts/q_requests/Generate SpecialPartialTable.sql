CREATE TABLE IF NOT EXISTS `SpecialPartialTable` AS
SELECT
    `ClaimsBasic`.`claim_id`,
    `ClaimsBasic`.`eerste_polis_nummer`,
    `ClaimsBasic`.`betaling_eind_datum`,
    ClaimsStatus(`claim_status`) AS `Status`,
    `ClaimsBasic`.`AO-%`,
    CAST(LEFT(`ClaimsBasic`.`ongeschiktheidsniveau`, 2) AS UNSIGNED) AS `PartDef`,
    IF((SELECT `AO-%`)<(SELECT `PartDef`),"Yes","No") AS `Special`
FROM
    `ClaimsBasic`
WHERE
    ClaimsStatus(`claim_status`) = "Accepted";