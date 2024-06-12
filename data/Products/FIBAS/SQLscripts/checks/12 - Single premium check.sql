INSERT INTO ErrorTable(`PolNo`, `Error`, `Warning`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
    IF(ISNULL(`SPadd`),"Single premium empty",
        IF(`SPadd`<=10000,"Invalid single premium","")) AS `Error`,
IF(`SPadd`>10000,"Single premium > 10'000 EUR","") AS `Warning`,
`MonetInputsUpdated`.`SPadd` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`SPadd`)>0
    And (`MonetInputsUpdated`.`SPadd`)<=10000)=False)
    And ((`MonetInputsUpdated`.`PremFreq`)<>12)) Or ((((`MonetInputsUpdated`.`SPadd`)>0
    And (`MonetInputsUpdated`.`SPadd`)<=10000)=False)
    And ((`MonetInputsUpdated`.`StartMthMP`)<>0)) Or (((`MonetInputsUpdated`.`SPadd`)<0)
    And ((`MonetInputsUpdated`.`PremFreq`)=12) And ((`MonetInputsUpdated`.`StartMthMP`)=0));