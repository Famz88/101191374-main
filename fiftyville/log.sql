-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Checking the records of Humphrey Street on the day of the crime
SELECT description FROM crime_scene_reports
WHERE month = 7 AND day = 28 AND street = "Humphrey Street";
-- Theft took place 10:15am at the Humphrey Street bakery
-- and 3 witnesses were present on scene.
-- littering took place at 16:36 but no witnesses.

-- Read the interview transcript on that day incident
SELECT * FROM interviews WHERE month = 7 AND day = 28;
-- Ruth , Eugene and Raymond were the witnesses

-- After 10 minutes of Theft Ruth saw the thief getting in to the car in the bakery parking lot
-- and suggested to check the camera footage

-- Eugene recognized the thief because earlier morning before arrived at Emma's bakery
-- he saw the Thief withdrawing some money at ATM on Legget Street

-- Raymond heard the thief talking with someone through phone for less than a minute that they were
-- planning to take the earliest flight out of Fiftyville tomorrow and
-- the thief asked the person on call to purchase the flight ticket.

-- To check the phone records of the people who talked less than a minute during that day
SELECT * FROM phone_calls WHERE month = 7 AND day = 28 AND duration <= 60;
-- Found id 221, 224, 233, 234, 251, 254, 255, 261, 279 and 281

-- look for people with the id numbers that was found on calls

SELECT * FROM airports; -- Which i found the aiport id 8 for Fiftyville Regional Airport

SELECT * FROM flights WHERE month = 7 AND day = 29;
-- finding the flights on next day of theft
-- and dest 6 the time 16:00 / Logan Internation Airport - Boston flight id 18
-- dest 11 time 12:15 / Indira Gandhi Internation Airport - Delhi flight id 23
-- dest 4 time 8:20 / LaGuardia Aiport - New York City flight id 36
-- dest 1 time 9:30 / O'hare Internation Airport - Chicago flight id 43
-- dest 9 time 15:20 / Tokyo Internation Airport- Tokyo flight id 53

-- First flight passengers
SELECT * FROM passengers WHERE flight_id = 36;

-- Flight passengers and their full details
SELECT * FROM people JOIN passengers ON passengers.passport_number = people.passport_number WHERE flight_id = "36";

SELECT name, license_plate, phone_number FROM people JOIN passengers ON passengers.passport_number = people.passport_number WHERE flight_id = "36";

-- matching license numbers with the passengers
SELECT DISTINCT bakery_security_logs.license_plate FROM bakery_security_logs JOIN (SELECT * FROM people JOIN passengers ON passengers.passport_number = people.passport_number WHERE flight_id = "36") WHERE month = 7 AND day = 28;

-- People who made a call with less than 1 minutes on the day of theft
SELECT * FROM people JOIN phone_calls ON phone_calls.caller = people.phone_number WHERE month = 7 AND day = 28 AND duration <= 60 ORDER BY duration ASC;

-- Checking atm transactions on the day of theft
SELECT * FROM atm_transactions WHERE month = 7 AND day = 28 AND atm_location = "Leggett Street";

-- Matching the bank accounts with atm transactions
SELECT * FROM bank_accounts JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE month = 7 AND day = 28 AND atm_location = "Leggett Street";

-- Matching people with the results of bank account
SELECT * FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE month = 7 AND day = 28 AND atm_location = "Leggett Street";

SELECT name, transaction_type, phone_number, license_plate FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE month = 7 AND day = 28;

SELECT * FROM atm_transactions WHERE month = 7 AND day = 29;


SELECT * FROM people JOIN phone_calls ON phone_calls.caller = people.phone_number WHERE month = 7 AND day = 28 AND duration <= 60 INTERSECT SELECT * FROM people JOIN phone_calls ON phone_calls.caller = people.phone_number WHERE month = 7 AND day = 28 AND duration <= 60;

SELECT * FROM bakery_security_logs WHERE month = 7 AND day = 28 INTERSECT SELECT * FROM passengers WHERE month = 7 AND day = 29;

SELECT name FROM people
JOIN bank_accounts ON bank_accounts.person_id = people.id
WHERE account_number IN (
  SELECT account_number FROM atm_transactions
  WHERE atm_location = 'Leggett Street' AND year = 2021 AND month = 7 AND day = 28 AND transaction_type = 'withdraw'
);

-- Seems like it's actually Bruce its coming from all the results

SELECT * FROM people WHERE name = 'Bruce';

-- Let's double check if Bruce really is the thief
-- Bakery security logs
SELECT * FROM bakery_security_logs WHERE license_plate = (SELECT license_plate FROM people WHERE name = 'Bruce');
-- Bruce enter the at 8:23 and exit at 10:18

-- Calls
SELECT * FROM phone_calls WHERE caller = (SELECT phone_number FROM people WHERE name = 'Bruce');
-- Bruce did make a call for 45 minutes, the owner might be bad with estimating times

-- Flights
SELECT * FROM flights
JOIN passengers ON passengers.flight_id = flights.id
WHERE passengers.passport_number = (SELECT passport_number FROM people WHERE name = 'Bruce');
-- Only 1 result: 7/28 8:20 flight with id = 36, seat=4A, origin_airport_id = 8, destination_airport_id = 4

-- The destination is:
SELECT * FROM airports WHERE id = 4;

-- | 4  | LGA          | LaGuardia Airport | New York City |

-- Now let's look for his accomplice

-- So Bruce talked for 45 minutes on 7/28 with this number  (375) 555-8161
SELECT * FROM people WHERE phone_number = '(375) 555-8161';

-- We found our Thief who is Bruce and Robin his accomplice