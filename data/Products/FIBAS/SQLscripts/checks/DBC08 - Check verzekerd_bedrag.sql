INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`verzekerd_pedrag`),"verzekerd_bedrag empty","Invalid verzekerd_bedrag") AS `Error`,
"verzekerd_pedrag" AS `Variable`,
`Claims`.`verzekerd_pedrag` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims`
WHERE (((`Claims`.`verzekerd_pedrag`) Is Null
    Or (`Claims`.`verzekerd_pedrag`)<=0));