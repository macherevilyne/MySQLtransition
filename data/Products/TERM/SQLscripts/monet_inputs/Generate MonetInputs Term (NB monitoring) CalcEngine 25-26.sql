DROP TABLE IF EXISTS `MonetInputsTerm (NB Monitoring) CalcEngine 25-26`;
CREATE TABLE IF NOT EXISTS `MonetInputsTerm (NB Monitoring) CalcEngine 25-26` AS
SELECT
  `Monet Inputs Term`.*
FROM
  `Monet Inputs Term`
WHERE
  (
    (`Monet Inputs Term`.`CalcEngine` > 24 AND `Monet Inputs Term`.`CalcEngine` < 27) AND
    (YEAR(STR_TO_DATE(`Monet Inputs Term`.`DOC`, '%d-%m-%Y')) = 2022) AND
    (MONTH(STR_TO_DATE(`Monet Inputs Term`.`DOC`, '%d-%m-%Y')) IN (1, 2, 3))
  );