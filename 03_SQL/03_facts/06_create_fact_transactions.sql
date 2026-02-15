USE phonepe_analytics;

CREATE TABLE fact_transactions (
    transaction_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    state_id INT,
    time_id INT,
    transaction_type VARCHAR(50),
    transaction_count BIGINT,
    transaction_amount_rupees BIGINT,
    transaction_amount_crore DOUBLE,
    avg_transaction_value DOUBLE,

    FOREIGN KEY (state_id) REFERENCES dim_state(state_id),
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id)
);

DESCRIBE fact_transactions;




USE phonepe_analytics;

INSERT INTO fact_transactions (
    state_id,
    time_id,
    transaction_type,
    transaction_count,
    transaction_amount_rupees,
    transaction_amount_crore,
    avg_transaction_value
)
SELECT
    ds.state_id,
    dt.time_id,
    st.transaction_type,
    st.transaction_count,
    st.transaction_amount_rupees,
    st.transaction_amount_crore,
    st.avg_transaction_value
FROM stg_transactions st
JOIN dim_state ds
    ON st.state = ds.state_name
JOIN dim_time dt
    ON st.year = dt.year
   AND st.quarter = dt.quarter;



SELECT COUNT(*) FROM fact_transactions;

SELECT * FROM fact_transactions LIMIT 5;

SELECT COUNT(*) 
FROM stg_transactions;
