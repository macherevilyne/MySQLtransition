INSERT INTO ErrorTable(`PolNo`, `Error`, `Warning`, `Value` )
SELECT `MonetInputsUpdated`.`PolNo`,
    IF(ISNULL(`MonthlyPremium`),"Monthly premium empty",
        IF(`MonthlyPremium`<=500,"Invalid monthly premium","")) AS `Error`,
IF(`MonthlyPremium`>500,"Monthly premium > 500 EUR","") AS `Warning`,
`MonetInputsUpdated`.`MonthlyPremium` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`MonthlyPremium`)>0
And (`MonetInputsUpdated`.`MonthlyPremium`)<=500)=False)
And ((`MonetInputsUpdated`.`PremFreq`)<>99)) Or (((`MonetInputsUpdated`.`MonthlyPremium`)<>0)
And ((`MonetInputsUpdated`.`PremFreq`)=99));