-- Exercise 3: dates
 
-- 1) Select the name, job and hiredate of the employees in dept 20 (format the hiredate column using a picture of mm/dd/yy)
 
SELECT ENAME, JOB, DATE_FORMAT(HIREDATE, "%m/%d/%y") 'Hire Date'
FROM EMP;

-- 2) Use a picture to format hiredate as: day (day of the week), month (name of the month), dd (day of the month) and yyyy (year). e.g. wednesday, january, 12, 1983
 
SELECT ENAME, JOB, DATE_FORMAT(HIREDATE, "%W, %M, %d, %Y") 'Hire Date'
FROM EMP;

-- 3) Use the format mask suffix 'th' in a picture (oracle will put a suffix after the field (ddth).)
 
SELECT ENAME, JOB, DATE_FORMAT(HIREDATE, "%W, %M, %dth, %Y") 'Hire Date'
FROM EMP;

/* 4) Select the name and hiredate of department 20's employees in the following format:
ename, hiredate
adams, january 12th, 1983, 11:05 am */
 
SELECT ENAME, DATE_FORMAT(HIREDATE, "%W, %M, %dth, %Y, %h:%i %p") 'Hire Date'
FROM EMP
WHERE DEPTNO=20;