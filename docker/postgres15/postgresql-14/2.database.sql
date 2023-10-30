\q
\help select

create database hello;

create table company (
   id INT PRIMARY KEY     NOT NULL,
   name           TEXT    NOT NULL,
   age            INT     NOT NULL,
   address        CHAR(50),
   salary         REAL
);


create table department(
   id INT PRIMARY KEY      NOT NULL,
   dept           CHAR(50) NOT NULL,
   emp_id         INT      NOT NULL
);

insert into company (id, name, age, address, salary) values
  (1, 'Alice', 7, 'aaaa', 70000),
  (2, 'Bob',   9, 'bbbb', 42000)
  returning *;


\d
\d department

\l
\c hello;

drop table department, company;
