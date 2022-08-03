
create table api.people (
  id serial primary key,
  name text not null,
  student boolean not null default false,
  age int not null
);


insert into api.people (name,student,age) values
  ('jeevan', false ,30), ('praitk', true ,31),('heero', true ,32),('swapnil', false ,33),('mayur', false ,34);

insert into api.people (name,student,age) values
  ('prashnt', false ,35), ('praitk-2', true ,36),('heero-2', true ,37),('swapnil-2', true ,38),('mayur-2', true ,39);


grant select on api.people to web_anon;
grant all on api.people to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.people_id_seq to todo_user;



CREATE VIEW api.student_people AS
SELECT *
  FROM api.people
 WHERE student = true
    AND age < 35
ORDER BY age DESC;

grant select on api.student_people to web_anon;
grant all on api.student_people to todo_user;