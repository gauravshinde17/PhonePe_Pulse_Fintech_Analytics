USE phonepe_analytics;

CREATE TABLE dim_state (
    state_id INT PRIMARY KEY AUTO_INCREMENT,
    state_name VARCHAR(50) NOT NULL UNIQUE,
    region VARCHAR(20)
);


SHOW TABLES LIKE 'dim_state';
DESCRIBE dim_state;




INSERT INTO dim_state (state_name, region)
SELECT DISTINCT
    state,
    region
FROM stg_transactions
ORDER BY state;


SELECT COUNT(*) FROM dim_state;

SELECT * FROM dim_state ORDER BY state_name;


## Create dim_region

DROP TABLE IF EXISTS dim_region;

CREATE TABLE dim_region (
    region_id INT NOT NULL AUTO_INCREMENT,
    region VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (region_id),
    UNIQUE KEY uk_region (region)
);

INSERT INTO dim_region (region)
SELECT DISTINCT region
FROM dim_state
ORDER BY region;

SELECT * FROM dim_region;



