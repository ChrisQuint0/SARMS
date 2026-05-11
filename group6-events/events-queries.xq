xquery version "1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

(: Count participants per event. Output is XML, not HTML. :)
let $system := doc("events.xml")/eventManagementSystem
return
  <eventParticipantCounts totalEvents="{count($system/events/event)}">
    {
      for $event in $system/events/event
      let $eventId := string($event/@eventId)
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
              for $registration in $registrations
              let $participant := $system/participants/participant[@participantId = string($registration/@participantId)]
              order by string($participant/fullName)
              return
                <participant participantId="{string($participant/@participantId)}"
                             registrationId="{string($registration/@registrationId)}"
                             status="{string($registration/@registrationStatus)}">
                  <fullName>{string($participant/fullName)}</fullName>
                  <department>{string($participant/department)}</department>
                </participant>
            }
          </participants>
        </event>
    }
  </eventParticipantCounts>
