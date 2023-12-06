import ballerina/http;
import ballerina/time;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;


mysql:Client dbConn = check new("localhost", "root", "", "users_db");

type User record 
{|
    readonly int id;
    string first_name;
    string last_name;
    time:Date birthdate;

|};


type NewUser record 
{|
    string first_name;
    string last_name;
    time:Date birthdate;
|};


service /users on new http:Listener(9090) 
{
    resource function get getusers() returns User[]|error
    {
        stream<User, sql:Error?> userStream = dbConn -> query(`SELECT * FROM info`);
        return from var user in userStream select user; 
    }

    resource function post newuser(NewUser newuser) returns http:Created|error
    {
        _ = check dbConn -> execute(`INSERT INTO info(first_name, last_name, birthdate) VALUES (${newuser.first_name}, ${newuser.last_name}, ${newuser.birthdate});`);
        return http:CREATED;
    }

}   

