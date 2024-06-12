INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`reserveringen_vrijgegeven`),"reserveringen_vrijgegeven empty","Invalid reserveringen_vrijgegeven") AS `Error`,
"reserveringen_vrijgegeven" AS `Variable`,
`Claims`.`reserveringen_vrijgegeven` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`reserveringen_vrijgegeven`) Is Null
    Or (`Claims`.`reserveringen_vrijgegeven`)>0));