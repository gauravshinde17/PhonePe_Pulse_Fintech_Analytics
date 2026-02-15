## ============================================
## View: vw_core_quarterly_national_transactions
## Purpose: Quarterly national transaction aggregation
## Granularity: Quarter level (National)
## ============================================


USE phonepe_analytics;


CREATE OR REPLACE VIEW vw_core_quarterly_national_transactions AS

SELECT 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,

    SUM(ft.transaction_count) AS total_transactions,
    SUM(ft.transaction_amount_rupees) AS total_transaction_value_rupees,
    SUM(ft.transaction_amount_crore) AS total_transaction_value_crore,
    COUNT(DISTINCT ft.state_id) AS active_states_count

FROM fact_transactions ft
JOIN dim_time dt 
    ON ft.time_id = dt.time_id

GROUP BY 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter

ORDER BY 
    dt.year,
    dt.quarter;

## ============================================
## End of View
## ============================================


## ============================================
## Validation
## ============================================

# Row Count

SELECT COUNT(*) 
FROM vw_core_quarterly_national_transactions;

SELECT SUM(total_transaction_value_rupees)
FROM vw_core_quarterly_national_transactions;

SELECT SUM(transaction_amount_rupees)
FROM fact_transactions;

SELECT SUM(total_transactions)
FROM vw_core_quarterly_national_transactions;

SELECT SUM(transaction_count)
FROM fact_transactions;

SELECT DISTINCT active_states_count
FROM vw_core_quarterly_national_transactions;

