# ANSI SQL Using MySQL — CTS Exercises

## Overview
This repository contains SQL exercises completed as part of the 
Cognizant Technology Solutions (CTS) training module on 
ANSI SQL Using MySQL.

## Database Schema
The exercises are based on an Event Management System with 
the following tables:

- **Users** — Stores user information
- **Events** — Stores event details and status
- **Sessions** — Stores sessions under each event
- **Registrations** — Tracks which users registered for which events
- **Feedback** — Stores user ratings and comments for events
- **Resources** — Stores PDFs, images, and links for events

## Files
- `cts_sql_exercises.sql` — Contains:
  - Table creation scripts (DDL)
  - Sample data insertion (DML)
  - 25 SQL exercise queries with comments

## Topics Covered
- SELECT, WHERE, ORDER BY, LIMIT
- Aggregate functions (SUM, AVG, COUNT, MAX, MIN)
- GROUP BY and HAVING
- INNER JOIN, LEFT JOIN, Self Join
- Subqueries and NOT IN
- TIMESTAMPDIFF and TIME functions
- DATE functions (CURDATE, INTERVAL)
- Indexes and Constraints

## How to Run
1. Open MySQL Workbench or any MySQL client
2. Run the full `cts_sql_exercises.sql` file
3. Each query is clearly commented with its question number

## Module
CTS Training — ANSI SQL Using MySQL (2026)
