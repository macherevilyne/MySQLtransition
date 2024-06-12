INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`BeneDuration`),"Benefit duration empty","Invalid Benefit duration") AS `Error`,
`MonetInputsUpdated`.`BeneDuration` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`BeneDuration`)="Extended"
    Or (`MonetInputsUpdated`.`BeneDuration`)="Basic"
    Or `BeneDuration`="Short")=False));