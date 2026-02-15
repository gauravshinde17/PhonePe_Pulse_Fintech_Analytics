
USE phonepe_analytics;

LOAD DATA LOCAL INFILE 'C:/PROJECTS/PhonePe_Pulse_Analytics/01_Data/02_Processed_Data/phonepe_users_aggregated.csv'
INTO TABLE stg_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM stg_users;
SELECT * FROM stg_users LIMIT 5;



LOAD DATA LOCAL INFILE 'C:/PROJECTS/PhonePe_Pulse_Analytics/01_Data/02_Processed_Data/phonepe_transactions_aggregated.csv'
INTO TABLE stg_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM stg_transactions;
SELECT * FROM stg_transactions LIMIT 5;

SELECT 
    MIN(transaction_amount_crore) AS min_amt,
    MAX(transaction_amount_crore) AS max_amt,
    MIN(avg_transaction_value) AS min_avg,
    MAX(avg_transaction_value) AS max_avg
FROM stg_transactions;




LOAD DATA LOCAL INFILE 'C:/PROJECTS/PhonePe_Pulse_Analytics/01_Data/02_Processed_Data/phonepe_insurance_aggregated_india.csv'
INTO TABLE stg_insurance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM stg_insurance;
SELECT * FROM stg_insurance LIMIT 5;
