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

/* Create tables for the following relations: 
SUPPLIERS(s#(pk), name_s, balance, city)
PRODUCTS(prod#(pk), type#(pk), name_p, color, weight, city_p)
OFFERS(o#(pk), s#(fk), pr#(pk), t#(fk), quantity_order, date_order, quantity_supply, date_supply) */

CREATE TABLE SUPPLIERS
(
s NUMBER(3) PRIMARY KEY,
name_s VARCHAR(50),
balance NUMBER,
city VARCHAR(20)
)

CREATE TABLE PRODUCTS
(
prod NUMBER(5),
type NUMBER(2),
name_p VARCHAR(50),
color CHAR(5),
weight NUMBER(3),
city_p VARCHAR(20),
CONSTRAINT PRODUCTS_PK PRIMARY KEY (prod, type)
)

CREATE TABLE OFFERS
(
o NUMBER(5) PRIMARY KEY,
s NUMBER(3) REFERENCES SUPPLIERS(s)
pr NUMBER(5),
type NUMBER(2),
quantity_order NUMBER,
date_order DATE,
quantity_supply NUMBER,
date_supply DATE,
CONSTRAINT OFFERS_FK FOREIGN KEY (pr, type)
REFERENCES PRODUCTS(prod, type)
)

/* Add these conditions:
- the names of the suppliers can't be null
- the names of the suppliers are unique
- the balance has to be a number bigger than 0
- if the city is not entered, then set the default value to London
- the name of the city where the products are made has to be one 
of the following: London, Paris, Rome
- the quantity of supply has to be bigger than the order quantity
 */

 CREATE TABLE SUPPLIERS
(
s NUMBER(3) PRIMARY KEY,
name_s VARCHAR(50) NOT NULL,
balance NUMBER CHECK (balance>0),
city VARCHAR(20) DEFAULT "London",
CONSTRAINT name_unique UNIQUE(name_s)
)

CREATE TABLE PRODUCTS
(
prod NUMBER(5),
type NUMBER(2),
name_p VARCHAR(50),
color CHAR(5),
weight NUMBER(3),
city_p VARCHAR(20) CHECK (city_p IN ('London', 'Paris', 'Rome')),
CONSTRAINT PRODUCTS_PK PRIMARY KEY (prod, type)
)

CREATE TABLE OFFERS
(
o NUMBER(5) PRIMARY KEY,
s NUMBER(3) REFERENCES SUPPLIERS(s)
ON DELETE CASCADE ON UPDATE CASCADE,
pr NUMBER(5),
type NUMBER(2),
quantity_order NUMBER,
date_order DATE,
quantity_supply NUMBER,
date_supply DATE,
CHECK(quantity_supply <= quantity_order)
CONSTRAINT OFFERS_FK FOREIGN KEY (pr, type)
REFERENCES PRODUCTS(prod, type)
ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT type_fk FOREIGN KEY (type) REFERENCES PRODUCTS(type)
ON DELETE SET NULL ON UPDATE CASCADE
)