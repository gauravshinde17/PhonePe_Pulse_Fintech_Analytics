USE phonepe_analytics;

## ============================================
## View: vw_merchant_growth
## Purpose: Calculate QoQ and YoY growth for Merchant payments
## Based On: vw_core_quarterly_transaction_type
## ============================================

CREATE OR REPLACE VIEW vw_merchant_growth AS

SELECT
    time_id,
    year,
    quarter,
    year_quarter,
    total_transactions,
    total_transaction_value_rupees,
    total_transaction_value_crore,

    ROUND(
        (total_transaction_value_rupees - LAG(total_transaction_value_rupees, 1)
            OVER (ORDER BY time_id))
        / LAG(total_transaction_value_rupees, 1)
            OVER (ORDER BY time_id) * 100,
        2
    ) AS qoq_growth_percent,

    ROUND(
        (total_transaction_value_rupees - LAG(total_transaction_value_rupees, 4)
            OVER (ORDER BY time_id))
        / LAG(total_transaction_value_rupees, 4)
            OVER (ORDER BY time_id) * 100,
        2
    ) AS yoy_growth_percent

FROM vw_core_quarterly_transaction_type

WHERE transaction_type = 'Merchant payments'

ORDER BY time_id;

## ============================================
## End of View
## ============================================

## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_merchant_growth;


## First 6 Rows

SELECT *
FROM vw_merchant_growth
ORDER BY time_id
LIMIT 6;


