/* How salary changes over time with increasing seniority years and
 * Maximal Social Insurance Income increases introduced by government
 */

WITH RECURSIVE
strt AS (SELECT '2020-01-01' AS dt), /* TODO: Change start date here */
yrs AS (
  SELECT YEAR(strt.dt) AS yr FROM strt
  UNION ALL
  SELECT yr + 1
    FROM yrs
  WHERE yr < YEAR(NOW()) + 1
),
mnths AS (
  SELECT 1 AS mnth
  UNION ALL
  SELECT mnth + 1
    FROM mnths
   WHERE mnth < 12
),
cal AS (
  SELECT yr, mnth, fst_dt,
         LAST_DAY(fst_dt) AS lst_dt,
         TIMESTAMPDIFF(YEAR, strt.dt, fst_dt) AS snrty
    FROM strt,
         (SELECT yrs.yr, mnths.mnth,
                 STR_TO_DATE(CONCAT(yrs.yr, '-', mnths.mnth, '-01'), '%Y-%m-%d') AS fst_dt
            FROM yrs, mnths) yrs_mnths
),
bases_tbl AS ( /* TODO: Enter base salary adjustments here following example */
  VALUES ROW('2020-01-01',  8000.08),
         ROW('2021-01-01',  9000.09),
         ROW('2022-01-01', 10000.01),
         ROW('2026-01-01', 12000.02) /* reset diff just for EUR */
),
base AS (
  SELECT since,
         DATE_ADD(till, INTERVAL -1 DAY) AS till,
         sal
    FROM (SELECT column_0 AS since,
                 LEAD(column_0) OVER(ORDER BY column_0
                   ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS till,
                 column_1 AS sal
            FROM bases_tbl) bases
),
sal_tbl AS (
  SELECT cal.yr, cal.mnth,
         base.since, base.sal AS base_sal,
         cal.snrty,
         codix.calcNetSalaryBGForYearMonth(base.sal, cal.snrty, cal.yr, cal.mnth) AS sal
    FROM base, cal, strt
   WHERE cal.fst_dt >= base.since
     AND cal.lst_dt <= IFNULL(base.till, cal.lst_dt)
),
sal_diffs AS (
  SELECT yr, mnth, since, base_sal, snrty, sal,
         sal - FIRST_VALUE(sal) OVER (PARTITION BY since ORDER BY yr, mnth
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS diff
    FROM sal_tbl
   ORDER BY yr, mnth
)
SELECT CONCAT(yr, '-', mnth) AS yr_mnth, since, base_sal, snrty, sal, diff,
       SUM(diff) OVER (ORDER BY yr, mnth
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_diff
  FROM sal_diffs, strt
 ORDER BY yr, mnth;
