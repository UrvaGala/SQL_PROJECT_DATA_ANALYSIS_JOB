/*
Q] What are the most optimal skills to learn ( aka it's in high demand and high-paying skill)?
- Identify the skills that are both in high demand and associated with higher-paying data analyst roles.
-Concentrates on remote job postings with specified salaries (remove nulls).
-Why? Targets skills that offer job security(high demand) and financial benefits (high pay), providing a strategic advantage for job seekers.
*/

--method 1: using CTEs to calculate demand and salary separately, then joining them to find the optimal skills. This approach allows for a clear separation of the two metrics (demand and salary) and makes it easier to analyze the relationship between them.
WITH skill_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count
    from
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short='Data Analyst' AND
        job_work_from_home=TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), 
skill_salary AS (
    SELECT
        skills_dim.skill_id,
        round(avg(salary_year_avg), 2) as avg_salary
    from
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short='Data Analyst' AND
        job_work_from_home=TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skill_demand.skills,
    skill_demand.demand_count,
    skill_salary.avg_salary
FROM
    skill_demand
INNER JOIN skill_salary ON skill_demand.skill_id = skill_salary.skill_id
WHERE
    skill_demand.demand_count >10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 10;

--method 2: using a single query with aggregation to calculate both demand and salary in one step. This approach is more concise and may be more efficient, but it can be less clear in terms of separating the two metrics.
SELECT
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(salary_year_avg), 2) as avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short='Data Analyst' AND
    job_work_from_home=TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    count(skills_job_dim.job_id) > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 10;