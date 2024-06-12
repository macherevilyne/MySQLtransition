CREATE TABLE IF NOT EXISTS ErrorTable (
   `PolNo` TEXT,
   `Error` VARCHAR(50),
   `Warning` TEXT,
   `Value` TEXT
   );

INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`FIBStat`),"Fibas Status empty","Invalid FIBAS status") AS `Error`,
`MonetInputsUpdated`.`FibStat` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`FibStat`)="Active"
    Or (`MonetInputsUpdated`.`FibStat`)="Lapsed"
    Or (`MonetInputsUpdated`.`FibStat`)="Other")=False));