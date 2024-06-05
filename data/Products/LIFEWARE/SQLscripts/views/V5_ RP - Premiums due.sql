DROP VIEW IF EXISTS `V5: RP - Premiums due`;
CREATE VIEW `V5: RP - Premiums due` AS
    SELECT
        Bestandsreport.`Branch`,
        Bestandsreport.`Währung` AS `Currency`,
        COUNT(Bestandsreport.`Policy Nr`) AS `AnzahlvonPolicy Nr`,
        SUM(Bestandsreport.`Due Regular Premiums`) AS `SummevonDue Regular Premiums`,
        SUM(Bestandsreport.`Due Single Premium`) AS `SummevonDue Single Premium`,
        SUM(Bestandsreport.`Current Account`) AS `SummevonCurrent Account`,
        SUM(Bestandsreport.`Transaction Account`) AS `SummevonTransaction Account`,
        SUM(Bestandsreport.`Fund Reserve`) AS `SummevonFund Reserve`,
        SUM(Bestandsreport.`Surrender Value`) AS `SummevonSurrender Value`
    FROM Bestandsreport
    WHERE Bestandsreport.`Status` = 'true'
        AND Bestandsreport.`Regular Premium` IS NOT NULL
        AND Bestandsreport.`Due Regular Premiums` > 0
    GROUP BY Bestandsreport.`Branch`, Bestandsreport.`Währung`;