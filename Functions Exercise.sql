-- Exercise 2: functions
 
-- 1) Find out how many managers there are without listing them. 
 
 SELECT COUNT(DISTINCT MGR) 'Number of Managers'
 FROM EMP;

-- 2) Compute the average annual salary + commission for all salesman

SELECT AVG(SAL+COMM)*12
FROM EMP;

-- 3) Find the highest and lowest paid employees and the difference between them

SELECT MAX(SAL) 'Highest Paid', MIN(SAL) 'Lowest Paid', MAX(SAL)-MIN(SAL) 'Difference'
FROM EMP;

-- 4) Find the number of characters in the longest department name

 SELECT MAX(LENGTH(DNAME)) 'Number of Characters'
 FROM DEPT;

-- 5) Count the number of people in department 30 who receive a salary and the number of people who receive a commission

SELECT COUNT(SAL) 'Number of Salaries', COUNT(COMM) 'Number of Commissions'
FROM EMP
WHERE DEPTNO = 30;

-- 6) List the average commission of employees who receive a commission and the average commission of all employees (treating employees who do not receive a commission as receiving a zero commission)

SELECT AVG(COMM) 'Average Commission', AVG(COALESCE(COMM, 0)) 'Average Commission of All Employees'
FROM EMP;

/* 7) List the average salary of employees that receive a salary, the average commission of employees that receive a commission, 
the average salary plus commission of only those employees that receive a commission 
and average salary plus commission of all employees including those who do not receive a commission */

SELECT AVG(SAL) 'Average Salary', AVG(COMM) 'Average Commission', AVG(SAL+COMM) 'Average Total Compensation', AVG(SAL + COALESCE(COMM, 0)) 'Average Total Compensation of all Employees'
FROM EMP;

-- 8) Compute the daily and hourly salaries for emplyees in department 30. Round the results to the nearest penny. Assume there are 22 working days in a month and 8 working hours in a day.
 
SELECT ENAME, ROUND(SAL/22, 2) 'Daily Salary', ROUND(SAL/(22*8), 2) 'Hourly Salary'
FROM EMP
WHERE DEPTNO=30;
 
-- 9) Issue the same query as the previous one except that this time truncate (trunc) to the nearest penny rather than round.
SELECT ENAME, TRUNCATE(SAL/22, 2) 'Daily Salary', TRUNCATE(SAL/(22*8), 2) 'Hourly Salary'
FROM EMP
WHERE DEPTNO=30;