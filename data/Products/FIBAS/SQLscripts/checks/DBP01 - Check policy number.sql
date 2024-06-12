CREATE TABLE IF NOT EXISTS DBPErrorTable (
   `Policy Nr` TEXT,
   `Error` TEXT,
   `Variable` TEXT,
   `Value` TEXT,
   `Status` TEXT
   );


INSERT INTO `DBPErrorTable` (`Policy Nr`,`Error`,`Variable`,`Value`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`policy number`) Or `Policies`.`policy number`="","Invalid Policy number","Double counted policy") AS `Error`,
"Policy Nr" AS `Variable`,
`Policies`.`Policy number`
FROM `Policies`
GROUP BY `Policies`.`policy number`, `Policies`.`Policy number`, `Policies`.`policy number`
HAVING (((Count(`Policies`.`policy number`))<>1)) OR (((`Policies`.`policy number`) Is Null)) OR (((`Policies`.`policy number`)=""));