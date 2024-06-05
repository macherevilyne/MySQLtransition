DROP VIEW IF EXISTS `Q_NoOfPolicies`;
CREATE VIEW `Q_NoOfPolicies` AS
    SELECT
        COUNT(Bestandsreport.`Policy Nr`) AS CountOfPolicyNr
    FROM Bestandsreport
    WHERE (NOT (CalcProduct(Bestandsreport.`Gewinnverband`) LIKE 'AP%'
                    OR CalcProduct(Bestandsreport.`Gewinnverband`) LIKE 'PB%'))
        AND (Bestandsreport.`Status` = 'true');