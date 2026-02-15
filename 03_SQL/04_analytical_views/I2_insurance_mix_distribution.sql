USE phonepe_analytics;

## ============================================
## View: vw_insurance_mix_distribution
## Purpose: Calculate share of each insurance type per quarter
## Based On: vw_core_quarterly_insurance
## ============================================

CREATE OR REPLACE VIEW vw_insurance_mix_distribution AS

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
        total_policy_count /
        SUM(total_policy_count) OVER (PARTITION BY time_id) * 100,
        2
    ) AS policy_share_percent,

    ROUND(
        total_premium_rupees /
        SUM(total_premium_rupees) OVER (PARTITION BY time_id) * 100,
        2
    ) AS premium_share_percent

FROM vw_core_quarterly_insurance

ORDER BY time_id, insurance_type;

## ============================================
## End of View
## ============================================



## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_insurance_mix_distribution;

## Share Check

SELECT year_quarter, SUM(policy_share_percent)
FROM vw_insurance_mix_distribution
GROUP BY year_quarter;


