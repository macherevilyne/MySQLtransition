DROP VIEW IF EXISTS `Q_AMCSlideValues`;
CREATE VIEW `Q_AMCSlideValues` AS
    SELECT
        TermsheetReport.`Tariff Symbol`,
        TermsheetReport.`AMC Slide`,
        Bestandsreport.`Policy Nr`,
        Bestandsreport.`Fund Reserve`
    FROM TermsheetReport
    LEFT JOIN Bestandsreport ON TermsheetReport.`Tariff Symbol` = Bestandsreport.tariffCode
    WHERE TermsheetReport.`AMC Slide` IS NOT NULL;