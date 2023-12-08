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
    //Get all users
    resource function get getusers() returns User[]|error
    {
        stream<User, sql:Error?> userStream = dbConn -> query(`SELECT * FROM info`);
        return from var user in userStream select user; 
    }

    //Get user by ID
    resource function get user/[int id]() returns User|error {
        User|sql:Error result = dbConn -> queryRow(`SELECT * FROM info WHERE id=${id}`);
        return result;
    }

    //Create a new user
    resource function post newuser(NewUser newuser) returns http:Created|error
    {
        _ = check dbConn -> execute(`INSERT INTO info(first_name, last_name, birthdate) VALUES (${newuser.first_name}, ${newuser.last_name}, ${newuser.birthdate});`);
        return http:CREATED;
    }

    //Update user
    resource function patch updateuser(User user)returns User|error {
        
        _ = check dbConn -> execute(`UPDATE info SET first_name=${user.first_name},last_name=${user.last_name},birthdate=${user.birthdate} WHERE id=${user.id}`);
        return user;
    }
}   

