------------------------------------------------------------
-- M2 STAT ECO 2020 ASKREDDIT DATABASE - PROJECT
------------------------------------------------------------
-- author: 		guillem.forto-cornella@ut-capiole.fr
-- date:		25.02.2020
-- last mod.:		-
------------------------------------------------------------
-- Part 2: Exploring the database using SQL
------------------------------------------------------------

------------------------------------------------------------
-- 0. READING the .sqlite file
------------------------------------------------------------
cd ~/Desktop -- change working directory
pwd -- print working directory
sqlite3 -- enables sqlite commands

.open askreddit.sqlite
.tables

.header on
.mode column
pragma table_info('author');
pragma table_info('depends');
pragma table_info('parent');
pragma table_info('score');
pragma table_info('comment');
pragma table_info('distinguished');
pragma table_info('removal');
pragma table_info('subreddit');
pragma table_info('controversy');
pragma table_info('is_distinguished');
pragma table_info('removed');


------------------------------------------------------------
-- 1. BASIC QUERIES
------------------------------------------------------------
-- NUMBER OF ROWS IN EACH TABLE
SELECT count(*) FROM author; -- 570 735
SELECT count(*) FROM depends; -- 4 234 970
SELECT count(*) FROM parent; -- 1 464 558
SELECT count(*) FROM score; -- 4 234 970
SELECT count(*) FROM comment; -- 4 234 970
SELECT count(*) FROM distinguished; -- 3
SELECT count(*) FROM removal; -- 1
SELECT count(*) FROM subreddit; -- 1
SELECT count(*) FROM controversy; -- 2
SELECT count(*) FROM is_distinguished; -- 4 234 970
SELECT count(*) FROM removed; -- 4 234 970

-- READABLE STATISTICS
-- SCORE table
-- stats
SELECT round(avg(score), 2) as avg_score, max(score) as max_score, min(score) as min_score
FROM score;

-- downs
SELECT * FROM score LIMIT 5;
SELECT count(downs) FROM score where downs=0; -- downs is always 0
SELECT count(score) FROM score where ups=score; -- ups and score are identical

-- gilded
SELECT max(gilded), min(gilded) from score; - from 0 to 12

-- COMMENT table
SELECT 	datetime(min(created_utc), 'unixepoch') as first_publication_time, 
	datetime(max(created_utc), 'unixepoch') as last_publication_time
FROM comment;

SELECT round(avg(length(body)),2) as avg_comment_length,
	max(length(body)) as max_comment_length,
	min(length(body)) as min_comment_length
FROM comment;


-- DISTINGUISHED table
SELECT count(distinguished) as nb_moderator_comments
FROM is_distinguished
WHERE distinguished = 'moderator'; -- 39 760

SELECT count(distinguished) as nb_special_comments
FROM is_distinguished
WHERE distinguished = 'special'; -- 4





