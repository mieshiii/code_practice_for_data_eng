-- Table: Sales

-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | sale_id     | int   |
-- | product_id  | int   |
-- | year        | int   |
-- | quantity    | int   |
-- | price       | int   |
-- +-------------+-------+
-- (sale_id, year) is the primary key (combination of columns with unique values) of this table.
-- Each row records a sale of a product in a given year.
-- A product may have multiple sales entries in the same year.
-- Note that the per-unit price.

-- Write a solution to find all sales that occurred in the first year each product was sold.

-- For each product_id, identify the earliest year it appears in the Sales table.

-- Return all sales entries for that product in that year.

-- Return a table with the following columns: product_id, first_year, quantity, and price.
-- Return the result in any order.

 

-- Example 1:

-- Input: 
-- Sales table:
-- +---------+------------+------+----------+-------+
-- | sale_id | product_id | year | quantity | price |
-- +---------+------------+------+----------+-------+ 
-- | 1       | 100        | 2008 | 10       | 5000  |
-- | 2       | 100        | 2009 | 12       | 5000  |
-- | 7       | 200        | 2011 | 15       | 9000  |
-- +---------+------------+------+----------+-------+

-- Output: 
-- +------------+------------+----------+-------+
-- | product_id | first_year | quantity | price |
-- +------------+------------+----------+-------+ 
-- | 100        | 2008       | 10       | 5000  |
-- | 200        | 2011       | 15       | 9000  |
-- +------------+------------+----------+-------+

-- draft solution
SELECT
    product_id,
    MIN(year) AS first_year,
    quantity,
    price
FROM
    Sales
GROUP BY product_id

-- corrected solution
SELECT
    s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM
    Sales s
JOIN (
    SELECT
        product_id,
        MIN(year) AS first_year
    FROM
        Sales
    GROUP BY product_id
) first_sales ON s.product_id = first_sales.product_id
              AND s.year = first_sales.first_year;

-- optimized solution
SELECT 
    product_id,
    year AS first_year,
    quantity,
    price
FROM (
    SELECT 
        product_id,
        year,
        quantity,
        price,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY year) as rn
    FROM Sales
) ranked
WHERE rn = 1;


-- notes:
-- draft solution has the logic in the right path but 
-- it does not ensure that quantity and price correspond to that first year,
-- because quantity and price are not part of the GROUP BY, 
-- and SQL will pick arbitrary values from the group

-- for the optimized solution, it is better as you don't need to further join as it already is ranked via row number