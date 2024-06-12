DROP VIEW IF EXISTS `V7a: DAC & DOC per branch (pre 2009)`;
CREATE VIEW `V7a: DAC & DOC per branch (pre 2009)` AS
    SELECT
        Bestandsreport.`Branch`,
        COUNT(Bestandsreport.`Policy Nr`) AS `No of Policies`,
        SUM(Results_Records.`DACValDat`) AS `DAC at ValDate`,
        SUM(Results_Records.`DOCValDat`) AS `DOC at ValDate`
    FROM Results_Records
    INNER JOIN Bestandsreport ON Results_Records.`PolNo` = Bestandsreport.`Policy Nr`
    WHERE Bestandsreport.`Start` < '2009-01-01'
    GROUP BY Bestandsreport.`Branch`;