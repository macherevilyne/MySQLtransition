INSERT INTO DBCErrorTable(`Claim ID`,Error,Variable,`Value`, Status)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`totaal_betaald_taf`),"totaal_betaald_taf empty","Invalid totaal_betaald_taf") AS `Error`,
"totaal_betaald_taf" AS `Variable`,
`Claims`.`totaal_betaald_taf` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`totaal_betaald_taf`) Is Null
    Or (`Claims`.`totaal_betaald_taf`)<0));