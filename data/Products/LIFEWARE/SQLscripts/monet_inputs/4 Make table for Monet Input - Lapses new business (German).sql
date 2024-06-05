DROP TABLE IF EXISTS `MonetPolData Lapses NB (GermanUL)`;
CREATE TABLE IF NOT EXISTS `MonetPolData Lapses NB (GermanUL)` AS
    SELECT
        0 AS PeriodIF,
        `MonetPolData NewBiz GermanUL`.*
    FROM `MonetPolData NewBiz GermanUL`
    INNER JOIN `Lapsed policies` ON `MonetPolData NewBiz GermanUL`.PolNo = `Lapsed policies`.VersNr;