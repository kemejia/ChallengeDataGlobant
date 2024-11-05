CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `db`.`Challenge2a` AS 
select `d`.`department` AS `department`
	,`j`.`job` AS `job`
	,sum((case when (quarter(`e`.`datetime`) = 1) then 1 else 0 end)) AS `Q1`
    ,sum((case when (quarter(`e`.`datetime`) = 2) then 1 else 0 end)) AS `Q2`
    ,sum((case when (quarter(`e`.`datetime`) = 3) then 1 else 0 end)) AS `Q3`
    ,sum((case when (quarter(`e`.`datetime`) = 4) then 1 else 0 end)) AS `Q4` 
from ((`db`.`hired_employees` `e` 
	join `db`.`departments` `d` on((`e`.`department_id` = `d`.`id`))) 
    join `db`.`jobs` `j` on((`e`.`job_id` = `j`.`id`))) 
where (year(`e`.`datetime`) = 2021) 
group by `d`.`department`,`j`.`job` 
order by `d`.`department`,`j`.`job`;
