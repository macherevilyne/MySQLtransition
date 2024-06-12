DROP VIEW IF EXISTS `V7old: Zillmer per branch - Lausanne basis (old method)`;
CREATE VIEW `V7old: Zillmer per branch - Lausanne basis (old method)` AS
    SELECT
        CASE
            WHEN Bestandsreport.`Gewinnverband` = 'OIP' THEN 'OIP'
            WHEN Bestandsreport.`Branch` = 'WNB' THEN 'Swiss'
            WHEN Bestandsreport.`Gewinnverband` = 'POLAND' THEN 'Poland'
            ELSE 'German UL'
        END AS Product,
        Bestandsreport.`Branch`,
        COUNT(Results_Records_OldMeth.`PolNo`) AS `No of Policies`,
        SUM(Results_Records_OldMeth.`ZillmerValDat`) AS Zillmer,
        SUM(Results_Records_OldMeth.`PolReceivableValDat`) AS PolReceivable
    FROM Results_Records_OldMeth
    INNER JOIN Bestandsreport ON Results_Records_OldMeth.`PolNo` = Bestandsreport.`Policy Nr`
    GROUP BY
        CASE
            WHEN Bestandsreport.`Gewinnverband` = 'OIP' THEN 'OIP'
            WHEN Bestandsreport.`Branch` = 'WNB' THEN 'Swiss'
            WHEN Bestandsreport.`Gewinnverband` = 'POLAND' THEN 'Poland'
            ELSE 'German UL'
        END,
        Bestandsreport.`Branch`;