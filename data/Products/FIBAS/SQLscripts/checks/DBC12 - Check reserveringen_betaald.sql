INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`reserveringen_betaald`),"reserveringen_betaald empty","Invalid reserveringen_betaald") AS `Error`,
"reserveringen_betaald" AS `Variable`,
`Claims`.`reserveringen_betaald` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`reserveringen_betaald`) Is Null
    Or (`Claims`.`reserveringen_betaald`)>0));