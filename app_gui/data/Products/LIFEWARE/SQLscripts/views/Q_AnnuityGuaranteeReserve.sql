DROP VIEW IF EXISTS `Q_AnnuityGuaranteeReserve`;
CREATE VIEW `Q_AnnuityGuaranteeReserve` AS
    SELECT
        MonetPolData_GermanUL.PeriodIF,
        (MonetPolData_GermanUL.RegularContribution * MonetPolData_GermanUL.PremFreq) AS AnnualContribution,
        MonetPolData_GermanUL.SingleContribution,
        MonetPolData_GermanUL.TermPrem,
        (MonetPolData_GermanUL.SingleContribution + (MonetPolData_GermanUL.RegularContribution * MonetPolData_GermanUL.PremFreq * MonetPolData_GermanUL.TermPrem)) AS PremSum,
        0.003 * (MonetPolData_GermanUL.SingleContribution + (MonetPolData_GermanUL.RegularContribution * MonetPolData_GermanUL.PremFreq * MonetPolData_GermanUL.TermPrem)) AS GuaranteeReserve
    FROM MonetPolData_GermanUL
    WHERE MonetPolData_GermanUL.PeriodIF <= DATEDIFF(MONTH, '2010-07-01', MonetPolData_GermanUL.ValDate);
