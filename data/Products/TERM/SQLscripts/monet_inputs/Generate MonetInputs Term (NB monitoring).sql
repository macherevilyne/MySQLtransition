DROP TABLE IF EXISTS `MonetInputsTerm (NB Monitoring)`;
CREATE TABLE IF NOT EXISTS `MonetInputsTerm (NB Monitoring)` AS
SELECT
  `Monet Inputs Term`.*,
  YEAR(STR_TO_DATE(`Monet Inputs Term`.`DOC`, '%d-%m-%Y')) AS Expr1
FROM
  `Monet Inputs Term`
WHERE
  (
    (YEAR(STR_TO_DATE(`Monet Inputs Term`.`DOC`, '%d-%m-%Y')) = 2021) AND
    (MONTH(STR_TO_DATE(`Monet Inputs Term`.`DOC`, '%d-%m-%Y')) IN (7, 8, 9))
  );