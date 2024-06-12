DROP TABLE IF EXISTS `MonetPolData Lapses NB (GermanUL)`;
CREATE TABLE IF NOT EXISTS `MonetPolData Lapses NB (GermanUL)` AS
    SELECT
        0 AS PeriodIF,
        `MonetPolData NewBiz PB`.*
    FROM `MonetPolData NewBiz PB`
    INNER JOIN `Lapsed policies` ON `MonetPolData NewBiz PB`.PolNo = `Lapsed policies`.VersNr;