SELECT toDate(transaction_datetime) AS day,
       sum(quantity * unit_price) AS total_profit
FROM sales_db.sales
GROUP BY day
ORDER BY day;
--------------------------------------------
SELECT product_id,
       sum(quantity) AS total_quantity
FROM sales_db.sales
GROUP BY product_id
ORDER BY total_quantity DESC
LIMIT 5;
--------------------------------------------
SELECT product_id,
       sum(quantity * unit_price) AS total_profit
FROM sales_db.sales
GROUP BY product_id
ORDER BY total_profit DESC
LIMIT 5;

