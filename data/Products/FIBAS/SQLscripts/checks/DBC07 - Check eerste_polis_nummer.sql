INSERT INTO `DBCErrorTable` (`Claim ID`,Error,Variable,`Value`,Status)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`eerste_polis_nummer`),"eerste_polis_nummer empty","Invalid eerste_polis_nummer") AS `Error`,
"eerste_polis_nummer" AS `Variable`,
`Claims`.`eerste_polis_nummer` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims` LEFT JOIN `Policies` ON `Claims`.`eerste_polis_nummer` = `Policies`.`policy number`
WHERE (((`Claims`.`eerste_polis_nummer`) Is Null))
    Or (((`Policies`.`policy number`) Is Null));