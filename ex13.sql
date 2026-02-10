SELECT enrolment."student id",  student_info."student firstname", student_info."student surname" , ROUND(AVG(enrolment.score))
FROM enrolment
INNER JOIN student_info
ON enrolment."student id" = student_info."student id"
WHERE "module id" like 'COMP%' AND assesment = "exam"
GROUP BY enrolment."student id"
ORDER BY ROUND(AVG(enrolment.score)) DESC;
