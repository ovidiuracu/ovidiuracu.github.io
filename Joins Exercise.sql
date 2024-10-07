-- Exercise 5: joins
 
-- 1) Find the name and salary of employees in dallas
 
SELECT ENAME, SAL
FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
WHERE LOC = 'DALLAS';
 
-- 2) Join the dept table to the emp table and show in department number order
 
SELECT *
FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO
ORDER BY EMP.DEPTNO;
 
-- 3) List all departments that have employees plus those departments that do not have employees
 
SELECT DNAME, COUNT(ENAME) 'Number of Employees'
FROM EMP RIGHT JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO
GROUP BY DNAME; 
 
-- 4) List all departments that do not have any employees
 
SELECT DNAME, COUNT(ENAME) 'Number of Employees'
FROM EMP RIGHT JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO
GROUP BY DNAME
HAVING COUNT(ENAME) = 0;
 
-- 5) Find all the employees that earn more than jones using temporary labels to abreviate table names
 
SELECT ENAME, SAL
FROM EMP
WHERE SAL > (SELECT SAL FROM EMP WHERE ENAME = 'JONES');
 
-- 6) For each employee whose salary exceeds his manager's salary list the employee's name and a salary and the manager's name and salary
 
SELECT A.ENAME, A.SAL, B.ENAME, B.SAL
FROM EMP A, EMP B
WHERE A.SAL > B.SAL AND B.EMPNO = A.MGR;