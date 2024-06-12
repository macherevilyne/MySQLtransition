UPDATE `Monet Inputs ExpPL`
INNER JOIN `Monet Inputs Term` ON `Monet Inputs ExpPL`.PolNo = `Monet Inputs Term`.PolNo
SET `Monet Inputs ExpPL`.PeriodIF = `Monet Inputs Term`.PeriodIF
WHERE `Monet Inputs ExpPL`.PeriodIF <> `Monet Inputs Term`.PeriodIF OR `Monet Inputs ExpPL`.PeriodIF IS NULL;