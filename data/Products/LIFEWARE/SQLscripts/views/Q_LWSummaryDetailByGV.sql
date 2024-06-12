DROP VIEW IF EXISTS `Q_LWSummaryDetailByGV`;
CREATE VIEW `Q_LWSummaryDetailByGV` AS
    SELECT
        Bestandsreport.Gewinnverband,
        Bestandsreport.Status,
        IF(`Contract Term (years)` + YEAR(`Start`) + MONTH(`Start`) / 12 + DAY(`Start`) / 365 > YEAR(`ValDate`) + MONTH(`ValDate`) / 12 + DAY(`ValDate`) / 365 + 1 / 12, 'No', 'Yes') AS Expired,
        IF(`Fund Reserve` >= 0, 'No', 'Yes') AS NegFV,
        COUNT(Bestandsreport.`Policy Nr`) AS CountOfPolicyNr,
        SUM(Bestandsreport.`Fund Reserve`) AS SumOfFundReserve
    FROM Bestandsreport
    WHERE Bestandsreport.Gewinnverband <> 'PRD AP (EUR)'
    GROUP BY Bestandsreport.Gewinnverband, Bestandsreport.Status, Expired, NegFV;