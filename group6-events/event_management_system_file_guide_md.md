# Event Management System — Complete File-Based Development Guide

## System Overview

The system is a static university Event Management System built using XML technologies.

The project focuses on:

- XML data storage
- DTD validation
- XSD validation and assertions
- XPath querying
- XQuery processing
- XSLT

The system manages:

- University events
- Participants
- Registration records
- Event attendance
- Event scheduling rules

All records are hard coded.

The system contains approximately 100 static records.

No database or backend logic is used.

---

# Tech Stack Requirements

## XML
Used for storing structured academic event data.

## DTD
Used for validating XML structure.

## XSD
Used for:

- Advanced validation
- Data typing
- Enumerations
- Assertions
- Referential integrity

## XPath
Used for:

- Extracting records
- Filtering records
- Complex queries

## XQuery
Used for:

- Aggregation
- Counting records
- Advanced querying

## XSLT
Used for:

- Transforming XML into HTML
- Creating dashboard-style output
- Attendance sheet generation

---

# General System Rules

## XML Requirements

- All XML documents must be well-formed.
- Proper nesting is required.
- Every opening tag must have a closing tag.
- Attribute values must use quotation marks.
- XML is case-sensitive.
- Only one root element is allowed.

---

# Naming Conventions

## Element Naming

All element names must use camelCase.

Examples:

- `eventId`
- `participantId`
- `registrationDate`
- `eventDate`
- `registrationStatus`

---

## Attribute Naming

All attribute names must use camelCase.

Examples:

- `eventType`
- `participantType`
- `statusCode`

---

## File Naming

All project files must use kebab-case.

Examples:

- `event-management.xml`
- `event-management.dtd`
- `event-management.xsd`
- `xpath-queries.txt`
- `event-dashboard.xsl`
- `event-queries.xq`

---

## ID Naming Convention

All IDs must follow the format:

`<MODULE>-<NUMBER>`

Examples:

- `EVT-001`
- `PAR-001`
- `REG-001`

Rules:

- IDs must be unique.
- IDs must not repeat.
- IDs should remain sequential when possible.
- Missing IDs must be documented using comments.

---

# Required Project Files

The project must contain the following files:

1. XML File
2. DTD File
3. XSD File
4. XPath Queries File
5. XSLT File
6. XQuery File

---

# File 1 — XML File Guide

## Purpose

The XML file stores all structured event management data.

It acts as the main data source for:

- DTD validation
- XSD validation
- XPath queries
- XQuery queries
- XSLT transformations

---

# XML Structure Requirements

The XML system must integrate all scenarios into one unified structure.

The XML should contain:

- Events section
- Participants section
- Registrations section

---

# Required Event Data

Each event must store:

- Event ID
- Event name
- Event category
- Event date
- Event time
- Venue
- Capacity
- Registration count
- Organizer
- Status

---

# Required Participant Data

Each participant must store:

- Participant ID
- Full name
- Department
- Email address
- Year level

---

# Required Registration Data

Each registration must store:

- Registration ID
- Participant ID reference
- Event ID reference
- Registration date
- Registration status

---

# XML Data Rules

## Event Rules

### Event IDs

- Event IDs must be unique.
- No duplicate event IDs allowed.
- Sequential IDs should not skip values.
- If an ID is skipped, document it using XML comments.

Example issue:

- `EVT-0011` missing between `EVT-0010` and `EVT-0012`

Fix:

- Add the missing event
- OR document the skip with a comment

---

## Event Name Rules

- Events may have the same name.
- Events with the same name must not share:
  - same date
  - same time

---

## Event Venue Rules

- Events may share the same venue.
- Events in the same venue must not overlap in time.
- Events can use the same venue on different times.

---

## Event Date Rules

- Events may share the same date.
- Events on the same date must not:
  - use the same venue at the same time
  - use the same event name at the same time

---

## Event Category Rules

Events may:

- share the same category
- share the same date
- share the same time

But must not:

- share the same venue simultaneously
- share the same exact event identity combination

---

## Event Capacity Rules

- Registration count must not exceed event capacity.
- Events must contain participants.
- Events cannot have zero participants.

---

# Participant Rules

## Participant IDs

- Participant IDs must be unique.
- No duplicate participant IDs allowed.

---

## Participant Names

- Exact duplicate participant names are not allowed.

---

## Participant Emails

- Email addresses must be unique.
- Multiple participants cannot share the same email.

---

## Participant Scheduling

- Participants cannot register for overlapping events.
- Participants cannot attend two events at the same time.

---

# Registration Rules

## Registration Dates

- Registration date must occur before the event date.

---

## Registration Counts

The registration count inside each event must match actual registration records.

Example issue:

- Event registration count says 8
- But only 1 registration exists

Fix:

- Ensure counts match actual records
- OR explain discrepancies using comments

---

# XML Comments Requirement

The XML should contain short comments explaining:

- Data structure
- Validation assumptions
- Missing IDs
- Static system limitations

Comments should remain short and simple.

---

# Critical XML Fixes

## Department Mismatch

Current issue:

The XSD enumerates short department names while the XML uses full college names.

Examples:

XSD:

- Computer Science
- Business

XML:

- College of Computer Studies
- College of Business and Accountancy

Impact:

- XSD validation fails
- XPath department queries return zero results

Required fix:

Choose ONE naming format and use it consistently across:

- XML
- XSD
- XPath

---

## Event Time Format

Current issue:

XSD uses `xs:time`.

`xs:time` requires:

`HH:MM:SS`

Current XML values use:

`HH:MM`

Fix options:

### Option 1

Update all XML times to:

- `09:00:00`
- `13:30:00`

### Option 2

Change XSD type to string with regex pattern validation.

---

## registrations Element Collision

Current issue:

`registrations` is used for:

- numeric count
- registration container section

DTD cannot support dual meanings.

Required fix:

Rename numeric count element to:

- `registrationCount`

Apply changes consistently across:

- XML
- DTD
- XSD
- XPath
- XSLT

---

# File 2 — DTD File Guide

## Purpose

The DTD validates:

- XML structure
- Element hierarchy
- Required elements
- Basic attribute rules

DTD does NOT support:

- advanced data typing
- assertions
- date validation
- regex patterns

These are handled by XSD.

---

# DTD Requirements

The DTD should define:

- Root structure
- Event elements
- Participant elements
- Registration elements
- Element order
- Required child elements

---

# DTD Validation Scope

DTD validates:

- Required child elements
- Element nesting
- Allowed structure
- ID uniqueness
- ID references

---

# DTD Limitations

DTD cannot validate:

- Dates
- Time formats
- Email formats
- Capacity constraints
- Cross-element conditions

Document these limitations using comments.

---

# Critical DTD Fix

## registrations Element Collision

Problem:

DTD cannot declare:

- `registrations` as text
- and `registrations` as a container

at the same time.

Required solution:

Rename count field to:

`registrationCount`

---

# DTD Comment Requirements

Include short comments explaining:

- Structural validation purpose
- DTD limitations
- Difference between DTD and XSD validation

---

# File 3 — XSD File Guide

## Purpose

The XSD provides advanced validation.

It validates:

- Data types
- Enumerations
- Constraints
- Assertions
- Referential integrity

---

# XSD Requirements

The XSD must validate:

- Event data
- Participant data
- Registration data
- Date rules
- Capacity rules
- Unique constraints

---

# Required XSD Features

## Simple Types

Use simple types for:

- IDs
- Department values
- Categories
- Status values

---

## Enumerations

Use enumerations for:

- Departments
- Event categories
- Registration statuses

---

## Unique Constraints

Use:

- `xs:unique`
- `xs:key`
- `xs:keyref`

For:

- unique participant IDs
- unique event IDs
- registration references

---

# Required XSD Assertions

The project requires XSD 1.1 assertions.

---

## Assertion 1 — Event Date Not in the Past

Requirement:

Event dates must not be in the past.

Use:

- `xs:assert`
- `current-date()`

This requires XSD 1.1.

---

## Assertion 2 — Registration Before Event Date

Requirement:

Participants must register before the event date.

This requires:

- cross-element validation
- event lookup logic
- assertions

Use:

- `xs:assert`
- `xs:key`
- `xs:keyref`

---

# XSD Version Requirement

Assertions require XSD 1.1.

The schema must declare:

- XSD 1.1 support
- proper version configuration

Without this:

- assertions will fail silently

---

# Department Enumeration Consistency

The department enumeration values MUST match:

- XML values
- XPath filters

Choose ONE format only.

Recommended approach:

Use full college names consistently.

Examples:

- College of Computer Studies
- College of Engineering
- College of Business and Accountancy
- College of Arts and Science

---

# Event Time Validation

Current issue:

`xs:time` requires:

`HH:MM:SS`

Fix options:

- update XML times
- OR change validation strategy

---

# Event Category Enumeration

Current issue:

Some enumerated values are unused.

Examples:

- Workshop
- Seminar
- Forum
- Symposium

Possible fixes:

- remove unused enums
- OR create matching events

---

# XSD Comment Requirements

Include comments explaining:

- validation rules
- assertions
- XSD 1.1 requirements
- unique constraints

---

# File 4 — XPath Queries Guide

## Purpose

XPath is used to:

- search records
- filter records
- retrieve subsets of data

---

# XPath Requirements

Minimum required:

- 5 XPath queries

Recommended:

- complex XPath expressions
- filtering
- conditions
- sorting support

---

# Required XPath Coverage

Queries should include:

- participants per event
- participants by department
- approved registrations
- events by category
- events by venue
- upcoming events
- full participant lists

---

# Required Complex XPath Usage

The project specifically requires:

- advanced filtering
- complex conditions
- nested predicates

---

# Critical XPath Fix

## Department Filter Mismatch

Current issue:

XPath queries use:

- `Computer Science`
- `Business`

But XML uses:

- `College of Computer Studies`
- `College of Business and Accountancy`

Impact:

- Queries return zero results

Fix:

Use consistent department values.

---

# XPath File Naming

Recommended filename:

`xpath-queries.txt`

---

# XPath Documentation

Each query should include:

- short description
- purpose
- expected result

---

# File 5 — XSLT File Guide

## Purpose

The XSLT transforms XML into a dashboard-style HTML interface.

---

# XSLT Requirements

The output should:

- look modern
- resemble a dashboard
- remain readable
- display structured event data

---

# Dashboard Design Requirements

The interface should:

- use mostly white layout
- use subtle green accents
- use gray surfaces minimally
- avoid excessive colors
- avoid emojis
- appear professional
- appear modern and clean

---

# XSLT Structure Requirements

The XSLT must:

- use multiple templates
- separate sections logically
- organize dashboard components

---

# Required Dashboard Sections

Recommended sections:

- Event overview
- Upcoming events
- Participant list
- Registration summary
- Attendance sheet
- Event analytics

---

# Required Attendance Sheet Template

Current issue:

The attendance section exists but no dedicated attendance sheet template is implemented.

Requirement:

Create a dedicated named template for attendance generation.

The template should:

- render event attendance lists
- show participants per event
- display registration status

---

# XSLT Transformation Goals

The transformation should:

- improve readability
- summarize event data
- organize records visually
- support reporting

---

# XSLT Comments Requirement

Include short comments explaining:

- template purpose
- dashboard sections
- transformation logic

---

# File 6 — XQuery File Guide

## Purpose

XQuery performs advanced querying and aggregation.

---

# Required XQuery Deliverable

The project requires:

- counting participants per event

---

# XQuery Requirements

The XQuery file should include:

- participant counts
- grouped event statistics
- filtered registration reports
- optional analytics summaries

---

# Recommended XQuery Coverage

Include queries for:

- participant totals
- approved registrations
- events by category
- events by venue
- participant schedules

---

# XQuery File Naming

Recommended filename:

`event-queries.xq`

---

# Static System Notes

This system is static.

Meaning:

- no live database
- no backend updates
- no dynamic registration processing
- all records are manually encoded

Because of this:

- all counts must remain manually consistent
- all references must be validated carefully
- all hard-coded records must align with validation rules

---

# Final Validation Checklist

## XML Checklist

- Well-formed XML
- Unique IDs
- Consistent department values
- Correct event times
- No duplicate participant emails
- No duplicate participant names
- Registration counts consistent
- Missing IDs documented

---

## DTD Checklist

- No element name collisions
- Proper hierarchy declarations
- Correct ID/IDREF usage
- Structural comments included

---

## XSD Checklist

- XSD 1.1 enabled
- Assertions implemented
- Enumerations consistent
- Unique constraints implemented
- Time validation fixed

---

## XPath Checklist

- Minimum 5 queries
- Complex expressions used
- Department filters corrected
- Queries documented

---

## XSLT Checklist

- Dashboard-style HTML output
- Multiple templates used
- Attendance sheet template added
- Structured sections included
- Professional design maintained

---

## XQuery Checklist

- Participant count query included
- Aggregation queries implemented
- File exists and documented

---

# Final Submission Notes

Before submission:

- validate XML against DTD
- validate XML against XSD
- verify XPath query outputs
- verify XQuery outputs
- test XSLT transformation
- confirm dashboard rendering
- ensure all files follow naming conventions
- ensure all comments are short and simple
- ensure all hard-coded records remain consistent

---

# Recommended File Structure

```text
project-folder/
│
├── event-management.xml
├── event-management.dtd
├── event-management.xsd
├── xpath-queries.txt
├── event-dashboard.xsl
├── event-queries.xq
├── generated-dashboard.html
└── README.md
```

---

# Summary

The Event Management System is a static XML-based academic project focused on:

- structured data storage
- XML validation
- XML querying
- XML transformation
- dashboard-style presentation

The project must demonstrate:

- proper XML architecture
- DTD validation
- XSD validation with assertions
- advanced XPath querying
- XQuery aggregation
- professional XSLT transformation
- strict data consistency
- unified file integration

All files must work together consistently.

