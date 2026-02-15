USE phonepe_analytics;

CREATE OR REPLACE VIEW vw_regional_user_growth AS

SELECT
    region,
    time_id,
    year,
    quarter,
    year_quarter,

    SUM(total_registered_users) AS total_registered_users,
    SUM(total_app_opens) AS total_app_opens,

    ROUND(
        (
            SUM(total_registered_users) -
            LAG(SUM(total_registered_users))
                OVER (PARTITION BY region ORDER BY time_id)
        )
        /
        LAG(SUM(total_registered_users))
            OVER (PARTITION BY region ORDER BY time_id)
        * 100,
        2
    ) AS qoq_user_growth_percent,

    ROUND(
        (
            SUM(total_app_opens) -
            LAG(SUM(total_app_opens))
                OVER (PARTITION BY region ORDER BY time_id)
        )
        /
        LAG(SUM(total_app_opens))
            OVER (PARTITION BY region ORDER BY time_id)
        * 100,
        2
    ) AS qoq_app_opens_growth_percent

FROM vw_core_quarterly_users

GROUP BY
    region,
    time_id,
    year,
    quarter,
    year_quarter

ORDER BY
    region,
    time_id;




SELECT *
FROM vw_regional_user_growth
WHERE year_quarter = '2024-Q4';

