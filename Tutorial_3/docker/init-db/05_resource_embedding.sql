create table api.actors (
  id serial primary key,
  first_name text not null,
  last_name text not null
);

grant select on api.actors to web_anon;
grant all on api.actors to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.actors_id_seq to todo_user;

create table api.directors (
  id serial primary key,
  first_name text not null,
  last_name text not null
);

grant select on api.directors to web_anon;
grant all on api.directors to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.directors_id_seq to todo_user;


create table api.compitations (
  id serial primary key,
  name text not null,
  year integer not null
);

grant select on api.compitations to web_anon;
grant all on api.compitations to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.compitations_id_seq to todo_user;

create table api.films (
  id serial primary key,
  title text not null,
  year integer not null,
  rating integer not null,
  language text not null,
--   dirctor_id integer  not null,
--   constraint fk_dirctor_id foreign key (dirctor_id) references api.directors(id)

  director_id      integer references api.directors(id)
);

grant select on api.films to web_anon;
grant all on api.films to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.films_id_seq to todo_user;

create table api.roles (
  id serial primary key,
  character text not null,
  actor_id integer  not null,
  film_id integer  not null,
  constraint fk_actor_id foreign key (actor_id) references api.actors(id),
  constraint fk_film_id foreign key (film_id) references api.films(id)
);

grant select on api.roles to web_anon;
grant all on api.roles to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.roles_id_seq to todo_user;

create table api.nominations (
  id serial primary key,
  compitation_id integer  not null,
  film_id integer  not null,
  rank integer  not null,
  constraint fk_compitation_id foreign key (compitation_id) references api.compitations(id),
  constraint fk_film_id foreign key (film_id) references api.films(id)
);


grant select on api.nominations to web_anon;
grant all on api.nominations to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.nominations_id_seq to todo_user;



ALTER TABLE api.films
    ADD COLUMN my_tsv tsvector
               GENERATED ALWAYS AS (to_tsvector('english', coalesce(title, ''))) STORED;

-- Insert Data

insert into api.compitations (name,year) values
  ('FIFA', 2020), ('Mifta',2021),('Alfa', 2022);


insert into api.directors (first_name,last_name) values
  ('Nilesh', 'Soni'), ('Vaibhav','Soni'),('Mayur', 'Soni');

insert into api.actors (first_name,last_name) values
  ('Jeevan', 'Ghule'), ('Pratik','Kamble'),('Swapnil', 'Kamble');

insert into api.films (title,year,rating,language,director_id) values
  ('Dhamal', 2000,4,'hindi',1),('Dhamal-2', 2001,3,'hindi',2),('Dhamal-3', 2002,5,'eng',3),('Golmal', 2003,4,'hindi',1) ;

insert into api.roles (character,actor_id,film_id) values
  ('Heero', 1,1),('Vilan', 2,1),('Father', 3,1);

insert into api.roles (character,actor_id,film_id) values
  ('Heero', 3,2),('Vilan', 2,2),('Father', 1,2);

insert into api.roles (character,actor_id,film_id) values
  ('Heero', 2,3),('Vilan', 3,3),('Father', 1,4);


insert into api.nominations (compitation_id,film_id,rank) values
  ( 1,1,1),(2,2,2),(3,3,3);


CREATE FUNCTION api.add_them_int(a integer, b integer)
RETURNS integer AS $$
 SELECT a + b;
$$ LANGUAGE SQL IMMUTABLE;