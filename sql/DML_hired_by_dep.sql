with cte_avg as (
select count(*) as  qty_2021, department_id 
from hired_employees he 
where substring(datetime, 1,4) = '2021'
group by department_id 
), all_deps as
(
select count(*) as  qty, department_id 
from hired_employees he 
group by department_id 
)
select d.id, d.department, qty as hired 
from all_deps c inner join departments d on c.department_id=d.id 
where qty > (select avg(qty_2021) from cte_avg)
order by 3 desc