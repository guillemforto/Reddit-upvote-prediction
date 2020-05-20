------------------------------------------------------------
-- M2 STAT ECO 2020 ASKREDDIT DATABASE - PROJECT
------------------------------------------------------------
-- author: 		guillem.forto-cornella@ut-capiole.fr
-- date:		25.02.2020
-- last mod.:		-
------------------------------------------------------------
-- Part 1: creating and populating the database
------------------------------------------------------------


------------------------------------------------------------
-- 0. CREATION OF THE .DB FILE 
------------------------------------------------------------
cd ~/Desktop -- change working directory
pwd -- print working directory
sqlite3 AskReddit_FORTO_21502168.db

/* Remark:
SQL is not case sensitive, but for clarity and readability, 
SQL commands and table names will be in capital letters, 
whereas column names will be lowercased. */



------------------------------------------------------------
-- 1. DATA DEFINITION LANGUAGE
------------------------------------------------------------

-- Before any creation, we drop the tables for the sake of coherence
-- The order of deletion is the inverse of the order of creation (see report)
DROP TABLE IF EXISTS DEPENDS;
DROP TABLE IF EXISTS REMOVED;
DROP TABLE IF EXISTS IS_DISTINGUISHED;
DROP TABLE IF EXISTS SCORE;
DROP TABLE IF EXISTS COMENT;
DROP TABLE IF EXISTS SUBREDDIT;
DROP TABLE IF EXISTS PARENT;
DROP TABLE IF EXISTS REMOVAL;
DROP TABLE IF EXISTS CONTROVERSY;
DROP TABLE IF EXISTS DISTINGUISHED;
DROP TABLE IF EXISTS AUTHOR;


-- Now we can create the tables
CREATE TABLE IF NOT EXISTS AUTHOR (
	-- columns
	author TEXT, 
	-- primary keys
	PRIMARY KEY (author)
	);

CREATE TABLE IF NOT EXISTS DISTINGUISHED (
	-- columns 
	distinguished TEXT, 
	-- primary keys
	PRIMARY KEY (distinguished)
	);
	
CREATE TABLE IF NOT EXISTS CONTROVERSY (
	-- columns 
	controversiality INT,
	-- primary key(s)
	PRIMARY KEY (controversiality)
	);

CREATE TABLE IF NOT EXISTS REMOVAL (
	-- columns 
	removal_reason TEXT,
	-- primary keys
	PRIMARY KEY (removal_reason)
	);

CREATE TABLE IF NOT EXISTS PARENT (
	-- columns 
	parent_id TEXT,
	link_id TEXT, 
	-- primary keys
	PRIMARY KEY (parent_id)
	);	

CREATE TABLE IF NOT EXISTS SUBREDDIT (
	-- columns 
	subreddit_id TEXT,
	subreddit TEXT, 
	-- primary keys
	PRIMARY KEY (subreddit_id)
	);

CREATE TABLE IF NOT EXISTS COMENT (
	-- columns 
	id TEXT,
	created_utc INT, 
	name TEXT,
	body TEXT, 
	edited TEXT, 
	author_flair_css_class TEXT,
	author_flair_text TEXT,
	author TEXT,
	controversiality INT,
	subreddit_id TEXT,
	-- primary keys
	PRIMARY KEY (id)
	-- foreign keys
	FOREIGN KEY (author) REFERENCES AUTHOR(author),
	FOREIGN KEY (controversiality) REFERENCES CONTROVERSY(controversiality),
	FOREIGN KEY (subreddit_id) REFERENCES SUBREDDIT(subreddit_id)	
	);

CREATE TABLE IF NOT EXISTS SCORE (
	-- columns 
	id TEXT,
	score INT, 
	ups INT,
	downs INT, 
	score_hidden INT, 
	gilded INT, 
	-- primary keys
	PRIMARY KEY (id),
	-- foreign keys
	FOREIGN KEY (id) REFERENCES COMENT(id)
	);

CREATE TABLE IF NOT EXISTS IS_DISTINGUISHED (
	-- columns 
	id TEXT,
	distinguished TEXT, 
	-- primary keys
	PRIMARY KEY (id, distinguished),
	-- foreign keys
	FOREIGN KEY (id) REFERENCES COMENT(id),
	FOREIGN KEY (distinguished) REFERENCES DISTINGUISHED(distinguished)	
	);	
	
CREATE TABLE IF NOT EXISTS REMOVED (
	-- columns 
	id TEXT,
	removal_reason TEXT, 
	-- primary keys
	PRIMARY KEY (id, removal_reason),
	-- foreign keys
	FOREIGN KEY (id) REFERENCES coment(id), 
	FOREIGN KEY (removal_reason) REFERENCES REMOVAL(removal_reason)
	);

CREATE TABLE IF NOT EXISTS DEPENDS (
	-- columns 
	id TEXT,
	parent_id TEXT, 
	-- primary keys
	PRIMARY KEY (id, parent_id),
	-- foreign keys
	FOREIGN KEY (id) REFERENCES COMENT(id),
	FOREIGN KEY (parent_id) REFERENCES PARENT(parent_id)		
	);


-- sanity check
.tables



------------------------------------------------------------
-- 2. DATA IMPORTATION FROM .csv 
------------------------------------------------------------

-- Remark: the .csv file must in the same directory as the .db file
DROP TABLE IF EXISTS MAY2015;
CREATE TABLE IF NOT EXISTS MAY2015 (
	-- columns
	author, distinguished, controversiality, removal_reason, score, ups, downs, score_hidden, gilded, parent_id, link_id, subreddit_id, subreddit, id, created_utc, name, body, edited, author_flair_css_class, author_flair_text
	);
.mode csv
.import exp_askreddit.csv MAY2015

-- Let's check that the importation was successfull
.header on
.mode column
pragma table_info('MAY2015'); -- no NULL values, and everything is in TEXT format



------------------------------------------------------------
-- 3. DATA CLEANING
------------------------------------------------------------

/* Before inserting the data from the .csv file to our tables, we apply some filters to meet weight constraints */
-- Once imported, every column is in TEXT type. That's why we put quotation marks.

-- Filters
DELETE FROM MAY2015 WHERE gilded = '0'; -- 4231979 lines removed
DELETE FROM MAY2015 WHERE score_hidden = '1'; -- 2 lines removed
DELETE FROM MAY2015 WHERE edited != '0'; -- we delete edited comments


-- Check how many lines left in MAY2015
SELECT COUNT(*) AS total_nb_lines FROM MAY2015; -- 2033 lines left


-- Now let's spot the columns with empty strings (we print the first 5 rows)
.header on
.mode column
SELECT id, author, removal_reason, author_flair_text, author_flair_css_class, distinguished FROM MAY2015
LIMIT 5;

-- removal_reason, author_flair_text, author_flair_css_class have empty strings
-- Let's count how many do they have each
SELECT COUNT(*) FROM MAY2015 WHERE removal_reason = '';
SELECT COUNT(*) FROM MAY2015 WHERE author_flair_text = '';
SELECT COUNT(*) FROM MAY2015 WHERE author_flair_css_class = '';
SELECT COUNT(*) FROM MAY2015 WHERE distinguished = '';


-- We need to be careful in the following part (4) not to leave a table completely empty



------------------------------------------------------------
-- 4. DATA MANIPULATION LANGUAGE
------------------------------------------------------------

-- Removing data from the tables, for data coherence
DELETE FROM DEPENDS;
DELETE FROM REMOVED;
DELETE FROM IS_DISTINGUISHED; 
DELETE FROM SCORE;
DELETE FROM COMENT;
DELETE FROM SUBREDDIT;
DELETE FROM PARENT;
DELETE FROM REMOVAL;
DELETE FROM CONTROVERSY;
DELETE FROM DISTINGUISHED;
DELETE FROM AUTHOR;


-- Now we can insert
INSERT INTO AUTHOR (author)
SELECT DISTINCT(author)
FROM MAY2015;

INSERT INTO DISTINGUISHED (distinguished)
SELECT DISTINCT(distinguished)
FROM MAY2015;

INSERT INTO CONTROVERSY (controversiality)
SELECT DISTINCT(controversiality)
FROM MAY2015;

INSERT INTO REMOVAL (removal_reason)
VALUES ('undef');

INSERT INTO PARENT (parent_id, link_id)
SELECT DISTINCT(parent_id), link_id
FROM MAY2015;

INSERT INTO SUBREDDIT (subreddit_id, subreddit)
SELECT DISTINCT(subreddit_id), subreddit
FROM MAY2015;

INSERT INTO COMENT (id, created_utc, name, body, edited, author_flair_css_class, author_flair_text, author, controversiality, subreddit_id)
SELECT id, CAST(created_utc AS INTEGER), name, body, edited, author_flair_css_class, author_flair_text, author, controversiality, subreddit_id
FROM MAY2015;

INSERT INTO SCORE (id, score, ups, downs, score_hidden, gilded)
SELECT id, CAST(score AS INTEGER), CAST(ups AS INTEGER), CAST(downs AS INTEGER), CAST(score_hidden AS INTEGER), CAST(gilded AS INTEGER)
FROM MAY2015;

INSERT INTO IS_DISTINGUISHED (id, distinguished)
SELECT id, CAST(distinguished AS INTEGER)
FROM MAY2015;

INSERT INTO REMOVED (id, removal_reason)
SELECT DISTINCT(id), removal_reason
FROM MAY2015;

INSERT INTO DEPENDS (id, parent_id)
SELECT DISTINCT(id), parent_id
FROM MAY2015;

DROP TABLE IF EXISTS MAY2015;


-- How many lines per table?
SELECT COUNT(*) FROM AUTHOR;
SELECT COUNT(*) FROM DISTINGUISHED;
SELECT COUNT(*) FROM CONTROVERSY;
SELECT COUNT(*) FROM REMOVAL;
SELECT COUNT(*) FROM PARENT;
SELECT COUNT(*) FROM SUBREDDIT;
SELECT COUNT(*) FROM COMENT;
SELECT COUNT(*) FROM SCORE;
SELECT COUNT(*) FROM IS_DISTINGUISHED;
SELECT COUNT(*) FROM REMOVED;
SELECT COUNT(*) FROM DEPENDS;


------------------------------------------------------------
-- 5. MAKING SURE EVERYTHING IS FINE
------------------------------------------------------------
SELECT * FROM AUTHOR LIMIT 5;
SELECT * FROM DISTINGUISHED;
SELECT * FROM CONTROVERSY;
SELECT * FROM REMOVAL;
SELECT * FROM PARENT LIMIT 5;
SELECT * FROM SUBREDDIT;
SELECT id, created_utc, name, edited, author_flair_css_class, author_flair_text, author, controversiality, subreddit_id
FROM COMENT LIMIT 5;
SELECT * FROM SCORE LIMIT 5;
SELECT * FROM IS_DISTINGUISHED LIMIT 5;
SELECT * FROM REMOVED LIMIT 5;
SELECT * FROM DEPENDS LIMIT 5;

-- to save space
VACUUM;


-- Exiting sqlite3
.exit


