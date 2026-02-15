USE phonepe_analytics;

## ============================================
## View: vw_insurance_growth
## Purpose: Calculate QoQ and YoY growth for insurance
## Based On: vw_core_quarterly_insurance
## ============================================

CREATE OR REPLACE VIEW vw_insurance_growth AS

SELECT
    time_id,
    year,
    quarter,
    year_quarter,
    insurance_type,
    total_policy_count,
    total_premium_rupees,
    total_premium_crore,
    avg_policy_value,

    ROUND(
        (total_policy_count - LAG(total_policy_count, 1)
            OVER (ORDER BY time_id))
        / LAG(total_policy_count, 1)
            OVER (ORDER BY time_id) * 100,
        2
    ) AS qoq_policy_growth_percent,

    ROUND(
        (total_policy_count - LAG(total_policy_count, 4)
            OVER (ORDER BY time_id))
        / LAG(total_policy_count, 4)
            OVER (ORDER BY time_id) * 100,
        2
    ) AS yoy_policy_growth_percent,

    ROUND(
        (total_premium_rupees - LAG(total_premium_rupees, 1)
            OVER (ORDER BY time_id))
        / LAG(total_premium_rupees, 1)
            OVER (ORDER BY time_id) * 100,
        2
    ) AS qoq_premium_growth_percent,

    ROUND(
        (total_premium_rupees - LAG(total_premium_rupees, 4)
            OVER (ORDER BY time_id))
        / LAG(total_premium_rupees, 4)
            OVER (ORDER BY time_id) * 100,
        2
    ) AS yoy_premium_growth_percent

FROM vw_core_quarterly_insurance

ORDER BY time_id;

## ============================================
## End of View
## ============================================




## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_insurance_growth;

## First 6 Rows

SELECT *
FROM vw_insurance_growth
ORDER BY time_id
LIMIT 6;

