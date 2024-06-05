INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`totaal_betaald_verzekeraar`),"totaal_betaald_verzekeraar empty","Invalid totaal_betaald_verzekeraar") AS `Error`,
"totaal_betaald_verzekeraar" AS `Variable`,
`Claims`.`totaal_betaald_verzekeraar` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`totaal_betaald_verzekeraar`) Is Null
    Or (`Claims`.`totaal_betaald_verzekeraar`)<0));