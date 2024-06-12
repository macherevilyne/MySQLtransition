DROP TABLE IF EXISTS `C_Status`;
CREATE TABLE IF NOT EXISTS C_Status (
   `Original` VARCHAR(50),
   `Converted` VARCHAR(50)
   );
INSERT INTO C_Status(`Original`, `Converted`) VALUES('WAITING_FOR_APPROVAL_PREMIUM', 'To be accepted by client');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('REMOVED', 'Removed');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('ENDED', 'Cancelled Policy - end of term');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('CANCELLED', 'Cancelled Policy');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('REVOKED', 'Cancelled Request');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('WAITING_FOR_ADMINISTRATIVE_COMPLETE', 'Extra information requested');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('REASSESS_ADMINISTRATIVE', 'Extra information requested');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('DEFINITE', 'Issued');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('ISSUED', 'Issued');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('PREPARED_FOR_END', 'Issued');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('MEDICAL_ASSESSMENT', 'Ready for medical assessment');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('DECLINED_BY_INSURER', 'Rejected by Quantum');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('DECLINED_BY_TAF', 'Rejected by TAF');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('WAITING_FOR_APPROVAL_CUSTOMER', 'To be accepted by client');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('INSURER_ASSESSMENT', 'To be accepted by Quantum');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('REINSURER_ASSESSMENT', 'To be accepted by reinsurer');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('ENTERED', 'To be accepted by TAF');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('WAITING_FOR_APPROVAL_DECLINED_INSURED', 'To be accepted by client');
INSERT INTO C_Status(`Original`, `Converted`) VALUES('WAITING_FOR_APPROVAL_EXTRA_MORTALITY', 'To be accepted by client');