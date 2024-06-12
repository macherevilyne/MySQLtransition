DROP VIEW IF EXISTS `V4: SP - Premiums paid in advance`;
CREATE VIEW `V4: SP - Premiums paid in advance` AS
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
    WHERE Bestandsreport.`Due Single Premium` < 0
        AND Bestandsreport.`Status` = 'true'
        AND Bestandsreport.`Regular Premium` IS NULL
    ORDER BY Bestandsreport.`Policy Nr`;
