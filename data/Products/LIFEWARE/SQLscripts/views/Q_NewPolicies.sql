DROP VIEW IF EXISTS `Q_NewPolicies`;
CREATE VIEW `Q_NewPolicies` AS
    SELECT *
    FROM Bestandsreport
    WHERE Bestandsreport.Start >= '2022-01-01';