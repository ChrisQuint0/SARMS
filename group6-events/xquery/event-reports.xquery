(: 
  Events Management System - XQuery
  Advanced querying for statistical reports and analysis
  XQuery allows construction of new XML output from source data
  
  Usage: Execute these queries against events-data.xml
  Output: Generates XML-formatted results
:)

(: ==================================================
   QUERY 1: Event Summary Report
   Purpose: Generate summary for each event with participant count
   ================================================== :)

for $event in //event
let $regCount := count(//registration[eventId=$event/@eventId])
let $registeredCount := count(//registration[eventId=$event/@eventId and registrationStatus='Registered'])
return
<eventSummary eventId="{$event/@eventId}">
  <eventName>{data($event/eventName)}</eventName>
  <eventDate>{data($event/eventDate)}</eventDate>
  <venue>{data($event/venue)}</venue>
  <totalRegistrations>{$regCount}</totalRegistrations>
  <registeredParticipants>{$registeredCount}</registeredParticipants>
  <pendingApprovals>{$regCount - $registeredCount}</pendingApprovals>
</eventSummary>

(: ==================================================
   QUERY 2: Participant Activity Report
   Purpose: Show all events each participant is registered for
   ================================================== :)

for $participant in //participant
let $events := //registration[participantId=$participant/@participantId]/eventId
return
<participantActivity participantId="{$participant/@participantId}">
  <name>{data($participant/fullName)}</name>
  <department>{data($participant/department)}</department>
  <registrationCount>{count($events)}</registrationCount>
  <events>
  {
    for $eventId in $events
    let $event := //event[@eventId=$eventId]
    return
    <event eventId="{$eventId}">
      <eventName>{data($event/eventName)}</eventName>
      <eventDate>{data($event/eventDate)}</eventDate>
    </event>
  }
  </events>
</participantActivity>

(: ==================================================
   QUERY 3: Department Statistics
   Purpose: Generate statistics per department
   ================================================== :)

let $departments := distinct-values(//participant/department)
for $dept in $departments
let $participants := //participant[department=$dept]
let $registrations := //registration[participantId=$participants/@participantId]
return
<departmentStats department="{$dept}">
  <totalParticipants>{count($participants)}</totalParticipants>
  <totalRegistrations>{count($registrations)}</totalRegistrations>
  <registeredCount>{count($registrations[registrationStatus='Registered'])}</registeredCount>
  <pendingCount>{count($registrations[registrationStatus='Pending'])}</pendingCount>
  <avgRegistrationsPerPerson>{round(count($registrations) div count($participants), 2)}</avgRegistrationsPerPerson>
</departmentStats>

(: ==================================================
   QUERY 4: Attendance Projection
   Purpose: Estimate actual attendance (Registered only)
   ================================================== :)

<attendanceProjection generatedDate="{current-date()}">
  <totalEvents>{count(//event)}</totalEvents>
  <totalParticipants>{count(//participant)}</totalParticipants>
  <totalRegistrations>{count(//registration)}</totalRegistrations>
  <confirmedAttendance>{count(//registration[registrationStatus='Registered'])}</confirmedAttendance>
  <pendingApprovals>{count(//registration[registrationStatus='Pending'])}</pendingApprovals>
  <confirmationRate>{round(count(//registration[registrationStatus='Registered']) div count(//registration) * 100, 2)}</confirmationRate>
  <eventCoverage>
  {
    let $eventsWithReg := count(//event[count(//registration[eventId=current()/@eventId]) > 0])
    return
    <eventsWithRegistrations>{$eventsWithReg}</eventsWithRegistrations>
  }
  </eventCoverage>
</attendanceProjection>

(: ==================================================
   QUERY 5: Most Popular Events
   Purpose: Rank events by registration count
   ================================================== :)

<popularEvents>
{
  for $event in //event
  let $regCount := count(//registration[eventId=$event/@eventId])
  order by $regCount descending
  return
  <event rank="{count($event/preceding-sibling::event[count(//registration[eventId=current()/@eventId]) >= count(//registration[eventId=$event/@eventId])]) + 1}">
    <eventId>{$event/@eventId}</eventId>
    <eventName>{data($event/eventName)}</eventName>
    <registrationCount>{$regCount}</registrationCount>
  </event>
}
</popularEvents>

(: ==================================================
   QUERY 6: Least Popular Events
   Purpose: Identify events with low registration
   ================================================== :)

<unpopularEvents threshold="2">
{
  for $event in //event
  let $regCount := count(//registration[eventId=$event/@eventId])
  where $regCount &lt; 2
  return
  <event>
    <eventId>{$event/@eventId}</eventId>
    <eventName>{data($event/eventName)}</eventName>
    <registrationCount>{$regCount}</registrationCount>
  </event>
}
</unpopularEvents>

(: ==================================================
   QUERY 7: Cross-Department Event Participation
   Purpose: Show department diversity for each event
   ================================================== :)

for $event in //event
let $registrations := //registration[eventId=$event/@eventId]
let $departments := distinct-values($registrations/participantId[//participant[@participantId=current()]/department])
return
<eventDiversity eventId="{$event/@eventId}">
  <eventName>{data($event/eventName)}</eventName>
  <totalRegistrations>{count($registrations)}</totalRegistrations>
  <departmentCount>{count(distinct-values(
    for $reg in $registrations
    let $partId := data($reg/participantId)
    return //participant[@participantId=$partId]/department
  ))}</departmentCount>
  <departmentBreakdown>
  {
    for $dept in distinct-values(
      for $reg in $registrations
      let $partId := data($reg/participantId)
      return //participant[@participantId=$partId]/department
    )
    let $count := count($registrations[
      participantId[
        //participant[@participantId=current()]/department=$dept
      ]
    ])
    return
    <department name="{$dept}" count="{$count}"/>
  }
  </departmentBreakdown>
</eventDiversity>

(: ==================================================
   QUERY 8: Timeline Analysis
   Purpose: Generate monthly registration timeline
   ================================================== :)

<registrationTimeline>
{
  let $months := distinct-values(
    for $reg in //registration
    return substring($reg/registrationDate, 1, 7)
  )
  for $month in sort($months)
  let $regs := //registration[starts-with(registrationDate, $month)]
  return
  <month value="{$month}">
    <registrationCount>{count($regs)}</registrationCount>
    <registeredCount>{count($regs[registrationStatus='Registered'])}</registeredCount>
    <pendingCount>{count($regs[registrationStatus='Pending'])}</pendingCount>
  </month>
}
</registrationTimeline>

(: ==================================================
   QUERY 9: High-Engagement Participants
   Purpose: Find participants registered for most events (>2)
   ================================================== :)

<activeParticipants minEvents="2">
{
  for $participant in //participant
  let $eventCount := count(//registration[participantId=$participant/@participantId])
  where $eventCount > 2
  order by $eventCount descending
  return
  <participant participantId="{$participant/@participantId}">
    <name>{data($participant/fullName)}</name>
    <department>{data($participant/department)}</department>
    <eventCount>{$eventCount}</eventCount>
  </participant>
}
</activeParticipants>

(: ==================================================
   QUERY 10: Executive Summary Dashboard
   Purpose: High-level overview metrics
   ================================================== :)

let $events := //event
let $participants := //participant
let $registrations := //registration
let $registered := $registrations[registrationStatus='Registered']
let $pending := $registrations[registrationStatus='Pending']
let $depts := distinct-values($participants/department)
return
<executiveSummary>
  <generatedDate>{current-date()}</generatedDate>
  <metrics>
    <totalEvents>{count($events)}</totalEvents>
    <totalParticipants>{count($participants)}</totalParticipants>
    <totalRegistrations>{count($registrations)}</totalRegistrations>
    <confirmedRegistrations>{count($registered)}</confirmedRegistrations>
    <pendingRegistrations>{count($pending)}</pendingRegistrations>
    <departmentCount>{count($depts)}</departmentCount>
  </metrics>
  <conversionMetrics>
    <registrationRate>{round(count($registrations) div (count($events) * count($participants)) * 100, 2)}</registrationRate>
    <confirmationRate>{round(count($registered) div count($registrations) * 100, 2)}</confirmationRate>
    <avgRegistrationsPerEvent>{round(count($registrations) div count($events), 2)}</avgRegistrationsPerEvent>
    <avgRegistrationsPerParticipant>{round(count($registrations) div count($participants), 2)}</avgRegistrationsPerParticipant>
  </conversionMetrics>
  <departmentsList>
  {
    for $dept in sort($depts)
    let $deptParticipants := $participants[department=$dept]
    return
    <department name="{$dept}" participantCount="{count($deptParticipants)}"/>
  }
  </departmentsList>
</executiveSummary>
