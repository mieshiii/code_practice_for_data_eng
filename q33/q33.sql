-- Table: Logs

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | num         | varchar |
-- +-------------+---------+
-- In SQL, id is the primary key for this table.
-- id is an autoincrement column starting from 1.
 

-- Find all numbers that appear at least three times consecutively.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Logs table:
-- +----+-----+
-- | id | num |
-- +----+-----+
-- | 1  | 1   |
-- | 2  | 1   |
-- | 3  | 1   |
-- | 4  | 2   |
-- | 5  | 1   |
-- | 6  | 2   |
-- | 7  | 2   |
-- +----+-----+
-- Output: 
-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+
-- Explanation: 1 is the only number that appears consecutively for at least three times.

-- my draft solution
WITH row_numbers AS
    SELECT
        id,
        num,
        ROW_NUMBER() OVER (
        PARTITION BY num
        ORDER BY id ASC
    ) AS row_num
    FROM Logs

SELECT 
    num AS ConsecutiveNums
FROM 
Logs
GROUP BY num
HAVING COUNT(row_num) >= 3

-- correct solution using lag or lead
SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT 
        num,
        LAG(num, 1) OVER (ORDER BY id) AS prev_num,
        LAG(num, 2) OVER (ORDER BY id) AS prev_prev_num
    FROM Logs
) t
WHERE num = prev_num AND num = prev_prev_num;

-- notes:
-- my solution has an issue is that ROW_NUMBER() assigns sequential numbers within each partition, 
-- but this doesn't help identify consecutive occurrences in the original sequence

-- correct solution uses lag/lead to check the prev 2 or next 2 then check the 3 columns
-- being the original, next/prev 1, next/prev 2 if they are all equal