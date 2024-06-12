DROP VIEW IF EXISTS `Q_LapsesEY`;
CREATE VIEW `Q_LapsesEY` AS
    SELECT
        `Lapses since inception`.*
    FROM `Lapses since inception`
    WHERE `Lapses since inception`.`Stornodatum (effective)` >= '2018-01-01';
