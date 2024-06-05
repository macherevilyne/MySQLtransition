INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(IsNull(`MonetInputsUpdated`.`MonthlyBenefit`),"Monthly benefit empty","Invalid monthly benefit") AS `Error`,
`MonetInputsUpdated`.`MonthlyBenefit` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`MonthlyBenefit`)>0
    And (`MonetInputsUpdated`.`MonthlyBenefit`)<=`MonetInputsUpdated`.`SumAssuredEnt`*(1+`MonetInputsUpdated`.`Index`/100)^(ROUND(`PeriodIF`/12))+0.01)=False)
    And ((`MonetInputsUpdated`.`Status`)="disable"));