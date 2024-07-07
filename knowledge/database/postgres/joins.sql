create table join_a01 (
    name varchar,
    
    primary key(name)
);

create table join_a02 (
    name     varchar,
    org_name varchar,
    status   bool,

    primary key(name, org_name)
);

insert into join_a01 values 
('Jane'),
('Smith'),
('X-Mem'),
('Alice'),
('Bob');


insert into join_a02 values 
('Jane', 'org1', true),
('Jane', 'org2', false),
('Smith', 'org1', true),
('Smith', 'org2', true),
('X-Bob', 'org1', true),
('X-Bob', 'org2', false);

select t1.name, t2.org_name, t2.status from join_a01 t1
left join join_a02 t2 on t1.name = t2.name
where t2.org_name is not null;
/*
 Jane  | org1     | t
 Jane  | org2     | f
 Smith | org1     | t
 Smith | org2     | t
*/

select t1.name, t2.org_name, t2.status from join_a01 t1
inner join join_a02 t2 on t1.name = t2.name
where t2.org_name is not null;
/*
 Jane  | org1     | t
 Jane  | org2     | f
 Smith | org1     | t
 Smith | org2     | t
*/

select t1.name from join_a01 t1
left join join_a02 t2 on t1.name = t2.name
where t2.org_name is not null;
/*
 Jane
 Jane
 Smith
 Smith
*/

select name from join_a01
where name in (select name from join_a02);
/*
 Jane
 Smith
*/

SELECT name
FROM join_a01 t1
WHERE EXISTS (
    SELECT 1
    FROM join_a02 t2
    WHERE t1.name = t2.name
);
