xquery version "3.1";

(: Embedded XML document :)
declare variable $doc :=

<eventManagementSystem>

    <events>

        <event eventId="E001" eventStatus="upcoming">
            <eventName>Tech Symposium</eventName>
            <eventDate>2026-06-10</eventDate>
            <category>Technology</category>
            <capacity>200</capacity>
        </event>

        <event eventId="E002" eventStatus="current">
            <eventName>Sports Fest</eventName>
            <eventDate>2026-06-15</eventDate>
            <category>Sports</category>
            <capacity>150</capacity>
        </event>

        <event eventId="E003" eventStatus="closed">
            <eventName>Cultural Day</eventName>
            <eventDate>2026-05-01</eventDate>
            <category>Culture</category>
            <capacity>100</capacity>
        </event>

    </events>

    <participants>

        <participant participantId="P001">
            <fullName>Juan Dela Cruz</fullName>
            <department>College of Computer Studies</department>
        </participant>

        <participant participantId="P002">
            <fullName>Maria Santos</fullName>
            <department>College of Engineering</department>
        </participant>

        <participant participantId="P003">
            <fullName>Jose Reyes</fullName>
            <department>College of Business and Accountancy</department>
        </participant>

    </participants>

    <registrations>

        <registration
            registrationId="R001"
            eventId="E001"
            participantId="P001"
            registrationStatus="Registered"
            registrationDate="2026-05-10"/>

        <registration
            registrationId="R002"
            eventId="E002"
            participantId="P002"
            registrationStatus="Attended"
            registrationDate="2026-05-11"/>

        <registration
            registrationId="R003"
            eventId="E003"
            participantId="P003"
            registrationStatus="Cancelled"
            registrationDate="2026-05-12"/>

    </registrations>

</eventManagementSystem>;

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

</results>
