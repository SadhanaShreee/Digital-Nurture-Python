CREATE DATABASE IF NOT EXISTS cts_events;
USE cts_events;

CREATE TABLE Users (
    user_id           INT PRIMARY KEY AUTO_INCREMENT,
    full_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(100) UNIQUE NOT NULL,
    city              VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL
);
-- 2. Events Table
CREATE TABLE Events (
    event_id     INT PRIMARY KEY AUTO_INCREMENT,
    title        VARCHAR(200) NOT NULL,
    description  TEXT,
    city         VARCHAR(100) NOT NULL,
    start_date   DATETIME NOT NULL,
    end_date     DATETIME NOT NULL,
    status       ENUM('upcoming', 'completed', 'cancelled'),
    organizer_id INT,
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);
 
-- 3. Sessions Table
CREATE TABLE Sessions (
    session_id   INT PRIMARY KEY AUTO_INCREMENT,
    event_id     INT,
    title        VARCHAR(200) NOT NULL,
    speaker_name VARCHAR(100) NOT NULL,
    start_time   DATETIME NOT NULL,
    end_time     DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
 
-- 4. Registrations Table
CREATE TABLE Registrations (
    registration_id   INT PRIMARY KEY AUTO_INCREMENT,
    user_id           INT,
    event_id          INT,
    registration_date DATE NOT NULL,
    FOREIGN KEY (user_id)  REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
 
-- 5. Feedback Table
CREATE TABLE Feedback (
    feedback_id   INT PRIMARY KEY AUTO_INCREMENT,
    user_id       INT,
    event_id      INT,
    rating        INT CHECK (rating BETWEEN 1 AND 5),
    comments      TEXT,
    feedback_date DATE NOT NULL,
    FOREIGN KEY (user_id)  REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
 
-- 6. Resources Table
CREATE TABLE Resources (
    resource_id   INT PRIMARY KEY AUTO_INCREMENT,
    event_id      INT,
    resource_type ENUM('pdf', 'image', 'link'),
    resource_url  VARCHAR(255) NOT NULL,
    uploaded_at   DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- Users
INSERT INTO Users (full_name, email, city, registration_date) VALUES
('Alice Johnson', 'alice@example.com', 'New York',    '2024-12-01'),
('Bob Smith',     'bob@example.com',   'Los Angeles', '2024-12-05'),
('Charlie Lee',   'charlie@example.com','Chicago',    '2024-12-10'),
('Diana King',    'diana@example.com', 'New York',    '2025-01-15'),
('Ethan Hunt',    'ethan@example.com', 'Los Angeles', '2025-02-01');
 
-- Events
INSERT INTO Events (title, description, city, start_date, end_date, status, organizer_id) VALUES
('Tech Innovators Meetup',    'A meetup for tech enthusiasts.',          'New York',    '2025-06-10 10:00:00', '2025-06-10 16:00:00', 'upcoming',  1),
('AI & ML Conference',        'Conference on AI and ML advancements.',   'Chicago',     '2025-05-15 09:00:00', '2025-05-15 17:00:00', 'completed', 3),
('Frontend Development Bootcamp', 'Hands-on training on frontend tech.', 'Los Angeles', '2025-07-01 10:00:00', '2025-07-03 16:00:00', 'upcoming',  2);
 
-- Sessions
INSERT INTO Sessions (event_id, title, speaker_name, start_time, end_time) VALUES
(1, 'Opening Keynote',      'Dr. Tech',      '2025-06-10 10:00:00', '2025-06-10 11:00:00'),
(1, 'Future of Web Dev',    'Alice Johnson', '2025-06-10 11:15:00', '2025-06-10 12:30:00'),
(2, 'AI in Healthcare',     'Charlie Lee',   '2025-05-15 09:30:00', '2025-05-15 11:00:00'),
(3, 'Intro to HTML5',       'Bob Smith',     '2025-07-01 10:00:00', '2025-07-01 12:00:00');
 
-- Registrations
INSERT INTO Registrations (user_id, event_id, registration_date) VALUES
(1, 1, '2025-05-01'),
(2, 1, '2025-05-02'),
(3, 2, '2025-04-30'),
(4, 2, '2025-04-28'),
(5, 3, '2025-06-15');
 
-- Feedback
INSERT INTO Feedback (user_id, event_id, rating, comments, feedback_date) VALUES
(3, 2, 4, 'Great insights!',    '2025-05-16'),
(4, 2, 5, 'Very informative.',  '2025-05-16'),
(2, 1, 3, 'Could be better.',   '2025-06-11');
 
-- Resources
INSERT INTO Resources (event_id, resource_type, resource_url, uploaded_at) VALUES
(1, 'pdf',   'https://portal.com/resources/tech_meetup_agenda.pdf', '2025-05-01 10:00:00'),
(2, 'image', 'https://portal.com/resources/ai_poster.jpg',          '2025-04-20 09:00:00'),
(3, 'link',  'https://portal.com/resources/html5_docs',             '2025-06-25 15:00:00');

-- Q1. User Upcoming Events
-- Show upcoming events a user is registered for in their city,sorted by start date.
select u.full_name, u.city,e.title,e.start_date,e.status
from Users u
join Registrations r on u.user_id = r.user_id
join Events e on e.event_id = r.event_id
where e.status = 'upcoming' and e.city = u.city
order by e.start_date;
-- Q2 
select e.title,e.event_id,AVG(f.rating),COUNT(f.feedback_id)
from Events e
join Feedback f on e.event_id = f.event_id
group by e.title,e.event_id
having COUNT(f.feedback_id) >=10
order by AVG(f.rating) DESC;

-- Q3 
select u.full_name,u.user_id
from Users u
where u.user_id not in (select user_id from Registrations where registration_date >= curdate() - interval 90 day);

-- Q4
select e.title, COUNT(*) AS session_count
from Sessions s
join Events e on e.event_id = s.event_id
where time(s.start_time) >= '10:00:00' and time(s.start_time) < '12:00:00'
group by e.title;

-- Q5
select u.city, COUNT(distinct u.user_id) as distinct_users
from Users u
join Registrations r on r.user_id = u.user_id
group by u.city
order by distinct_users desc limit 5;

-- Q6
select e.title , sum(r.resource_type = 'pdf') as pdf_count, sum(r.resource_type = 'image') as image_count, 
		sum(r.resource_type = 'link') as link_count, count(*) as total_count
from Resources r
join Events e on r.event_id = e.event_id
group by e.title;

-- Q7
select u.full_name,f.comments,e.title
from Feedback f
join Users u on u.user_id = f.user_id
join Events e on e.event_id = f.event_id
where f.rating < 3;

-- Q8 
select e.event_id, e.title, count(s.session_id) as session_count
from Events e
left join Sessions s on s.event_id = e.event_id
where e.status = 'upcoming'
group by e.event_id,e.title;

-- Q9
select u.full_name as organizer_name,e.status, count(*) as event_count
from Events e
join Users u on u.user_id = e.organizer_id
group by u.full_name,e.organizer_id,e.status;

-- Q10
select distinct e.event_id,e.title
from Events e
where e.event_id in (select event_id from Registrations r) and e.event_id not in(select event_id from Feedback);

-- Q11 
select registration_date , count(*) as users_count
from Registrations 
where registration_date >= curdate() - interval 7 day
group by registration_date;

-- Q12
SELECT e.title, COUNT(s.session_id) AS session_count
FROM Events e
JOIN Sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title
ORDER BY session_count DESC
LIMIT 1;
-- Q13
select e.city, avg(f.rating) as avg_ratings
from Events e
join Feedback f on f.event_id = e.event_id
group by e.city
order by avg_ratings desc;

-- Q14
select e.title, count(r.registration_id) as total_registrations
from Events e
join Registrations r on r.event_id = e.event_id
group by e.title,e.event_id
order by total_registrations desc limit 3;

-- Q15
select s1.event_id , s1.title as session_1, s2.title as session_2, s1.start_time as s1_st , s1.end_time as s1_et, s2.start_time as s2_st, s2.end_time as s2_et
from Sessions s1
join Sessions s2 on s1.event_id = s2.event_id and s1.event_id < s2.event_id
where s1.start_time < s2.end_time and s1.end_time > s2.start_time;

-- Q16
select full_name,user_id,registration_date
from Users u
where registration_date >= curdate() -interval 30 day and user_id not in (select user_id from Registrations);

-- Q17
select speaker_name, count(*) as session_count
from Sessions
group by speaker_name
having count(*) >1;


-- Q18
select e.event_id,e.title
from Events e
Left join Resources r on e.event_id = r.event_id
where r.resource_type is null;

-- Q19 
select e.event_id,e.title, count(distinct r.registration_id) as tot_reg, avg(f.rating) as avg_rating
from Events e 
left join Registrations r on r.event_id = e.event_id
left join Feedback f on f.event_id = e.event_id
where e.status = 'completed'
group by e.event_id,e.title;

-- Q20
select u.user_id,u.full_name, count(distinct r.event_id) as events_reg, count(distinct f.feedback_id) tot_feedback
from users u
left join Registrations r on r.user_id = u.user_id
left join Feedback f on f.user_id = u.user_id
group by u.user_id,u.full_name; 

-- Q21
select u.full_name,count(f.feedback_id) as tot_fed
from Users u
join Feedback f on f.user_id = u.user_id
group by u.full_name
order by tot_fed desc limit 5;

-- Q22
select user_id,event_id,count(registration_id) as tot_reg
from Registrations 
group by user_id,event_id
having tot_reg > 1;

-- Q23
select year(registration_date) as reg_year, month(registration_date) as reg_mon,count(registration_id) as tot_reg
from Registrations
where registration_date >= curdate() - interval 12 month
group by year(registration_date), month(registration_date)
order by reg_year,reg_mon;

-- Q24 
select e.title, avg(timestampdiff(minute, s.start_time,s.end_time)) as avg_timestamp
from Sessions s
join Events e on e.event_id = s.event_id
group by e.event_id,e.title;

-- Q25
select e.title,e.event_id
from Events e
left join Sessions s on s.event_id = e.event_id
where s.session_id is null;