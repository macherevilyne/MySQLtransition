DROP TABLE IF EXISTS `C_Freq`;
CREATE TABLE IF NOT EXISTS C_Freq (
   `Original` VARCHAR(50),
   `Converted` VARCHAR(50)
   );
INSERT INTO C_Freq(`Original`, `Converted`) VALUES('ANNUALLY', 'Yearly');
INSERT INTO C_Freq(`Original`, `Converted`) VALUES('MONTHLY', 'Monthly');
INSERT INTO C_Freq(`Original`, `Converted`) VALUES('SINGLE', 'Single');
INSERT INTO C_Freq(`Original`, `Converted`) VALUES('SINGLE_ANNUALLY', 'Yearly');
INSERT INTO C_Freq(`Original`, `Converted`) VALUES('SINGLE_MONTHLY', 'Monthly');