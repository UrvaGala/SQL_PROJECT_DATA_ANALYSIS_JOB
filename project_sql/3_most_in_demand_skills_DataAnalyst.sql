/*
Q] what are the most in-demand skills for data analysts?
-Identify the most in-demand skills for data analysts based on job postings.
-Analyze the frequency of skills mentioned in job postings for data analyst roles.
*/

--method 1
SELECT
    skills,
    count(skills_job_dim.job_id) as skill_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short='Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT 5;


--method 2

WITH skills_required AS (
    SELECT
        job_postings_fact.job_id,
        skills_job_dim.skill_id
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_title_short='Data Analyst'
)

select
    skills,
    count(skills_required.job_id) as skill_count
from
    skills_required
inner join skills_dim on skills_required.skill_id = skills_dim.skill_id
group by
    skills
order by
    skill_count desc
limit 5;

