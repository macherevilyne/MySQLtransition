INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(IsNull(`BenefitDef`),"Benefit definition empty","Invalid Benefit definition") AS `Error`,
`MonetInputsUpdated`.`BenefitDef` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`BenefitDef`)="P35"
    Or (`MonetInputsUpdated`.`BenefitDef`)="F35"
    Or `BenefitDef`="P80"
    Or `MonetInputsUpdated`.`BenefitDef`="P25"
    Or `MonetInputsUpdated`.`BenefitDef`="F25"
    Or `MonetInputsUpdated`.`BenefitDef`="P45"
    Or `MonetInputsUpdated`.`BenefitDef`="P55"
    Or `MonetInputsUpdated`.`BenefitDef`="P65")=False));