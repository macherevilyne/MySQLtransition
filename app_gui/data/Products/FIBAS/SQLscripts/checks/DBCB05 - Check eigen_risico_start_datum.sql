INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`claimsBasic`.`eigen_risico_start_datum`),"eigen_risico_start_datum empty","Invalid eigen_risico_start_datum") AS `Error`,
"eigen_risico_start_datum" AS `Variable`,
`ClaimsBasic`.`eigen_risico_start_datum` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM (`ClaimsBasic` LEFT JOIN `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`)
    LEFT JOIN `OvertakenClaims` ON `ClaimsBasic`.`claim_id` = `OvertakenClaims`.`claim_id`
WHERE (((`ClaimsBasic`.`eigen_risico_start_datum`) Is Null
    Or (STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))<STR_TO_DATE(`ClaimsBasic`.`polis_ingangs_datum`, '%d-%m-%Y'))
And ((ClaimsStatus(`ClaimsBasic`.`claim_status`))<>"Terminated")
And ((`OvertakenClaims`.`claim_id`) Is Null))
    Or (((`ClaimsBasic`.`eigen_risico_start_datum`) Is Null
    Or (STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))<STR_TO_DATE(`ClaimsBasic`.`polis_ingangs_datum`, '%d-%m-%Y'))
And ((`Claims`.`reserveringen_betaald`)<0)
And ((`OvertakenClaims`.`claim_id`) Is Null));