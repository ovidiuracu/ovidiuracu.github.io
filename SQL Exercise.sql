-- Exercise 1 SQL

-- 1 List all employees whose salary is between 1,000 and 2,000. Show employee name, department and salary

SELECT ENAME AS 'Employee Name', DNAME AS 'Department', SAL AS 'Salary'
FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
WHERE SAL BETWEEN 1000 AND 2000;
 
-- 2 Display all the different types of occupations
 
 SELECT DISTINCT(JOB)
 FROM EMP;

-- 3 List details of employees in departments 10 and 30

SELECT *
FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
WHERE EMP.DEPTNO = 10 OR EMP.DEPTNO = 30;
 
-- 4 Display all employees who recruited during 1982, giving their name, department and hiredate.

SELECT ENAME 'Employee Name', DNAME 'Department', HIREDATE 'Hire Date'
FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
WHERE HIREDATE LIKE '%1982%';

-- 5 List the employees whose names have 'th' or 'll' in them

SELECT ENAME 'Employee Name'
FROM EMP
WHERE ENAME LIKE '%th%' OR ENAME LIKE '%ll%';
 
-- 6 List the department numbers and names in department name order
 
SELECT DEPTNO, DNAME
FROM DEPT
ORDER BY DNAME;

-- 7 Find the names, jobs, salaries and commissions of all employees who do not have managers
 
SELECT ENAME, JOB, SAL, COMM
FROM EMP
WHERE MGR IS NULL;

-- 8 List all salesmen in descending order of their commission divided by their salary

SELECT ENAME, COMM/SAL 'Commission to Salary Ratio'
FROM EMP
WHERE COMM IS NOT NULL
ORDER BY COMM/SAL DESC;
 
-- 9 Calculate the total annual compensation of all salesmen based upon their monthly salary and monthly commission ((sal+comm)*12)

SELECT ENAME, CASE 
	WHEN COMM IS NULL THEN SAL*12 
	WHEN COMM IS NOT NULL THEN (SAL+COMM)*12
END 'Total Annual Compensation'
FROM EMP;

-- 10 Find all the salesmen in department 30 who have a salary greater than or equal to $1,500

SELECT ENAME
FROM EMP
WHERE DEPTNO = 30 AND SAL >= 1500;