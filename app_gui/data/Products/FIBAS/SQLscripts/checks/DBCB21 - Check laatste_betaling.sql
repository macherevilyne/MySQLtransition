INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`laatste_betaling`),"laatste_betaling empty","Invalid laatste_betaling") AS `Error`,
"laatste_betaling" AS `Variable`,
`ClaimsBasic`.`laatste_betaling` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic` LEFT JOIN `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`
WHERE (((STR_TO_DATE(`ClaimsBasic`.`laatste_betaling`, '%d-%m-%Y'))<STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))
And ((`ClaimsBasic`.`claim_status`)="DISABILITY")
And ((`Claims`.`reserveringen_betaald`)<0))
    Or (((`ClaimsBasic`.`laatste_betaling`) Is Null)
And ((`Claims`.`reserveringen_betaald`)<0));