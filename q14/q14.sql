-- Table: Signups

-- +----------------+----------+
-- | Column Name    | Type     |
-- +----------------+----------+
-- | user_id        | int      |
-- | time_stamp     | datetime |
-- +----------------+----------+
-- user_id is the column of unique values for this table.
-- Each row contains information about the signup time for the user with ID user_id.
 

-- Table: Confirmations

-- +----------------+----------+
-- | Column Name    | Type     |
-- +----------------+----------+
-- | user_id        | int      |
-- | time_stamp     | datetime |
-- | action         | ENUM     |
-- +----------------+----------+
-- (user_id, time_stamp) is the primary key (combination of columns with unique values) for this table.
-- user_id is a foreign key (reference column) to the Signups table.
-- action is an ENUM (category) of the type ('confirmed', 'timeout')
-- Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').
 

-- The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

-- Write a solution to find the confirmation rate of each user.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Signups table:
-- +---------+---------------------+
-- | user_id | time_stamp          |
-- +---------+---------------------+
-- | 3       | 2020-03-21 10:16:13 |
-- | 7       | 2020-01-04 13:57:59 |
-- | 2       | 2020-07-29 23:09:44 |
-- | 6       | 2020-12-09 10:39:37 |
-- +---------+---------------------+
-- Confirmations table:
-- +---------+---------------------+-----------+
-- | user_id | time_stamp          | action    |
-- +---------+---------------------+-----------+
-- | 3       | 2021-01-06 03:30:46 | timeout   |
-- | 3       | 2021-07-14 14:00:00 | timeout   |
-- | 7       | 2021-06-12 11:57:29 | confirmed |
-- | 7       | 2021-06-13 12:58:28 | confirmed |
-- | 7       | 2021-06-14 13:59:27 | confirmed |
-- | 2       | 2021-01-22 00:00:00 | confirmed |
-- | 2       | 2021-02-28 23:59:59 | timeout   |
-- +---------+---------------------+-----------+
-- Output: 
-- +---------+-------------------+
-- | user_id | confirmation_rate |
-- +---------+-------------------+
-- | 6       | 0.00              |
-- | 3       | 0.00              |
-- | 7       | 1.00              |
-- | 2       | 0.50              |
-- +---------+-------------------+
-- Explanation: 
-- User 6 did not request any confirmation messages. The confirmation rate is 0.
-- User 3 made 2 requests and both timed out. The confirmation rate is 0.
-- User 7 made 3 requests and all were confirmed. The confirmation rate is 1.
-- User 2 made 2 requests where one was confirmed and the other timed out. The confirmation rate is 1 / 2 = 0.5.

-- draft solution
-- logic: no need to use the Signups, all of the information is on the Confirmation table
-- use CTE to get the confirmations count then get the total using user_id on the same table
WITH confirmed_count as
SELECT 
    user_id,
    COUNT(user_id) as confirmed_count     
FROM
Confirmations
WHERE 
action = confirmed
GROUP BY user_id

SELECT
    user_id,
    ROUND((confirmed_count/COUNT(user_id)), 2)
FROM
Confirmations a
INNER JOIN 
confirmed_count B
ON a.userid = b.user_id
GROUP BY user_id


-- correct solution
SELECT 
    s.user_id,
    ROUND(
        COALESCE(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END), 0) / 
        COALESCE(COUNT(c.user_id), 1), 
        2
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id;

-- notes:
-- question: "why is the signups table included? when all of the information is technically on the confirmations table"
-- Signups table: Contains ALL users (even those who never requested confirmations)
-- Confirmations table: Contains only users who made confirmation requests

-- Start with ALL users from Signups
-- LEFT JOIN with Confirmations to get their request history
-- Calculate confirmation rate for each user (including those with 0 requests)
-- Users with 0 requests should have confirmation rate = 0.00

-- a more elegant solution from leetcode:
SELECT 
    s.user_id,
    ROUND(COALESCE(AVG(CASE WHEN c.action = 'confirmed' THEN 1.0 ELSE 0.0 END), 0.0), 2) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id;

-- CASE WHEN c.action = 'confirmed' THEN 1.0 ELSE 0.0 END
-- This converts each confirmation to 1.0 (confirmed) or 0.0 (not confirmed)
-- Using 1.0 and 0.0 ensures we get decimal results

-- AVG()
-- Calculates the average of these 1s and 0s
-- Since average = (sum of 1s) / (total count), this gives us the confirmation rate directly
-- For example: 3 confirmed out of 5 requests = (3/5) = 0.6

-- LEFT JOIN
-- Includes all users from Signups
-- Users with no confirmations will have NULL values, which AVG ignores