INSERT INTO ErrorTable(`PolNo`, `Error`, `Value` )
SELECT `MonetInputsUpdated`.`PolNo`,
    IF(ISNULL(`DisableDef`),"Disability definition empty","Invalid disability definition") AS `Error`,
`MonetInputsUpdated`.`DisableDef` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`DisableDef`)="Suitable"
    Or (`MonetInputsUpdated`.`DisableDef`)="Own"
    Or `DisableDef`="Any")=False));