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
    string firstName;
    string lastName;
    time:Date birthdate;
|};


service /users on new http:Listener(9090) 
{
    resource function get getusers() returns User[]|error
    {
        stream<User, sql:Error?> userStream = dbConn -> query(`SELECT * FROM info`);
        return from var user in userStream select user; 
    }
}   

