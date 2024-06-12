DROP VIEW IF EXISTS `Q_Input_AnnuityGuaranteeReserve_V2a`;
CREATE VIEW `Q_Input_AnnuityGuaranteeReserve_V2a` AS
    SELECT
        MonetPolData_GermanUL.PeriodIF,
        MonetPolData_GermanUL.AgeEnt1,
        MonetPolData_GermanUL.Sex1,
        RegularContribution * PremFreq AS AnnualContribution,
        MonetPolData_GermanUL.SingleContribution,
        MonetPolData_GermanUL.TermPrem,
        IF(AgeEnt1 + MonetPolData_GermanUL.Term >= 55 AND AgeEnt1 + MonetPolData_GermanUL.Term <= 75, MonetPolData_GermanUL.Term, IF(Sex1 = 'Male', 67 - AgeEnt1, 65 - AgeEnt1)) AS Term,
        FundAccValDat + AnnualContribution * (TermPrem - PeriodIF / 12) AS PremSum,
        IF(PeriodIF <= TIMESTAMPDIFF(MONTH, '2015-01-01', ValDate), 0.0125,
            IF(PeriodIF <= TIMESTAMPDIFF(MONTH, '2012-01-01', ValDate), 0.0175, 0.0225)) AS Iguar
    FROM MonetPolData_GermanUL
    WHERE (MonetPolData_GermanUL.PeriodIF <= TIMESTAMPDIFF(MONTH, '2010-07-01', ValDate) OR MonetPolData_GermanUL.PeriodIF > TIMESTAMPDIFF(MONTH, '2007-07-01', ValDate))
          AND (IF(AgeEnt1 + MonetPolData_GermanUL.Term >= 55 AND AgeEnt1 + MonetPolData_GermanUL.Term <= 75, MonetPolData_GermanUL.Term, IF(Sex1 = 'Male', 67 - AgeEnt1, 65 - AgeEnt1)) > PeriodIF / 12);
