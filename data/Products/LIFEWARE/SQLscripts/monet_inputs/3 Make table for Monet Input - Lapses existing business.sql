DROP TABLE IF EXISTS `MonetPolData Lapses EB`;
CREATE TABLE IF NOT EXISTS `MonetPolData Lapses EB` AS
    SELECT `MonetPolData BoP`.*
    FROM `Lapsed policies`
    INNER JOIN `MonetPolData BoP` ON `Lapsed policies`.VersNr = `MonetPolData BoP`.PolNo;