INSERT INTO ErrorTable(`PolNo`, `Error`, `Warning`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
    IF(ISNULL(`PeriodDisable`),"Period disable empty",
        IF(`PeriodDisable`<0,"Invalid period disable","")) AS `Error`,
IF(`PeriodDisable`>@Max_Disable,"Too large period disable","") AS `Warning`,
`MonetInputsUpdated`.`PeriodDisable` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`PeriodDisable`)>=0
    And (`MonetInputsUpdated`.`PeriodDisable`)<=CAST('{MaxDisable}' AS SIGNED))=False)
    And ((`MonetInputsUpdated`.`Status`)="disable"));