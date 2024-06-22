create table hired_employees(
	id int primary key,
	name varchar(100),
	datetime varchar(30),
	department_id integer,
	job_id integer
);
alter table hired_employees add constraint fk_hired_employess_jobs foreign key(job_id) references jobs(id); 
alter table hired_employees add constraint fk_hired_employess_department foreign key(department_id) references departments(id);