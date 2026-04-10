-- Table: Customer

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | customer_id | int     |
-- | product_key | int     |
-- +-------------+---------+
-- This table may contain duplicates rows. 
-- customer_id is not NULL.
-- product_key is a foreign key (reference column) to Product table.
 

-- Table: Product

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_key | int     |
-- +-------------+---------+
-- product_key is the primary key (column with unique values) for this table.
 

-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Customer table:
-- +-------------+-------------+
-- | customer_id | product_key |
-- +-------------+-------------+
-- | 1           | 5           |
-- | 2           | 6           |
-- | 3           | 5           |
-- | 3           | 6           |
-- | 1           | 6           |
-- +-------------+-------------+
-- Product table:
-- +-------------+
-- | product_key |
-- +-------------+
-- | 5           |
-- | 6           |
-- +-------------+
-- Output: 
-- +-------------+
-- | customer_id |
-- +-------------+
-- | 1           |
-- | 3           |
-- +-------------+
-- Explanation: 
-- The customers who bought all the products (5 and 6) are customers with IDs 1 and 3.

-- draft solution
SELECT
    customer_id
FROM
Customer c
LEFT JOIN 
Product p
ON
c.product_key = p.product_key
WHERE COUNT(DISTINCT c.product_key) = COUNT(p.product_key)
GROUP BY c.customer_id

-- corrected solution
SELECT
    customer_id
FROM
    Customer c
GROUP BY 
    customer_id
HAVING 
    COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)

-- possible solution with CTE
WITH product_count AS 
(
    SELECT 
        customer_id,
        COUNT(DISTINCT product_key) as products_bought
    FROM Customer
    GROUP BY customer_id
)

SELECT
    customer_id
FROM product_count
WHERE product_bought = (SELECT COUNT(1) FROM  Products)

--notes
-- the idea was almost correct, but join isn't the right way to get the total count 
-- by using having, the key point is to use a subquery to get the total distinct products
-- by using a CTE, it's almost the same just that the count of products bought per user is in the CTE not on the filter clause