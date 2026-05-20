xquery version "1.0";

(:
  SARMS Group 1: Student Enrollment System
  Unified Academic Report
  This script implements exactly 10 XPath queries into a single,
  automated XQuery report, updated to reflect the revised XML structure.
:)

let $doc      := doc("students.xml")
let $students := $doc/students/student
let $subjects := $doc/students/student/enrolledSubjects/subject

return
<academicReport>
    <title>SARMS Enrollment System - Comprehensive Academic Report</title>
    <timestamp>{ current-dateTime() }</timestamp>

    <summary>
        <!-- Query 1: Count total number of enrolled students -->
        <totalStudents>{ count($students) }</totalStudents>

        <!-- Query 2: Calculate the total units enrolled across all students -->
        <totalUnitsEnrolled>{ sum($subjects/units) }</totalUnitsEnrolled>
    </summary>

    <academicStanding>
        <!-- Query 3: Retrieve all students with GPA > 2.0 (Needs intervention) -->
        <studentsNeedingIntervention count="{ count($students[gpa > 2.0]) }">
            {
                for $s in $students[gpa > 2.0]
                order by $s/gpa ascending
                return <student id="{ string($s/@studentId) }"
                                name="{ concat($s/firstName, ' ', $s/lastName) }"
                                program="{ $s/program }"
                                gpa="{ $s/gpa }"/>
            }
        </studentsNeedingIntervention>

        <!-- Query 4: Get the student ID and GPA of the Dean's Listers (GPA <= 1.75) -->
        <deansListers count="{ count($students[gpa <= 1.75]) }">
            {
                for $s in $students[gpa <= 1.75]
                order by $s/gpa ascending
                return <lister id="{ string($s/@studentId) }"
                               name="{ concat($s/firstName, ' ', $s/lastName) }"
                               gpa="{ $s/gpa }"/>
            }
        </deansListers>
    </academicStanding>

    <demographics>
        <!-- Query 5: List all students enrolled in the BSIT program -->
        <bsitStudents count="{ count($students[program = 'BSIT']) }">
            {
                for $s in $students[program = 'BSIT']
                order by $s/lastName ascending
                return <student id="{ string($s/@studentId) }"
                                name="{ concat($s/firstName, ' ', $s/lastName) }"
                                yearLevel="{ $s/yearLevel }"
                                department="{ $s/studDepartment }"/>
            }
        </bsitStudents>

        <!-- Query 6: Retrieve students from BSCS program in year level 4 -->
        <graduatingBscsStudents count="{ count($students[program = 'BSCS' and yearLevel = 4]) }">
            {
                for $s in $students[program = 'BSCS' and yearLevel = 4]
                return <student id="{ string($s/@studentId) }"
                                name="{ concat($s/firstName, ' ', $s/lastName) }"
                                department="{ $s/studDepartment }"/>
            }
        </graduatingBscsStudents>
    </demographics>

    <courseLoadAndPerformance>
        <!-- Query 7: Find all subjects with a grade of 1.00 (perfect mark) -->
        <perfectMarkSubjects count="{ count($subjects[grade = 1.00]) }">
            {
                for $subj in $subjects[grade = 1.00]
                let $student := $subj/../../..
                return <subject subjectId="{ string($subj/@subjectId) }"
                                studentId="{ string($student/@studentId) }"
                                faculty="{ $subj/facultyMember/professorName }">
                           { string($subj/subjectName) }
                       </subject>
            }
        </perfectMarkSubjects>
    </courseLoadAndPerformance>

    <newXMLStructureQueries>
        <!-- Query 8: Retrieve faculty details for all subjects taught by Sir Lito Pacquiao -->
        <subjectsByProfessor professor="Sir Lito Pacquiao">
            {
                for $subj in $subjects[facultyMember/professorName = 'Sir Lito Pacquiao']
                return <subject id="{ string($subj/@subjectId) }">{ string($subj/subjectName) }</subject>
            }
        </subjectsByProfessor>

        <!-- Query 9: Retrieve all subject names along with their contact hours -->
        <subjectsAndHours>
            {
                for $subj in $subjects
                return <subject name="{ string($subj/subjectName) }" hours="{ $subj/hours }"/>
            }
        </subjectsAndHours>

        <!-- Query 10: List subjects taught by faculty from College of Computer Studies -->
        <subjectsByDepartment department="College of Computer Studies">
            {
                for $subj in $subjects[facultyMember/department = 'College of Computer Studies']
                return <subject>{ string($subj/subjectName) }</subject>
            }
        </subjectsByDepartment>
    </newXMLStructureQueries>

</academicReport>
