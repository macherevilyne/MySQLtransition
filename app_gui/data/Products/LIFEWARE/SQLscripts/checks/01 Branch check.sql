DROP TABLE IF EXISTS `Error Table`;
CREATE TABLE IF NOT EXISTS `Error Table` (
   `Policy Nr` TEXT,
   `Error` TEXT,
   `Warning` TEXT,
   `Data Value` TEXT
   );

INSERT INTO `Error Table`(`Policy Nr`, `Error`, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    'Branch empty' AS `Error`,
    Bestandsreport.Branch
FROM Bestandsreport
WHERE Bestandsreport.Branch IS NULL;