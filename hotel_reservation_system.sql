
CREATE SCHEMA hotel_reservation_system; -- Creating schema called hotel_reservation_system to input tables --

USE hotel_reservation_system; -- Selecting database with the USE function --



-- Creating tables --

CREATE TABLE Customer (
customer_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE Room (
room_id INT AUTO_INCREMENT PRIMARY KEY,
room_number INT UNIQUE NOT NULL,
room_type VARCHAR(50) NOT NULL,
price_per_night DECIMAL (10,2) NOT NULL,
status ENUM ('available', 'occupied', 'maintenance') DEFAULT 'available'
);

CREATE TABLE Reservation (
reservation_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT NOT NULL,
room_id INT NOT NULL,
booking_date DATE NOT NULL,
check_in_date DATE NOT NULL,
check_out_date DATE NOT NULL,
status ENUM ('reserved', 'checked_in', 'checked_out', 'cancelled') DEFAULT 'reserved',
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE Payment (
payment_id INT AUTO_INCREMENT PRIMARY KEY,
reservation_id INT NOT NULL,
amount DECIMAL (10,2) NOT NULL,
payment_method ENUM ('card', 'cash', 'transfer') NOT NULL,
payment_date DATE NOT NULL,
payment_status ENUM ('approved', 'declined', 'pending') DEFAULT 'pending',
FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id)
);



-- Inserting data into tables --

INSERT INTO Customer (first_name, last_name, email, phone_number) 
VALUES
('Maria', 'Schmidt', 'maria.schmidt@email.com', '+491511234567'),
('James', 'Wilson', 'james.wilson@email.com', '+491522345678'),
('Sofia', 'Müller', 'sofia.mueller@email.com', '+491533456789'),
('Lucas', 'Anderson', 'lucas.anderson@gmail.com', '+491544567890'),
('David', 'Nguyen', 'david.nguyen@gmail.com', '+491510123456');

INSERT INTO Room (room_number, room_type, price_per_night, status)
VALUES
(101, 'single', 80.00, 'available'),
(102, 'double', 120.00, 'available'),
(103, 'suite', 250.00, 'available'),
(104, 'double', 130.00, 'occupied'),
(105, 'single', 85.00, 'maintenance');

INSERT INTO Reservation (customer_id, room_id, booking_date, check_in_date, check_out_date, status)
VALUES 
(1, 1, '2025-01-10', '2025-01-15', '2025-01-20', 'checked_out'),
(2, 2, '2025-02-01', '2025-02-05', '2025-02-10', 'reserved'),
(3, 3, '2025-03-01', '2025-03-10', '2025-03-15', 'cancelled'),
(4, 4, '2025-04-01', '2025-04-05', '2025-04-08', 'checked_in'),
(5, 5, '2025-05-01', '2025-05-10', '2025-05-15', 'cancelled');

INSERT INTO Payment (reservation_id, amount, payment_method, payment_date, payment_status)
VALUES
(1, 400.00, 'cash', '2025-01-20', 'approved'),
(2, 600.00, 'transfer', '2025-02-01', 'pending'),
(3, 1250.00, 'card', '2025-03-01', 'declined'),
(4, 390.00, 'card', '2025-04-05', 'pending'),
(5, 425.00, 'cash', '2025-05-01', 'declined');



-- All available rooms --

SELECT *
FROM Room
WHERE status = 'available';


-- All active reservations with customer names --

SELECT C.customer_id, C.first_name, C.last_name, R.reservation_id, R.status
FROM Customer C
JOIN Reservation R ON C.customer_id = R.customer_id
WHERE R.status IN ('reserved', 'checked_in');


-- Finding total payment that are approved --

SELECT SUM(amount) AS total
FROM Payment P
WHERE P.payment_status = 'approved';


-- All cancelled reservations 

SELECT *
FROM Reservation R
WHERE R.status = 'cancelled';


-- Updating reservation status from reserved to checked in --

UPDATE Reservation 
SET status = 'checked_in'
WHERE reservation_id = 2;


-- Removing a customer from the data table --

DELETE FROM Payment
WHERE payment_id = 5;

DELETE FROM Reservation 
WHERE reservation_id = 5;

DELETE FROM Customer
WHERE customer_id = 5;


-- Finding the total revenue of a room that has been approved --

SELECT R.room_type, SUM(P.amount) AS total_revenue
FROM Payment P
JOIN Reservation RE ON P.reservation_id = RE.reservation_id
JOIN Room R ON RE.room_id = R.room_id
WHERE P.payment_status = 'approved'
GROUP BY R.room_type
















