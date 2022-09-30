create extension if not exists pgcrypto;
-- CREATE EXTENSION pgcrypto;
create extension if not exists pgjwt;
-- CREATE EXTENSION pgjwt;
-- CREATE EXTENSION pgjwt WITH SCHEMA public;

-- We put things inside the basic_auth schema to hide
-- them from public view. Certain public procs/views will
-- refer to helpers and tables inside.
create schema if not exists basic_auth;

SET search_path TO api,basic_auth,auth,public;

grant usage on schema basic_auth to web_anon;

create table if not exists
basic_auth.users (
  email    text primary key check ( email ~* '^.+@.+\..+$' ),
  pass     text not null check (length(pass) < 512),
  role     name not null check (length(role) < 512)
);

create or replace function
basic_auth.check_role_exists() returns trigger as $$
begin
  if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
    raise foreign_key_violation using message =
      'unknown database role: ' || new.role;
    return null;
  end if;
  return new;
end
$$ language plpgsql;

drop trigger if exists ensure_user_role_exists on basic_auth.users;
create constraint trigger ensure_user_role_exists
  after insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.check_role_exists();


-- -- create extension if not exists pgcrypto;
-- CREATE EXTENSION pgcrypto;
-- -- create extension if not exists pgjwt;
-- CREATE EXTENSION pgjwt;
-- -- CREATE EXTENSION pgjwt WITH SCHEMA public;

create or replace function
basic_auth.encrypt_pass() returns trigger as $$
begin
  if tg_op = 'INSERT' or new.pass <> old.pass then
    new.pass = crypt(new.pass, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

drop trigger if exists encrypt_pass on basic_auth.users;
create trigger encrypt_pass
  before insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.encrypt_pass();


create or replace function
basic_auth.user_role(email text, pass text) returns name
  language plpgsql
  as $$
begin
  return (
  select role from basic_auth.users
   where users.email = user_role.email
     and users.pass = crypt(user_role.pass, users.pass)
  );
end;
$$;


-- add type
CREATE TYPE basic_auth.jwt_token AS (
  token text
);

-- login should be on your exposed schema
create or replace function api.login(email text, pass text) returns basic_auth.jwt_token as $$
declare
  _role name;
  result basic_auth.jwt_token;
begin
  -- check email and password
  select basic_auth.user_role(email, pass) into _role;
  if _role is null then
    raise invalid_password using message = 'invalid user or password';
  end if;

  select sign(
      row_to_json(r), 't/LviH6kc2QUqPhoFKX+Id61tbwqFGWY2cdeMGLAgTQONC02hURALz88mxQg017dU/VOaZUH6Rh2pybYrqJKLA=='
    ) as token
    from (
      select _role as role, login.email as email,
         extract(epoch from now())::integer + 60*60 as exp
    ) r
    into result;
  return result;
end;
$$ language plpgsql security definer;

grant execute on function api.login(text,text) to web_anon;





create or replace function
basic_auth.check_email_exists(email text) returns name
  language plpgsql
  as $$
begin
  return (
  select role from basic_auth.users
   where users.email = check_email_exists.email
  );
end;
$$;

-- login should be on your exposed schema
create or replace function api.signup(email text, pass text, confirmed_pass text) returns basic_auth.jwt_token as $$
declare
  _role name;
  result basic_auth.jwt_token;
begin
  -- check password and confirmed_pass is same
  if pass != confirmed_pass then
    raise invalid_password using message = 'password and confirmed password are not the same';
  end if;

  -- check email and password
  select basic_auth.check_email_exists(email) into _role;
  if _role then
    raise invalid_password using message = 'email already exists';
  end if;

  INSERT INTO basic_auth.users(
	email, pass, role)
	VALUES (email, pass, 'member');

  select sign(
      row_to_json(r), 't/LviH6kc2QUqPhoFKX+Id61tbwqFGWY2cdeMGLAgTQONC02hURALz88mxQg017dU/VOaZUH6Rh2pybYrqJKLA=='
    ) as token
    from (
      select 'member' as role, signup.email as email,
         extract(epoch from now())::integer + 60*60 as exp
    ) r
    into result;
  return result;
end;
$$ language plpgsql security definer;


grant execute on function api.signup(text,text,text) to web_anon;