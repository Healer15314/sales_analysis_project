
CREATE DATABASE IF NOT EXISTS product_sales CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE product_sales;


CREATE TABLE IF NOT EXISTS sales (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_datetime DATETIME NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

DELIMITER $$

DROP PROCEDURE IF EXISTS generate_sales_data $$

CREATE PROCEDURE generate_sales_data()
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < 1000 DO
        INSERT INTO sales (
            transaction_datetime,
            product_id,
            quantity,
            unit_price
        )
        VALUES (
            NOW() - INTERVAL FLOOR(RAND() * 30) DAY + INTERVAL FLOOR(RAND() * 24) HOUR,
            FLOOR(1 + RAND() * 20), 
            FLOOR(1 + RAND() * 10),
            ROUND(50 + RAND() * 450, 2) 
        );
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;


CALL generate_sales_data();
