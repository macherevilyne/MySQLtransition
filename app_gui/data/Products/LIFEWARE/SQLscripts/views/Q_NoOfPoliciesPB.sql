DROP VIEW IF EXISTS `Q_NoOfPoliciesPB`;
CREATE VIEW `Q_NoOfPoliciesPB` AS
    SELECT
        COUNT(Bestandsreport.`Policy Nr`) AS CountOfPolicyNr
    FROM Bestandsreport
    WHERE (CalcProduct(Bestandsreport.`Gewinnverband`) LIKE 'PB%') AND (Bestandsreport.`Status` = 'true');
