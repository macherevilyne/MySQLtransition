INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`totaal_uit_te_keren_bedrag`),"totaal_uit_te_keren_bedrag empty","Invalid totaal_uit_te_keren_bedrag") AS `Error`,
"totaal_uit_te_keren_bedrag" AS `Variable`,
`ClaimsBasic`.`totaal_uit_te_keren_bedrag` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`totaal_uit_te_keren_bedrag`) Is Null
    Or (`ClaimsBasic`.`totaal_uit_te_keren_bedrag`)<=0
    Or (`ClaimsBasic`.`totaal_uit_te_keren_bedrag`)>`totaal_verzekerd_bedrag`*(1+COALESCE(`indexatie_percentage`)/100)^TIMESTAMPDIFF(YEAR,STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'),STR_TO_DATE('{ValDat}', '%d-%m-%Y'))+0.01));