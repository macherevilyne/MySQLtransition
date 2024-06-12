DROP VIEW IF EXISTS `Lapsed policies`;
CREATE VIEW `Lapsed policies` AS
    SELECT
        `Lapses since inception`.VersNr,
        YEAR(`Lapses since inception`.`Stornodatum (timestamp)`) AS LapseYear
    FROM
        `Lapses since inception`
    WHERE
        YEAR(`Lapses since inception`.`Stornodatum (timestamp)`) = `Calendar year of lapse`;