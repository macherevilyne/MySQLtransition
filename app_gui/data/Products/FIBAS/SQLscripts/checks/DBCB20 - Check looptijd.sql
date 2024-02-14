INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`looptijd`),"looptijd empty","Invalid looptijd") AS `Error`,
"looptijd" AS `Variable`,
`ClaimsBasic`.`looptijd` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`looptijd`) Is Null
    Or (`ClaimsBasic`.`looptijd`)<=0));