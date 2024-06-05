DROP TABLE IF EXISTS `MonetInputs BusinessSteering (EUR)`;
CREATE TABLE IF NOT EXISTS `MonetInputs BusinessSteering (EUR)` AS
    SELECT
        `MonetPolData_BE`.*,
        `Bestandsreport`.`Start`
    FROM `MonetPolData_BE`
        LEFT JOIN `Bestandsreport` ON `MonetPolData_BE`.PolNo = `Bestandsreport`.`Policy Nr`
    WHERE `Bestandsreport`.`Start` >= [StartDate] AND `Bestandsreport`.`Start` < [ValDate];