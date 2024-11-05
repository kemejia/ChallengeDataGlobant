CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `Challenge2b` AS 
select `d`.`id` AS `id`,`d`.`department` AS `department`,count(`e`.`id`) AS `hired` 
from (`hired_employees` `e` 
	join `departments` `d` on((`e`.`department_id` = `d`.`id`))) 
where (year(`e`.`datetime`) = 2021) 
group by `d`.`id`,`d`.`department` 
having (count(`e`.`id`) > (select avg(`tbl`.`hire_count`) AS `average_hires` 
							from (select count(1) AS `hire_count` 
								from `hired_employees` `eavg` 
								where (year(`eavg`.`datetime`) = 2021) 
                                group by month(`eavg`.`datetime`)) `tbl`)) 
order by count(`e`.`id`) desc;
