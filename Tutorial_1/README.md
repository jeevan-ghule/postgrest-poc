Tutorial 1: 

This task allow user to create data using role base assess

https://postgrest.org/en/stable/tutorials/tut1.html

user can access the table but not able to create a new row in the table.


To run 

1. Go to Tutorial_O -> docker folder
2. Run the following command
   docker-compose up 
3. To stop the docker container, run the following command
   docker-compose down 

This will start the docker server with two services postgres and postgrest 


Testing 
1. Read the table data 
   curl http://localhost:3000/todos


create JWT token at https://jwt.io/ with { "role" "todo_user"}
Add JWT secret as in .env file
You can add the expiration date for token
{ "role" "todo_user" , "exp" : 1659203615 } 


To get exp : 
select extract(epoch from now() + '5 minutes'::interval) :: integer;


2. Add data to the table : 

 This token has role access "todo_user"
export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwicm9sZSI6InRvZG9fdXNlciIsImlhdCI6MTUxNjIzOTAyMn0.PW7SbR0pbiIt_NEP71Mc4PhVrkuoF7MX0K-vrv_cQKY"

   A. create

    curl http://localhost:3000/todos -X POST \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"task": "learn how to auth"}'


   B. update id 1

     curl "http://localhost:3000/todos?id=eq.1" -X PATCH \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"task": "update learn how to auth"}'

   C. delete

     curl "http://localhost:3000/todos?id=eq.1" -X DELETE \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Prefer: return=representation"


Note this token is valid till expiration time even. Even if you remove the user token is still valid
To avoid this we can restrict user using email or any specific unique filed for JWT token


create token with email data : { "role" "todo_user" , "exp" : 1659203615 , "email": "disgruntled@mycompany.com" } 

# this fuction exectue on per resquest and check user JWT token
# see 03_auth.sql file 
PGRST_DB_PRE_REQUEST="auth.check_token"

This token has role access "todo_user" and email disgruntled@mycompany.com
export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZW1haWwiOiJkaXNncnVudGxlZEBteWNvbXBhbnkuY29tIn0.z94QY10yCP4PEURR6akMQ45e6t0nV3I_eNX78TFBBT8"

curl http://localhost:3000/todos -X POST \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"task": "learn how to auth"}'

Error response
{"hint":"Nope, we are on to you","details":null,"code":"42501","message":"insufficient_privilege"}