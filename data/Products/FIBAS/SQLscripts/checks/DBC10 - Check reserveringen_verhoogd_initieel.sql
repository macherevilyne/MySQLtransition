INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`reserveringen_verhoogd_initieel`),"reserveringen_verhoogd_initieel empty","Invalid reserveringen_verhoogd_initieel") AS `Error`,
"reserveringen_verhoogd_initieel" AS `Variable`,
`Claims`.`reserveringen_verhoogd_initieel` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`reserveringen_verhoogd_initieel`) Is Null
    Or (`Claims`.`reserveringen_verhoogd_initieel`)<0));