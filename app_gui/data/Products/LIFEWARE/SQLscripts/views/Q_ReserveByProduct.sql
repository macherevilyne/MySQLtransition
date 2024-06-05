DROP VIEW IF EXISTS `Q_ReserveByProduct`;
CREATE VIEW `Q_ReserveByProduct` AS
    SELECT
        COUNT(Bestandsreport.`Policy Nr`) AS AnzahlvonPolicyNr, CalcProduct(Bestandsreport.`Gewinnverband`) AS Product,
        Bestandsreport.`Status`,
        IF(Bestandsreport.`Fund Reserve` > 0, 'Yes', 'No') AS PosFund,
        IF(DATEDIFF(Bestandsreport.`Start`, Bestandsreport.`ValDat`)/12 >= Bestandsreport.`Contract Term (years)`, 'Yes', 'No') AS Expired,
        SUM(Bestandsreport.`Fund Reserve`) AS FundReserve,
        SUM(Bestandsreport.`Due Regular Premiums`) AS DueRP,
        SUM(Bestandsreport.`Due Single Premium`) AS DueSP,
        SUM(Bestandsreport.`Current Account`) AS CurrentAccount,
        SUM(Bestandsreport.`Transaction Account`) AS TransactionAccount,
        SUM(Bestandsreport.`Due Benefit`) AS DueBenefit
FROM Bestandsreport
GROUP BY CalcProduct(Bestandsreport.`Gewinnverband`), Bestandsreport.`Status`,
         IF(Bestandsreport.`Fund Reserve` > 0, 'Yes', 'No'),
         IF(DATEDIFF(Bestandsreport.`Start`, Bestandsreport.`ValDat`)/12 >= Bestandsreport.`Contract Term (years)`, 'Yes', 'No');