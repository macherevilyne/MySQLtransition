DROP VIEW IF EXISTS `Q_ExistingPoliciesRP`;
CREATE VIEW `Q_ExistingPoliciesRP` AS
    SELECT
        Bestandsreport.*,
        `Lapses since inception`.`Stornodatum (effective)`
    FROM
        Bestandsreport
    LEFT JOIN
        `Lapses since inception` ON Bestandsreport.`Policy Nr` = `Lapses since inception`.VersNr
    WHERE
        (`Lapses since inception`.`Stornodatum (effective)` IS NULL OR `Lapses since inception`.`Stornodatum (effective)` >= '2018-01-01')
        AND (Bestandsreport.`Regular Premium` > 0);
