-------------------------------------------------------------------------------------------------------------------------------------------------------------

>> Creating a new database 

CREATE database employee_distribution;

>> Using that database

use employee_distribution;

>> Once the database is in use then importing data directly from Human Resources CSV file
   > Right click to table option in MySQL Workbench
   > Select Table Data Import Wizard and choose your CSV file that needs to import.
   

>> Query to Check the total number of records present.

select count(*) from hr_details;
+----------+
| count(*) |
+----------+
|    22214 |
+----------+

>> Query to display all records from hr_details table
>> Analysing the data

select * from hr_details;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
>> Data Cleaning
>> We are renaming the Invalid character named column into "employee_id"

ALTER TABLE hr_details RENAME COLUMN ﻿id TO employee_id;

>> Chaning the datatype of employee_id

ALTER TABLE hr_details MODIFY employee_id  varchar(20);

>> birthdate is in invalid format, Changing it to correct format 
>> We are updating the date format of birthdate and hire_date columns

>> We are using the safe update mode it will not allow us to update without where clause. So we are setting sql_safe_updates to 0
set sql_safe_updates = 0

update hr_details set birthdate = case
  when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
  when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
else NULL
end;

update hr_details set hire_date = case
  when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
  when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
else NULL
end;

Alter table hr_details modify column hire_date date; 
Alter table hr_details modify column birthdate date; 


update hr_details set termdate=date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC')) where termdate is not null and termdate != ' ';

>> Altering the data type

Alter table hr_details modify column termdate date; 

>> Adding a new column age and calculating the age

ALTER TABLE hr_details ADD age INT after last_name;

>> Calculating the age and updating the same

UPDATE hr_details SET
age=timestampdiff(YEAR,birthdate,CURDATE())

>> Query to validate the Data type

describe hr_details;
+----------------+-------------+------+-----+---------+-------+
| Field          | Type        | Null | Key | Default | Extra |
+----------------+-------------+------+-----+---------+-------+
| employee_id    | varchar(20) | YES  |     | NULL    |       |
| first_name     | text        | YES  |     | NULL    |       |
| last_name      | text        | YES  |     | NULL    |       |
| age            | int         | YES  |     | NULL    |       |
| birthdate      | date        | YES  |     | NULL    |       |
| gender         | text        | YES  |     | NULL    |       |
| race           | text        | YES  |     | NULL    |       |
| department     | text        | YES  |     | NULL    |       |
| jobtitle       | text        | YES  |     | NULL    |       |
| location       | text        | YES  |     | NULL    |       |
| hire_date      | date        | YES  |     | NULL    |       |
| termdate       | date        | YES  |     | NULL    |       |
| location_city  | text        | YES  |     | NULL    |       |
| location_state | text        | YES  |     | NULL    |       |
+----------------+-------------+------+-----+---------+-------+


-------------------------------------------------------------------------------------------------------------------------------------------------------------
>> Data Analysis


SELECT 
min(age) AS youngest,
max(age) AS oldest
FROM hr_details;

+----------+--------+
| youngest | oldest |
+----------+--------+
|      -45 |     58 |
+----------+--------+

SELECT COUNT(*) AS count FROM hr_details where age<18;

+-------+
| count |
+-------+
|   967 |
+-------+

>> What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) as count
FROM hr_details 
WHERE age>17 and termdate like '0000-00-00' 
GROUP BY gender 
ORDER BY count desc;

+----------------+-------+
| gender         | count |
+----------------+-------+
| Male           |  8911 |
| Female         |  8090 |
| Non-Conforming |   481 |
+----------------+-------+

>> What is the race/ethnicity breakdown of employees in the company?
SELECT race,count(*) as count
FROM hr_details 
WHERE age>17 and termdate like '0000-00-00'
GROUP BY race
ORDER BY count DESC;
+-------------------------------------------+-------+
| race                                      | count |
+-------------------------------------------+-------+
| White                                     |  4987 |
| Two or More Races                         |  2867 |
| Black or African American                 |  2840 |
| Asian                                     |  2791 |
| Hispanic or Latino                        |  1994 |
| American Indian or Alaska Native          |  1051 |
| Native Hawaiian or Other Pacific Islander |   952 |
+-------------------------------------------+-------+


>> What is the age distribution of employees in the company?
SELECT min(age) as youngest_age,
max(age) as oldest_age
FROM hr_details
WHERE age>17 and termdate like '0000-00-00';

+--------------+------------+
| youngest_age | oldest_age |
+--------------+------------+
|           21 |         58 |
+--------------+------------+

SELECT CASE
WHEN age>17 AND age<25 THEN '18-24'
WHEN age>24 AND age<35 THEN '25-34'
WHEN age>34 AND age<45 THEN '35-44'
WHEN age>44 AND age<55 THEN '45-54'
WHEN age>54 AND age<65 THEN '55-64'
ELSE '65+'
END AS age_group,
count(*) AS count
FROM hr_details
WHERE age>17 and termdate like '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

+-----------+-------+
| age_group | count |
+-----------+-------+
| 18-24     |  1553 |
| 25-34     |  4912 |
| 35-44     |  5024 |
| 45-54     |  4822 |
| 55-64     |  1171 |
+-----------+-------+


SELECT CASE
WHEN age>17 AND age<25 THEN '18-24'
WHEN age>24 AND age<35 THEN '25-34'
WHEN age>34 AND age<45 THEN '35-44'
WHEN age>44 AND age<55 THEN '45-54'
WHEN age>54 AND age<65 THEN '55-64'
ELSE '65+'
END AS age_group,gender,
count(*) AS count
FROM hr_details
WHERE age>17 and termdate like '0000-00-00'
GROUP BY age_group,gender
ORDER BY age_group,gender;

+-----------+----------------+-------+
| age_group | gender         | count |
+-----------+----------------+-------+
| 18-24     | Female         |   720 |
| 18-24     | Male           |   798 |
| 18-24     | Non-Conforming |    35 |
| 25-34     | Female         |  2304 |
| 25-34     | Male           |  2467 |
| 25-34     | Non-Conforming |   141 |
| 35-44     | Female         |  2257 |
| 35-44     | Male           |  2631 |
| 35-44     | Non-Conforming |   136 |
| 45-54     | Female         |  2246 |
| 45-54     | Male           |  2438 |
| 45-54     | Non-Conforming |   138 |
| 55-64     | Female         |   563 |
| 55-64     | Male           |   577 |
| 55-64     | Non-Conforming |    31 |
+-----------+----------------+-------+

>> How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS count
FROM hr_details 
WHERE age>17 and termdate like '0000-00-00'
GROUP BY location 
ORDER BY count DESC;

+--------------+-------+
| location     | count |
+--------------+-------+
| Headquarters | 13107 |
| Remote       |  4375 |
+--------------+-------+

>> What is the average length of employment for employees who have been terminated?
SELECT round(AVG(datediff(termdate,hire_date))/365) AS avg_length_employeement
FROM hr_details
WHERE termdate<=curdate() AND termdate not like '0000%' AND age>17;

+-------------------------+
| avg_length_employeement |
+-------------------------+
|                       8 |
+-------------------------+

>> How does the gender distribution vary across departments?
SELECT department,gender,count(*) AS count 
FROM hr_details
WHERE age>17 and termdate like '0000-00-00'
GROUP BY gender,department
ORDER BY department;

+--------------------------+----------------+-------+
| department               | gender         | count |
+--------------------------+----------------+-------+
| Accounting               | Male           |  1375 |
| Accounting               | Female         |  1175 |
| Accounting               | Non-Conforming |    76 |
| Auditing                 | Female         |    19 |
| Auditing                 | Male           |    19 |
| Business Development     | Male           |   672 |
| Business Development     | Female         |   593 |
| Business Development     | Non-Conforming |    42 |
| Engineering              | Male           |  2671 |
| Engineering              | Female         |  2442 |
| Engineering              | Non-Conforming |   146 |
| Human Resources          | Female         |   672 |
| Human Resources          | Male           |   721 |
| Human Resources          | Non-Conforming |    37 |
| Legal                    | Male           |   125 |
| Legal                    | Female         |   107 |
| Legal                    | Non-Conforming |     5 |
| Marketing                | Male           |   199 |
| Marketing                | Female         |   206 |
| Marketing                | Non-Conforming |     5 |
| Product Management       | Male           |   272 |
| Product Management       | Female         |   227 |
| Product Management       | Non-Conforming |    13 |
| Research and Development | Female         |   404 |
| Research and Development | Male           |   401 |
| Research and Development | Non-Conforming |    25 |
| Sales                    | Male           |   739 |
| Sales                    | Female         |   648 |
| Sales                    | Non-Conforming |    39 |
| Services                 | Female         |   647 |
| Services                 | Male           |   661 |
| Services                 | Non-Conforming |    29 |
| Support                  | Male           |   368 |
| Support                  | Non-Conforming |    27 |
| Support                  | Female         |   337 |
| Training                 | Non-Conforming |    37 |
| Training                 | Male           |   688 |
| Training                 | Female         |   613 |
+--------------------------+----------------+-------+

>> What is the distribution of job titles across the company?
SELECT jobtitle,count(*) AS count 
FROM hr_details
WHERE age>17 and termdate like '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

+--------------------------------------+-------+
| jobtitle                             | count |
+--------------------------------------+-------+
| Web Developer IV                     |    58 |
| Web Developer III                    |    53 |
| Web Developer II                     |    66 |
| Web Developer I                      |    79 |
| Web Designer IV                      |     5 |
| Web Designer III                     |    10 |
| Web Designer II                      |     3 |
| Web Designer I                       |    27 |
| VP Sales                             |     5 |
| VP Quality Control                   |    34 |
| VP Product Management                |    31 |
| VP of Training and Development       |     1 |
| VP Marketing                         |    38 |
| VP Accounting                        |    65 |
| Training Manager                     |   149 |
| Trainer III                          |   139 |
| Trainer II                           |   149 |
| Trainer I                            |   152 |
| Tax Accountant                       |   230 |
| Systems Administrator IV             |    63 |
| Systems Administrator III            |    72 |
| Systems Administrator II             |    54 |
| Systems Administrator I              |   302 |
| Support Staff III                    |    16 |
| Support Staff II                     |    45 |
| Support Staff                        |    75 |
| Structural Engineer                  |   249 |
| Structural Analysis Engineer         |    36 |
| Statistician III                     |     2 |
| Statistician II                      |    10 |
| Statistician I                       |    10 |
| Staff Scientist                      |    26 |
| Staff Accountant IV                  |    83 |
| Staff Accountant III                 |    77 |
| Staff Accountant II                  |    65 |
| Staff Accountant I                   |   364 |
| Solutions Engineer Manager           |   164 |
| Solutions Engineer                   |   170 |
| Software Test Engineer IV            |    74 |
| Software Test Engineer III           |    65 |
| Software Test Engineer II            |    53 |
| Software Test Engineer I             |    65 |
| Software Engineer IV                 |    70 |
| Software Engineer III                |    82 |
| Software Engineer II                 |    70 |
| Software Engineer I                  |   308 |
| Software Consultant                  |   262 |
| Service Tech III                     |   268 |
| Service Tech II                      |   265 |
| Service Tech                         |   254 |
| Service Manager                      |   267 |
| Service Coordinator                  |   259 |
| Senior Trainer                       |   147 |
| Senior Sales Associate               |    12 |
| Senior Recruiter                     |   165 |
| Senior Quality Engineer              |   114 |
| Senior Financial Analyst             |    47 |
| Senior Editor                        |   120 |
| Senior Developer                     |   281 |
| Senior Cost Accountant               |   248 |
| Senior Attorney                      |    32 |
| Sales Representative                 |     3 |
| Sales Associate                      |     4 |
| Research Associate                   |   164 |
| Research Assistant IV                |     6 |
| Research Assistant III               |    15 |
| Research Assistant II                |   608 |
| Research Assistant I                 |   408 |
| Research Assistant                   |    30 |
| Relationshiop Manager                |   164 |
| Recruiting Manager                   |    19 |
| Recruiter                            |   184 |
| Quality Engineer                     |    52 |
| Quality Control Specialist           |   104 |
| Project Manager                      |   269 |
| Programmer IV                        |    50 |
| Programmer III                       |    65 |
| Programmer II                        |    69 |
| Programmer I                         |    70 |
| Programmer Analyst IV                |    64 |
| Programmer Analyst III               |    66 |
| Programmer Analyst II                |    77 |
| Programmer Analyst I                 |    74 |
| Product Engineer                     |    46 |
| Pre-Sales Consultant                 |   169 |
| Payment Adjustment Coordinator       |    16 |
| Paralegal                            |    48 |
| Operator                             |   170 |
| Office Assistant IV                  |     1 |
| Office Assistant I                   |     6 |
| Media Manager II                     |    41 |
| Media Manager I                      |   108 |
| Mechanical Systems Engineer          |    21 |
| Marketing Manager                    |     1 |
| Marketing Assistant                  |     8 |
| Librarian                            |    20 |
| Legal Assistant                      |    16 |
| Junior Trainer                       |   135 |
| Internal Auditor                     |    38 |
| Information Systems Manager          |    31 |
| Human Resources Manager              |    53 |
| Human Resources Assistant IV         |     9 |
| Human Resources Assistant III        |    13 |
| Human Resources Assistant II         |    10 |
| Human Resources Assistant I          |    10 |
| Human Resources Analyst II           |   477 |
| Human Resources Analyst              |   324 |
| HR Manager                           |   162 |
| Help Desk Technician                 |   266 |
| Help Desk Operator                   |    70 |
| Graphic Designer                     |     9 |
| General Manager                      |    21 |
| Financial Analyst                    |    48 |
| Financial Advisor                    |    26 |
| Executive Assistant                  |    31 |
| Engineer IV                          |     1 |
| Engineer III                         |     5 |
| Engineer II                          |     4 |
| Engineer I                           |     7 |
| Electrical Engineer                  |    22 |
| Editor                               |    69 |
| Director of Sales                    |     8 |
| Developer IV                         |    59 |
| Developer III                        |    62 |
| Developer II                         |    53 |
| Developer I                          |    69 |
| Desktop Support Technician           |   242 |
| Design Engineer                      |    41 |
| Database Administrator IV            |    69 |
| Database Administrator III           |    67 |
| Database Administrator II            |    68 |
| Database Administrator I             |    64 |
| Data Visualization Specialist        |   346 |
| Data Coordiator                      |   284 |
| Customer Success Manager             |   151 |
| Cost Accountant                      |   240 |
| Content Developer III                |    42 |
| Content Developer II                 |    43 |
| Content Developer                    |    42 |
| Computer Systems Analyst IV          |    53 |
| Computer Systems Analyst III         |    55 |
| Computer Systems Analyst II          |    75 |
| Computer Systems Analyst I           |    71 |
| Compensation Analyst                 |    25 |
| Community Outreach Specialist        |    21 |
| Chief Design Engineer                |    76 |
| Business Systems Development Analyst |   272 |
| Business Development Manager         |     5 |
| Business Analyst                     |   552 |
| Budget/Accounting Analyst IV         |   135 |
| Budget/Accounting Analyst III        |   130 |
| Budget/Accounting Analyst II         |   130 |
| Budget/Accounting Analyst I          |   120 |
| Automation Specialist IV             |    15 |
| Automation Specialist III            |    11 |
| Automation Specialist II             |    26 |
| Automation Specialist I              |    22 |
| Attorney                             |    33 |
| Associate Professor                  |     1 |
| Assistant Trainer                    |   139 |
| Assistant Professor                  |     1 |
| Assistant Manager                    |    39 |
| Analyst Programmer                   |   290 |
| Analog Circuit Design manager        |    36 |
| Administrative Officer               |    45 |
| Administrative Assistant IV          |     6 |
| Administrative Assistant III         |    14 |
| Administrative Assistant II          |    37 |
| Administrative Assistant I           |   154 |
| Administrative Assistant             |    27 |
| Actuary                              |    20 |
| Accounting Assistant IV              |    68 |
| Accounting Assistant III             |    59 |
| Accounting Assistant II              |    69 |
| Accounting Assistant I               |    74 |
| Accountant IV                        |    70 |
| Accountant III                       |    71 |
| Accountant II                        |    65 |
| Accountant I                         |    62 |
| Account Manager                      |   188 |
| Account Executive                    |   386 |
| Account Coordinator                  |     2 |
+--------------------------------------+-------+

>> Which department has the highest turnover rate?
SELECT department,
	total_count,
	terminated_count,
    terminated_count/total_count AS termination_rate
FROM (SELECT department,
count(*) AS total_count,
sum(CASE WHEN termdate NOT LIKE '0000%' AND termdate<=curdate() THEN 1 ELSE 0 END) AS terminated_count
FROM hr_details
where age>17 
GROUP BY department) as temp
ORDER BY termination_rate DESC;

+--------------------------+-------------+------------------+------------------+
| department               | total_count | terminated_count | termination_rate |
+--------------------------+-------------+------------------+------------------+
| Auditing                 |          50 |                9 |           0.1800 |
| Legal                    |         299 |               42 |           0.1405 |
| Training                 |        1622 |              204 |           0.1258 |
| Research and Development |        1032 |              124 |           0.1202 |
| Human Resources          |        1727 |              204 |           0.1181 |
| Support                  |         903 |              105 |           0.1163 |
| Engineering              |        6387 |              742 |           0.1162 |
| Accounting               |        3192 |              369 |           0.1156 |
| Sales                    |        1745 |              200 |           0.1146 |
| Product Management       |         623 |               71 |           0.1140 |
| Services                 |        1618 |              181 |           0.1119 |
| Business Development     |        1569 |              159 |           0.1013 |
| Marketing                |         480 |               46 |           0.0958 |
+--------------------------+-------------+------------------+------------------+

>> What is the distribution of employees across locations by state?
SELECT location_state,count(*) AS count 
FROM hr_details 
GROUP BY location_state
ORDER BY count DESC;

+----------------+-------+
| location_state | count |
+----------------+-------+
| Ohio           | 18025 |
| Pennsylvania   |  1115 |
| Illinois       |   868 |
| Indiana        |   700 |
| Michigan       |   673 |
| Kentucky       |   451 |
| Wisconsin      |   382 |
+----------------+-------+

>> How has the company's employee count changed over time based on hire and term dates?
SELECT 
	YEAR,
    hires,
    terminations,
    (hires-terminations) AS net_change,
    round(((hires-terminations)/hires)*100,2) AS net_change_percentage
FROM (
		SELECT YEAR(hire_date) AS YEAR,
        count(*) AS hires,
        SUM(CASE WHEN termdate NOT LIKE '0000%' AND termdate <=curdate() THEN 1 ELSE 0 END)AS terminations
        FROM hr_details 
        WHERE age>17 
        GROUP BY YEAR(hire_date)
        ) AS temp
ORDER BY year ASC;

+------+-------+--------------+------------+-----------------------+
| YEAR | hires | terminations | net_change | net_change_percentage |
+------+-------+--------------+------------+-----------------------+
| 2000 |   211 |           26 |        185 |                 87.68 |
| 2001 |  1082 |          197 |        885 |                 81.79 |
| 2002 |  1012 |          162 |        850 |                 83.99 |
| 2003 |  1088 |          196 |        892 |                 81.99 |
| 2004 |  1087 |          199 |        888 |                 81.69 |
| 2005 |  1038 |          181 |        857 |                 82.56 |
| 2006 |  1069 |          179 |        890 |                 83.26 |
| 2007 |  1058 |          147 |        911 |                 86.11 |
| 2008 |  1061 |          142 |        919 |                 86.62 |
| 2009 |  1094 |          151 |        943 |                 86.20 |
| 2010 |  1050 |          130 |        920 |                 87.62 |
| 2011 |  1057 |          115 |        942 |                 89.12 |
| 2012 |  1059 |          109 |        950 |                 89.71 |
| 2013 |  1042 |           93 |        949 |                 91.07 |
| 2014 |  1014 |           90 |        924 |                 91.12 |
| 2015 |  1011 |           82 |        929 |                 91.89 |
| 2016 |  1076 |           69 |       1007 |                 93.59 |
| 2017 |  1043 |           55 |        988 |                 94.73 |
| 2018 |  1090 |           52 |       1038 |                 95.23 |
| 2019 |  1038 |           50 |        988 |                 95.18 |
| 2020 |   967 |           31 |        936 |                 96.79 |
+------+-------+--------------+------------+-----------------------+

>> What is the tenure distribution for each department?
SELECT department,
	round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr_details
WHERE termdate<=curdate() AND termdate NOT LIKE '0000%' and age>17
GROUP BY department;

+--------------------------+------------+
| department               | avg_tenure |
+--------------------------+------------+
| Engineering              |          8 |
| Services                 |          8 |
| Human Resources          |          8 |
| Business Development     |          8 |
| Sales                    |          9 |
| Support                  |          8 |
| Auditing                 |          8 |
| Training                 |          7 |
| Accounting               |          8 |
| Research and Development |          8 |
| Product Management       |          7 |
| Legal                    |          7 |
| Marketing                |          8 |
+--------------------------+------------+

-------------------------------------------------------------------------------------------------------------------------------------------------------------

