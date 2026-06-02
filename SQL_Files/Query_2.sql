use olist_db;
SELECT 
  t.product_category_name_english AS category,
  ROUND(SUM(oi.price), 2) AS revenue,
  COUNT(DISTINCT oi.order_id) AS total_orders
FROM olist_order_items_dataset_cleaned oi
JOIN olist_products_dataset_cleaned p 
  ON oi.product_id = p.product_id
JOIN product_category_name_translation_cleaned t 
  ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;