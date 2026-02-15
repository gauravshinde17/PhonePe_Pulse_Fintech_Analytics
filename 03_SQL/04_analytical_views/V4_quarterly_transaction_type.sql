USE phonepe_analytics;

## ============================================
## View: vw_core_quarterly_transaction_type
## Purpose: Quarterly aggregation by transaction type
## Granularity: Transaction Type × Quarter
## ============================================

CREATE OR REPLACE VIEW vw_core_quarterly_transaction_type AS

SELECT 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,
    ft.transaction_type,

    SUM(ft.transaction_count) AS total_transactions,
    SUM(ft.transaction_amount_rupees) AS total_transaction_value_rupees,
    SUM(ft.transaction_amount_crore) AS total_transaction_value_crore,
    AVG(ft.avg_transaction_value) AS avg_transaction_value

FROM fact_transactions ft
JOIN dim_time dt 
    ON ft.time_id = dt.time_id

GROUP BY 
    dt.time_id,
    dt.year,
    dt.quarter,
    dt.year_quarter,
    ft.transaction_type

ORDER BY 
    dt.year,
    dt.quarter,
    ft.transaction_type;

## ============================================
## End of View
## ============================================

## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*) 
FROM vw_core_quarterly_transaction_type;

## Value Reconciliation

SELECT SUM(total_transaction_value_rupees)
FROM vw_core_quarterly_transaction_type;

SELECT SUM(transaction_amount_rupees)
FROM fact_transactions;

## Transaction Count Check

SELECT SUM(total_transactions)
FROM vw_core_quarterly_transaction_type;

SELECT SUM(transaction_count)
FROM fact_transactions;
