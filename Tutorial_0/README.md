Tutorial 0: 

The tutorial created a web_anon role in the database with which to execute anonymous web requests
This will create a new schema named "api" with the "todos" table 
And give access to the "web_anon" role to read the table

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

2. Add data to the table : (this will failed due to not having permission to create)
    curl http://localhost:3000/todos -X POST \
     -H "Content-Type: application/json" \
     -d '{"task": "do bad thing"}'

Response 
     {"hint":null,"details":null,"code":"42501","message":"permission denied for table todos"}