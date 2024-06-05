DROP TABLE IF EXISTS `MonetInputsTerm (BusinessSteering) CE 21;25-26`;
CREATE TABLE IF NOT EXISTS `MonetInputsTerm (BusinessSteering) CE 21;25-26` AS
SELECT `Monet Inputs Term`.*
FROM `Monet Inputs Term`
WHERE
  (
    (`Monet Inputs Term`.`CalcEngine` > 24 AND `Monet Inputs Term`.`CalcEngine` < 27) AND
    (STR_TO_DATE(`Monet Inputs Term`.`DOC`, '%d-%m-%Y') < STR_TO_DATE('{date_data_extract}', '%d-%m-%Y') AND `Monet Inputs Term`.DOC >= `StartDate`)
  )
  OR
  (
    (`Monet Inputs Term`.`CalcEngine` = 21) AND
    (STR_TO_DATE(`Monet Inputs Term`.`DOC`, '%d-%m-%Y') < STR_TO_DATE('{date_data_extract}', '%d-%m-%Y') AND `Monet Inputs Term`.`DOC` >= `StartDate`)
  );