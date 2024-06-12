DROP TABLE IF EXISTS `C_CoverType`;
CREATE TABLE IF NOT EXISTS C_CoverType (`Original` VARCHAR(50),`Converted` VARCHAR(50));
INSERT INTO C_CoverType(`Original`, `Converted`) VALUES('ANNUITY', 'Annuity');
INSERT INTO C_CoverType(`Original`, `Converted`) VALUES('ANNUITY_INCREASING', 'Annuity increasing');
INSERT INTO C_CoverType(`Original`, `Converted`) VALUES('LEVEL', 'Level');
INSERT INTO C_CoverType(`Original`, `Converted`) VALUES('STRAIGHTLINE', 'Straightline');
INSERT INTO C_CoverType(`Original`, `Converted`) VALUES('STRAIGHTLINE_INCREASING', 'Linear increasing');