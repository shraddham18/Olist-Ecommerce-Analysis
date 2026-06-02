SELECT 
  c.customer_id,
  c.customer_state,
  COUNT(DISTINCT o.order_id) AS frequency,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS monetary,
  MAX(o.Delivery_Days) AS recency_proxy
FROM olist_customers_dataset_cleaned c
JOIN olist_orders_dataset_cleaned o 
  ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset_cleaned oi 
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_id, c.customer_state
ORDER BY monetary DESC
LIMIT 20;
SELECT 
  customer_id,
  customer_state,
  frequency,
  monetary,
  CASE 
    WHEN frequency >= 3 AND monetary >= 5000 THEN 'Champion'
    WHEN frequency >= 2 AND monetary >= 2000 THEN 'Loyal'
    WHEN frequency = 1 AND monetary >= 3000 THEN 'High Value One Timer'
    WHEN frequency = 1 AND monetary < 3000 THEN 'Regular One Timer'
    ELSE 'Low Value'
  END AS customer_segment
FROM (
  SELECT 
    c.customer_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS monetary
  FROM olist_customers_dataset_cleaned c
  JOIN olist_orders_dataset_cleaned o 
    ON c.customer_id = o.customer_id
  JOIN olist_order_items_dataset_cleaned oi 
    ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_id, c.customer_state
) AS customer_data
ORDER BY monetary DESC;
SELECT 
  customer_segment,
  COUNT(*) AS total_customers,
  ROUND(AVG(monetary), 2) AS avg_revenue
FROM (
  SELECT 
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS monetary,
    CASE 
      WHEN COUNT(DISTINCT o.order_id) >= 3 AND ROUND(SUM(oi.price + oi.freight_value), 2) >= 5000 THEN 'Champion'
      WHEN COUNT(DISTINCT o.order_id) >= 2 AND ROUND(SUM(oi.price + oi.freight_value), 2) >= 2000 THEN 'Loyal'
      WHEN COUNT(DISTINCT o.order_id) = 1 AND ROUND(SUM(oi.price + oi.freight_value), 2) >= 3000 THEN 'High Value One Timer'
      WHEN COUNT(DISTINCT o.order_id) = 1 AND ROUND(SUM(oi.price + oi.freight_value), 2) < 3000 THEN 'Regular One Timer'
      ELSE 'Low Value'
    END AS customer_segment
  FROM olist_customers_dataset_cleaned c
  JOIN olist_orders_dataset_cleaned o ON c.customer_id = o.customer_id
  JOIN olist_order_items_dataset_cleaned oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_id
) AS rfm
GROUP BY customer_segment
ORDER BY total_customers DESC;