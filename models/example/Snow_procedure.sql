/*
--lets create a customer table with basic fields
create or replace transient table customer_dts (
customer_id int,
salutation varchar,
first_name varchar,
last_name varchar,
birth_day int,
birth_month int,
birth_year int,
birth_country varchar,
email_address varchar,
cust_status varchar)
comment ='this is simple customer table';

insert into customer_dts (customer_id , salutation , first_name , last_name , birth_day , birth_month , birth_year ,
birth_country , email_address, cust_status)
values
(101, 'Mr.', 'Cust-1', 'LName-1', 10, 12, 2000, 'Japan' , 'cust-1.lname-1@gmail.com','Active'),
(102, 'Mr.', 'Cust-2','LName-2', 27, 11, 1999, 'USA', 'cust-2.lname-2@gmail.com','Inactive'),
(103,'Mr.', 'Cust-3','LName-3', 21,2, 1998, 'UK','cust-3.lname-3@gmail.com','Blocked'),
(104, 'Mr.', 'Cust-4','LName-4', 19, 9, 1997, 'USA' , 'cust-4.lname-4@gmail.com','Active'),
(105,'Mr.', 'Cust-5','LName-5', 11, 3, 1997,'Canada', 'cust-5.lname-5@gmail.com','Unknown');

insert into customer_dts (customer_id , salutation , first_name , last_name , birth_day , birth_month , birth_year ,
birth_country , email_address, cust_status)
values
(102, 'Mr.', 'Cust-2','LName-2', 27, 11, 1999, 'USA', 'cust-2.lname-2@gmail.com','Inactive');

select * from customer_dts



/*
CREATE OR REPLACE PROCEDURE purge_inactive_customer()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  HANDLER = 'run'
  EXECUTE AS OWNER
AS
$$
def run(snowflake_session):
    # Use the provided Snowflake session object
    snowflake_session.sql("DELETE FROM customer_dts WHERE cust_status = 'Inactive';").collect()
    return 'Inactive customers purged successfully'
$$;*/

create or replace procedure purge_inactive_customer()
       returns string 
       language javascript
       strict
       execute as owner as
       $$
       var rs = snowflake.execute({
       sqlText: "delete from customer_dts where cust_status = 'Inactive';"
       });
       return 'Inactive customers purged';
       $$;

call purge_inactive_customer();       

/*
CREATE OR REPLACE PROCEDURE purge_inactive_customer()
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  STRICT
  EXECUTE AS OWNER
AS
$$
var rs = snowflake.execute({
    sqlText: "DELETE FROM customer_dts WHERE cust_status = 'Inactive';"
});
return 'Inactive customers purged';
$$;*/

/*
select * from table(result_scan(last_query_id()))

set my_value = (select * from table(result_scan(last_query_id())));
select $my_value

       
-- now lets add multiple SQL statement and see how it works.
create or replace procedure purge_non_active_customer()
returns string
language javascript
strict
execute as owner
as
$$
var rs_inactive = snowflake.execute( { sqlText:
"DELETE FROM customer_dts WHERE CUST_STATUS = 'Inactive' ;"
} );
var rs_blocked = snowflake.execute( { sqlText:
"DELETE FROM customer_dts WHERE CUST_STATUS = 'Blocked' ;"
} );
var rs_blocked = snowflake.execute( { sqlText:
"DELETE FROM customer_dts WHERE CUST_STATUS = 'Unknown';"
} );
return 'All non-active customers purged. ';
$$;
       
call purge_non_active_customer();   
       

select * from table(result_scan(last_query_id()))

set set_value = (select * from table(result_scan(last_query_id())))
select $set_value

show procedures;

select * from "dev"."information_schema"."procedures"




create or replace procedure purge_inactive_customer(in_param string)
     returns string
     language javascript
     strict 
     execute as owner
     as 
     $$
     var rs = snowflake.execute({
    sqlText: "DELETE FROM customer_dts WHERE cust_status = ?",
    binds: [IN_PARAM]})
     return 'Customer purged per req dts'
     $$;


CALL purge_inactive_customer('Inactive');

select * from customer_dts



create or replace procedure get_customer_name_binds(status string)
      returns string
      language javascript
      as 
      $$
      var return_val = "";

      var sql_query = "select salutation , first_name , last_name from customer_dts whwre cust_status = ?";

      var sql_statement = snowflake.createStatement(
      {
      sqlText: sql_query,
      binds : [STATUS]
      }
      
      );

      var result_scan = sql_statement.execute();
      while (result_scan.next()) {
          return_value += "\n";
          return_value += result_scan.getColumnValue(1);
          return_value += result_scan.getColumnValue(2);
          return_value += result_scan.getColumnValue(3);
      }
       returen return_val; */

















