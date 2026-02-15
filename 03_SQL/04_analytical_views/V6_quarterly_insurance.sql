USE phonepe_analytics;

## ============================================
## View: vw_core_quarterly_insurance
## Purpose: Quarterly aggregation of insurance data
## Granularity: Quarter × Insurance Type (National)
## ============================================

CREATE OR REPLACE VIEW vw_core_quarterly_insurance AS

SELECT 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,
    fi.insurance_type,

    SUM(fi.policy_count) AS total_policy_count,
    SUM(fi.insurance_amount_rupees) AS total_premium_rupees,
    SUM(fi.insurance_amount_crore) AS total_premium_crore,
    AVG(fi.avg_policy_value) AS avg_policy_value

FROM fact_insurance fi
JOIN dim_time dt 
    ON fi.time_id = dt.time_id

GROUP BY 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,
    fi.insurance_type

ORDER BY 
    dt.year,
    dt.quarter,
    fi.insurance_type;

## ============================================
## End of View
## ============================================


## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*) 
FROM vw_core_quarterly_insurance;

## Reconciliation Check

SELECT SUM(total_premium_rupees)
FROM vw_core_quarterly_insurance;

SELECT SUM(insurance_amount_rupees)
FROM fact_insurance;

## Policies

SELECT SUM(total_policy_count)
FROM vw_core_quarterly_insurance;

SELECT SUM(policy_count)
FROM fact_insurance;
