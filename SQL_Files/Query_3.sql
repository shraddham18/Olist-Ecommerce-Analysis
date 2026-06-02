use olist_db;
SELECT 
  c.customer_state,
  ROUND(AVG(o.Delivery_Days), 1) AS avg_delivery_days,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders_dataset_cleaned o
JOIN olist_customers_dataset_cleaned c 
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.Delivery_Days IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;