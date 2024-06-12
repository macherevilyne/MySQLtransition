DROP TABLE IF EXISTS `C_Flags`;
CREATE TABLE IF NOT EXISTS C_Flags (
   `Original` BIT,
   `Converted` VARCHAR(50)
   );
INSERT INTO C_Flags(`Original`, `Converted`) VALUES(TRUE, 'Yes');
INSERT INTO C_Flags(`Original`, `Converted`) VALUES(FALSE, 'No');