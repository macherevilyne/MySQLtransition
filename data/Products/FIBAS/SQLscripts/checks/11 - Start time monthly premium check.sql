INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`StartMthMP`),"Start time monthly premium empty","Invalid start time monthly premium") AS `Error`,
`MonetInputsUpdated`.`StartMthMP` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`StartMthMP`)>=0
    And (`MonetInputsUpdated`.`StartMthMP`)<`Term`)=False)
    And ((`MonetInputsUpdated`.`PremFreq`)=12))
    Or ((((`MonetInputsUpdated`.`StartMthMP`)>=0
    And (`MonetInputsUpdated`.`StartMthMP`)<`Term`)=0)
    And ((`MonetInputsUpdated`.`PremFreq`)=99));