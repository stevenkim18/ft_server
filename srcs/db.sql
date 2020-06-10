use mysql;

CREATE DATABASE wordpress;

-- id : test pw : 1234 
create user 'test'@'%' identified by '1234';

-- give test to root auth
grant all privileges on *.* to 'test'@'%';

--apply
FLUSH privileges;
