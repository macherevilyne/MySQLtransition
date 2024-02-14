DROP TABLE IF EXISTS `MonetPolData Lapses EB (GermanUL)`;
CREATE TABLE IF NOT EXISTS `MonetPolData Lapses EB (GermanUL)` AS
    SELECT `MonetPolData_GermanUL BoP`.*
    FROM `MonetPolData_GermanUL BoP`
    INNER JOIN `Lapsed policies` ON `MonetPolData_GermanUL BoP`.PolNo = `Lapsed policies`.VersNr;