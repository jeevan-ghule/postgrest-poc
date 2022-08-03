Tutorial 3: resource-embedding

This task allow user fetch data using query and relationships

https://postgrest.org/en/stable/api.html#resource-embedding


To run 

1. Go to Tutorial_3 -> docker folder
2. Run the following command
   docker-compose up 
3. To stop the docker container, run the following command
   docker-compose down 

This will start the docker server with two services postgres and postgrest 



1. curl "http://localhost:3000/films?select=title"

2. However because a foreign key constraint exists between Films and Directors, we can request this information be included:

curl "http://localhost:3000/films?select=title,directors(id,last_name)"

3. casting 
curl "http://localhost:3000/films?select=title,director:directors(id,last_name)"

4. Full text search

curl "http://localhost:3000/films?my_tsv=fts(english).Dhamal"


5. Embedding through join tables
   curl "http://localhost:3000/actors?select=films(title,year)"

6. Nested
  curl "http://localhost:3000/actors?select=roles(character,films(title,year))"

7. filter

curl "http://localhost:3000/films?select=*,roles(*)&roles.character=in.(Heero)"


8. custom query function

curl "http://localhost:3000/rpc/add_them_int" \
  -X POST -H "Content-Type: application/json" \
  -d '{ "a": 1, "b": 2 }'


TODO  Not working in CMD but working in browser
http://localhost:3000/films?select=title,actors!inner(first_name,last_name)&actors.first_name=eq.Jeevan

curl "http://localhost:3000/films?select%3Dtitle%2Cactors!inner(first_name%2Clast_name)%26actors.first_name%3Deq.Jeevan"