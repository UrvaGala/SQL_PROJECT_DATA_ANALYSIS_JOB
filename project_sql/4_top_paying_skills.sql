/*
Q] top paying skills for data analyst jobs
- look at the average salary for data analyst jobs that require specific skills.
- identify the skills that are associated with higher-paying data analyst roles.
- why? Understanding the top-paying skills for data analyst jobs can help job seekers focus on developing the most valuable skills in the job market, and it can also provide insights into which skills are in high demand by employers.
*/  

SELECT
    skills,
    round(avg(salary_year_avg), 2) as avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short='Data Analyst' AND
    --job_location='Anywhere' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;