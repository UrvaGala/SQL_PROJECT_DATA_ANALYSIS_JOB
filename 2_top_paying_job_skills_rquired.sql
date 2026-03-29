/*
Q] what are the skills required for the top-10 paying data analyst jobs?
-Identify the skills required for the top 10 highest paying data analyst roles that are available remotely.
-focuses on job postings with specified salaries (remove nulls).
*/


with top_paying_jobs as (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_name
    FROM
        job_postings_fact
    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short='Data Analyst' AND
        job_location='Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

select 
    top_paying_jobs.*,
    skills 
from 
    top_paying_jobs
inner join skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
order by 
    salary_year_avg desc


/*
Top 5 Skills (with Count)
SQL → 8
Python → 7
Tableau → 6
R → 4
Excel → 3
*/
