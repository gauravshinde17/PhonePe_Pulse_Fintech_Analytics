USE phonepe_analytics;

## ============================================
## View: vw_state_leaderboard
## Purpose: Rank states per quarter and calculate contribution
## Based On: vw_core_quarterly_state_transactions
## ============================================


CREATE VIEW vw_state_leaderboard AS
SELECT
    ds.state_name,
    SUM(ft.transaction_amount_rupees) AS total_transaction_value_rupees,
    
    DENSE_RANK() OVER (
        ORDER BY SUM(ft.transaction_amount_rupees) DESC
    ) AS state_rank,
    
    ROUND(
        SUM(ft.transaction_amount_rupees) /
        SUM(SUM(ft.transaction_amount_rupees)) OVER () * 100,
        2
    ) AS state_contribution_percent

FROM fact_transactions ft
JOIN dim_time dt 
    ON ft.time_id = dt.time_id
JOIN dim_state ds 
    ON ft.state_id = ds.state_id

WHERE dt.time_id = (SELECT MAX(time_id) FROM dim_time)

GROUP BY ds.state_name

ORDER BY state_rank;




## ============================================
## End of View
## ============================================


## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_state_leaderboard;


## Check Ranking Logic

## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_state_leaderboard;


## Check Ranking Logic

SELECT state_name, state_rank
FROM vw_state_leaderboard
ORDER BY state_rank
LIMIT 10;


## Contribution Check

SELECT ROUND(SUM(state_contribution_percent),2) AS total_percent
FROM vw_state_leaderboard;
