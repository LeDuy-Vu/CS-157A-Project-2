CREATE TABLE homeowner
(
	SSN VARCHAR(9) NOT NULL PRIMARY KEY CHECK (LENGTH(SSN) = 9 AND SSN NOT LIKE '%[^0-9]%'),
	first_name VARCHAR(20) NOT NULL,
	middle_name VARCHAR(20),
	last_name VARCHAR(20) NOT NULL,
	gender VARCHAR(9) CHECK (gender IN ('Male', 'Female', 'Nonbinary')),
	date_of_birth DATE,
	email VARCHAR(320) NOT NULL UNIQUE,
	phone VARCHAR(10) NOT NULL UNIQUE CHECK (LENGTH(phone) = 10 AND phone NOT LIKE '%[^0-9]%')
) ;

CREATE TABLE home
(
	street VARCHAR(50) NOT NULL,
	zipcode VARCHAR(5) NOT NULL CHECK (LENGTH(zipcode) = 5 AND zipcode NOT LIKE '%[^0-9]%'),
	age_year INTEGER NOT NULL CHECK (age_year > 0),
	area_meter_square INTEGER NOT NULL CHECK (area_meter_square > 0),
	SSN VARCHAR(9) NOT NULL CHECK (LENGTH(SSN) = 9 AND SSN NOT LIKE '%[^0-9]%'),
	policy_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (street, zipcode),
	FOREIGN KEY (zipcode) REFERENCES zips ON DELETE SET NULL,
	FOREIGN KEY (SSN) REFERENCES homeowner ON DELETE CASCADE,
	FOREIGN KEY (policy_name) REFERENCES policy ON DELETE SET NULL
) ;

CREATE TABLE own
(
	SSN VARCHAR(9) NOT NULL CHECK (LENGTH(SSN) = 9 AND SSN NOT LIKE '%[^0-9]%'),
	street VARCHAR(50) NOT NULL,
	zipcode VARCHAR(5) NOT NULL CHECK (LENGTH(zipcode) = 5 AND zipcode NOT LIKE '%[^0-9]%'),
	own_since DATE NOT NULL,
	PRIMARY KEY (SSN, street, zipcode),
	FOREIGN KEY (SSN) REFERENCES homeowner ON DELETE CASCADE,
	FOREIGN KEY (street) REFERENCES home ON DELETE CASCADE,
	FOREIGN KEY (zipcode) REFERENCES home ON DELETE CASCADE
) ;

CREATE TABLE policy
(
	policy_name VARCHAR(255) NOT NULL PRIMARY KEY,
	monthly_fee DECIMAL(10, 2) NOT NULL CHECK (monthly_fee > 0),
	registered_date DATE NOT NULL DEFAULT 'now',
	cover_percentage FLOAT NOT NULL CHECK (cover_percentage > 0 AND cover_percentage <= 1),
	deductible DECIMAL(10, 2) NOT NULL CHECK (deductible > 0)
);

CREATE TABLE incident
(
	remark TEXT NOT NULL DEFAULT '',
	date DATE NOT NULL,
	damage_cost DECIMAL(10, 2) NOT NULL CHECK (damage_cost > 0),
	street VARCHAR(50) NOT NULL,
	zipcode VARCHAR(5) NOT NULL CHECK (LENGTH(zipcode) = 5 AND zipcode NOT LIKE '%[^0-9]%'),
	PRIMARY KEY (street, zipcode, date),
	FOREIGN KEY (street) REFERENCES home ON DELETE CASCADE,
	FOREIGN KEY (zipcode) REFERENCES home ON DELETE CASCADE
);

CREATE TABLE payment
(
	confirmation_number VARCHAR(15) NOT NULL PRIMARY KEY,
	payment_date DATE,
	due_date DATE NOT NULL,
	payment_amount DECIMAL(10, 2) NOT NULL CHECK (payment_amount > 0),
	coverage_time_day INTEGER NOT NULL CHECK (coverage_time_day > 0),
	street VARCHAR(50) NOT NULL,
	zipcode VARCHAR(5) NOT NULL CHECK (LENGTH(zipcode) = 5 AND zipcode NOT LIKE '%[^0-9]%'),
	policy_name VARCHAR(255) NOT NULL,
	FOREIGN KEY (street) REFERENCES home ON DELETE CASCADE,
	FOREIGN KEY (zipcode) REFERENCES home ON DELETE CASCADE,
	FOREIGN KEY (policy_name) REFERENCES policy ON DELETE SET NULL
);

CREATE TABLE zips
(
	zipcode VARCHAR(5) NOT NULL PRIMARY KEY CHECK (LENGTH(zipcode) = 5 AND zipcode NOT LIKE '%[^0-9]%'),
	city VARCHAR(50) NOT NULL,
	state VARCHAR(2) NOT NULL CHECK (LENGTH(state) = 2)
) ;

INSERT INTO homeowner (SSN, first_name, middle_name, last_name, gender, date_of_birth, email, phone) VALUES
	('493829382', 'James', '', 'Born', 'Male', '1975-03-12', 'jamesborn@gmail.com', '3859374394'),
	('294857204', 'Abbey', '', 'Edward', 'Nonbinary', '1964-09-21', 'abbeyedward@gmail.com', '9348509340'),
	('934857920', 'Agena', '', 'Keiko', 'Female', '1993-05-21', 'agenakeiko@gmail.com', '9435864130'),
	('849348571', 'Alba', '', 'Jessica', 'Female', '1979-12-21', 'albajessica@gmail.com', '9483758202') ;

INSERT INTO home VALUES 
	('90 Hello Ave', '96801', 23, 100, '934857920', 'policy-2'),
	('43 Goodbye Road', '72201', 100, 200, '493829382', 'policy-2'),
	('11 Volcano Court', '06101', 1, 250, '849348571', 'policy-1'),
	('375 Corona Street', '95148', 68, 50, '493829382', 'policy-4'),
	('666 Alien Blvd', '99501', 12, 643, '294857204', 'policy-2'),
	('1024 Milkyway Ave', '30301', 53, 369, '849348571', 'policy-1'),
	('9099 Polaris Court', '20001', 71, 876, '493829382', 'policy-4') ;

INSERT INTO own (SSN, street, zipcode, own_since) VALUES
	('493829382', '90 Hello Ave', '96801', '2012-02-21'),
	('294857204', '43 Goodbye Road', '72201', '2013-07-21'),
	('934857920', '11 Volcano Court', '06101', '2014-09-21'),
	('849348571', '375 Corona Street', '95148', '2015-01-21'),
	('493829382', '666 Alien Blvd', '99501', '2013-02-21'),
	('294857204', '1024 Milkyway Ave', '30301', '2014-11-21'),
	('493829382', '9099 Polaris Court', '20001', '2016-09-21') ;

INSERT INTO policy (policy_name, monthly_fee, registered_date, cover_percentage, deductible) VALUES
	('policy-1', 100.00, '2020-01-01', 0.8, 3000.00),
	('policy-2', 120.00, '2020-01-01', 0.85, 4000.00),
	('policy-3', 150.00, '2018-12-12', 0.90, 5000.00),
	('policy-4', 175.00, '2019-03-22', 0.95, 7500.00) ;

INSERT INTO incident (remark, date, damage_cost, street, zipcode) VALUES
	('The earthquake happened and the house has been gone', '2020-02-21', 2000.00, '90 Hello Ave', '96801'),
	('The big typhoon came to my city and the roof of my house is gone.', '2020-02-22' , 4050.00, '90 Hello Ave', '96801'),
	('Tsunami has eaten everything of my house.', '2020-03-11', 10000.00, '43 Goodbye Road', '72201'),
	('Tiger ate my house.', '2020-02-23', 6000.00, '11 Volcano Court', '06101'),
	('Thunder destroyed my house', '2019-12-31', 4000.00, '375 Corona Street', '95148'),
	('Fire Fire Fire Fire Fire', '2020-04-30', 4500.00, '666 Alien Blvd', '99501') ;

INSERT INTO zips (zipcode, city, state) VALUES
	('95148', 'San Jose', 'CA'),
	('99501', 'Anchorage', 'AK'),
	('85001', 'Phoenix', 'AZ'),
	('72201', 'Little Rock', 'AR'),
	('80201', 'Denver', 'CO'),
	('06101', 'Hartford', 'CT'),
	('19901', 'Dover', 'DE'),
	('20001', 'Washington', 'DC'),
	('30301', 'Atlanta', 'GA'),
	('96801', 'Honolulu', 'HI') ;

INSERT INTO payment 
	(confirmation_number, payment_date, due_date, payment_amount, coverage_time_day, street, zipcode, policy_name)
VALUES
	('2343k43456423k4', NULL, '2020-06-21', 1000.00, 150, '90 Hello Ave', '96801', 'policy-2'),
	('2343456423k4dke', '2020-02-21', '2020-05-21', 3000.00, 90, '90 Hello Ave', '96801', 'policy-2'),
	('0543k43456423k4', NULL, '2020-08-21', 1500.00, 200, '43 Goodbye Road', '72201', 'policy-2'),
	('0543k435791k3k4', '2019-12-12', '2020-12-12', 50000.00, 365, '43 Goodbye Road', '72201', 'policy-2'),
	('0543k43556keidk', '2020-01-12', '2020-12-12', 4500.00, 330, '11 Volcano Court', '06101', 'policy-1'),
	('340294kd3432k33', '2020-03-01', '2020-06-01', 2500.00, 90, '375 Corona Street', '95148', 'policy-4'),
	('394k340m3403230', '2020-03-01', '2022-03-01', 10000.00, 730, '666 Alien Blvd', '99501', 'policy-2') ;

SELECT first_name, last_name, total_payment, total_amount FROM homeowner NATURAL JOIN 
	(SELECT SSN, COUNT(confirmation_number) AS total_payment, SUM(payment_amount) AS total_amount 
	FROM homeowner NATURAL JOIN home NATURAL JOIN payment WHERE payment_date IS NOT NULL GROUP BY SSN) ;

SELECT policy_name, COUNT(*) AS incident_num FROM policy NATURAL JOIN home NATURAL JOIN incident
	WHERE deductible < damage_cost GROUP BY policy_name ;

WITH T(policy_name, homeowner_num) AS (SELECT policy_name, COUNT(DISTINCT SSN)
	FROM homeowner NATURAL JOIN home NATURAL JOIN policy GROUP BY policy_name)
SELECT policy_name FROM T WHERE homeowner_num = (SELECT MAX(homeowner_num) AS homeowner_num FROM T) ;

SELECT first_name, last_name FROM homeowner WHERE SSN IN (SELECT DISTINCT SSN 
	FROM homeowner NATURAL JOIN home NATURAL JOIN payment WHERE payment_date IS NULL) ;

SELECT first_name, last_name, total_cost FROM homeowner NATURAL JOIN
	(SELECT SSN, SUM(damage_cost) AS total_cost FROM homeowner NATURAL JOIN home NATURAL JOIN incident GROUP BY SSN)
	ORDER BY total_cost DESC ;
