INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`ClaimsBasic`.`betaling_start_datum`),"betaling_start_datum empty","Invalid betaling_start_datum") AS `Error`,
"betaling_start_datum" AS `Variable`,
ClaimsBasic.betaling_start_datum AS `Value`,
ClaimsBasic.claim_status AS `Status`
FROM `ClaimsBasic` LEFT JOIN `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`
WHERE (((`ClaimsBasic`.`betaling_start_datum`) Is Null
    Or (STR_TO_DATE(`ClaimsBasic`.`betaling_start_datum`, '%d-%m-%Y'))<STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'))
And ((ClaimsStatus(`ClaimsBasic`.`claim_status`))<>"Terminated"))
    Or (((`ClaimsBasic`.`betaling_start_datum`) Is Null
    Or (STR_TO_DATE(`ClaimsBasic`.`betaling_start_datum`, '%d-%m-%Y'))<STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'))
And ((`Claims`.`reserveringen_betaald`)<0));