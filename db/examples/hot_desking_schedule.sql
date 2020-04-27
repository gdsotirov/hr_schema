/* Purpose: Generate schedule for hot desking
 * See: https://en.wikipedia.org/wiki/Hot_desking
 * Description: Have a number of employees (e.g. 10) and a limited number
 * of desks (e.g. 5), so generate a schedule for usage of the desks based on
 * the preferences of the employees (e.g. more in the office or more from
 * home) considering weekends and public holidays.
 * Requirements: The schedule should adhere to the following requirements:
 *   - include only working days and exclude weekends and public holidays;
 *   - follow only working days (ordered);
 *   - each desk could have different usage scheme with at least one day in
 *     the office (need to manually adjust desk schedule queries);
 *   - have variety of employees in the office (more differentiated schemes
 *     would provide more variety).
 * Requires: MySQL 8.0.1 or later for Common Table Expressions (CTE) support.
 */

WITH RECURSIVE
/* List of public holidays in Bulgaria for 2020 */
pubhol(dat) AS (
  SELECT STR_TO_DATE('2020-01-01', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-03-03', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-04-17', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-04-20', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-05-01', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-05-06', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-05-25', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-09-07', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-09-22', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-12-24', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-12-25', '%Y-%m-%d') UNION ALL
  SELECT STR_TO_DATE('2020-12-28', '%Y-%m-%d')
),
/* Schedule start date */
start_dat(sdat) AS (SELECT STR_TO_DATE('2020-05-14', '%Y-%m-%d') AS sdat),
/* Schdule end date */
end_dat(edat)   AS (SELECT STR_TO_DATE('2020-12-31', '%Y-%m-%d') AS edat),
/* Calendar dates from start to end date */
dates(dat) AS (
  SELECT sdat AS dat FROM start_dat
  UNION ALL
  SELECT DATE_ADD(dat, INTERVAL 1 DAY)
    FROM dates
   WHERE dat < (SELECT edat FROM end_dat)
),
/* Desk 1 Schedule */
desk1(num, emp) AS ( /* 1 office / 4 home */
  SELECT 1 AS num, CAST('Employee 0' AS CHAR(12)) AS emp
  UNION ALL SELECT 2, 'Employee 1'
  UNION ALL SELECT 3, 'Employee 1'
  UNION ALL SELECT 4, 'Employee 1'
  UNION ALL SELECT 5, 'Employee 1'
),
/* Desk 2 Schedule */
desk2(num, emp) AS ( /* 50/50 */
  SELECT 2 AS num, CAST('Employee 2' AS CHAR(12)) AS emp
  UNION ALL SELECT 3, 'Employee 2'
  UNION ALL SELECT 4, 'Employee 2'
  UNION ALL SELECT 5, 'Employee 3'
  UNION ALL SELECT 6, 'Employee 3'
  UNION ALL SELECT 1, 'Employee 3'
),
/* Desk 3 Schedule */
desk3(num, emp) AS ( /* 4 office / 1 home */
  SELECT 3 AS num, CAST('Employee 4' AS CHAR(12)) AS emp
  UNION ALL SELECT 4, 'Employee 4'
  UNION ALL SELECT 5, 'Employee 4'
  UNION ALL SELECT 1, 'Employee 4'
  UNION ALL SELECT 2, 'Employee 5'
),
/* Desk 4 Schedule */
desk4(num, emp) AS ( /* 2 office / 3 home */
  SELECT 4 AS num, CAST('Employee 6' AS CHAR(12)) AS emp
  UNION ALL SELECT 5, 'Employee 6'
  UNION ALL SELECT 1, 'Employee 7'
  UNION ALL SELECT 2, 'Employee 7'
  UNION ALL SELECT 3, 'Employee 7'
),
/* Desk 5 Schedule */
desk5(num, emp) AS ( /* 3 office / 2 home */
  SELECT 5 AS num, CAST('Employee 8' AS CHAR(12)) AS emp
  UNION ALL SELECT 1, 'Employee 8'
  UNION ALL SELECT 2, 'Employee 8'
  UNION ALL SELECT 3, 'Employee 9'
  UNION ALL SELECT 4, 'Employee 9'
)
/* TODO: Add more desks here */
/* Schemes could be generated in different way, but I used separate
/* queries to make them more explicit. */

/* Generate schedule */
SELECT cdays.num, cdays.dat,
       desk1.emp AS desk1,
       desk2.emp AS desk2,
       desk3.emp AS desk3,
       desk4.emp AS desk4,
       desk5.emp AS desk5
       /* TODO: Add more deskss here */
  FROM (SELECT ROW_NUMBER() OVER() num, /* number workdays */
               dat
          FROM dates
         WHERE /* exclude weekends */
               WEEKDAY(dates.dat) NOT IN (5, 6)
               /* exclude public holidays for 2020 */
           AND dates.dat NOT IN (SELECT dat FROM pubhol)
       UNION
       SELECT NULL AS num,
              dat
         FROM dates
        WHERE /* weekends */
              WEEKDAY(dates.dat) IN (5, 6)
              /* or public holidays for 2020 */
            OR dates.dat IN (SELECT dat FROM pubhol)
        ORDER BY dat
       ) cdays
       LEFT JOIN desk1 ON cdays.num MOD 5 = desk1.num MOD 5
       LEFT JOIN desk2 ON cdays.num MOD 6 = desk2.num MOD 6 /* 50/50 */
       LEFT JOIN desk3 ON cdays.num MOD 5 = desk3.num MOD 5
       LEFT JOIN desk4 ON cdays.num MOD 5 = desk4.num MOD 5
       LEFT JOIN desk5 ON cdays.num MOD 5 = desk5.num MOD 5
       /* TODO: Add more desks here - divide by 5 or 6 for 50/50 scheme */
 WHERE 1=1 /* TODO: Add additional constraints here */;

