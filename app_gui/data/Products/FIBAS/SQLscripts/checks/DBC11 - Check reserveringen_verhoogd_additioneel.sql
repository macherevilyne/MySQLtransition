INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`reserveringen_verhoogd_additioneel`),"reserveringen_verhoogd_additioneel empty","Invalid reserveringen_verhoogd_additioneel") AS `Error`,
"reserveringen_verhoogd_additioneel" AS `Variable`,
`Claims`.`reserveringen_verhoogd_additioneel` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`reserveringen_verhoogd_additioneel`) Is Null
    Or (`Claims`.`reserveringen_verhoogd_additioneel`)<0));