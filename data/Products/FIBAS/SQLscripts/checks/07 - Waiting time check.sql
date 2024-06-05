INSERT INTO ErrorTable(`PolNo`, Error, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`WaitingTime`),"Waiting time empty","Invalid waiting time") AS `Error`,
`MonetInputsUpdated`.`WaitingTime` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`WaitingTime`)=30
    Or (`MonetInputsUpdated`.`WaitingTime`)=90
    Or `WaitingTime`=365
    Or `WaitingTime`=730
    Or `WaitingTime`=60
    Or `WaitingTime`=120
    Or `WaitingTime`=180
    Or `WaitingTime`=210
    Or `WaitingTime`=240
    Or `WaitingTime`=270
    Or `WaitingTime`=300)=False));