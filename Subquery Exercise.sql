-- Exercise 6: Subqueries
 
-- 1) List the name and job of employees who have the same job as jones
 
 SELECT ENAME, JOB
 FROM EMP
 WHERE JOB = (SELECT JOB FROM EMP WHERE ENAME = 'JONES') AND ENAME != 'JONES';
 
-- 2) Find all the employees in department 10 who have a job that is the same as anyone in department 30
 
 SELECT ENAME, JOB
 FROM EMP
 WHERE DEPTNO=10 AND JOB IN (SELECT JOB FROM EMP WHERE DEPTNO = 30); 
 
-- 3) List the name, job title and salary of employees who have the same job and salary as ford
 
 SELECT ENAME, JOB, SAL
 FROM EMP
 WHERE JOB = (SELECT JOB FROM EMP WHERE ENAME = 'FORD') AND SAL = (SELECT SAL FROM EMP WHERE ENAME = 'FORD');
 
-- 4) List the name, job and department of employees who have the same job as jones or a salary greater than or equal to ford
 
 SELECT ENAME, JOB, DNAME
 FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
 WHERE JOB = (SELECT JOB FROM EMP WHERE ENAME = 'JONES') OR SAL >= (SELECT SAL FROM EMP WHERE ENAME = 'FORD');
 
-- 5) Find all the employees in department 10 that have a job that is the same as anyone in the sales department
 
SELECT ENAME, JOB, DNAME
FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO
WHERE EMP.DEPTNO = 10 AND JOB IN (SELECT JOB FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO WHERE DNAME = 'SALES'); 
 
-- 6) Find the employees located in chicago who have the same job as allen. return the results in alphabetical order by employee name
 
SELECT ENAME, JOB, LOC
FROM EMP JOIN DEPT ON EMP.DEPTNO = DEPT.DEPTNO 
WHERE LOC = 'CHICAGO' AND JOB = (SELECT JOB FROM EMP WHERE ENAME = 'ALLEN') AND ENAME != 'ALLEN'
ORDER BY ENAME;
 
-- 7) Find all employees that earn more than the average salary of employees in their department

SELECT ENAME
FROM EMP e
WHERE SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO = e.DEPTNO);