/* For every project with more than 2 employees, find the project number,
the name of the project and the number of employees */
SELECT PNUMBER, PNAME, COUNT(*)
FROM PROJECT, WORKS_ON
WHERE PNUMBER=PNO
GROUP BY PNUMBER, PNAME
HAVING COUNT(*) > 2

/* Show the list of employees, together with the project they are working on, 
ordered by the department of the employee, and then by the last name */
SELECT DNAME, LNAME, FNAME, PNAME
FROM DEPARTMENT, EMPLOYEE, WORKS_ON, PROJECT
WHERE DNUMBER=DNO AND SSN=ESSN AND PNO=PNUMBER
ORDER BY DNAME, LNAME

/* Create a temporary table that will contain the department names, the
total number of employees and the total salary per department */
CREATE TABLE DEPTS_INFO
(
DEPT_NAME VARCHAR(10),
NO_OF_EMPS INTEGER,
TOTAL_SAL INTEGER
)

INSERT INTO DEPTS_INFO (DEPT_NAME, NO_OF_EMPS, TOTAL_SAL)
SELECT DNAME, COUNT(*), SUM(SALARY)
FROM DEPARTMENT, EMPLOYEE
WHERE DNUMBER=DNO
GROUP BY DNAME

/* Delete all employees that work in the Research department */
DELETE FROM EMPLOYEE
WHERE DNO IN 
	(SELECT DNUMBER
		FROM DEPARTMENT
		WHERE DNAME='Research')

/* Change the location and the management department of the project
with number 10 to 'Bellair' and 5 */
UPDATE PROJECT
SET  PLOCATION='Bellaire', DNUM=5
WHERE PNUMBER=10

/* Give a salary raise to all employees in the Research department */
UPDATE EMPLOYEE
SET SALARY = SALARY * 1.1
WHERE DNO IN (SELECT DNUMBER
	FROM DEPARTMENT
	WHERE DNAME='Research')

/* The employees of one department cannot be paid more than the boss.
If the result of the query inside NOT EXISTS is empty set then the constraint
is valid */
CREATE ASSERTION SALARY_CONSTRAINT
CHECK (NOT EXISTS(SELECT * 
					FROM EMPLOYEE E, EMPLOYEE M, DEPARTMENT D
					WHERE E.SALARY > M.SALARY AND
					E.DNO = D.NUMBER AND D.MGRSSN = M.SSN))

/* Write an activator that will compare the salary of the employee
with the salary of his/her boss when the operations INSERT and UPDATE are used */
CREATE TRIGGER INFORM_SUPERVISOR
BEFORE INSERT OR UPDATE OF SALARY, SUPERVISOR_SSN ON EMPLOYEE
FOR EACH ROW
WHEN 
(
NEW.SALARY > (SELECT SALARY
				FROM EMPLOYEE
				WHERE SSN=NEW.SUPERVISOR_SSN)
)
INFORM_SUPERVISOR (NEW.SUPERVISOR_SSN, NEW.SSN)

/* Specify new table WORKS_ON_NEW in which you will store the names of the
participants in the project, as well as the project name and the hours dedicated on it */
CREATE VIEW WORKS_ON_NEW AS
SELECT FNAME, LNAME, PNAME, HOURS 
FROM EMPLOYEE, PROJECT, WORKS_ON
WHERE SSN=ESSN AND PNO=PNUMBER