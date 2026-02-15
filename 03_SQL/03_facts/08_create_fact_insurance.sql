USE phonepe_analytics;

DROP TABLE IF EXISTS fact_insurance;

CREATE TABLE fact_insurance (
    insurance_fact_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    time_id INT,
    insurance_type VARCHAR(50),
    policy_count BIGINT,
    insurance_amount_rupees BIGINT,
    insurance_amount_crore DOUBLE,
    avg_policy_value DOUBLE,
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id)
);

DESCRIBE stg_insurance;


INSERT INTO fact_insurance (
    time_id,
    insurance_type,
    policy_count,
    insurance_amount_rupees,
    insurance_amount_crore,
    avg_policy_value
)
SELECT
    dt.time_id,
    si.insurance_type,
    si.policy_count,
    si.insurance_amount_rupees,
    si.insurance_amount_crore,
    si.avg_policy_value
FROM stg_insurance si
JOIN dim_time dt
    ON si.year = dt.year
   AND si.quarter = dt.quarter;


SELECT COUNT(*) FROM fact_insurance;

