INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`AgeEnt1`),"Age empty","Invalid age at entry") AS `Error`,
`MonetInputsUpdated`.`AgeEnt1` AS `Value`
FROM `MonetInputsUpdated`
WHERE (((`MonetInputsUpdated`.`AgeEnt1`>=18 And `MonetInputsUpdated`.`AgeEnt1`<=62)=False));