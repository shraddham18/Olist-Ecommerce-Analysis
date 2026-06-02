DESCRIBE olist_orders_dataset_cleaned;
SELECT 
  CASE 
    WHEN CONCAT(SUBSTRING(o.order_delivered_customer_date, 7, 4), SUBSTRING(o.order_delivered_customer_date, 4, 2), SUBSTRING(o.order_delivered_customer_date, 1, 2)) 
       <= CONCAT(SUBSTRING(o.order_estimated_delivery_date, 7, 4), SUBSTRING(o.order_estimated_delivery_date, 4, 2), SUBSTRING(o.order_estimated_delivery_date, 1, 2))
    THEN 'On Time'
    ELSE 'Late'
  END AS delivery_status,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders_dataset_cleaned o
JOIN olist_order_reviews_dataset_cleaned r 
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status;