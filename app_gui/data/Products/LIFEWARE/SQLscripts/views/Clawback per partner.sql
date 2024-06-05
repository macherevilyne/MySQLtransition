DROP VIEW IF EXISTS `Clawback per partner`;
CREATE VIEW `Clawback per partner` AS
    SELECT
        Bestandsreport.Branch,
        Sum(Bestandsreport.`Clawback (EUR)`) AS Clawback
    FROM
        Bestandsreport
    GROUP BY
        Bestandsreport.Branch;