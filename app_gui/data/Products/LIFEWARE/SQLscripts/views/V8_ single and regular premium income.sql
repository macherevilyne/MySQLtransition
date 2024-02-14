DROP VIEW IF EXISTS `V8: single and regular premium income`;
CREATE VIEW `V8: single and regular premium income` AS
    SELECT
        SUM(Bewegungsreport.`Regular Premium  (EUR)`) AS `SummevonRegular Premium  (EUR)`,
        SUM(Bewegungsreport.`Single Premium  (EUR)`) AS `SummevonSingle Premium  (EUR)`
    FROM Bewegungsreport;