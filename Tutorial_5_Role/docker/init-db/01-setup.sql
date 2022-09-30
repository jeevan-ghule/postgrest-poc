
-- Create role
create role web_anon nologin;
create role member nologin;
create role admin nologin;
create role super_admin nologin;

-- schema
create schema api;

create table api.people (
  id serial primary key,
  name text not null,
  student boolean not null default false,
  age int not null,
  details jsonb
);


insert into api.people (name,student,age,details) values
  ('jeevan', false ,30, '{ "address" :"pune"}'), ('praitk', true ,31, '{ "address" :"bopkhel"}'),('heero', true ,32, '{ "address" :"mumbai"}'),('swapnil', false ,33, '{ "address" :"warje"}'),('mayur', false ,34, '{ "address" :"thane"}');

insert into api.people (name,student,age) values
  ('prashant', false ,35), ('praitk-2', true ,36),('heero-2', true ,37),('swapnil-2', true ,38),('mayur-2', true ,39);

create table api.todos (
  id serial primary key,
  done boolean not null default false,
  task text not null,
  due timestamptz
);

insert into api.todos (task) values
  ('finish tutorial 0'), ('pat self on back');


-- Access
grant usage on schema api to web_anon;
grant select on api.people to web_anon;
grant web_anon to member;
grant insert,update on api.people to member;
grant usage, select on sequence api.people_id_seq to member;
grant member to admin;
grant delete on api.people to admin;
grant admin to super_admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA api TO super_admin;


-- create role authenticator noinherit login password 'mysecretpassword';
-- grant web_anon to authenticator;
