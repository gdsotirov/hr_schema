# HR Schema

An example HR database for management of company's organization (departments,
divisions, locations), party (persons and relations), recruitment (jobs offers
and candidates), employees (absences, appraisals, job and team history),
remuneration (salary history, bonuses and distribution), etc.

# Database structure

The database holds information for several domains as follows.

## Company organization

Defines company's organization structure. Includes the following 5 tables:
  * `countries` - list of countries where the company has activities;
  * `departments` - departments register;
  * `divisions` - company's divisions;
  * `locations` - locations of company's offices, warehouses, etc.;
  * `regions` - list of country regions where the company has activities.

## Employee management

Defines employees and related data. Includes the following 11 tables:
  * `absence_totals` - defines the maximum days per absence type, user or
    division to be used in a calendar year;
  * `absence_types` - types of possible absences;
  * `absences` - register of employees absences;
  * `appraisal_period_types` - type of appraisals by period;
  * `appraisal_types` - type of appraisals;
  * `appraisals` - employees appraisals;
  * `division_change` - employees division change register;
  * `employees` - catalog of company's most valuable resources
  * `job_history` - employees job changes;
  * `memos` - notes on employees behavior, attitude, problems, etc.;
  * `team_change` - employees team change history.

## Foreign exchange

Defines currencies and rates. Includes the following 2 tables:
  * `curr_rates` - currency conversion rates register;
  * `currencies` - currencies register.

## Party management

Defines persons and relations. Includes the following 3 tables:
  * `person_relation_types` - types of relations between persons;
  * `person_relations` - relations between persons;
  * `persons` - persons register.

## Recruitment

Defines jobs, offers and candidates. Includes the following 3 tables:
  * `job_candidates` - catalog of job candidates;
  * `job_offers` - catalog of job offers;
  * `jobs` - list of jobs within the company with salary range.

## Remuneration

Defines salary history, bonuses and distribution. Includes the following 3
tables:
  * `bonus_distribution` - bonus distribution per employee;
  * `bonuses` - additional payments for performance;
  * `sal_history` - employees salary history.

# Application

The project includes a simple application in OpenOffice Base that could be
used for entry or modification of data.

