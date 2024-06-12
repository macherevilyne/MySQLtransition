DROP TABLE IF EXISTS `MonetPolData ExpPL (GermanUL)`;
CREATE TABLE IF NOT EXISTS `MonetPolData ExpPL (GermanUL)` AS
    SELECT
        `MonetPolData_GermanUL BoP`.*,
        1.01 AS DeathPerc
    FROM `MonetPolData_GermanUL BoP`
        LEFT JOIN `Lapsed policies` ON `MonetPolData_GermanUL BoP`.PolNo = `Lapsed policies`.VersNr
    WHERE `Lapsed policies`.VersNr IS NULL;