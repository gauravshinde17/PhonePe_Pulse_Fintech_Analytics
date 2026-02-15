USE phonepe_analytics;

## ============================================
## View: vw_engagement_intensity
## Purpose: Calculate engagement ratio (App Opens / Users)
## Based On: vw_core_quarterly_users
## ============================================

CREATE OR REPLACE VIEW vw_engagement_intensity AS

SELECT
    time_id,
    year,
    quarter,
    year_quarter,
    state_id,
    state_name,
    region,
    total_registered_users,
    total_app_opens,

    ROUND(
        total_app_opens / NULLIF(total_registered_users, 0),
        2
    ) AS engagement_ratio

FROM vw_core_quarterly_users

ORDER BY time_id, state_name;

## ============================================
## End of View
## ============================================



## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_engagement_intensity;


## Sanity Check

SELECT *
FROM vw_engagement_intensity
ORDER BY engagement_ratio DESC
LIMIT 10;

