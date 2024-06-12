DROP TABLE IF EXISTS `MonetInputs OB`;
CREATE TABLE IF NOT EXISTS `MonetInputs OB` AS
SELECT `MonetInputsUpdated`.*
FROM `MonetInputsUpdated NB` RIGHT JOIN `MonetInputsUpdated` ON `MonetInputsUpdated NB`.`PolNo` = `MonetInputsUpdated`.`PolNo`
WHERE (((`MonetInputsUpdated NB`.`PolNo`) Is Null));