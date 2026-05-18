xquery version "3.1";

(: Load the live project XML from the same folder as this XQuery file. :)
declare variable $doc := doc(resolve-uri("events.xml", static-base-uri()));

(: Safe integer conversion :)
declare function local:int($node) {
  if ($node = ()) then 0
  else xs:integer(normalize-space(string($node)))
};

<results generated-by="sample.xq"
         generated-on="{current-dateTime()}">

  <eventParticipantCounts totalEvents="{count($doc/events/event)}">
  {
    for $event in $doc/events/event
    let $eventId := string($event/@eventId)
    let $registrations :=
        $doc/registrations/registration[@eventId = $eventId]

    let $registeredCount := count($registrations)

    order by $eventId

    return
      <event eventId="{$eventId}"
             status="{string($event/@eventStatus)}">

        <eventName>{string($event/eventName)}</eventName>

        <eventDate>{string($event/eventDate)}</eventDate>

        <capacity>{local:int($event/capacity)}</capacity>

        <registrationCount>{$registeredCount}</registrationCount>

      </event>
  }
  </eventParticipantCounts>

  <eventsByStatus>
    <total>{count($doc/events/event)}</total>

    <upcoming>
      {count($doc/events/event[@eventStatus='upcoming'])}
    </upcoming>

    <current>
      {count($doc/events/event[@eventStatus='current'])}
    </current>

    <closed>
      {count($doc/events/event[@eventStatus='closed'])}
    </closed>
  </eventsByStatus>

  <eventCategories>
  {
    for $cat in distinct-values($doc/events/event/category)

    let $matched := $doc/events/event[category = $cat]

    order by $cat

    return
      <category>
        <name>{$cat}</name>
        <count>{count($matched)}</count>
      </category>
  }
  </eventCategories>

  <registrationsByStatus>
  {
    for $status in distinct-values($doc/registrations/registration/@registrationStatus)
    order by $status
    return
      <status name="{$status}" count="{count($doc/registrations/registration[@registrationStatus = $status])}"/>
  }
  </registrationsByStatus>

  <eventsByVenue>
  {
    for $v in distinct-values($doc/events/event/venue)
    let $evs := $doc/events/event[venue = $v]
    order by $v
    return
      <venue name="{$v}">
      {
        for $e in $evs
        let $eid := string($e/@eventId)
        let $regCount := count($doc/registrations/registration[@eventId = $eid])
        order by $eid
        return <event eventId="{$eid}" date="{string($e/eventDate)}" time="{string($e/eventTime)}" registrations="{$regCount}"/>
      }
      </venue>
  }
  </eventsByVenue>

  <attendedRegistrations>
  {
    for $reg in $doc/registrations/registration[@registrationStatus = 'Attended']
    let $eventId := string($reg/@eventId)
    let $participantId := string($reg/@participantId)
    let $event := $doc/events/event[@eventId = $eventId][1]
    let $participant := $doc/participants/participant[@participantId = $participantId][1]
    order by $participantId, $eventId
    return
      <attendance>
        <registrationId>{string($reg/@registrationId)}</registrationId>
        <participantName>{string($participant/fullName)}</participantName>
        <eventName>{string($event/eventName)}</eventName>
        <eventDate>{string($event/eventDate)}</eventDate>
        <eventTime>{string($event/eventTime)}</eventTime>
      </attendance>
  }
  </attendedRegistrations>

  <venueDistribution>
  {
    for $venue in distinct-values($doc/events/event/venue)
    let $venueEvents := $doc/events/event[venue = $venue]
    let $totalEventCount := count($venueEvents)
    order by $venue
    return
      <venue name="{$venue}" eventCount="{$totalEventCount}">
      {
        for $event in $venueEvents
        let $eventId := string($event/@eventId)
        let $regCount := count($doc/registrations/registration[@eventId = $eventId])
        order by $eventId
        return
          <event eventId="{$eventId}" 
                 eventName="{string($event/eventName)}" 
                 date="{string($event/eventDate)}" 
                 time="{string($event/eventTime)}" 
                 capacity="{string($event/capacity)}"
                 registrations="{$regCount}"/>
      }
      </venue>
  }
  </venueDistribution>

  <participantSchedules>
  {
    for $p in $doc/participants/participant
    let $pid := string($p/@participantId)
    let $regs := $doc/registrations/registration[@participantId = $pid]
    order by $pid
    return
      <participant participantId="{$pid}" fullName="{string($p/fullName)}">
      {
        for $r in $regs
        let $e := $doc/events/event[@eventId = string($r/@eventId)][1]
        order by $e/eventDate, $e/eventTime
        return <scheduled eventId="{string($e/@eventId)}" name="{string($e/eventName)}" date="{string($e/eventDate)}" time="{string($e/eventTime)}" status="{string($r/@registrationStatus)}"/>
      }
      </participant>
  }
  </participantSchedules>

</results>
