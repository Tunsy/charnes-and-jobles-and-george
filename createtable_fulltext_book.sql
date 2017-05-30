CREATE DATABASE IF NOT EXISTS booksdb;
USE booksdb;

CREATE TABLE IF NOT EXISTS book (
	isbn INTEGER NOT NULL, -- 13 digits and 4 hyphens
    title VARCHAR(200) NOT NULL,
	year_published INTEGER NOT NULL,
    publisher VARCHAR(200) NOT NULL,
    PRIMARY KEY (isbn),
    FULLTEXT (title)
); -- 243 ROWS

CREATE TABLE IF NOT EXISTS author (
	author_id INTEGER NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE,
    photo_url VARCHAR(200),
    PRIMARY KEY (author_id)
); -- 257 ROWS

CREATE TABLE IF NOT EXISTS authored (
	isbn INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    PRIMARY KEY (isbn, author_id),
    FOREIGN KEY (isbn) REFERENCES book (isbn),
    FOREIGN KEY (author_id) REFERENCES author (author_id)
); -- 526 ROWS

CREATE TABLE IF NOT EXISTS genre (
	id INTEGER NOT NULL AUTO_INCREMENT,
    genre_name VARCHAR(200) NOT NULL,
    PRIMARY KEY (id)
); -- 48 ROWS

CREATE TABLE IF NOT EXISTS genre_in_books (
	genre_id INTEGER NOT NULL,
    isbn INTEGER NOT NULL,
    PRIMARY KEY (genre_id, isbn),
    FOREIGN KEY (genre_id) REFERENCES genre (id),
	FOREIGN KEY (isbn) REFERENCES book (isbn)
); -- 620 ROWS

CREATE TABLE IF NOT EXISTS creditcards (
	id			VARCHAR(20) NOT NULL,
    first_name	VARCHAR(50) NOT NULL,
	last_name	VARCHAR(50) NOT NULL,
    expiration	DATE NOT NULL,
    PRIMARY KEY (id)
); -- 517 ROWS

CREATE TABLE IF NOT EXISTS customers (
	id			INTEGER NOT NULL AUTO_INCREMENT, 
	first_name	VARCHAR(50) NOT NULL,
	last_name	VARCHAR(50) NOT NULL,
	cc_id		VARCHAR(20) NOT NULL,
	address		VARCHAR(200) NOT NULL,
	email		VARCHAR(50) NOT NULL,
	emailpw		VARCHAR(20) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (cc_id) REFERENCES creditcards (id)
); -- 453 ROWS

CREATE TABLE IF NOT EXISTS sales (
	id			INTEGER NOT NULL AUTO_INCREMENT,
    customer_id INTEGER NOT NULL,
    isbn		INTEGER NOT NULL,
    sale_date	DATE NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers (id),
	FOREIGN KEY (isbn) REFERENCES book (isbn)
); -- 452 ROWS
    

