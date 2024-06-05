DROP VIEW IF EXISTS `V10: Expired policies`;
CREATE VIEW `V10: Expired policies` AS
    SELECT
        Bestandsreport.`Policy Nr`,
        Bestandsreport.Gewinnverband,
        Bestandsreport.Branch,
        Bestandsreport.Currency,
        Bestandsreport.Status,
        Bestandsreport.Start,
        Bestandsreport.`Contract Term (years)`,
        Bestandsreport.`Fund Reserve`,
        Bestandsreport.`Surrender Value`
    FROM
        Bestandsreport
    WHERE
        ((Bestandsreport.Status = 'true') AND
        (Bestandsreport.`Contract Term (years)` <= TIMESTAMPDIFF(MONTH, Bestandsreport.Start, Bestandsreport.ValDate)/12))
        OR
        ((Bestandsreport.Status = 'false') AND (Bestandsreport.`Fund Reserve` IS NOT NULL));