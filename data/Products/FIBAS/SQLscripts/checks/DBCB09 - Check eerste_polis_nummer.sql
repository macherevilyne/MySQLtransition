INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`eerste_polis_nummer`),"eerste_polis_nummer empty","Invalid eerste_polis_nummer") AS `Error`,
"eerste_polis_nummer" AS `Variable`,
`ClaimsBasic`.`eerste_polis_nummer` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic` LEFT JOIN `Policies` ON `ClaimsBasic`.`eerste_polis_nummer` = `Policies`.`policy number`
WHERE (((`ClaimsBasic`.`eerste_polis_nummer`) Is Null))
    Or (((`Policies`.`policy number`) Is Null));