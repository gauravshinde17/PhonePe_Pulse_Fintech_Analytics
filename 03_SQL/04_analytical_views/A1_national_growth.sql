USE phonepe_analytics;

## ============================================
## View: vw_national_growth
## Purpose: Add QoQ and YoY growth to national data
## Based On: vw_core_quarterly_national_transactions
## ============================================

CREATE OR REPLACE VIEW vw_national_growth AS

SELECT
    time_id,
    year,
    quarter,
    year_quarter,
    total_transactions,
    total_transaction_value_rupees,
    total_transaction_value_crore,
    active_states_count,

    ROUND(
        (total_transactions - LAG(total_transactions, 1) 
            OVER (ORDER BY time_id))
        / LAG(total_transactions, 1) 
            OVER (ORDER BY time_id) * 100,
        2
    ) AS qoq_growth_transactions_percent,

    ROUND(
        (total_transactions - LAG(total_transactions, 4) 
            OVER (ORDER BY time_id))
        / LAG(total_transactions, 4) 
            OVER (ORDER BY time_id) * 100,
        2
    ) AS yoy_growth_transactions_percent,

    ROUND(
        (total_transaction_value_rupees - LAG(total_transaction_value_rupees, 1) 
            OVER (ORDER BY time_id))
        / LAG(total_transaction_value_rupees, 1) 
            OVER (ORDER BY time_id) * 100,
        2
    ) AS qoq_growth_value_percent,

    ROUND(
        (total_transaction_value_rupees - LAG(total_transaction_value_rupees, 4) 
            OVER (ORDER BY time_id))
        / LAG(total_transaction_value_rupees, 4) 
            OVER (ORDER BY time_id) * 100,
        2
    ) AS yoy_growth_value_percent

FROM vw_core_quarterly_national_transactions

ORDER BY time_id;

## ============================================
## End of View
## ============================================

## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_national_growth;

## Check First 4 Rows

SELECT *
FROM vw_national_growth
ORDER BY time_id
LIMIT 6;

