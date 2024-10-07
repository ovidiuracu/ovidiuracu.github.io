-- Exercise 5: group by
 
-- 1) List the department number and average salary of each department
 
SELECT DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO;
 
-- 2) Divide all employees into groups by department and by job within department. Count the employees in each group and compute each groups average annual salary
 
SELECT DEPTNO, JOB, COUNT(ENAME), AVG(SAL*12)
FROM EMP
GROUP BY DEPTNO, JOB;
 
-- 3) Issue the same query as above except list the department name rather than the department number
 
SELECT DNAME, JOB, COUNT(ENAME), AVG(SAL*12)
FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO
GROUP BY DNAME, JOB; 
 
-- 4) List the average annual salary for all job groups having more than 2 employees in the group
 
SELECT JOB, COUNT(ENAME), AVG(SAL*12)
FROM EMP
GROUP BY JOB
HAVING COUNT(ENAME) > 2; 
 
-- 5) List all the departments that have at least two clerks
 
SELECT DNAME, JOB, COUNT(ENAME)
FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO
GROUP BY DNAME, JOB
HAVING COUNT(ENAME) >= 2 AND JOB = 'CLERK';  
 
-- 6) Find all departments with an average commission greater than 25% of average salary
 
SELECT DNAME, AVG(COMM)
FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO
GROUP BY DNAME
HAVING AVG(COMM) > 0.25*(SELECT AVG(SAL) FROM EMP); 
 
-- 7) Find each departments average annual salary for all its employees except the manager's and the president's
 
SELECT DNAME, AVG(SAL*12)
FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO
WHERE JOB != 'MANAGER' AND JOB != 'PRESIDENT'
GROUP BY DNAME;
 
-- 8) List the average annual salary for all job groups having more than two employees in a group

SELECT JOB, COUNT(ENAME), AVG(SAL*12)
FROM EMP
GROUP BY JOB
HAVING COUNT(ENAME) > 2;