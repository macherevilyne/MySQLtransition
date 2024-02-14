INSERT INTO ErrorTable(`PolNo`, `Error`, `Warning`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
    IF(ISNULL(`term`),"Term empty",
        IF(`term`<0,"Invalid term",
            IF(`ageent1`+`term`/12>71,"Invalid age at term",""))) AS `Error`,
IF(`Term`<60,"Term < 60 months",
    IF(`Term`>480,"Term > 480 months","")) AS `Warning`,
`MonetInputsUpdated`.`Term` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`term`)>=60 And (`MonetInputsUpdated`.`term`)<=480 And `AgeEnt1`+`term`/12<=71)=False));