INSERT INTO ErrorTable(`PolNo`, `Error`, `Warning`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`SumAssuredEnt`),"Sum assured empty",IF(`SumAssuredEnt`<0,"Invalid sum assured","")) AS `Error`,
IF(`SumAssuredEnt`<50,"Sum assured < 50 EUR",IF(`SumAssuredEnt`>5000,"Sum assured > 5'000 EUR","")) AS `Warning`,
`MonetInputsUpdated`.`SumAssuredEnt` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`SumAssuredEnt`)>=50 And (`MonetInputsUpdated`.`SumAssuredEnt`)<=5000)=False));