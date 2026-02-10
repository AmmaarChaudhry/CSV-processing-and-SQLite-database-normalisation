DROP TABLE IF EXISTS student_info;
DROP TABLE IF EXISTS  enrolment;
DROP TABLE IF EXISTS lecturer_assignment;
DROP TABLE IF EXISTS module;
DROP TABLE IF EXISTS "faculties pk";
DROP TABLE IF EXISTS lecturers;
DROP TABLE IF EXISTS buildings;
DROP TABLE IF EXISTS lecturer_room;


CREATE TABLE IF NOT EXISTS "student_info"(
"student firstname" TEXT,
"student surname" TEXT,
"student id" INTEGER PRIMARY KEY,
"student email" TEXT,
"year" INTEGER,
"address" TEXT,
"contact number" TEXT
);

CREATE TABLE IF NOT EXISTS "enrolment"(
"student id" INTEGER,
"module id" TEXT,
"module name" TEXT,
"leader" TEXT,
"assesment" TEXT,
"score" INT,
PRIMARY KEY("student id","module id", assesment)
);

CREATE TABLE IF NOT EXISTS "lecturer_assignment"(
"lecturer" TEXT,
"module id" TEXT,
"module name" TEXT,
"leader" TEXT,
PRIMARY KEY("lecturer", "module id")
);

INSERT OR IGNORE INTO lecturer_assignment ("lecturer", "module id", "module name", "leader")
SELECT "lecturer1", "module id", "module name", "leader"
FROM students
WHERE lecturer1 IS NOT NULL;

INSERT OR IGNORE INTO lecturer_assignment ("lecturer", "module id", "module name", "leader")
SELECT "lecturer2", "module id", "module name", "leader"
FROM students
WHERE lecturer2 IS NOT NULL;

INSERT OR IGNORE INTO student_info ("student firstname", "student surname", "student id", "student email", "year", "address", "contact number")
SELECT "student firstname", "student surname", "student id", "student email", "year", "address", "contact number"
FROM students
WHERE NOT EXISTS(
SELECT 1
FROM student_info
WHERE "students.student id" = "student_info.student id"
);

INSERT OR IGNORE INTO enrolment("student id", "module id", "module name", "leader", "assesment", "score")
SELECT "student id", "module id", "module name", "leader", 'exam', "exam mark"
FROM students
WHERE "exam mark" IS NOT NULL;

INSERT OR IGNORE INTO enrolment("student id", "module id", "module name", "leader", "assesment", "score")
SELECT "student id", "module id", "module name", "leader", 'coursework1', "coursework1"
FROM students
WHERE "coursework1" IS NOT NULL;

INSERT OR IGNORE INTO enrolment("student id", "module id", "module name", "leader", "assesment", "score")
SELECT "student id", "module id", "module name", "leader", 'coursework2', "coursework2"
FROM students
WHERE "coursework2" IS NOT NULL;

INSERT OR IGNORE INTO enrolment("student id", "module id", "module name", "leader", "assesment", "score")
SELECT "student id", "module id", "module name", "leader", 'coursework3', "coursework3"
FROM students
WHERE "coursework3" IS NOT NULL;



CREATE TABLE IF NOT EXISTS "module"(
"module id" TEXT,
"module name" TEXT,
"leader" TEXT,
PRIMARY KEY("module id")
);

CREATE TABLE IF NOT EXISTS "faculties pk"(
"faculty" TEXT,
"building" TEXT,
"room" TEXT,
"capacity" INTEGER,
"lecturer email" TEXT,
"lecturer firstname" TEXT,
"lecturer surname" TEXT,
PRIMARY KEY(building, room, "lecturer email")
);

INSERT OR IGNORE INTO "faculties pk"("faculty", "building", "room", "capacity", "lecturer email", "lecturer firstname", "lecturer surname")
SELECT "faculty", "building", "room", "capacity", "lecturer_email", "lecturer_firstname", "lecturer_surname"
FROM faculties;



INSERT OR IGNORE INTO module("module id", "module name", "leader")
SELECT "module id", "module name", "leader"
FROM students;

ALTER TABLE lecturer_assignment
DROP COLUMN "module name";

ALTER TABLE lecturer_assignment
DROP COLUMN "leader";

ALTER TABLE enrolment
DROP COLUMN "leader";


ALTER TABLE enrolment
DROP COLUMN "module name";

CREATE TABLE IF NOT EXISTS "lecturers"(
"faculty" TEXT,
"lecturer email" TEXT,
"lecturer firstname" TEXT,
"lecturer surname" TEXT,
PRIMARY KEY("lecturer email")
);

INSERT OR IGNORE INTO lecturers("faculty", "lecturer email", "lecturer firstname", "lecturer surname")
SELECT "faculty", "lecturer email", "lecturer firstname", "lecturer surname"
FROM "faculties pk";

CREATE TABLE IF NOT EXISTS "buildings"(
"building" TEXT,
"room" TEXT,
"capacity" TEXT,
PRIMARY KEY("building", "room")
);

INSERT OR IGNORE INTO buildings("building", "room", "capacity")
SELECT "building", "room", "capacity"
FROM "faculties pk";

CREATE TABLE IF NOT EXISTS "lecturer_room"(
"building" TEXT,
"room" TEXT,
"lecturer email" TEXT,
PRIMARY KEY("building", "room", "lecturer email")
);

INSERT OR IGNORE INTO lecturer_room("building", "room", "lecturer email")
SELECT "building", "room", "lecturer email"
FROM "faculties pk";


/* old ex15, DO NOT SUBMIT:
SELECT lecturer_assignment."module id", "lecturer", COUNT("student id"), lecturer_room."room", buildings."capacity"
FROM lecturer_assignment
INNER JOIN lecturer_room
ON lecturer_room."lecturer email" = lecturer_assignment."lecturer"
INNER JOIN enrolment
ON enrolment."module id" = lecturer_assignment."module id"
INNER JOIN buildings
ON lecturer_room."room" = buildings."room"
AND lecturer_room."building" = buildings."building"
WHERE COUNT("student id") > buildings."capacity"
GROUP BY lecturer_assignment."module id";
*/

/*ex 15:
SELECT "module id", "building", "room"
FROM(
SELECT lecturer_assignment."module id", "lecturer", COUNT("student id") AS student_numbers, buildings."building", lecturer_room."room", buildings."capacity"
FROM lecturer_assignment
INNER JOIN lecturer_room
ON lecturer_room."lecturer email" = lecturer_assignment."lecturer"
INNER JOIN enrolment
ON enrolment."module id" = lecturer_assignment."module id"
INNER JOIN buildings
ON lecturer_room."room" = buildings."room"
AND lecturer_room."building" = buildings."building"
GROUP BY lecturer_assignment."module id"
)
WHERE student_numbers > "capacity";
*/


/*ex13:
SELECT enrolment."student id",  student_info."student firstname", student_info."student surname" , ROUND(AVG(enrolment.score))
FROM enrolment
INNER JOIN student_info
ON enrolment."student id" = student_info."student id"
WHERE "module id" like 'COMP%' AND assesment = "exam"
GROUP BY enrolment."student id"
ORDER BY ROUND(AVG(enrolment.score)) DESC;
*/

/*ex14:
SELECT module_id, leader_firstname, leader_surname, faculty, MAX(module_average)
FROM (
SELECT module."module id" AS module_id, lecturers."lecturer firstname" AS leader_firstname, lecturers."lecturer surname" AS leader_surname, lecturers.faculty, ROUND(AVG(enrolment.score)) AS module_average
FROM module
INNER JOIN lecturers
ON module."leader" = lecturers."lecturer email"
INNER JOIN enrolment
ON module."module id" = enrolment."module id"
GROUP BY module."module id"
)
GROUP BY faculty;
*/


/*random testing
SELECT "lecturer email", "module id" , COUNT("student id"), "room", "capacity"
FROM lecturer_room
INNER JOIN lecturer_assignment
ON lecturer_room."lecturer email" = lecturer_assignment."lecturer";

SELECT "module id", COUNT("student id")
FROM enrolment
GROUP BY "module id";
*/



/*random testing
SELECT COUNT("student id"), "module id"
FROM enrolment
GROUP BY "module id"
*/

--23 different COMP modules
