USE phonepe_analytics;

## ============================================
## View: vw_user_growth
## Purpose: Calculate QoQ and YoY growth for users and app opens
## Based On: vw_core_quarterly_users
## ============================================

CREATE OR REPLACE VIEW vw_user_growth AS

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
        (total_registered_users - LAG(total_registered_users, 1)
            OVER (PARTITION BY state_id ORDER BY time_id))
        / LAG(total_registered_users, 1)
            OVER (PARTITION BY state_id ORDER BY time_id) * 100,
        2
    ) AS qoq_user_growth_percent,

    ROUND(
        (total_registered_users - LAG(total_registered_users, 4)
            OVER (PARTITION BY state_id ORDER BY time_id))
        / LAG(total_registered_users, 4)
            OVER (PARTITION BY state_id ORDER BY time_id) * 100,
        2
    ) AS yoy_user_growth_percent,

    ROUND(
        (total_app_opens - LAG(total_app_opens, 1)
            OVER (PARTITION BY state_id ORDER BY time_id))
        / LAG(total_app_opens, 1)
            OVER (PARTITION BY state_id ORDER BY time_id) * 100,
        2
    ) AS qoq_app_opens_growth_percent,

    ROUND(
        (total_app_opens - LAG(total_app_opens, 4)
            OVER (PARTITION BY state_id ORDER BY time_id))
        / LAG(total_app_opens, 4)
            OVER (PARTITION BY state_id ORDER BY time_id) * 100,
        2
    ) AS yoy_app_opens_growth_percent

FROM vw_core_quarterly_users

ORDER BY state_id, time_id;

## ============================================
## End of View
## ============================================













## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_user_growth;

## Check One State

SELECT *
FROM vw_user_growth
WHERE state_name = 'Maharashtra'
ORDER BY time_id
LIMIT 6;
