-- Creates new schema and drops old one if it exists
DROP SCHEMA IF EXISTS airport;

CREATE SCHEMA IF NOT EXISTS airport;

USE airport;

DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Airport;
DROP TABLE IF EXISTS Plane;
DROP TABLE IF EXISTS PhoneNumber;

-- Creates the tables
-- Holds information on individual passengers
CREATE TABLE Passenger(
 passengerID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
 firstName VARCHAR(40) NOT NULL, 
 lastName VARCHAR(40) NOT NULL, 
 age TINYINT UNSIGNED NOT NULL, 
 guardianID INT UNSIGNED, 
 CONSTRAINT fk_passenger_guardian FOREIGN KEY (guardianID) REFERENCES Passenger(passengerID) ON UPDATE CASCADE ON DELETE NO ACTION
);

-- Holds passenger phone numbers
-- Source for Check Constraint https://www.mysqltutorial.org/mysql-check-constraint/
-- Source for REGEXP https://dev.mysql.com/doc/refman/8.0/en/regexp.html
-- Source for general regex https://www.rexegg.com/regex-quickstart.html
-- Source for regex for phone number https://ihateregex.io/expr/phone/
CREATE TABLE PhoneNumber(
 phoneNo VARCHAR(13) PRIMARY KEY CHECK (phoneNo REGEXP "^[\+]?[0-9]{10,12}$"),
 passengerID INT UNSIGNED NOT NULL,
 CONSTRAINT fk_phone_passenger FOREIGN KEY (passengerID) REFERENCES Passenger(passengerID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Holds information on airports
-- Source for length function https://www.w3schools.com/sql/func_mysql_length.asp
CREATE TABLE Airport(
 airportCode VARCHAR(3) PRIMARY KEY CHECK (LENGTH(airportCode) = 3), 
 city VARCHAR(50) NOT NULL, 
 country VARCHAR(50) NOT NULL,
 runwayCount TINYINT UNSIGNED
);

-- Holds information on planes
CREATE TABLE Plane(
 planeID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
 model VARCHAR(30), 
 owner VARCHAR(30)
);

-- Holds information to do with specific flights
CREATE TABLE Flight(
 flightID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
 boardingTime DATETIME NOT NULL, 
 arrivalTime DATETIME NOT NULL, 
 assignedPlane INT UNSIGNED, 
 departingAirport VARCHAR(3) NOT NULL, 
 arrivingAirport VARCHAR(3) NOT NULL,
 CONSTRAINT fk_flight_plane FOREIGN KEY (assignedPlane) REFERENCES Plane(planeID) ON UPDATE CASCADE ON DELETE NO ACTION,
 CONSTRAINT fk_flight_departing FOREIGN KEY (departingAirport) REFERENCES Airport(airportCode) ON UPDATE CASCADE ON DELETE NO ACTION,
 CONSTRAINT fk_flight_arriving FOREIGN KEY (arrivingAirport) REFERENCES Airport(airportCode) ON UPDATE CASCADE ON DELETE NO ACTION
);

-- Holds information on flight tickets
-- Source for help with regex 1-99: https://stackoverflow.com/questions/13473523/regex-number-between-1-and-100
CREATE TABLE Ticket(
 ticketID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
 seat VARCHAR(3) NOT NULL CHECK (seat REGEXP "^[1-9][0-9]?[A-F]$"), 
 assignedPassenger INT UNSIGNED,
 assignedFlight INT UNSIGNED NOT NULL,
 CONSTRAINT fk_ticket_passenger FOREIGN KEY (assignedPassenger) REFERENCES Passenger(passengerID) ON UPDATE CASCADE ON DELETE SET NULL,
 CONSTRAINT fk_ticket_flight FOREIGN KEY (assignedFlight) REFERENCES Flight(flightID) ON UPDATE CASCADE ON DELETE CASCADE
);


-- Populates the talbes with data
INSERT INTO Passenger(firstName, lastName, age) VALUES
 ("Jack", "Murphy", 22), 
 ("Emily", "Kelly", 31),
 ("Noah", "Walsh", 47),
 ("Grace", "Smith", 86),
 ("James", "Byrne", 36),
 ("Sophie", "Ryan", 26),
 ("Charlie", "Doyle", 41),
 ("Lily", "McCarthy", 67),
 ("Liam", "Kennedy", 55),
 ("Mia", "Moore", 27);
 
INSERT INTO Passenger(firstName, lastName, age, guardianID) VALUES
 ("Tadhg", "Kelly", 7, 2), 
 ("Ellie", "Byrne", 9, 5),
 ("Fionn", "Byrne", 3, 5),
 ("Emma", "Doyle", 4, 7);
 
INSERT INTO PhoneNumber VALUES
 ("+353121470345", 1), 
 ("+353121470346", 1), 
 ("+353121470347", 1), 
 ("+353123456789", 2), 
 ("+353123456123", 2), 
 ("+353231781061", 3), 
 ("+353231781761", 3), 
 ("+353139084226", 4), 
 ("+353139084300", 4), 
 ("+353128359684", 5), 
 ("+353467572312", 6), 
 ("+353642650974", 7), 
 ("+353168880210", 8), 
 ("+353418036443", 9), 
 ("+353101627193", 10), 
 ("+353101627194", 11), 
 ("+353128359486", 12), 
 ("+353108627193", 13), 
 ("+353112347193", 14);
 
INSERT INTO Airport VALUES
 ("DUB", "Dublin", "Ireland", 3),
 ("ATL", "Atlanta", "Unites States", 5),
 ("DXB", "Garhoud", "United Arab Emirates", 2),
 ("LHR", "Hillingdon", "United Kingdom", 2),
 ("DEL", "Palam", "India", 4),
 ("AMS", "Haarlemmermeer", "Netherlands", 6);
 
 INSERT INTO Plane(model, owner) VALUES
 ("Boeing 737-800", "Ryanair"),
 ("Airbus A330-300", "Aer Lingus"),
 ("Boeing 737 MAX 8-200", "Ryanair"),
 ("Airbus A330-200", "Aer Lingus"),
 ("Airbus A321-200", "Delta Air Lines"),
 ("Boeing 737-800", "American Airlines");
 
INSERT INTO Flight(boardingTime, arrivalTime, assignedPlane, departingAirport, arrivingAirport) VALUES
 ("2023-12-15 06:00:00", "2023-12-15 14:40:00", 5, "DUB", "ATL"), 
 ("2023-12-15 20:00:00", "2023-12-16 04:00:00", 3, "LHR", "DEL"), 
 ("2023-12-16 07:30:00", "2023-12-16 23:30:00", 6, "ATL", "DXB"), 
 ("2023-12-16 09:15:00", "2023-12-16 11:00:00", 1, "AMS", "DUB"), 
 ("2023-12-16 15:00:00", "2023-12-16 16:30:00", 4, "DUB", "LHR"), 
 ("2023-12-17 22:00:00", "2023-12-18 08:50:00", 2, "DEL", "DUB");
 
INSERT INTO Ticket(seat, assignedPassenger, assignedFlight) VALUES
 ("15E", 2, 5), 
 ("15F", 11, 5),
 ("7A", 1, 1),
 ("32A", 5, 2),
 ("32B", 12, 2),
 ("32C", 13, 2),
 ("22B", 7, 4),
 ("22C", 14, 4),
 ("2C", 3, 3),
 ("9E", 4, 3),
 ("4F", 6, 3),
 ("12D", 8, 6),
 ("19B", 9, 6),
 ("23A", 10, 6);