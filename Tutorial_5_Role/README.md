Tutorial 3: resource-embedding

This task allow user fetch data using query and relationships

https://postgrest.org/en/stable/api.html#resource-embedding


To run 

1. Go to Tutorial_4 -> docker folder
2. Create custom postgres docker image with extension 
    docker build -t "custom-postgres" .
3. Run the following command
   docker-compose up 
4. To stop the docker container, run the following command
   docker-compose down 

This will start the docker server with two services postgres and postgrest 


TO add user 
select * from pg_roles;

1. Sign up the user with member role 
   <!-- Sign up as member -->
curl "http://localhost:3000/rpc/signup" \
  -X POST -H "Content-Type: application/json" \
  -d '{ "email": "jeevan@gmail.com", "pass": "ghule" , "confirmed_pass" : "ghule"}'


2. To create admin and super_admin  role, run the following command

<!-- For admin, run the following command  -->
INSERT INTO basic_auth.users(
	email, pass, role)
	VALUES ('jeevan-admin@gmail.com', 'ghule', 'admin');

<!-- For super_admin, run the following command -->
INSERT INTO basic_auth.users(
	email, pass, role)
	VALUES ('jeevan-super-admin@gmail.com', 'ghule', 'super_admin');

3. Login the user 
<!-- Login as member,admin,super_admin -->

curl "http://localhost:3000/rpc/login" \
  -X POST -H "Content-Type: application/json" \
  -d '{ "email": "jeevan@gmail.com", "pass": "ghule" }'

{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZW1haWwiOiJqZWV2YW5AZ21haWwuY29tIiwiZXhwIjoxNjY0MjkzOTQxfQ.g7uQlDiPaVC-0jMhdk0vNFtMEsNyyrgfdWzyBkIcjRk"}


Access Token

1. Select :  allow roles : web_anon, member, admin and super_admin
   curl http://localhost:3000/people

(Other parent roles member,admin and super_admin  roles are also able fetch data from people table)

   curl http://localhost:3000/people -X GET \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json"


2. Create :  allow roles : member, admin and super_admin
             Not Allowed : web_anon

   curl http://localhost:3000/people -X POST \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"name": "Aman" , "student" : true , "age": 40 , "details" : { "address" : "duabi", "phone" : 1234567890}}'


     {"id":11,"name":"Aman","student":true,"age":40,"details":{"phone": 1234567890, "address": "duabi"}}]

3. Delete :  allow roles :admin and super_admin
             Not Allowed : web_anon and member

   curl http://localhost:3000/people -X DELETE \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"name": "Aman"}'

4. For todos table only super_admin has all access  (web_anon and member and admin not allowed)
    
    curl http://localhost:3000/todos -X GET \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json"