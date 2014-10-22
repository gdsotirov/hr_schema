SELECT CASE
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 0.00 AND 1.00 THEN '1_up_to_1_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 1.01 AND 2.00 THEN '2_up_to_2_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 2.01 AND 3.00 THEN '3_up_to_3_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 3.01 AND 4.00 THEN '4_up_to_4_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 4.01 AND 5.00 THEN '5_up_to_5_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 5.01 AND 6.00 THEN '6_up_to_6_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 6.01 AND 7.00 THEN '7_up_to_7_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 7.01 AND 8.00 THEN '8_up_to_8_yr'
         WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 8.01 AND 9.00 THEN '9_up_to_9_yr'
         ELSE '_over_9_yr'
       END dur,
       MIN(utl_calcVacDays(EMP.hire_date, EMP.leave_date)),
       AVG(utl_calcVacDays(EMP.hire_date, EMP.leave_date)),
       MAX(utl_calcVacDays(EMP.hire_date, EMP.leave_date)),
       COUNT(*) cnt
  FROM employees EMP
 WHERE EMP.leave_date IS NOT NULL
 GROUP BY CASE
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 0.00 AND 1.00 THEN '1_up_to_1_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 1.01 AND 2.00 THEN '2_up_to_2_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 2.01 AND 3.00 THEN '3_up_to_3_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 3.01 AND 4.00 THEN '4_up_to_4_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 4.01 AND 5.00 THEN '5_up_to_5_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 5.01 AND 6.00 THEN '6_up_to_6_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 6.01 AND 7.00 THEN '7_up_to_7_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 7.01 AND 8.00 THEN '8_up_to_8_yr'
            WHEN ROUND(utl_calcVacDays(EMP.hire_date, EMP.leave_date)/365, 1) BETWEEN 8.01 AND 9.00 THEN '9_up_to_9_yr'
            ELSE '_over_9_yr'
          END
 ORDER BY 1;