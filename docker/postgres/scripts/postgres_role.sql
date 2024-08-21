create role test_a01 with login;
create database test_a01 with owner test_a01;
-- \password test_a01

create role test_b01 with login in group test_a01;
-- \password test_b01
