show databases;

create database GECA;
use GECA;


CREATE TABLE Employee (
  EmployeeId int,
  Name varchar(50),
  Gender varchar(10),
  Salary int,
  Department varchar(20),
  Experience int );
  
INSERT INTO Employee (EmployeeId, Name, Gender, Salary, Department, Experience)
VALUES  (1, 'Emily Johnson', 'Female', 45000, 'IT', 2),
               (2, 'Michael Smith', 'Male', 65000, 'Sales', 5),
               (3, 'Olivia Brown', 'Female', 55000, 'Marketing', 4),
               (4, 'James Davis', 'Male', 75000, 'Finance', 7),
               (5, 'Sophia Wilson', 'Female', 50000, 'IT', 3);

SELECT * FROM Employee;

SELECT SUM(Salary) AS Total_Salary
FROM Employee
HAVING SUM(Salary) >= 250000;

SELECT AVG(Salary) AS Average_Salary
FROM Employee
HAVING AVG(Salary) > 55000;

select max(salary) as max_salary
from employee
having max(salary) > 70000;


SELECT MIN(Experience) AS Min_Experience
FROM Employee
HAVING MIN(Experience) < 3;

SELECT SUM(Salary) AS Total_Salary, AVG(Salary) AS Average_Salary
FROM Employee
HAVING SUM(Salary) >= 250000 AND AVG(Salary) > 55000;
select * from employee;



    
    -- Elevate lab project task no. 6
create database Airline;
use Airline;
-- Flights Table
CREATE TABLE Flights (
    FlightID INT PRIMARY KEY AUTO_INCREMENT,
    FlightName VARCHAR(50),
    Source VARCHAR(50),
    Destination VARCHAR(50),
    FlightDate DATE,
    TotalSeats INT,
    AvailableSeats INT
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Email VARCHAR(50),
    Phone VARCHAR(15)
);

-- Bookings Table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    FlightID INT,
    SeatsBooked INT,
    BookingDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

-- Seats Table (optional for detailed seat tracking)
CREATE TABLE Seats (
    SeatID INT PRIMARY KEY AUTO_INCREMENT,
    FlightID INT,
    SeatNumber VARCHAR(5),
    IsBooked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

-- Flights
INSERT INTO Flights (FlightName, Source, Destination, FlightDate, TotalSeats, AvailableSeats)
VALUES 
('AirIndia101', 'Mumbai', 'Delhi', '2025-09-01', 150, 150),
('Indigo202', 'Delhi', 'Bangalore', '2025-09-02', 120, 120);

-- Customers
INSERT INTO Customers (Name, Email, Phone)
VALUES 
('Priyanshu', 'priyanshu@gmail.com', '9876543210'),
('Aarav', 'aarav@gmail.com', '9123456780');

-- Bookings
INSERT INTO Bookings (CustomerID, FlightID, SeatsBooked, BookingDate)
VALUES 
(1, 1, 2, '2025-08-26'),
(2, 2, 1, '2025-08-26');

-- Queries a) Check available seats for a flight
SELECT FlightName, Source, Destination, AvailableSeats
FROM Flights
WHERE FlightID = 1;

-- b) Search flights by source, destination, or date
SELECT * 
FROM Flights
WHERE Source = 'Mumbai' AND Destination = 'Delhi' AND FlightDate = '2025-09-01';

-- c) Booking summary report
SELECT B.BookingID, C.Name AS CustomerName, F.FlightName, B.SeatsBooked, B.BookingDate
FROM Bookings B
JOIN Customers C ON B.CustomerID = C.CustomerID
JOIN Flights F ON B.FlightID = F.FlightID;

-- 4. Triggers

-- a) After booking: decrease available seats
DELIMITER $$

CREATE TRIGGER AfterBooking
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Flights
    SET AvailableSeats = AvailableSeats - NEW.SeatsBooked
    WHERE FlightID = NEW.FlightID;
END $$

DELIMITER ;


-- b) After cancellation: increase available seats
CREATE TRIGGER AfterCancellation
AFTER DELETE ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Flights
    SET AvailableSeats = AvailableSeats + OLD.SeatsBooked
    WHERE FlightID = OLD.FlightID;
END;

-- 5. Flight availability view

CREATE VIEW AvailableFlights AS
SELECT FlightID, FlightName, Source, Destination, FlightDate, AvailableSeats
FROM Flights
WHERE AvailableSeats > 0;
