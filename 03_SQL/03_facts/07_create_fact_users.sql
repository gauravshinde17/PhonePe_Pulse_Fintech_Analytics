USE phonepe_analytics;

CREATE TABLE fact_users (
    user_fact_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    state_id INT,
    time_id INT,
    registered_users BIGINT,
    app_opens BIGINT,

    FOREIGN KEY (state_id) REFERENCES dim_state(state_id),
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id)
);

DESCRIBE fact_users;






INSERT INTO fact_users (
    state_id,
    time_id,
    registered_users,
    app_opens
)
SELECT
    ds.state_id,
    dt.time_id,
    su.registered_users,
    su.app_opens
FROM stg_users su
JOIN dim_state ds
    ON su.state = ds.state_name
JOIN dim_time dt
    ON su.year = dt.year
   AND su.quarter = dt.quarter;
   
   

SELECT COUNT(*) FROM fact_users;

SELECT COUNT(*) FROM stg_users;

SELECT * FROM fact_users LIMIT 5;
