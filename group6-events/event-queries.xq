

xquery version "3.1";

(: Load root data from events.xml :)
declare variable $doc := doc('events.xml')/eventManagementSystem;

(: Safe integer conversion; returns 0 when empty :)
declare function local:int($node) {
  if ($node = ()) then 0 else xs:integer(normalize-space(string($node)))
};

(: Final output container with generation metadata :)
<results generated-by="event-queries.xq" generated-on="{current-dateTime()}">

  (: Report 1: List participants per event :)
  <participantsPerEvent>
  {
    for $e in $doc/events/event
    let $eid := string($e/@eventId)
    let $regs := $doc/registrations/registration[@eventId = $eid]
    let $count := count($regs)
    return
      <event id="{$eid}" name="{string($e/eventName)}" registrations="{$count}">
        {
          for $r in $regs
          let $p := $doc/participants/participant[@participantId = $r/@participantId]
          return
            <participant id="{string($p/@participantId)}">{string($p/fullName)}</participant>
        }
      </event>
  }
  </participantsPerEvent>

  (: Report 2: Category totals (events, capacity, registrations) :)
  <eventsByCategory>
  {
    for $c in distinct-values($doc/events/event/category)
    let $events := $doc/events/event[category = $c]
    let $eventsCount := count($events)
    let $totalCapacity := sum(for $ev in $events return local:int($ev/capacity))
    let $totalRegistrations := sum(for $ev in $events return count($doc/registrations/registration[@eventId = $ev/@eventId]))
    return
      <category name="{string($c)}" events="{$eventsCount}" totalCapacity="{$totalCapacity}" totalRegistrations="{$totalRegistrations}"/>
  }
  </eventsByCategory>

  (: Report 3: Count registrations by status :)
  <registrationsByStatus>
  {
    for $s in distinct-values($doc/registrations/registration/@registrationStatus)
    let $cnt := count($doc/registrations/registration[@registrationStatus = $s])
    return <status name="{string($s)}" count="{$cnt}"/>
  }
  </registrationsByStatus>

  (: Report 4: Count participants by department :)
  <participantsByDepartment>
  {
    for $d in distinct-values($doc/participants/participant/department)
    let $cnt := count($doc/participants/participant[department = $d])
    return <department name="{string($d)}" count="{$cnt}"/>
  }
  </participantsByDepartment>

  (: Report 5: Top 5 events by registration count :)
  <topEvents>
  {
    for $e in $doc/events/event
    let $cnt := count($doc/registrations/registration[@eventId = $e/@eventId])
    order by $cnt descending, string($e/@eventId)
    return <event id="{string($e/@eventId)}" name="{string($e/eventName)}" registrations="{$cnt}"/>
  }[position() le 5]
  </topEvents>

</results>