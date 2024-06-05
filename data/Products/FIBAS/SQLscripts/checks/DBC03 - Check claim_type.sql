INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`claim_type`),"claim_type empty","Invalid claim_type") AS `Error`,
"claim_type" AS Variable, 
`Claims`.`claim_type` AS `Value`,
`Claims`.`status` AS `Status`
FROM Claims
WHERE (((`Claims`.`claim_type`)<>"DISABILITY"
And (`Claims`.`claim_type`)<>"DEATH"
And (`Claims`.`claim_type`)<>"UNEMPLOYMENT"));