--1. Общая прибыль со всех продаж по дням

SELECT
    DATE(transaction_datetime) AS sale_date,
    SUM(quantity * unit_price) AS total_profit
FROM sales
GROUP BY DATE(transaction_datetime)
ORDER BY sale_date;
-- иное решение
SELECT
    transaction_id,
    transaction_datetime,
    product_id,
    quantity,
    unit_price,
    DATE(transaction_datetime) AS sale_date,
    SUM(quantity * unit_price) OVER (PARTITION BY DATE(transaction_datetime)) AS daily_profit
FROM sales
ORDER BY sale_date;


--2.
SELECT
    product_id,
    SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY product_id
ORDER BY total_quantity_sold DESC
LIMIT 5;
-- иное решение
SELECT *
FROM (
    SELECT
        product_id,
        SUM(quantity) AS total_quantity_sold,
        RANK() OVER (ORDER BY SUM(quantity) DESC) AS rank
    FROM sales
    GROUP BY product_id
) ranked
WHERE rank <= 5;


--3.
SELECT
    product_id,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;
-- иное решение
SELECT *
FROM (
    SELECT
        product_id,
        SUM(quantity * unit_price) AS total_profit,
        DENSE_RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS rank
    FROM sales
    GROUP BY product_id
) ranked
WHERE rank <= 5;

