Tutorial 2: Tables and Views

This task allow user fetch data using query

https://postgrest.org/en/stable/api.html#tables-and-views

table people (
   name text
   age  int
   student  boolean
)

To run 

1. Go to Tutorial_O -> docker folder
2. Run the following command
   docker-compose up 
3. To stop the docker container, run the following command
   docker-compose down 

This will start the docker server with two services postgres and postgrest 


Horizontal Filtering (ROW)

1. Read all the table data 
   curl "http://localhost:3000/people"

2. Age less than 35
   curl "http://localhost:3000/people?age=lt.35"

3. Age equal to 35
   curl "http://localhost:3000/people?age=eq.35"
 
4. Age equal to 50 (empty array in response )
   curl "http://localhost:3000/people?age=eq.50"

5. age grater than 35 and is student
   curl "http://localhost:3000/people?age=gte.35&student=is.true"


Logical operators
 curl "http://localhost:3000/people?or=(age.lt.33,age.gt.38)"


 Vertical Filtering (Columns)

 1. curl "http://localhost:3000/people?select=name,age"

 Renaming Columns
 You can rename the columns by prefixing them with an alias followed by the colon : operator.

 2. curl "http://localhost:3000/people?select=NewName:name,NewAge:age"

 response
 <!-- [{"NewName":"jeevan","NewAge":""}] -->

 Casting Columns
 Casting the columns is possible by suffixing them with the double colon :: plus the desired type.

  casting integer age to the text
 3. "http://localhost:3000/people?select=name,age::text"

 <!-- [{"name":"jeevan","age":"30"}] -->


4. For more complicated filters you will have to create a new view in the database

CREATE VIEW api.student_people AS
SELECT *
  FROM api.people
 WHERE student = true
    AND age < 35
ORDER BY age DESC;

curl "http://localhost:3000/student_people"

response 
[{"id":3,"name":"heero","student":true,"age":32},
 {"id":2,"name":"praitk","student":true,"age":31}]


 Ordering

 5. curl "http://localhost:3000/people?order=age.desc"
 6. curl "http://localhost:3000/people?order=age.asc"

 If you care where nulls are sorted, add nullsfirst or nullslast:

 curl "http://localhost:3000/people?order=age.nullsfirst"
 curl "http://localhost:3000/people?order=age.nullslast"

default order: asc?

Limits and Pagination

There are two ways to apply a limit and offset rows: through request headers or query parameters. When using headers you specify the range of rows desired. This request gets the first twenty people.

7. curl "http://localhost:3000/people" -i \
  -H "Range-Unit: items" \
  -H "Range: 0-5"

HTTP/1.1 200 OK
Transfer-Encoding: chunked
Date: Sat, 30 Jul 2022 19:06:23 GMT
Server: postgrest/9.0.1
Content-Range: 0-5/*
Content-Location: /people
Content-Type: application/json; charset=utf-8
Content-Profile: api

8. curl "http://localhost:3000/people" -i \
  -H "Range-Unit: items" \
  -H "Range: 5-"

HTTP/1.1 200 OK
Transfer-Encoding: chunked
Date: Sat, 30 Jul 2022 19:06:41 GMT
Server: postgrest/9.0.1
Content-Range: 5-9/*
Content-Location: /people
Content-Type: application/json; charset=utf-8
Content-Profile: api


9.  curl "http://localhost:3000/people?limit=5&offset=0"
10.  curl "http://localhost:3000/people?limit=5&offset=5"



Exact Count : Total count for pagination

11. curl "http://localhost:3000/people" -I \
  -H "Range-Unit: items" \
  -H "Range: 0-24" \
  -H "Prefer: count=exact"

  
HTTP/1.1 200 OK
Date: Sat, 30 Jul 2022 19:10:29 GMT
Server: postgrest/9.0.1
Content-Range: 0-9/10
Content-Location: /people
Content-Type: application/json; charset=utf-8
Content-Profile: api


13. josnb filters

curl "http://localhost:3000/people?select=id,details->>address"


curl "http://localhost:3000/people?select=id,details->>address&details->>address=eq.bopkhel"