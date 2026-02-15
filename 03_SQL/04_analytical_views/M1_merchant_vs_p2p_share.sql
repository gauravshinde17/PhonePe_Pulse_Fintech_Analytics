USE phonepe_analytics;

## ============================================
## View: vw_merchant_vs_p2p_share
## Purpose: Calculate Merchant and P2P share per quarter
## Based On: vw_core_quarterly_transaction_type
## ============================================

CREATE OR REPLACE VIEW vw_merchant_vs_p2p_share AS

SELECT
    time_id,
    year,
    quarter,
    year_quarter,

    SUM(CASE 
            WHEN transaction_type = 'Merchant payments'
            THEN total_transaction_value_rupees 
            ELSE 0 
        END) AS merchant_value,

    SUM(CASE 
            WHEN transaction_type = 'Peer-to-peer payments'
            THEN total_transaction_value_rupees 
            ELSE 0 
        END) AS p2p_value,

    SUM(total_transaction_value_rupees) AS total_value,

    ROUND(
        SUM(CASE 
                WHEN transaction_type = 'Merchant payments'
                THEN total_transaction_value_rupees 
                ELSE 0 
            END)
        / SUM(total_transaction_value_rupees) * 100,
        2
    ) AS merchant_share_percent,

    ROUND(
        SUM(CASE 
                WHEN transaction_type = 'Peer-to-peer payments'
                THEN total_transaction_value_rupees 
                ELSE 0 
            END)
        / SUM(total_transaction_value_rupees) * 100,
        2
    ) AS p2p_share_percent

FROM vw_core_quarterly_transaction_type

GROUP BY 
    time_id,
    year,
    quarter,
    year_quarter

ORDER BY time_id;

## ============================================
## End of View
## ============================================


## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_merchant_vs_p2p_share;

## Share Check

SELECT merchant_share_percent + p2p_share_percent
FROM vw_merchant_vs_p2p_share
WHERE year_quarter = '2022-Q1';

SELECT DISTINCT transaction_type
FROM vw_core_quarterly_transaction_type;
