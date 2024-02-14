DROP TABLE IF EXISTS `TersheetErrorTable`;
CREATE TABLE IF NOT EXISTS `TersheetErrorTable` (
   `Tariff Symbol` TEXT,
   `Error` TEXT,
   `Warning` TEXT,
   `Value` TEXT
   );


INSERT INTO `TersheetErrorTable` (`Tariff Symbol`, Error, `Value`)
SELECT
    Bestandsreport.tariffCode AS `Tariff Symbol`,
    'Tariff code from Bestandsreport missing in TermsheetReport' AS Error,
    Bestandsreport.tariffCode AS `Value`
FROM Bestandsreport
LEFT JOIN TermsheetReport ON Bestandsreport.tariffCode = TermsheetReport.`Tariff Symbol`
WHERE TermsheetReport.`Tariff Symbol` IS NULL;