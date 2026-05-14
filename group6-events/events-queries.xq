xquery version "1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

(:
  Events Management System - XQuery Queries
  ==========================================
  Required deliverable: Count participants per event.
  Also includes filtering, aggregation, and cross-section queries.
  Run against events.xml using an XQuery 1.0-compliant processor
  (e.g., BaseX, Saxon-HE, eXist-db).
:)

(: ============================================================
   QUERY 1 (REQUIRED): Count participants per event
   Returns every event with its actual registered participant
   count derived from the <registrations> section.
   ============================================================ :)
let $system := doc("events.xml")/eventManagementSystem
return
  <eventParticipantCounts totalEvents="{count($system/events/event)}">
    {
      for $event in $system/events/event
      let $eventId      := string($event/@eventId)
      let $registrations := $system/registrations/registration[@eventId = $eventId]
      order by $eventId
      return
        <event eventId="{$eventId}" status="{string($event/@eventStatus)}">
          <eventName>{string($event/eventName)}</eventName>
          <eventDate>{string($event/eventDate)}</eventDate>
          <capacity>{xs:integer($event/capacity)}</capacity>
          <registrationCount>{count($registrations)}</registrationCount>
          <participants>
            {
              for $reg in $registrations
              let $par := $system/participants/participant[@participantId = string($reg/@participantId)]
              order by string($par/fullName)
              return
                <participant participantId="{string($par/@participantId)}"
                             registrationId="{string($reg/@registrationId)}"
                             status="{string($reg/@registrationStatus)}">
                  <fullName>{string($par/fullName)}</fullName>
                  <department>{string($par/department)}</department>
                </participant>
            }
          </participants>
        </event>
    }
  </eventParticipantCounts>

(: ============================================================
   QUERY 2: Count events by status
   ============================================================ :)
(: Uncomment to run independently:
let $system := doc("events.xml")/eventManagementSystem
return
  <eventsByStatus
    total="{count($system/events/event)}"
    upcoming="{count($system/events/event[@eventStatus='upcoming'])}"
    current="{count($system/events/event[@eventStatus='current'])}"
    closed="{count($system/events/event[@eventStatus='closed'])}"/>
:)

(: ============================================================
   QUERY 3: Count events by category
   ============================================================ :)
(: Uncomment to run independently:
let $system := doc("events.xml")/eventManagementSystem
for $cat in distinct-values($system/events/event/category)
let $events := $system/events/event[category = $cat]
order by $cat
return
  <category name="{$cat}" count="{count($events)}"/>
:)

(: ============================================================
   QUERY 4: Upcoming events with available capacity
   ============================================================ :)
(: Uncomment to run independently:
let $system := doc("events.xml")/eventManagementSystem
for $event in $system/events/event[@eventStatus = 'upcoming']
where xs:integer($event/registrationCount) lt xs:integer($event/capacity)
order by $event/eventDate
return
  <availableEvent eventId="{string($event/@eventId)}"
                  spotsLeft="{xs:integer($event/capacity) - xs:integer($event/registrationCount)}">
    <eventName>{string($event/eventName)}</eventName>
    <eventDate>{string($event/eventDate)}</eventDate>
    <venue>{string($event/venue)}</venue>
  </availableEvent>
:)

(: ============================================================
   QUERY 5: Participants per college/department
   ============================================================ :)
(: Uncomment to run independently:
let $system := doc("events.xml")/eventManagementSystem
for $dept in distinct-values($system/participants/participant/department)
let $members := $system/participants/participant[department = $dept]
order by $dept
return
  <college name="{$dept}" participantCount="{count($members)}"/>
:)

(: ============================================================
   QUERY 6: Registration status summary
   ============================================================ :)
(: Uncomment to run independently:
let $system := doc("events.xml")/eventManagementSystem
let $regs   := $system/registrations/registration
return
  <registrationSummary
    total="{count($regs)}"
    registered="{count($regs[@registrationStatus='Registered'])}"
    attended="{count($regs[@registrationStatus='Attended'])}"
    cancelled="{count($regs[@registrationStatus='Cancelled'])}"
    noShow="{count($regs[@registrationStatus='No-show'])}"/>
:)

(: ============================================================
   QUERY 7: Cross-reference — participants who attended events
   ============================================================ :)
(: Uncomment to run independently:
let $system := doc("events.xml")/eventManagementSystem
for $reg in $system/registrations/registration[@registrationStatus = 'Attended']
let $event := $system/events/event[@eventId = string($reg/@eventId)]
let $par   := $system/participants/participant[@participantId = string($reg/@participantId)]
order by string($event/@eventId)
return
  <attendanceRecord>
    <eventId>{string($event/@eventId)}</eventId>
    <eventName>{string($event/eventName)}</eventName>
    <participantId>{string($par/@participantId)}</participantId>
    <fullName>{string($par/fullName)}</fullName>
    <department>{string($par/department)}</department>
    <registrationDate>{string($reg/@registrationDate)}</registrationDate>
  </attendanceRecord>
:)
