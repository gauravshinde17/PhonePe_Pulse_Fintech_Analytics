USE phonepe_analytics;

## ============================================
## View: vw_regional_growth
## Purpose: Add QoQ and YoY growth per region
## Based On: vw_core_quarterly_regional_transactions
## ============================================

CREATE OR REPLACE VIEW vw_regional_growth AS

SELECT
    time_id,
    year,
    quarter,
    year_quarter,
    region,
    total_transactions,
    total_transaction_value_rupees,
    total_transaction_value_crore,

    ROUND(
        (total_transactions - LAG(total_transactions, 1) 
            OVER (PARTITION BY region ORDER BY time_id))
        / LAG(total_transactions, 1) 
            OVER (PARTITION BY region ORDER BY time_id) * 100,
        2
    ) AS qoq_growth_transactions_percent,

    ROUND(
        (total_transactions - LAG(total_transactions, 4) 
            OVER (PARTITION BY region ORDER BY time_id))
        / LAG(total_transactions, 4) 
            OVER (PARTITION BY region ORDER BY time_id) * 100,
        2
    ) AS yoy_growth_transactions_percent,

    ROUND(
        (total_transaction_value_rupees - LAG(total_transaction_value_rupees, 1) 
            OVER (PARTITION BY region ORDER BY time_id))
        / LAG(total_transaction_value_rupees, 1) 
            OVER (PARTITION BY region ORDER BY time_id) * 100,
        2
    ) AS qoq_growth_value_percent,

    ROUND(
        (total_transaction_value_rupees - LAG(total_transaction_value_rupees, 4) 
            OVER (PARTITION BY region ORDER BY time_id))
        / LAG(total_transaction_value_rupees, 4) 
            OVER (PARTITION BY region ORDER BY time_id) * 100,
        2
    ) AS yoy_growth_value_percent

FROM vw_core_quarterly_regional_transactions

ORDER BY region, time_id;

## ============================================
## End of View
## ============================================

## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_regional_growth;

## Check First Few Rows Per Region

SELECT *
FROM vw_regional_growth
WHERE region = 'North'
ORDER BY time_id
LIMIT 6;

