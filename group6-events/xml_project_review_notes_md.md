# XML Project Review Notes

## Fixed Items

- Department values are consistent across XML, XSD, XPath, and XQuery.
- Event registration counts now use `registrationCount`; the root `registrations` element remains the registration container.
- Event times use the strict `HH:MM:SS` format required by `xs:time`.
- `EVT-0011` has been added.
- Event registration counts match the actual registration records.
- XSD 1.1 assertions are present for:
  - event dates not being in the past
  - registration dates occurring before their related event dates
- The XSLT generates XML output only and includes a named `attendanceSheet` template.
- The required XQuery file, `events-queries.xq`, counts participants per event.

## Validation Notes

- DTD validates structure and ID/IDREF links.
- XSD assertions require an XSD 1.1 processor.
- DTD stores `registrationDate` as CDATA because DTD has no native date type; XSD validates it as `xs:date`.
