DROP VIEW IF EXISTS `Q_SumErrors`;
CREATE VIEW `Q_SumErrors` AS
SELECT 
    COUNT(`Q_CheckPolicyData`.`PolNo`) AS `CountOfPolNo`,
    SUM(`Q_CheckPolicyData`.`Check_FIBStat`) AS `SumOfCheck_FIBStat`,
    SUM(`Q_CheckPolicyData`.`Check_CommDate`) AS `SumOfCheck_CommDate`,
    SUM(`Q_CheckPolicyData`.`Check_product`) AS `SumOfCheck_product`,
    SUM(`Q_CheckPolicyData`.`Check_book`) AS `SumOfCheck_book`,
    SUM(`Q_CheckPolicyData`.`Check_Age`) AS `SumOfCheck_Age`,
    SUM(`Q_CheckPolicyData`.`Check_Sex`) AS `SumOfCheck_Sex`,
    SUM(`Q_CheckPolicyData`.`Check_Prof`) AS `SumOfCheck_Prof`,
    SUM(`Q_CheckPolicyData`.`Check_Term`) AS `SumOfCheck_Term`,
    SUM(`Q_CheckPolicyData`.`Check_StartMP`) AS `SumOfCheck_StartMP`,
    SUM(`Q_CheckPolicyData`.`Check_Wait`) AS `SumOfCheck_Wait`,
    SUM(`Q_CheckPolicyData`.`Check_Dur`) AS `SumOfCheck_Dur`,
    SUM(`Q_CheckPolicyData`.`Check_SA`) AS `SumOfCheck_SA`,
    SUM(`Q_CheckPolicyData`.`Check_SPadd`) AS `SumOfCheck_SPadd`,
    SUM(`Q_CheckPolicyData`.`Check_MP`) AS `SumOfCheck_MP`,
    SUM(`Q_CheckPolicyData`.`Check_Freq`) AS `SumOfCheck_Freq`,
    SUM(`Q_CheckPolicyData`.`Check_Def`) AS `SumOfCheck_Def`,
    SUM(`Q_CheckPolicyData`.`Check_BeneDef`) AS `SumOfCheck_BeneDef`,
    SUM(`Q_CheckPolicyData`.`Check_MthOwn`) AS `SumOfCheck_MthOwn`,
    SUM(`Q_CheckPolicyData`.`Check_MethPart`) AS `SumOfCheck_MethPart`,
    SUM(`Q_CheckPolicyData`.`Check_Mental`) AS `SumOfCheck_Mental`,
    SUM(`Q_CheckPolicyData`.`Check_WoP`) AS `SumOfCheck_WoP`
FROM 
    `Q_CheckPolicyData`;