CREATE TABLE IF NOT EXISTS CompletnessTable(
   `PolNo` TEXT,
   `ClaimID` TEXT,
   `Error` VARCHAR(50)
   );
INSERT INTO CompletnessTable(`PolNo`, `Error`)
SELECT `RC Regular premium`.`Policy Number`,
"No corresponding policy in data dump" AS `Error`
FROM `RC Regular premium` LEFT JOIN Policies ON `RC Regular premium`.`Policy Number` = `Policies`.`policy number`
WHERE (((`Policies`.`policy number`) Is Null));