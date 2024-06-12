DROP TABLE IF EXISTS `MonetPolData ExpPL (PB)`;
CREATE TABLE IF NOT EXISTS `MonetPolData ExpPL (PB)` AS
    SELECT
        `MonetPolDataPB_BoP`.*,
        1.01 AS DeathPerc,
        'Upfront' AS CommModel
    FROM `MonetPolDataPB_BoP`
        LEFT JOIN `MonetPolData_PB` ON `MonetPolDataPB_BoP`.PolNo = `MonetPolData_PB`.PolNo
    WHERE `MonetPolData_PB`.PolNo IS NOT NULL;