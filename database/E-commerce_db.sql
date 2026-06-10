CREATE DATABASE IF NOT EXISTS E_COMMERCE_DB;

USE E_COMMERCE_DB;

-- 1. Dimension Tables 
CREATE TABLE IF NOT EXISTS dim_users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    gender ENUM("Male", "Female", "Other"),
    city VARCHAR(100),
    signup_date DATE
);

CREATE TABLE IF NOT EXISTS dim_Products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2), -- Fixed precision/scale (10 total digits, 2 decimal places)
    rating FLOAT
);

-- 2. Fact Tables
CREATE TABLE IF NOT EXISTS fact_order (
    order_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50), -- Matched data type with dim_users
    order_date TIMESTAMP,
    order_status VARCHAR(50),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES dim_users (user_id)
);

CREATE TABLE IF NOT EXISTS fact_order_items (
    order_item_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50), -- Matched data type with fact_order
    product_id VARCHAR(50), -- Matched data type with dim_Products
    user_id VARCHAR(50), -- Matched data type with dim_users
    quantity INT,
    item_price DECIMAL(10, 2),
    item_total DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES fact_order (order_id),
    FOREIGN KEY (product_id) REFERENCES dim_Products (product_id),
    FOREIGN KEY (user_id) REFERENCES dim_users (user_id)
);

CREATE TABLE IF NOT EXISTS fact_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50), -- Matched data type with fact_order
    product_id VARCHAR(50), -- Matched data type with dim_Products
    user_id VARCHAR(50), -- Matched data type with dim_users
    rating INT,
    review_text VARCHAR(150),
    review_date TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES fact_order (order_id),
    FOREIGN KEY (product_id) REFERENCES dim_Products (product_id),
    FOREIGN KEY (user_id) REFERENCES dim_users (user_id)
);

CREATE TABLE IF NOT EXISTS fact_events (
    event_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50), -- Matched data type with dim_users
    product_id VARCHAR(50), -- Matched data type with dim_Products
    event_type VARCHAR(150),
    event_timestamp TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES dim_users (user_id),
    FOREIGN KEY (product_id) REFERENCES dim_Products (product_id)
);