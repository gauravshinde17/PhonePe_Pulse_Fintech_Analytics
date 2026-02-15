USE phonepe_analytics;

## ============================================
## View: vw_historical_master_kpi
## Purpose: Consolidated KPI view (Quarterly)
## ============================================

CREATE OR REPLACE VIEW vw_historical_master_kpi AS

WITH national_engagement AS (
    SELECT
        time_id,
        ROUND(
            SUM(total_app_opens) / NULLIF(SUM(total_registered_users), 0),
            2
        ) AS national_engagement_ratio
    FROM vw_core_quarterly_users
    GROUP BY time_id
)

SELECT
    n.time_id,
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

FROM vw_national_growth n
LEFT JOIN vw_merchant_vs_p2p_share m
    ON n.time_id = m.time_id
LEFT JOIN national_engagement e
    ON n.time_id = e.time_id
LEFT JOIN vw_insurance_growth i
    ON n.time_id = i.time_id

ORDER BY n.time_id;

## ============================================
## End of View
## ============================================




## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_historical_master_kpi;

## View Data

SELECT *
FROM vw_historical_master_kpi
ORDER BY time_id
LIMIT 6;
