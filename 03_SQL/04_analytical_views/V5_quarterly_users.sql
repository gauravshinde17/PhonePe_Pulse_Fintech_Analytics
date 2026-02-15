USE phonepe_analytics;

## ============================================
## View: vw_core_quarterly_users
## Purpose: Quarterly aggregation of users and app opens
## Granularity: State × Quarter
## ============================================

CREATE OR REPLACE VIEW vw_core_quarterly_users AS

SELECT 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,
    ds.state_id,
    ds.state_name,
    ds.region,

    SUM(fu.registered_users) AS total_registered_users,
    SUM(fu.app_opens) AS total_app_opens

FROM fact_users fu
JOIN dim_time dt 
    ON fu.time_id = dt.time_id
JOIN dim_state ds
    ON fu.state_id = ds.state_id

GROUP BY 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,
    ds.state_id,
    ds.state_name,
    ds.region

ORDER BY 
    dt.year,
    dt.quarter,
    ds.state_name;

## ============================================
## End of View
## ============================================

## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*) 
FROM vw_core_quarterly_users;

## Reconciliation Check

SELECT SUM(total_registered_users)
FROM vw_core_quarterly_users;

SELECT SUM(registered_users)
FROM fact_users;

## App opens

SELECT SUM(total_app_opens)
FROM vw_core_quarterly_users;

SELECT SUM(app_opens)
FROM fact_users;

