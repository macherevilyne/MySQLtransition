DROP TABLE IF EXISTS `MonetInputsUpdated NB`;
CREATE TABLE IF NOT EXISTS `MonetInputsUpdated NB` AS
SELECT MonetInputsUpdated.*
FROM `MonetInputsUpdated`
    LEFT JOIN `MonetInputsUpdated previous year` ON `MonetInputsUpdated`.`PolNo` = `MonetInputsUpdated previous year`.`PolNo`
WHERE (((`MonetInputsUpdated previous year`.`PolNo`) Is Null));