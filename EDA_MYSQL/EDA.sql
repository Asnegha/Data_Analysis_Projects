-- Problem statement
-- --------------------------------------------------------------------------------------------------------------------
-- Parrot is a fresher looking for entry level jobs. As the year 2022 is just after COVID ended. Parrot would like to 
-- analyze the job opening in data related field before diving into job search for better understanding. So here we 
-- took a data science salary dataset from Kaggle and analysing the entry level openings. 
-- --------------------------------------------------------------------------------------------------------------------

USE salary;
SELECT * FROM  ds_salaries;
-- -------------------------------------------------------------
-- Cleaning
-- 1. The dataset does not contain any null values. 

-- 2. Correcting inconsistent job_title column
SELECT job_title, count(job_title) as count
FROM ds_salaries
GROUP BY job_title
ORDER BY job_title;

UPDATE ds_salaries
SET job_title = CASE WHEN job_title = 'Finance Data Analyst' THEN 'Financial Data Analyst'
			     WHEN job_title = 'ML Engineer' THEN 'Machine Learning Engineer'
                 WHEN job_title = 'Data Analytics Lead' THEN 'Lead Data Analyst'
                 ELSE job_title
			     END;

-- Removing unimportant columns
ALTER TABLE ds_salaries
DROP COLUMN salary;
 
ALTER TABLE ds_salaries
DROP COLUMN salary_currency;

ALTER TABLE ds_salaries
DROP COLUMN employee_residence;
-- -------------------------------------------------------------------
-- EDA

-- Analysing the trend of data related jobs over year. 
SELECT work_year, count(work_year)
FROM ds_salaries
GROUP BY work_year;
-- -------------------------------------------------------------------
-- Observation: As we expected the job opening increased over year. 
-- -------------------------------------------------------------------

-- Analysing the trend of entry level jobs over year
SELECT work_year, experience_level, count(experience_level) as 'No.Jobs'
FROM ds_salaries
WHERE experience_level = 'EN'
GROUP BY work_year
ORDER BY work_year;
-- ----------------------------------------------------------------------------------------------------------------------------------
-- Observation: Suprisingly, entry level jobs decreased in 2020. These is because when we observe trend for all level of experience. 
-- It is observed that, as years pass by companies are expecting more and more experienced people in the field.  
-- ----------------------------------------------------------------------------------------------------------------------------------

-- Anlysing the min and max salary for entry level jobs over years. 
SELECT work_year, experience_level, min(salary_in_usd) as 'Min Salary', max(salary_in_usd) as 'Max Salary'
FROM ds_salaries
WHERE experience_level = 'EN'
GROUP BY work_year
ORDER BY work_year;   
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Observation: Entry level minimum salary increased over year but max salary for entry level jobs is reduced. This is because companies expect more and more experienced professionals. 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------             

-- Analysing which Location has more entry level job openings.
SELECT work_year, company_location, experience_level, count(company_location) as No_Jobs
FROM ds_salaries
WHERE experience_level = 'EN'
GROUP BY work_year,company_location
ORDER BY work_year, No_Jobs DESC;
-- ------------------------------------------------------------------------------
-- Observation: US have highest entry level jobs but it get reduced over year. 
-- ------------------------------------------------------------------------------

-- Analysing what size company to target for entry level jobs.
SELECT work_year, company_size, experience_level, count(company_size) as No_Jobs
FROM ds_salaries
WHERE experience_level = 'EN'
GROUP BY work_year,company_size
ORDER BY work_year, No_Jobs DESC; 
-- ---------------------------------------------------------------------------------
-- Observation: Medium size company tend to increase entry level jobs over year. 
-- ---------------------------------------------------------------------------------

-- Analysing between remote and on site entry level jobs by comparing salaries. 
SELECT remote_ratio, experience_level, min(salary_in_usd) as 'Min Salary', max(salary_in_usd) as 'Max Salary'
FROM ds_salaries
WHERE experience_level = 'EN'
GROUP BY remote_ratio;
-- --------------------------------------------------------
-- Observation: Remote jobs attract with high package.
-- -------------------------------------------------------- 

-- Aalysing the trend about number of remote job opening per year. 
SELECT work_year, remote_ratio, count(remote_ratio) as 'No_Jobs'
FROM ds_salaries
GROUP BY work_year, remote_ratio
ORDER BY work_year, No_Jobs DESC;
-- ------------------------------------------------------------------
-- Obserevation: Remote jobs are increasing every year. 
-- ------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Conculsion
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- 1. From the analysis, one can easily target remote entry-level jobs. Also, remote jobs offer high packages, and job openings are 
--    increasing yearly.
-- 2. During the job search, one can target many medium-sized companies because it increases entry-level job openings every year. 
-- 3. As the number of entry-level jobs is getting reduced over the years, one should get into a company with aspired designation than 
--    looking for large companies for jobs. We observed that large companies recruit more experienced professionals from our analysis. 
--    So by initially working at a small/medium size company, one should gain experience and move to large companies later.  
-- 4. Finally, for job relocation, one can target the US, as it has many entry-level job openings compared to other locations. 
-- ---------------------------------------------------------------------------------------------------------------------------------------
