USE airport;
/*
Basic Search Queries
Here are the searches for the most fundamental information
*/

-- Query to see all passengers
SELECT regular.passengerID AS "Passenger ID", 
       CONCAT(regular.firstName, " ", regular.lastName) AS "Passenger Name",
       regular.age AS "Age", 
       guardian.passengerID AS "Guardian ID",
       CONCAT(guardian.firstName, " ", guardian.lastName) AS "Guardian Name"
FROM passenger regular
LEFT JOIN passenger guardian ON guardian.passengerID = regular.guardianID
ORDER BY regular.passengerID;

-- Query to see passenger phone numbers
SELECT passenger.passengerID AS "Passenger ID", 
       CONCAT(firstName, " ", lastName) AS "Name", 
       phoneNo AS "Phone Number"
FROM PhoneNumber 
JOIN passenger ON PhoneNumber.passengerID = passenger.passengerID
ORDER BY passenger.passengerID;

-- Query for passenger to see their ticket
-- Source for help with recursive join https://stackoverflow.com/questions/70140169/sql-select-statement-on-1m-recursive-relationship
SELECT ticketID AS "Ticket ID", 
	   flightID AS "Flight ID",
	   CONCAT(firstName, " ", lastName) AS "Passenger Name",
       seat AS "Seat",
       CONCAT(departing.city) AS "Departing From",
       DATE_FORMAT(boardingTime, "%a, %D %b") AS "Date",
       DATE_FORMAT(boardingTime, "%H:%i") AS "Boarding Time",
       CONCAT(arriving.city) AS "Arriving At",
       DATE_FORMAT(arrivalTime, "%H:%i") AS "Arrival Time"
FROM ticket
JOIN passenger ON ticket.assignedPassenger = passenger.passengerID
JOIN flight ON ticket.assignedflight = flight.flightID
JOIN airport departing ON flight.departingAirport = departing.airportCode
JOIN airport arriving ON flight.arrivingAirport = arriving.airportCode
ORDER BY ticketID;

-- Query to see flight information
SELECT flightID AS "Flight ID",
       CONCAT(departing.city, ", ", departing.country) AS "Departing From",
       DATE_FORMAT(boardingTime, "%a, %D %b %Y") AS "Date",
       DATE_FORMAT(boardingTime, "%H:%i") AS "Boarding Time",
       CONCAT(arriving.city, ", ", arriving.country) AS "Arriving At",
       DATE_FORMAT(arrivalTime, "%H:%i") AS "Arrival Time",
       TIME_FORMAT(TIMEDIFF(arrivalTime, boardingTime), "%khr %imin") AS "Flight Time"
FROM flight
JOIN airport departing ON flight.departingAirport = departing.airportCode
JOIN airport arriving ON flight.arrivingAirport = arriving.airportCode
ORDER BY flightID;

-- Query to see airport information
SELECT airportCode AS "IATA Code", 
       city AS "City", 
       country AS "Country", 
       runwayCount AS "Runway Count"
FROM airport
ORDER BY airportCode;

-- Query to see plane information
SELECT planeID AS "Plane ID", model AS "Model", owner AS "Owner"
FROM plane
ORDER BY planeID;

/*
Specific Searches
Here are more specific searches which could be used to find certain more particular information or for statistical analysis
*/
-- Query to see all guardians and children
SELECT guardian.passengerID AS "Guardian ID", 
       CONCAT(guardian.firstName, " ", guardian.lastName) AS "Guardian Name",
       child.passengerID AS "Child ID", 
       CONCAT(child.firstName, " ", child.lastName) AS "Child Name"
FROM passenger guardian
JOIN passenger child ON child.guardianID = guardian.passengerID
ORDER BY guardian.passengerID;

-- Query to count how many passengers there are on each flight
SELECT flightID AS "Flight ID", 
       COUNT(ticket.assignedPassenger) AS "Number of Passengers"
FROM flight
JOIN ticket ON ticket.assignedflight = flight.flightID
GROUP BY flightID
ORDER BY flightID;

-- Query to see flights over 10 hours
SELECT flightID AS "Flights Longer Than 10 Hours"
FROM flight
WHERE TIMEDIFF(arrivalTime, boardingTime) > "10:00:00"
ORDER BY flightID;

-- Query to see flights to Europe
SELECT flightID AS "Flights to Europe", 
       departing.country AS "Departing From", 
       arriving.country AS "Arriving At"
FROM flight
JOIN airport departing ON flight.departingAirport = departing.airportCode
JOIN airport arriving ON flight.arrivingAirport = arriving.airportCode
WHERE arriving.country IN ("Ireland", "United Kingdom", "Netherlands")
ORDER BY flightID;

-- Query to see passengers by age group (middle aged)
SELECT passengerID AS "Middle Aged Passengers", 
       CONCAT(firstName, " ", lastName) AS "Passenger Name", 
       age AS "Age"
FROM passenger
WHERE age BETWEEN 35 AND 60
ORDER BY passengerID;

-- Query to see planes made by Boeing
SELECT planeID AS "Planes Made by Boeing", 
	   model AS "Model", 
       owner AS "Owner"
FROM plane
WHERE model LIKE "Boeing%"
ORDER BY planeID;

-- Flights flown primarily by young people
SELECT flightID AS "Flights Popular with Young People", 
	   ROUND(AVG(passenger.age)) AS "Average Age of Passenger",
       CONCAT(departing.city, ", ", departing.country) AS "Departing From",
       CONCAT(arriving.city, ", ", arriving.country) AS "Arriving At"
FROM flight
JOIN ticket ON flight.flightID = ticket.assignedflight 
JOIN passenger ON ticket.assignedPassenger = passenger.passengerID
JOIN airport departing ON flight.departingAirport = departing.airportCode
JOIN airport arriving ON flight.arrivingAirport = arriving.airportCode
GROUP BY flightID HAVING AVG(passenger.age) <= 25
ORDER BY flightID;

-- Query to get the phone numbers of a specific passenger (Jack Murphy)
SELECT phoneNo AS "Jack Murphies Phone Numbers"
FROM PhoneNumber 
JOIN passenger ON PhoneNumber.passengerID = passenger.passengerID
Where firstName LIKE "Jack" AND lastName LIKE "Murphy"
ORDER BY phoneNo;