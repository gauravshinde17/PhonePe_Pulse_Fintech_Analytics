USE phonepe_analytics;

## ============================================
## View: vw_core_quarterly_state_transactions
## Purpose: Quarterly transaction aggregation at State level
## Granularity: State × Quarter
## ============================================

CREATE OR REPLACE VIEW vw_core_quarterly_state_transactions AS

SELECT 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,
    ds.state_id,
    ds.state_name,
    ds.region,

    SUM(ft.transaction_count) AS total_transactions,
    SUM(ft.transaction_amount_rupees) AS total_transaction_value_rupees,
    SUM(ft.transaction_amount_crore) AS total_transaction_value_crore

FROM fact_transactions ft
JOIN dim_time dt 
    ON ft.time_id = dt.time_id
JOIN dim_state ds
    ON ft.state_id = ds.state_id

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
FROM vw_core_quarterly_state_transactions;

SELECT SUM(total_transaction_value_rupees)
FROM vw_core_quarterly_state_transactions;

SELECT SUM(transaction_amount_rupees)
FROM fact_transactions;

SELECT SUM(total_transactions)
FROM vw_core_quarterly_state_transactions;

SELECT SUM(transaction_count)
FROM fact_transactions;

