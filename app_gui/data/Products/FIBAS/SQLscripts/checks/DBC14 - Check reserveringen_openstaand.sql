INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.claim_id,
IF(ISNULL(`reserveringen_openstaand`),"reserveringen_openstaand empty","Invalid reserveringen_openstaand") AS `Error`,
"reserveringen_openstaand" AS `Variable`,
`Claims`.`reserveringen_openstaand` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`reserveringen_openstaand`) Is Null
    Or (`Claims`.`reserveringen_openstaand`)<0));