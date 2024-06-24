
select d.department ,j.job
,sum(case when substring(datetime, 6,2) in ('01','02','03') then 1 else 0 end ) as "Q1"
,sum(case when substring(datetime, 6,2) in ('04','05','06') then 1 else 0 end) as "Q2"
,sum(case when substring(datetime, 6,2) in ('07','08','09') then 1 else 0 end) as "Q3"
,sum(case when substring(datetime, 6,2) in ('10','11','12') then 1 else 0 end) as "Q4"
from hired_employees he inner join jobs j on he.job_id = j.id 
inner join departments d on he.department_id  = d.id 
where substring(datetime, 1,4) = '2021'
group by d.department, j.job
order by 1,2 asc