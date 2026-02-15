USE phonepe_analytics;

## ============================================
## View: vw_master_kpi_summary
## Purpose: Executive snapshot for latest quarter
## ============================================

CREATE OR REPLACE VIEW vw_master_kpi_summary AS

WITH latest_time AS (
    SELECT MAX(time_id) AS max_time_id
    FROM dim_time
),

national_kpi AS (
    SELECT *
    FROM vw_national_growth
    WHERE time_id = (SELECT max_time_id FROM latest_time)
),

merchant_kpi AS (
    SELECT *
    FROM vw_merchant_vs_p2p_share
    WHERE time_id = (SELECT max_time_id FROM latest_time)
),

engagement_kpi AS (
    SELECT 
        time_id,
        ROUND(SUM(total_app_opens) / NULLIF(SUM(total_registered_users), 0), 2)
            AS national_engagement_ratio
    FROM vw_core_quarterly_users
    WHERE time_id = (SELECT max_time_id FROM latest_time)
    GROUP BY time_id
),

insurance_kpi AS (
    SELECT *
    FROM vw_insurance_growth
    WHERE time_id = (SELECT max_time_id FROM latest_time)
)

SELECT
    n.year,
    n.quarter,
    n.year_quarter,

    n.total_transactions,
    n.total_transaction_value_rupees,
    n.qoq_growth_transactions_percent,
    n.yoy_growth_transactions_percent,

    m.merchant_share_percent,

    e.national_engagement_ratio,

    i.total_policy_count,
    i.total_premium_rupees,
    i.yoy_policy_growth_percent

FROM national_kpi n
JOIN merchant_kpi m ON n.time_id = m.time_id
JOIN engagement_kpi e ON n.time_id = e.time_id
LEFT JOIN insurance_kpi i ON n.time_id = i.time_id;

## ============================================
## End of View
## ============================================


## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_master_kpi_summary;

## View Data

SELECT *
FROM vw_master_kpi_summary;
