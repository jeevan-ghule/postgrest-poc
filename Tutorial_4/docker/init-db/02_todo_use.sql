create role todo_user nologin;
grant todo_user to authenticator;

grant usage on schema api to todo_user;
-- Access to read and write permissions
grant all on api.todos to todo_user;
-- Access to read sequence permissions
grant usage, select on sequence api.todos_id_seq to todo_user;