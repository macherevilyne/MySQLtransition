DROP TABLE IF EXISTS `MonetInputs Lapses`;
CREATE TABLE IF NOT EXISTS `MonetInputs Lapses` AS
SELECT `MonetInputsUpdated previous year`.*
FROM `MonetInputsUpdated previous year`
    LEFT JOIN `MonetInputsUpdated` ON `MonetInputsUpdated previous year`.`PolNo` = `MonetInputsUpdated`.`PolNo`
WHERE (((`MonetInputsUpdated`.`PolNo`) Is Null));