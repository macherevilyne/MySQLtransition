CREATE TABLE IF NOT EXISTS DBCBErrorTable (
   `Claim ID` TEXT,
   `Error` TEXT,
   `Variable` TEXT,
   `Value` TEXT,
   `Status` TEXT
   );
INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`, `Value`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`claim_id`) Or `claim_id`="","Invalid claim_id","Double counted claim") AS `Error`,
"claim_id" AS `Variable`,
`ClaimsBasic`.`claim_id` AS `Value`
FROM `ClaimsBasic`
GROUP BY `ClaimsBasic`.`claim_id`, `ClaimsBasic`.`claim_id`, `ClaimsBasic`.`claim_id`
HAVING (((Count(`ClaimsBasic`.`claim_id`))<>1))
    Or (((`ClaimsBasic`.`claim_id`) Is Null))
    Or (((`ClaimsBasic`.`claim_id`)=""));