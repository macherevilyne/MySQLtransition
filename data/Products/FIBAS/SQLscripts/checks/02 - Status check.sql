INSERT INTO ErrorTable(`PolNo`,`Error`,`Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`Status`),"Status empty","Invalid status") AS `Error`,
`MonetInputsUpdated`.`Status` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`Status`)="active" Or (`MonetInputsUpdated`.`Status`)="disable")=False));