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
