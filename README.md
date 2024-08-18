# Employee Distribution Insights

This project focuses on analyzing the Employee Distribution data of an organization to develop a Power BI dashboard. The dashboard provides the CEO with real-time insights into the organization's workforce, aiding in strategic decision-making.

## Table of Contents
- [Problem Statement](#problem-statement)
- [Project Overview](#key-features)
- [Tools and Technologies](#tools-and-technologies)
- [Data Cleaning and Data Analysis using MySQL](#data-cleaning-and-data-analysis-using-MySQL)
- [Dashboard](#contributing)
- [Git Commands](#git-commands-used)

## Probelm Statement

The CEO of the organization seeks a real-time, data-driven understanding of the company's workforce. The existing employee data is stored in a raw format, making it challenging to extract actionable insights. The goal of this project is to analyze the employee distribution data and develop a Power BI dashboard that provides the CEO with critical insights into the workforcE.
  
## Project Overview

The goal of this project is to transform raw employee data into actionable insights through data analysis and visualization. The Power BI dashboard will offer a comprehensive view of various workforce metrics, including department distribution, gender distribution and demographic breakdowns.

- **Real-Time Insights:** The dashboard updates in real-time to provide the latest data on employee distribution.
- **Interactive Visualizations:** Users can interact with various charts and graphs to explore the data from different perspectives.
- **Comprehensive Metrics:** The dashboard includes key metrics such as employee count, departmental distribution, and more.


## Tools and Technologies

- **MySQL Workbech:** For Data Cleaning and ETL.
- **Power BI:** For creating the interactive dashboard.
- **Excel/CSV:** Used for storing and preparing the raw data (Human Resources.CSV).

## Data Cleaning and Data Analysis using MySQL

Total number of records : 22214
   ```bash
   select count(*) from hr_details;
   +----------+
   | count(*) |
   +----------+
   |    22214 |
   +----------+
   ```
   Understanding the data :
   1. The Excel file consists almost 22214 records from the year 2000 to 2020.
   2. All the Columns having similar datatype that is text.
   3. First column name is misleading.
   4. Some records had negative ages and these were excluded during querying(967 records). Ages used were 18 years and above.
   5. Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.
      
### Data Cleaning
  1. Renaming the Invalid character named column into "employee_id"
  
    
    ALTER TABLE hr_details RENAME COLUMN ﻿id?!. TO employee_id;
    
    
  2. Changing the datatype of employee_id column
  
    
    ALTER TABLE hr_details MODIFY employee_id  varchar(20);
    

  3. Updating the date format of birthdate and hire_date columns because those are invalid formats
  
    
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
    

  4. Changing the datatype for those columns
  
   ```bash
    Alter table hr_details modify column hire_date date; 
    Alter table hr_details modify column birthdate date;
   ```

  5. Termdate is the column which contains invalid date and null values, Handling those invalid records.
   ```bash
   update hr_details set termdate=date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC')) where termdate is not null and termdate != ' ';
   ```
   
  6. Adding a new column named "age" to calculate the age.
  
   ```
   ALTER TABLE hr_details ADD age INT after last_name;
   ```

   7. Updating the values to the column age
    
   ```bash
   UPDATE hr_details SET
   age=timestampdiff(YEAR,birthdate,CURDATE());
   ```

### Data Analysis

   1. Data is analysed and written set of select queries to understand the data.
   
   2. Queries that are used to analyze the data is available in [SQL Queries](https://github.com/shreyasmc1234/Employee-Data-Analysis/tree/main/SQL%20Queries)
   
   3. Extracted the produced report from select queries in .CSV format [Extracted Data](https://github.com/shreyasmc1234/Employee-Data-Analysis/tree/main/Extracted%20data%20from%20MySQL)

   4. By using the result set created the Dashboard by using Power BI.
 
   
## Dashboard
![Employee Distribution Dashboard](https://github.com/shreyasmc1234/Employee-Data-Analysis/blob/12d574c6d099a34fc2aebeb0e4003fc6fc50a780/Power%20BI%20Reports%20and%20Final%20PDF/Employee_Ditribution1.png)

![Employee Distribution Dashboard](https://github.com/shreyasmc1234/Employee-Data-Analysis/blob/main/Power%20BI%20Reports%20and%20Final%20PDF/Employee_Ditribution2.png?raw=true)


## Conclusion
- <h5>Gender Distribution:</h5>

The employee population is predominantly male, with a balanced gender distribution across most departments.
Despite the overall balance, male employees slightly outnumber female employees across the organization.

- <h5>Racial Composition:

The workforce is predominantly White, with Native Hawaiian and American Indian being the least represented races within the organization.

- <h5>Age Demographics:

The age range of employees spans from 20 to 57 years old.
The majority of employees fall within the 25-34 age group, followed by those in the 35-44 age group. The smallest age group is 55-64.

- <h5>Work Location:

A significant number of employees work at the headquarters, with fewer employees working remotely.

- <h5>Employee Tenure:

The average tenure for terminated employees is approximately 7 years.
The average tenure across departments is around 8 years, with the Legal and Auditing departments having the highest average tenure, while the Services, Sales, and Marketing departments have the lowest.

- <h5>Turnover Rates:

The Marketing department exhibits the highest turnover rate, followed by the Training department.
The departments with the lowest turnover rates are Research and Development, Support, and Legal.

- <h5>Geographical Distribution:

A large portion of the workforce is based in Ohio, making it the most represented state among employees.

- <h5>Employment Trends:

The net change in the number of employees has shown an upward trend over the years, indicating organizational growth.

- <h5>Data Cleaning and Processing:

Performed data cleaning using update, insert, and alter statements to ensure data validity and accuracy.
Invalid data entries were cleaned through the ETL process, enhancing the reliability of the analysis results.
These insights provide a comprehensive understanding of the workforce dynamics within the organization, highlighting key areas such as demographic distribution, tenure, turnover rates, and employment trends.

## Git Commands Used

Here are the Git commands used to initialize the repository and push it to GitHub:

```bash
git init
git add README.md
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/user_name/Employee-Data-Analysis.git
git push -u origin main
```

**Clone the Repository:**
   ```bash
   git clone https://github.com/username/Employee-Data-Analysis.git
   ```
   

