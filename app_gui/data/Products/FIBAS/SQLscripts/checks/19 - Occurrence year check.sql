INSERT INTO ErrorTable(`PolNo`,`Error`,`Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`MonetInputsUpdated`.`OccurrenceYear`),"Occurrence year empty","Invalid occurrence year") AS `Error`,
`MonetInputsUpdated`.`OccurrenceYear` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`OccurrenceYear`)>=2008
    And `MonetInputsUpdated`.`OccurrenceYear`<=2022)=False)
    And ((`MonetInputsUpdated`.`Status`)="disable"));