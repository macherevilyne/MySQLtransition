INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`product`),"Product empty","Invalid product") AS `Error`,
`MonetInputsUpdated`.`product` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`product`)="MLB" Or (`MonetInputsUpdated`.`product`)="ZSP")=False));