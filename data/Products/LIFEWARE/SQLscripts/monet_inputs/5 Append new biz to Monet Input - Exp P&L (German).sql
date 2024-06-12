DROP TABLE IF EXISTS `MonetPolData ExpPL (GermanUL)`;
CREATE TABLE IF NOT EXISTS `MonetPolData ExpPL (GermanUL)` AS
    SELECT
        `MonetPolData NewBiz GermanUL`.*
    FROM `MonetPolData NewBiz GermanUL`
    LEFT JOIN `MonetPolData Lapses NB (GermanUL)`
        ON `MonetPolData NewBiz GermanUL`.PolNo = `MonetPolData Lapses NB (GermanUL)`.PolNo
    WHERE `MonetPolData Lapses NB (GermanUL)`.PolNo IS NULL;