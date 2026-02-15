
USE phonepe_analytics;

CREATE TABLE stg_users (
    state VARCHAR(50),
    region VARCHAR(20),
    year INT,
    quarter INT,
    registered_users BIGINT,
    app_opens BIGINT
);




CREATE TABLE stg_transactions (
    state VARCHAR(50),
    year INT,
    quarter INT,
    transaction_type VARCHAR(50),
    transaction_count BIGINT,
    transaction_amount_rupees BIGINT,
    transaction_amount_crore DOUBLE,
    avg_transaction_value DOUBLE,
    region VARCHAR(20)
);





CREATE TABLE stg_insurance (
    year INT,
    quarter INT,
    insurance_type VARCHAR(50),
    policy_count BIGINT,
    insurance_amount_rupees BIGINT,
    insurance_amount_crore DOUBLE,
    avg_policy_value DOUBLE
);


SHOW TABLES;