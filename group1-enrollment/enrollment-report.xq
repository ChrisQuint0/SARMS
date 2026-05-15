xquery version "1.0";

(: 
  SARMS Group 1: Student Enrollment System 
  Unified Academic Report
  This script implements all 10 required XPath queries into a single, automated XQuery report.
:)

let $doc := doc("students.xml")
let $students := $doc/students/student
let $subjects := $doc/students/student/enrolledSubjects/subject

return
<academicReport>
    <title>SARMS Enrollment System - Comprehensive Academic Report</title>
    <timestamp>{ current-dateTime() }</timestamp>
    
    <summary>
        <!-- Query 5: Count total number of enrolled students -->
        <totalStudents>{ count($students) }</totalStudents>
        
        <!-- Query 9: Calculate the total units enrolled across all students -->
        <totalUnitsEnrolled>{ sum($subjects/units) }</totalUnitsEnrolled>
    </summary>

    <academicStanding>
        <!-- Query 1: Retrieve all students with GPA > 2.0 (Needs intervention) -->
        <studentsNeedingIntervention count="{ count($students[gpa > 2.0]) }">
            {
                for $s in $students[gpa > 2.0]
                return <student id="{ string($s/@studentId) }" gpa="{ $s/gpa }">{ concat($s/firstName, ' ', $s/lastName) }</student>
            }
        </studentsNeedingIntervention>

        <!-- Query 7: Get the student ID and GPA of the Dean's Listers (GPA <= 1.75) -->
        <deansListers count="{ count($students[gpa <= 1.75]) }">
            {
                for $s in $students[gpa <= 1.75]
                return <lister id="{ string($s/@studentId) }" gpa="{ $s/gpa }" />
            }
        </deansListers>
    </academicStanding>

    <demographics>
        <!-- Query 2: List all students enrolled in the BSIT course -->
        <bsitStudents count="{ count($students[course = 'BSIT']) }">
            {
                for $s in $students[course = 'BSIT']
                return <student>{ concat($s/firstName, ' ', $s/lastName) }</student>
            }
        </bsitStudents>

        <!-- Query 3: Get the names of all 4th year students -->
        <fourthYearStudents count="{ count($students[yearLevel = 4]) }">
            {
                for $s in $students[yearLevel = 4]
                return <name>{ concat($s/firstName, ' ', $s/lastName) }</name>
            }
        </fourthYearStudents>

        <!-- Query 10: Retrieve students from BSCS course in year level 4 -->
        <graduatingBscsStudents count="{ count($students[course = 'BSCS' and yearLevel = 4]) }">
            {
                for $s in $students[course = 'BSCS' and yearLevel = 4]
                return <student id="{ string($s/@studentId) }" name="{ concat($s/firstName, ' ', $s/lastName) }" />
            }
        </graduatingBscsStudents>
    </demographics>

    <courseLoadAndPerformance>
        <!-- Query 6: Retrieve students enrolled in more than 3 subjects -->
        <heavyCourseLoadStudents count="{ count($students[count(enrolledSubjects/subject) > 3]) }">
            {
                for $s in $students[count(enrolledSubjects/subject) > 3]
                return <student id="{ string($s/@studentId) }">{ count($s/enrolledSubjects/subject) } subjects</student>
            }
        </heavyCourseLoadStudents>

        <!-- Query 4: Find all subjects with a grade of 1.00 (perfect mark) -->
        <perfectMarkSubjects count="{ count($subjects[grade = 1.00]) }">
            {
                for $subj in $subjects[grade = 1.00]
                return <subject>{ string($subj/subjectName) }</subject>
            }
        </perfectMarkSubjects>

        <!-- Query 8: List all subject names for student 23-00003 -->
        <student2300003Subjects>
            {
                for $name in $students[@studentId = '23-00003']/enrolledSubjects/subject/subjectName
                return <subject>{ string($name) }</subject>
            }
        </student2300003Subjects>
    </courseLoadAndPerformance>

</academicReport>
