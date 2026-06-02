create database Olist_DB ;
use Olist_DB ;
DROP TABLE olist_geolocation_dataset_cleaned;
SHOW VARIABLES LIKE 'secure_file_priv';
CREATE TABLE olist_geolocation_dataset_cleaned (
  geolocation_zip_code_prefix INT,
  geolocation_lat DOUBLE,
  geolocation_lng DOUBLE,
  geolocation_city TEXT,
  geolocation_state TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist_Geolocation_Dataset_Cleaned.csv'
INTO TABLE olist_geolocation_dataset_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
select count(*) from Olist_Geolocation_Dataset_Cleaned;
select count(*) from product_category_name_translation_cleaned;

DESCRIBE olist_orders_dataset_cleaned;
ALTER TABLE olist_orders_dataset_cleaned 
RENAME COLUMN `ï»¿order_id` TO order_id;

DESCRIBE olist_order_items_dataset_cleaned;
ALTER TABLE olist_order_items_dataset_cleaned 
RENAME COLUMN `ï»¿order_id` TO order_id;

DESCRIBE olist_customers_dataset_cleaned;
alter table olist_customers_dataset_cleaned
rename column `ï»¿customer_id` to customer_id;

DESCRIBE olist_geolocation_dataset_cleaned;

DESCRIBE olist_order_payments_dataset_cleaned;
ALTER TABLE olist_order_payments_dataset_cleaned 
RENAME COLUMN `ï»¿order_id` TO order_id;

DESCRIBE olist_order_reviews_dataset_cleaned;
ALTER TABLE olist_order_reviews_dataset_cleaned 
RENAME COLUMN `ï»¿review_id` TO review_id;

DESCRIBE olist_products_dataset_cleaned;
ALTER TABLE olist_products_dataset_cleaned 
RENAME COLUMN `ï»¿product_id` TO product_id;

DESCRIBE olist_sellers_dataset_cleaned;
ALTER TABLE olist_sellers_dataset_cleaned 
RENAME COLUMN `ï»¿seller_id` TO seller_id;

DESCRIBE product_category_name_translation_cleaned;
ALTER TABLE product_category_name_translation_cleaned 
RENAME COLUMN `ï»¿product_category_name` TO product_category_name;


SELECT order_purchase_timestamp 
FROM olist_orders_dataset_cleaned 
LIMIT 5;

SELECT 
  CONCAT(
    CASE SUBSTRING(o.order_purchase_timestamp, 4, 2)
      WHEN '01' THEN 'January'
      WHEN '02' THEN 'February'
      WHEN '03' THEN 'March'
      WHEN '04' THEN 'April'
      WHEN '05' THEN 'May'
      WHEN '06' THEN 'June'
      WHEN '07' THEN 'July'
      WHEN '08' THEN 'August'
      WHEN '09' THEN 'September'
      WHEN '10' THEN 'October'
      WHEN '11' THEN 'November'
      WHEN '12' THEN 'December'
    END,
    ' - ',
    SUBSTRING(o.order_purchase_timestamp, 7, 4)
  ) AS month,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders_dataset_cleaned o
JOIN olist_order_items_dataset_cleaned oi 
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month,
  CONCAT(SUBSTRING(o.order_purchase_timestamp, 7, 4), '-', SUBSTRING(o.order_purchase_timestamp, 4, 2))
ORDER BY 
  CONCAT(SUBSTRING(o.order_purchase_timestamp, 7, 4), '-', SUBSTRING(o.order_purchase_timestamp, 4, 2));