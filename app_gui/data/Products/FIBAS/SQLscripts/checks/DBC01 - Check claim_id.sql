CREATE TABLE IF NOT EXISTS DBCErrorTable (
   `Claim ID` TEXT,
   `Error` TEXT,
   `Variable` TEXT,
   `Value` TEXT,
   `Status` TEXT
   );

INSERT INTO DBCErrorTable(`Claim ID`, `Error`, `Variable`, `Value`)
SELECT `Claims`.`claim_id`, IF(ISNULL(`claim_id`) Or `claim_id`="",
"Invalid claim_id","Double counted claim") AS Error,
"claim_id" AS Variable,
`Claims`.`claim_id` AS `Value`
FROM `Claims`
GROUP BY `Claims`.`claim_id`, `Claims`.`claim_id`, `Claims`.`claim_id`
HAVING (((Count(`Claims`.`claim_id`))<>1))
    Or (((`Claims`.`claim_id`) Is Null))
    Or (((`Claims`.`claim_id`)=""));