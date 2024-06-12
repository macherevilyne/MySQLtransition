INSERT INTO ErrorTable(`PolNo`,`Error`,`Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`MonetInputsUpdated`.`PercentageDisable`),"Percentage disable empty","Invalid percentage disable") AS `Error`,
`MonetInputsUpdated`.`PercentageDisable` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`PercentageDisable`)>0
    And (`MonetInputsUpdated`.`PercentageDisable`)<=100)=False)
    And ((`MonetInputsUpdated`.`Status`)="disable"));