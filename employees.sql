--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;

flush /*!50503 binary */ logs;

SELECT 'LOADING departments' as 'INFO';
source load_departments.dump ;
SELECT 'LOADING employees' as 'INFO';
source load_employees.dump ;
SELECT 'LOADING dept_emp' as 'INFO';
source load_dept_emp.dump ;
SELECT 'LOADING dept_manager' as 'INFO';
source load_dept_manager.dump ;
SELECT 'LOADING titles' as 'INFO';
source load_titles.dump ;
SELECT 'LOADING salaries' as 'INFO';
source load_salaries1.dump ;
source load_salaries2.dump ;
source load_salaries3.dump ;

source show_elapsed.sql ;


INSERT INTO departments (dept_no, dept_name) 
VALUES 
('d010', 'Commercial'),
('d011', 'Informatique'),
('d012', 'RH'),
('d013', 'Finance'),
('d014', 'Logistique'),
('d015', 'Marketing'),
('d016', 'Production'),
('d017', 'Qualité');


INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date) 
VALUES 
(999901, '1986-04-21', 'John', 'Smith', 'M', '2025-01-01'),
(999902, '1973-03-26', 'Patricia', 'Lawrence', 'F', '2025-01-01'),
(999903, '1977-09-14', 'John', 'Doe', 'M', '2025-01-01'),
(999904, '1985-02-19', 'Jane', 'Doe', 'F', '2025-01-01'),
(999905, '1990-07-30', 'Michael', 'Johnson', 'M', '2025-01-01'),
(999906, '1988-11-12', 'Emily', 'Williams', 'F', '2025-01-01'),
(999907, '1982-05-08', 'David', 'Brown', 'M', '2025-01-01');


INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date) 
VALUES 
(999901, 'd010', '2025-01-01', '9999-01-01'),
(999902, 'd011', '2025-01-01', '9999-01-01'),
(999903, 'd012', '2025-01-01', '9999-01-01'),
(999904, 'd013', '2025-01-01', '9999-01-01'),
(999905, 'd014', '2025-01-01', '9999-01-01'),
(999906, 'd015', '2025-01-01', '9999-01-01'),
(999907, 'd016', '2025-01-01', '9999-01-01');

INSERT INTO titles (emp_no, title, from_date, to_date) 
VALUES 
(999901, 'Senior Engineer', '2025-01-01', '9999-01-01'),
(999902, 'Engineer', '2025-01-01', '9999-01-01'),
(999903, 'Senior Engineer', '2025-01-01', '9999-01-01'),
(999904, 'Engineer', '2025-01-01', '9999-01-01'),
(999905, 'Senior Engineer', '2025-01-01', '9999-01-01'),
(999906, 'Engineer', '2025-01-01', '9999-01-01'),
(999907, 'Senior Engineer', '2025-01-01', '9999-01-01');

INSERT INTO salaries (emp_no, salary, from_date, to_date) 
VALUES 
(999901, 50000, '2025-01-01', '9999-01-01'),
(999902, 60000, '2025-01-01', '9999-01-01'),
(999903, 70000, '2025-01-01', '9999-01-01'),
(999904, 80000, '2025-01-01', '9999-01-01'),
(999905, 90000, '2025-01-01', '9999-01-01'),
(999906, 100000, '2025-01-01', '9999-01-01'),
(999907, 110000, '2025-01-01', '9999-01-01');






