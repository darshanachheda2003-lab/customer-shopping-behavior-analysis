SELECT gender, SUM(purchase_amount) AS revenue
FROM customer_shopping
GROUP BY gender;

SELECT customer_id, purchase_amount 
FROM customer_shopping 
WHERE discount_applied = 'Yes' AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer_shopping);

SELECT item_purchased, ROUND(avg(review_rating),2) AS "Average Product Rating"
FROM customer_shopping
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

SELECT shipping_type, ROUND(AVG(purchase_amount),2)
FROM customer_shopping
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type;

SELECT subscription_status,
COUNT(customer_id) AS total_customers,
ROUND(AVG(purchase_amount),2) AS avg_spend,
ROUND(SUM(purchase_amount),2) AS total_revenue
FROM customer_shopping
GROUP BY subscription_status
ORDER BY total_revenue,avg_spend DESC;

SELECT item_purchased,
ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS discount_rate
FROM customer_shopping
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

with customer_type as (
SELECT customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM customer_shopping)
select customer_segment,count(*) AS "Number of Customers" 
from customer_type 
group by customer_segment;

WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer_shopping
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;

SELECT subscription_status,
    COUNT(*) AS repeat_buyers
FROM customer_shopping
WHERE previous_purchases > 5
GROUP BY subscription_status
ORDER BY repeat_buyers DESC;

SELECT age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping
GROUP BY age_group
ORDER BY total_revenue desc;