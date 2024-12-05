create database chatsystem;

use chatsystem;
-- 1. Creating Tables

CREATE TABLE organization (
  id INT primary key auto_increment,
  name VARCHAR(40) NOT NULL
);

CREATE TABLE channel (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(40) NOT NULL,
  organization_id INT,
  FOREIGN KEY (organization_id) REFERENCES organization(id)
);


CREATE TABLE user (
  id INT primary key auto_increment,
  name VARCHAR(40) NOT NULL
);


CREATE TABLE message (
  id INT PRIMARY KEY AUTO_INCREMENT,
  post_time DATETIME NOT NULL,
  content TEXT NOT NULL,
  user_id INT NOT NULL,
  channel_id INT NOT NULL, -- Add this column
  FOREIGN KEY (user_id) REFERENCES user(id),
  FOREIGN KEY (channel_id) REFERENCES channel(id)
);



CREATE TABLE user_channel (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  channel_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES user(id),
  FOREIGN KEY (channel_id) REFERENCES channel(id)
);

select * from message;



-- 4 insert queries

insert into organization values(01,'Lambda School');
insert into user values(01,'Alice'),(02,'Bob'),(03,'Chris');
insert into channel values(1, '#general', 1), (2, '#random', 1);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES
('2024-12-05 10:00:00', 'Hello everyone!', 1, 1), 
('2024-12-05 10:05:00', 'Hi Alice!', 2, 1), 
('2024-12-05 10:10:00', 'Good morning!', 3, 1), 
('2024-12-05 10:15:00', 'Welcome to the random channel.', 1, 2), 
('2024-12-05 10:20:00', 'Thanks, Alice!', 3, 2), 
('2024-12-05 10:25:00', 'This channel looks cool.', 2, 2), 
('2024-12-05 10:30:00', 'How are you all?', 1, 1), 
('2024-12-05 10:35:00', 'Doing great, Alice!', 2, 1), 
('2024-12-05 10:40:00', 'Let’s schedule a meeting.', 1, 1), 
('2024-12-05 10:45:00', 'Sure, sounds good!', 1, 1);


INSERT INTO user_channel (user_id, channel_id) VALUES
(1, 1), 
(1, 2), 
(2, 1), 
(3, 2); 





-- 5 select queries



-- List all organization names.

SELECT name FROM organization;

-- List all channel names.

SELECT name FROM channel;

-- List all channels in a specific organization by organization name.

SELECT name 
FROM channel 
WHERE organization_id = (SELECT id FROM organization WHERE name = 'Lambda School');

-- List all messages in a specific channel by channel name #general in order of post_time, descending.

SELECT content, post_time 
FROM message 
WHERE channel_id = (SELECT id FROM channel WHERE name = '#general')
ORDER BY post_time DESC;

-- List all channels to which user Alice belongs.

SELECT channel_id 
FROM user_channel 
WHERE user_id = (SELECT id FROM user WHERE name = 'Alice');

-- List all users that belong to channel #general.

SELECT user_id 
FROM user_channel 
WHERE channel_id = (SELECT id FROM channel WHERE name = '#general');

-- List all messages in all channels by user Alice.

select content,post_time from message
where user_id=(select id from user where name='Alice');

-- List all messages in #random by user Bob.

select content from message 
where user_id=(select id from user where name='Bob') 
and channel_id=(select id from channel where name='#random');


-- List the count of messages across all channels per user. (Hint: COUNT, GROUP BY.)

select u.name, count(m.content) from user u join message m 
where u.id=m.user_id group by m.user_id;


--  List the count of messages per user per channel.

SELECT u.name, c.name AS channel_name, COUNT(m.content) AS message_count
FROM user u
JOIN message m ON u.id = m.user_id
JOIN channel c ON m.channel_id = c.id
GROUP BY u.id, c.id;



-- To automatically delete all messages when a user is deleted, use a foreign key constraint with ON DELETE CASCADE.
-- Define a foreign key from the message table to the user table.
-- Use ON DELETE CASCADE to automatically delete related messages when a user is removed.
-- This ensures that deleting a user removes all their messages from the message table.






