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


INSERT INTO basic_auth.users(
	email, pass, role)
	VALUES ('jeevan@gmail.com', 'ghule', 'todo_user');

curl "http://localhost:3000/rpc/login" \
  -X POST -H "Content-Type: application/json" \
  -d '{ "email": "jeevan@gmail.com", "pass": "ghule" }'

{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZW1haWwiOiJqZWV2YW5AZ21haWwuY29tIiwiZXhwIjoxNjY0MjkzOTQxfQ.g7uQlDiPaVC-0jMhdk0vNFtMEsNyyrgfdWzyBkIcjRk"}




