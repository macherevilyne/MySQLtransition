DROP VIEW IF EXISTS `V6: SP - Premiums due`;
CREATE VIEW `V6: SP - Premiums due` AS
    SELECT
        Bestandsreport.`Branch`,
        Bestandsreport.`Währung` AS `Currency`,
        Bestandsreport.`Policy Nr`,
        Bestandsreport.`Due Regular Premiums`,
        Bestandsreport.`Due Single Premium`,
        Bestandsreport.`Current Account`,
        Bestandsreport.`Transaction Account`,
        Bestandsreport.`Fund Reserve`,
        Bestandsreport.`Surrender Value`,
        Bestandsreport.`Status`,
        Bestandsreport.`Start`,
        Bestandsreport.`Regular Premium`,
        Bestandsreport.`Single Premium`
    FROM Bestandsreport
    WHERE Bestandsreport.`Due Single Premium` > 0
        AND Bestandsreport.`Status` = 'true'
        AND Bestandsreport.`Regular Premium` IS NULL
    ORDER BY Bestandsreport.`Policy Nr`;