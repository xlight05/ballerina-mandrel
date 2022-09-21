import ballerina/http;
import ballerina/io;

listener http:Listener helloEP = new(9090);

service /helloWorld on helloEP {
    resource function get sayHello() returns string {
        io:println("here");
        return "Hello, World";
    }
}
