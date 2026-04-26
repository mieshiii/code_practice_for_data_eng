-- Table: Products

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key (combination of columns with unique values) of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.
-- Initially, all products have price 10.

-- Write a solution to find the prices of all products on the date 2019-08-16.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+
-- Output: 
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+

-- draft solution
SELECT 
    product_id,
    new_price as price
FROM
Products
GROUP BY product_id
HAVING change_date =  '2019-08-16'

-- correct solution
SELECT 
    p1.product_id,
    COALESCE(
        (SELECT TOP 1 p2.new_price 
         FROM Products p2 
         WHERE p2.product_id = p1.product_id 
         AND p2.change_date <= '2019-08-16'
         ORDER BY p2.change_date DESC), 
        10
    ) AS price
FROM (SELECT DISTINCT product_id FROM Products) p1


-- correct using CTE
WITH RankedPrices AS (
    SELECT 
        product_id,
        new_price,
        change_date,
        ROW_NUMBER() OVER (
            PARTITION BY product_id 
            ORDER BY change_date DESC
        ) as rn
    FROM Products 
    WHERE change_date <= '2019-08-16'
)
SELECT 
    p.product_id,
    COALESCE(rp.new_price, 10) AS price
FROM (SELECT DISTINCT product_id FROM Products) p
LEFT JOIN RankedPrices rp ON p.product_id = rp.product_id AND rp.rn = 1

-- notes:
-- one forgot to add the fallback value of 10 (using COALESCE(value, 10))
-- a join is required to get, first the total list of products,
-- second, joined to ranked prices based off of change_date ranked