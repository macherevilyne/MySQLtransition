DROP VIEW IF EXISTS `Q_SIBToExclude`;
CREATE VIEW `Q_SIBToExclude` AS
    SELECT
        SIBPolNo.`policy`,
        Bestandsreport.`Fund Reserve`
    FROM SIBPolNo
    LEFT JOIN Bestandsreport ON SIBPolNo.`policy` = Bestandsreport.`Policy Nr`;