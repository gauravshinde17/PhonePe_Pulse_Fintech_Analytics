USE phonepe_analytics;

CREATE TABLE dim_time (
    time_id INT PRIMARY KEY AUTO_INCREMENT,
    year INT NOT NULL,
    quarter INT NOT NULL,
    year_quarter VARCHAR(10) NOT NULL,
    UNIQUE (year, quarter)
);


SHOW TABLES LIKE 'dim_time';
DESCRIBE dim_time;


USE phonepe_analytics;

INSERT INTO dim_time (year, quarter, year_quarter)
SELECT DISTINCT
    year,
    quarter,
    CONCAT(year, '-Q', quarter) AS year_quarter
FROM (
    SELECT year, quarter FROM stg_users
    UNION
    SELECT year, quarter FROM stg_transactions
    UNION
    SELECT year, quarter FROM stg_insurance
) t
ORDER BY year, quarter;


SELECT * FROM dim_time ORDER BY year, quarter;
SELECT COUNT(*) FROM dim_time;
