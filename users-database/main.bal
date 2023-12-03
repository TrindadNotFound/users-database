import ballerina/io;
import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

mysql:Client|sql:Error dbConn = check new("hostname", "username", "password", "dataBase");

public function main() {
    io:println("Hello, World!");
}
