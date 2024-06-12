INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`reserveringen_verhoogd`),"reserveringen_verhoogd empty","Invalid reserveringen_verhoogd") AS `Error`,
"reserveringen_verhoogd" AS `Variable`,
`Claims`.`reserveringen_verhoogd` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`reserveringen_verhoogd`) Is Null Or (`Claims`.`reserveringen_verhoogd`)<0));