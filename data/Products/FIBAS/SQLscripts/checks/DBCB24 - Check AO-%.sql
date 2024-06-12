INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`indexatie_percentage`),"Indexatie percentage empty","Invalid indexatie percentage") AS `Error`,
"AO-%" AS `Variable`,
`ClaimsBasic`.`AO-%` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`AO-%`)<0 Or (`ClaimsBasic`.`AO-%`)>100));