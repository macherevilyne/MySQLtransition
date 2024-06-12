DROP TABLE IF EXISTS `C_Education`;
CREATE TABLE IF NOT EXISTS C_Education (
   `Original` VARCHAR(50),
   `Converted` INT
   );
INSERT INTO C_Education(`Original`, `Converted`) VALUES('UNIVERSITAIR', 1);
INSERT INTO C_Education(`Original`, `Converted`) VALUES('HBO_NIVEAU', 2);
INSERT INTO C_Education(`Original`, `Converted`) VALUES('MBO_NIVEAU', 3);
INSERT INTO C_Education(`Original`, `Converted`) VALUES('LBO_NIVEAU', 4);
INSERT INTO C_Education(`Original`, `Converted`) VALUES('BASIS_ONDERWIJS', 5);