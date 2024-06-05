DROP TABLE IF EXISTS `C_Occupation`;
CREATE TABLE IF NOT EXISTS C_Occupation (
   `Original` VARCHAR(50),
   `Converted` INT
   );
INSERT INTO C_Occupation(`Original`, `Converted`) VALUES('LEVEL_ONE', 1);
INSERT INTO C_Occupation(`Original`, `Converted`) VALUES('LEVEL_TWO', 2);
INSERT INTO C_Occupation(`Original`, `Converted`) VALUES('LEVEL_THREE', 3);
INSERT INTO C_Occupation(`Original`, `Converted`) VALUES('LEVEL_FOUR', 4);
INSERT INTO C_Occupation(`Original`, `Converted`) VALUES('LEVEL_FIVE', 5);