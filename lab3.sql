CREATE table country (
  id INT NOT NULL,
  name char(100) NOT NULL,
  PRIMARY KEY(id) );

CREATE TABLE university (
  id INT NOT NULL,
  name char(100) NOT NULL,
  state char(2),
  PRIMARY KEY(id)
);

CREATE TABLE author (
  id INT NOT NULL AUTO_INCREMENT,
  LN char(100) NOT NULL,
  FN char(100),
  MI char(1),
  cid INT,
  uid INT,
  FOREIGN KEY(cid) REFERENCES country(id),
  FOREIGN KEY(uid) REFERENCES university(id),
  PRIMARY KEY(id)
);

INSERT INTO country VALUES(1, "USA");
INSERT INTO country VALUES(2, "CANADA");

SELECT * FROM country;

INSERT INTO university VALUES(1, "Calstate LA", "CA");
INSERT INTO university VALUES(2, "MIT", "MA");
INSERT INTO university VALUES(3, "University of Idaho", "ID");

INSERT INTO author VALUES(1, "Smith", "Michael", "W", 1, 1);
INSERT INTO author VALUES(NULL, "Badger", "Honey", NULL, 2, 3);

INSERT INTO author VALUES(2, "Bond", "Jimmy", "K", 2, 3); -- epic failure because Primary Key 2 already exist
INSERT INTO author VALUES(NULL, "Bond", "Jimmy", "K", 5, 3); -- epic failure because foreign key 5 is not there

INSERT INTO author VALUES(NULL, "Bond", "Jimmy", "JW", 2, 3); -- epic failure because MI is too big
INSERT INTO author VALUES(NULL, "Bond", "Michael", "W", 2, 3);
