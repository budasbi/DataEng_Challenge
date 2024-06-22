create table logs(
	id serial primary key,
	table_name varchar(15),
	datetime timestamp not null default NOW(),
	payload varchar(500)
);