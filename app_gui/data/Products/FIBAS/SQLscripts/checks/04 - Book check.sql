INSERT INTO ErrorTable(`PolNo`, `Error`, `Value`)
SELECT `MonetInputsUpdated`.`PolNo`,
IF(ISNULL(`book`),"Book empty","Invalid book") AS `Error`,
`MonetInputsUpdated`.`book` AS `Value`
FROM `MonetInputsUpdated`
WHERE ((((`MonetInputsUpdated`.`book`)=200809
    Or (`MonetInputsUpdated`.`book`)=2010
    Or `book`=2011
    Or `book`=2012
    Or `book`=2014
    Or `book`=2015
    Or `book`=2019
    Or `book`=2020)=False));