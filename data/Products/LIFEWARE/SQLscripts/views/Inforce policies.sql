DROP VIEW IF EXISTS `Inforce policies`;
CREATE VIEW `Inforce policies` AS
    SELECT
        Bestandsreport.`Policy Nr`,
        Bestandsreport.Status,
        Bestandsreport.`Fund Reserve`
    FROM
        Bestandsreport
    WHERE
        Bestandsreport.Status = true AND Bestandsreport.`Fund Reserve` > 0;