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
