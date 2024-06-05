INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`PremFreq`),"Premium frequency empty","Invalid Premium frequency") AS `Error`,
`MonetInputsUpdated`.`PremFreq` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`PremFreq`)=12 Or (`MonetInputsUpdated`.`PremFreq`)=99)=False));