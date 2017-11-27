/* Return the names and the addresses of all employees that work in 
the department 'Research' */
SELECT FNAME, LNAME, ADDRESS
FROM EMPLOYEE 
WHERE DEPARTMENT_NUMBER IN (SELECT DNUMBER 
							FROM DEPARTMENT 
							WHERE DNAME = 'Research')

/* Return the full name of every employee, with the full name of his/her boss */
/* In the following question E and S are aliases */
/* Solution 1 */
SELECT E.FNAME, E.LNAME, S.FNAME, S.LNAME
FROM EMPLOYEE E S 
WHERE E.SUPERSSN = S.SSN 
/* Solution 2 */
SELECT E.FNAME, E.LNAME, S.FNAME, S.LNAME
FROM (EMPLOYEE E LEFT OUTER JOIN EMPLOYEE S
	ON E.SUPERSSN = S.SSN)


/* Return the names of all employees that have dependends with the same name
as the employee (interconnected nested question) */
/* Solution 1 */
SELECT E.FNAME, E.LNAME
FROM EMPLOYEE AS E 
WHERE E.SSN IN (SELECT ESSN
				FROM DEPENDENT
				WHERE ESSN = E.SSN AND 
					E.FNAME = DEPENDENT_NAME)
/* Solution 2 */
SELECT E.FNAME, E.LNAME
FROM EMPLOYEE E, DEPENDENT DEPENDENT
WHERE E.SSN = D.ESSN AND
	E.FNAME = D.DEPENDENT_NAME 
/* Solution 3 - with the use of EXISTS */
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE EXISTS (SELECT *
			FROM DEPENDENT
			WHERE SSN = ESSN AND
				FNAME = DEPENDENT_NAME)

/* Return the names of all employees that don't have dependends */
SELECT FNAME, LNAME
FROM EMPLOYEE 
WHERE NOT EXISTS (SELECT * 
				FROM DEPENDENT
				WHERE SSN = ESSN)

/* Return the names of all employees that don't have supervisors */
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SUPERSSN IS NULL

/* For every project located on 'Stafford', list the project number,
department number and the last name, address and date of birth of the manager */
/* Solution 1 */
SELECT PNUMBER, DNUMBER, LNAME, ADDRESS, BDATE
FROM PROJECT, DEPARTMENT, EMPLOYEE
WHERE DNUMBER=DNUM AND MGRSSN=SSN
	AND PLOCATION='Stafford'
/* Solution 2 */
SELECT PNUMBER, DNUMBER, LNAME, ADDRESS, BDATE
FROM ((PROJECT JOIN DEPARTMENT ON DNUM=DNUMBER)
	JOIN EMPLOYEE ON MGRSSN=SSN)
WHERE PLOCATION='Stafford'

/* Find the highest, lowest and the average salary */
SELECT MAX(SALARY),
		MIN(SALARY),
		AVG(SALARY)
FROM EMPLOYEE

/* Find the highest, lowest and the average salary of the employees
that work in the department 'Research'*/
SELECT MAX(SALARY), MIN(SALARY), AVG(SALARY)
FROM EMPLOYEE, DEPARTMENT
WHERE DNO=DNUMBER AND DNAME="Research"

/* Find the total number of employees in the 'Research' department*/
SELECT COUNT(*)
FROM EMPLOYEE, DEPARTMENT
WHERE DNO=DNUMBER AND DNAME='Research'

/* Find the number of distinct salaries */
SELECT COUNT(DISTINCT SALARY)
FROM employee

/* For every department, find the department number, the number of 
employees and their average salary */
SELECT DNO, COUNT(*), AVG(SALARY)
FROM EMPLOYEE
GROUP BY DNO

/* For every project, find the project number, it's name and the number
of employees currently working on it */
SELECT PNUMBER, PNAME, COUNT(*)
FROM PROJECT, WORKS_ON
WHERE PNUMBER=PNO
GROUP BY PNUMBER, PNAME






