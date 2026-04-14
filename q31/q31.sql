-- Table: Employee

-- +---------------+---------+
-- | Column Name   |  Type   |
-- +---------------+---------+
-- | employee_id   | int     |
-- | department_id | int     |
-- | primary_flag  | varchar |
-- +---------------+---------+
-- (employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
-- employee_id is the id of the employee.
-- department_id is the id of the department to which the employee belongs.
-- primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department is the primary department for the employee. If the flag is 'N', the department is not the primary.
 

-- Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

-- Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.

-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Employee table:
-- +-------------+---------------+--------------+
-- | employee_id | department_id | primary_flag |
-- +-------------+---------------+--------------+
-- | 1           | 1             | N            |
-- | 2           | 1             | Y            |
-- | 2           | 2             | N            |
-- | 3           | 3             | N            |
-- | 4           | 2             | N            |
-- | 4           | 3             | Y            |
-- | 4           | 4             | N            |
-- +-------------+---------------+--------------+
-- Output: 
-- +-------------+---------------+
-- | employee_id | department_id |
-- +-------------+---------------+
-- | 1           | 1             |
-- | 2           | 1             |
-- | 3           | 3             |
-- | 4           | 3             |
-- +-------------+---------------+
-- Explanation: 
-- - The Primary department for employee 1 is 1.
-- - The Primary department for employee 2 is 1.
-- - The Primary department for employee 3 is 3.
-- - The Primary department for employee 4 is 3.

-- draft solution
SELECT 
    employee_id,
    CASE
        WHEN COUNT(department_id) > 1
        THEN 
            CASE WHEN primary_flag = 'Y'
            THEN department_id
            ELSE department_id
        ELSE department_id
    END AS department_id
FROM Employee
GROUP BY employee_id

-- correct solution
SELECT 
    employee_id,
    department_id
FROM Employee
WHERE primary_flag = 'Y'

UNION

SELECT 
    employee_id,
    department_id
FROM Employee e1
WHERE employee_id IN (
    SELECT employee_id
    FROM Employee
    GROUP BY employee_id
    HAVING COUNT(*) = 1
)

-- alternative solution
WITH Ranked AS (
    SELECT 
        employee_id,
        department_id,
        primary_flag,
        ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY CASE WHEN primary_flag = 'Y' THEN 0 ELSE 1 END) AS rn
    FROM Employee
)
SELECT 
    employee_id,
    department_id
FROM Ranked
WHERE rn = 1;


-- notes:
-- use UNION to rejoin the table by itself with 2 separate filters, table 1 gets the one with just the Y flag
-- table 2 filters using the having count(1) = 1
-- alternative solution is using window function ROW() then applying an order by prioritization,
-- Sort by priority via CASE WHEN since order by works as such on integers (0 < 1, hence comes first)