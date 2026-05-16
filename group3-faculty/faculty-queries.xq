xquery version "1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

(:
  SARMS Group 3: Faculty Workload System
  Comprehensive XQuery report based on the 10 query examples
  in xpath-queries.txt.

  Run from the group3-faculty directory against faculty.xml.
:)

let $doc := doc("faculty.xml")
let $faculty := $doc/faculty/facultyMember
let $subjects := $faculty/subjects/subject

return
<facultyWorkloadReport>
    <title>SARMS Faculty Workload System - Comprehensive Query Report</title>
    <timestamp>{ current-dateTime() }</timestamp>

    <summary>
        <!-- Query 5: Count total number of faculty members -->
        <totalFacultyMembers>{ count($faculty) }</totalFacultyMembers>

        <!-- Query 9: Calculate the total teaching hours of all faculty -->
        <totalTeachingHours>{ sum($faculty/totalHours) }</totalTeachingHours>
    </summary>

    <query1FacultyTeachingMoreThan3Subjects count="{ count($faculty[count(subjects/subject) > 3]) }">
        {
            for $f in $faculty[count(subjects/subject) > 3]
            order by string($f/id)
            return
                <facultyMember id="{ string($f/id) }">
                    <name>{ string($f/name) }</name>
                    <department>{ string($f/department) }</department>
                    <subjectCount>{ count($f/subjects/subject) }</subjectCount>
                    <totalHours>{ string($f/totalHours) }</totalHours>
                </facultyMember>
        }
    </query1FacultyTeachingMoreThan3Subjects>

    <query2CollegeOfEngineeringFaculty count="{ count($faculty[department = 'College of Engineering']) }">
        {
            for $f in $faculty[department = 'College of Engineering']
            order by string($f/id)
            return
                <facultyMember id="{ string($f/id) }">
                    <name>{ string($f/name) }</name>
                    <totalHours>{ string($f/totalHours) }</totalHours>
                </facultyMember>
        }
    </query2CollegeOfEngineeringFaculty>

    <query3NamesWithTotalHoursAbove20 count="{ count($faculty[totalHours > 20]) }">
        {
            for $f in $faculty[totalHours > 20]
            order by xs:integer($f/totalHours) descending
            return
                <name facultyId="{ string($f/id) }" totalHours="{ string($f/totalHours) }">
                    { string($f/name) }
                </name>
        }
    </query3NamesWithTotalHoursAbove20>

    <query4SubjectsWith5TeachingHours count="{ count($subjects[hours = 5]) }">
        {
            for $s in $subjects[hours = 5]
            let $facultyMember := $s/ancestor::facultyMember[1]
            order by string($facultyMember/id), string($s/subjectName)
            return
                <subject facultyId="{ string($facultyMember/id) }">
                    <facultyName>{ string($facultyMember/name) }</facultyName>
                    <subjectName>{ string($s/subjectName) }</subjectName>
                </subject>
        }
    </query4SubjectsWith5TeachingHours>

    <query5CountTotalFacultyMembers>
        <count>{ count($faculty) }</count>
    </query5CountTotalFacultyMembers>

    <query6FacultyTeachingMachineLearning count="{ count($faculty[subjects/subject/subjectName = 'Machine Learning']) }">
        {
            for $f in $faculty[subjects/subject/subjectName = 'Machine Learning']
            order by string($f/id)
            return
                <facultyMember id="{ string($f/id) }">
                    <name>{ string($f/name) }</name>
                    <department>{ string($f/department) }</department>
                </facultyMember>
        }
    </query6FacultyTeachingMachineLearning>

    <query7FacultyIdAndTotalHoursAbove24 count="{ count($faculty[totalHours > 24]) }">
        {
            for $f in $faculty[totalHours > 24]
            order by xs:integer($f/totalHours) descending
            return
                <facultyLoad>
                    <id>{ string($f/id) }</id>
                    <totalHours>{ string($f/totalHours) }</totalHours>
                </facultyLoad>
        }
    </query7FacultyIdAndTotalHoursAbove24>

    <query8SubjectsHandledByFAC021 count="{ count($faculty[id = 'FAC-021']/subjects/subject) }">
        {
            for $s in $faculty[id = 'FAC-021']/subjects/subject/subjectName
            return
                <subject>{ string($s) }</subject>
        }
    </query8SubjectsHandledByFAC021>

    <query9TotalTeachingHoursAllFaculty>
        <sum>{ sum($faculty/totalHours) }</sum>
    </query9TotalTeachingHoursAllFaculty>

    <query10ComputerStudiesFacultyTeachingCloudComputing count="{ count($faculty[department = 'College of Computer Studies' and subjects/subject/subjectName = 'Cloud Computing']) }">
        {
            for $f in $faculty[
                department = 'College of Computer Studies'
                and subjects/subject/subjectName = 'Cloud Computing'
            ]
            order by string($f/id)
            return
                <facultyMember id="{ string($f/id) }">
                    <name>{ string($f/name) }</name>
                    <totalHours>{ string($f/totalHours) }</totalHours>
                </facultyMember>
        }
    </query10ComputerStudiesFacultyTeachingCloudComputing>
</facultyWorkloadReport>
