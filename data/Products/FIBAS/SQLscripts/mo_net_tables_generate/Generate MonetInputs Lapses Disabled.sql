DROP TABLE IF EXISTS `MonetInputs Lapses Disabled`;
CREATE TABLE IF NOT EXISTS `MonetInputs Lapses Disabled` AS
SELECT `MonetInputsUpdated previous year`.*
FROM `MonetInputsUpdated previous year` LEFT JOIN `MonetInputsUpdated` ON `MonetInputsUpdated previous year`.`PolNo` = `MonetInputsUpdated`.`PolNo`
WHERE (((`MonetInputsUpdated`.`PolNo`) Is Null) AND ((`MonetInputsUpdated previous year`.`Status`)="disable"));