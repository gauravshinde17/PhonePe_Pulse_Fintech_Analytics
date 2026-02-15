USE phonepe_analytics;

## ============================================
## View: vw_fastest_growing_region
## Purpose: Identify fastest growing region based on user YoY growth
## ============================================

CREATE OR REPLACE VIEW vw_fastest_growing_region AS

WITH regional_users AS (
    SELECT
        dt.time_id,
        dt.year,
        dt.quarter,
        dt.year_quarter,
        ds.region,
        SUM(fu.registered_users) AS total_registered_users
    FROM fact_users fu
    JOIN dim_time dt ON fu.time_id = dt.time_id
    JOIN dim_state ds ON fu.state_id = ds.state_id
    GROUP BY dt.time_id, dt.year, dt.quarter, dt.year_quarter, ds.region
),

regional_growth AS (
    SELECT
        time_id,
        year,
        quarter,
        year_quarter,
        region,
        total_registered_users,

        ROUND(
            (total_registered_users - LAG(total_registered_users, 4)
                OVER (PARTITION BY region ORDER BY time_id))
            / LAG(total_registered_users, 4)
                OVER (PARTITION BY region ORDER BY time_id) * 100,
            2
        ) AS yoy_growth_percent

    FROM regional_users
)

SELECT
    *,
    DENSE_RANK() OVER (
        PARTITION BY time_id
        ORDER BY yoy_growth_percent DESC
    ) AS growth_rank

FROM regional_growth

ORDER BY time_id, growth_rank;

## ============================================
## End of View
## ============================================




## ============================================
## Validation
## ============================================

## Row Count

SELECT COUNT(*)
FROM vw_fastest_growing_region;

## Check Ranking

SELECT year_quarter, region, yoy_growth_percent, growth_rank
FROM vw_fastest_growing_region
WHERE year_quarter = '2022-Q1'
ORDER BY growth_rank;
