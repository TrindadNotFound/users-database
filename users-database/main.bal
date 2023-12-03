import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

mysql:Client|sql:Error dbConn = check new("hostname", "username", "password", "dataBase");

service / on new http:Listener(9090) 
{
    //Let's code !!!    
}

