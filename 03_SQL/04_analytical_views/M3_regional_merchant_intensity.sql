USE phonepe_analytics;

## ============================================
## View: vw_regional_merchant_intensity
## Purpose: Calculate Merchant intensity per region
## Based On: Core regional and transaction type views
## ============================================

CREATE OR REPLACE VIEW vw_regional_merchant_intensity AS

WITH merchant_regional AS (
    SELECT
        dt.time_id,
        ds.region,
        SUM(ft.transaction_amount_rupees) AS merchant_value
    FROM fact_transactions ft
    JOIN dim_time dt ON ft.time_id = dt.time_id
    JOIN dim_state ds ON ft.state_id = ds.state_id
    WHERE ft.transaction_type = 'Merchant payments'
    GROUP BY dt.time_id, ds.region
)

SELECT
    r.time_id,
    r.year,
    r.quarter,
    r.year_quarter,
    r.region,
    r.total_transaction_value_rupees AS total_value,
    m.merchant_value,

    ROUND(
        m.merchant_value / r.total_transaction_value_rupees * 100,
        2
    ) AS merchant_intensity_percent

FROM vw_core_quarterly_regional_transactions r
JOIN merchant_regional m
    ON r.time_id = m.time_id
    AND r.region = m.region

ORDER BY r.region, r.time_id;

## ============================================
## End of View
## ============================================


## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_regional_merchant_intensity;

## Sanity Check

SELECT *
FROM vw_regional_merchant_intensity
ORDER BY merchant_intensity_percent DESC
LIMIT 10;
