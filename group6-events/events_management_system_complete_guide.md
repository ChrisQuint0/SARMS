# Events Management System — Complete Project Guide

## System Overview

The **Events Management System** is a static XML-based academic project designed to manage university events and participants. The system stores structured event data using XML and applies XML technologies such as DTD, XSD, XPath, XSLT, XQuery, and XSD Assertions for validation, querying, transformation, and rule enforcement.

The project follows a dashboard-style structure with modern, clean, and professional UI principles.

---

# System Requirements

## Functional Requirements

The system must:

- Store structured academic data using XML
- Ensure data integrity via DTD and XSD
- Transform data into readable formats using XSLT
- Extract and filter data using XPath
- Support advanced querying using XQuery
- Enforce rules using XSD Assertions

---

# Tech Stack

- **XML** — Structured data storage for all academic records
- **DTD** — Document Type Definition for structural validation
- **XSD** — XML Schema Definition for advanced type and constraint validation
- **XPath** — Query language for extracting and filtering XML data
- **XSLT** — Stylesheet language for transforming XML into HTML reports
- **XQuery** _(self-study)_ — Advanced querying of XML data
- **XSD Assertions** _(self-study)_ — Rule-based constraint enforcement

---

# System Scope

The system manages university events and participants.

## Stored Data

The system stores:

- Event name
- Event date
- Venue
- Participants
- Registration status

---

# Required Tasks

## DTD
Used for XML structure validation.

## XSD
Validates:
- Correct data types
- Event date must not be in the past

## XPath
Used to:
- List participants per event
- Filter event data

## XSLT
Used to:
- Generate event attendance sheets
- Transform XML into dashboard-style HTML pages

## XQuery
Used to:
- Count participants per event

## XSD Assertion
Validates:
- Participant must be registered before event date

---

# Project Notes

- All records are hard coded (minimum of 100 records)
- The system is static
- Ensure all XML documents are well-formed
- Include simple short comments in the code
- Integrate all records into one unified XML system
- Create dashboard-style HTML output
- Use multiple XSLT templates
- Apply complex XPath expressions

---

# Naming Conventions

## Element Names
Use camelCase:

```xml
<eventName>
<eventDate>
<registrationStatus>
```

## Attribute Names
Use camelCase:

```xml
eventId
participantId
```

## File Names
Use kebab-case:

```text
events-data.xml
events-schema.xsd
xpath-queries.txt
```

## ID Format

```text
EVT-001
PAR-001
REG-001
```

---

# Design System

## Design Philosophy

The system must follow a sleek, modern, simple, and professional dashboard design.

The interface should:

- Use mostly white and neutral colors
- Use subtle green accents
- Minimize yellow usage
- Use red only for destructive actions
- Avoid emojis and excessive decorations
- Maintain clean spacing and hierarchy

---

# Core Design Tokens

| Token | Variable | Value | Usage |
|---|---|---|---|
| Primary Green | `--primary-500` | `#008A45` | Main brand color, buttons, headers |
| Primary Green Light | `--primary-100` | `#E8F5EE` | Hover states, highlights |
| Surface White | `--surface-0` | `#FFFFFF` | Main backgrounds |
| Surface Gray | `--surface-50` | `#F8FAFC` | Secondary sections |
| Border Gray | `--border-200` | `#E5E7EB` | Borders and dividers |
| Text Primary | `--neutral-900` | `#111827` | Main text |
| Text Secondary | `--neutral-600` | `#4B5563` | Secondary text |
| Success | `--success-500` | `#16A34A` | Success indicators |
| Warning | `--warning-500` | `#F59E0B` | Minor warnings |
| Destructive | `--danger-500` | `#DC2626` | Delete buttons and errors |

---

# Design Style Guidelines

## Layout

The layout should:

- Use a white-dominant interface
- Include soft gray backgrounds
- Use subtle shadows
- Apply thin borders and dividers
- Maintain consistent spacing
- Use rounded corners minimally

---

## Typography

Use:

- Clean sans-serif fonts
- Strong readability
- Minimal font weight variations
- Neutral dark text colors

---

## Table Styling

Tables should:

- Use white backgrounds
- Use thin gray borders
- Include subtle row hover effects
- Use green for table headers only
- Maintain compact spacing

---

## Color Usage Rules

### Green Usage
Use green for:
- Headers
- Active states
- Buttons
- Success indicators
- Dashboard highlights

Green should remain an accent color only.

---

### Yellow Usage
Yellow usage must remain minimal.

Use yellow only for:
- Minor warnings
- Small notification indicators

Avoid large yellow sections.

---

### Red Usage
Red is reserved strictly for:
- Delete actions
- Failed validations
- Dangerous actions
- Error indicators

---

# Simple Website Page Guide

The system uses four simple HTML pages generated from XML and XSLT.

---

# 1. Dashboard Page (`index.html`)

## Purpose
Main landing page of the system.

## Contents
- Total Events
- Total Participants
- Upcoming Events
- Registration Summary
- Navigation Links

## XML Features Used
- XSLT transforms XML into dashboard cards
- XPath extracts summary data

## Example Sections
- Summary Cards
- Upcoming Events Table
- Quick Statistics

---

# 2. Events Page (`events.html`)

## Purpose
Displays all university events.

## Contents
- Event ID
- Event Name
- Event Date
- Venue
- Event Status

## XML Features Used
- XML stores event records
- DTD validates structure
- XSD validates dates and constraints
- XSLT transforms data into HTML tables

---

# 3. Participants Page (`participants.html`)

## Purpose
Displays all participants registered for events.

## Contents
- Participant ID
- Full Name
- Event Registered
- Registration Status
- Registration Date

## XML Features Used
- XPath filters participants
- XSLT generates participant tables
- XSD Assertions validate registration rules

---

# 4. Reports Page (`reports.html`)

## Purpose
Displays reports, attendance sheets, and statistics.

## Contents
- Attendance Sheet
- Participant Counts
- Event Statistics
- Registered vs Unregistered Reports

## XML Features Used
- XSLT generates attendance sheet
- XPath filters event reports
- XQuery counts participants per event

---

# Suggested Project Structure

```text
event-management-system/
│
├── xml/
│   ├── events-data.xml
│   ├── events.dtd
│   ├── events-schema.xsd
│
├── xslt/
│   ├── events-transform.xsl
│
├── xpath/
│   ├── xpath-queries.txt
│
├── xquery/
│   ├── event-reports.xquery
│
├── html/
│   ├── index.html
│   ├── events.html
│   ├── participants.html
│   ├── reports.html
│
├── css/
│   ├── style.css
│
└── README.md
```

---

# Unified XML Structure

## Root Element

```xml
<eventManagementSystem>
```

## Main Sections

```xml
<events>
<participants>
<registrations>
```

---

# Sample XML Data

## Event Record

```xml
<event eventId="EVT-001">
    <eventName>University Tech Expo</eventName>
    <eventDate>2026-06-20</eventDate>
    <venue>Main Auditorium</venue>
</event>
```

## Participant Record

```xml
<participant participantId="PAR-001">
    <fullName>Juan Dela Cruz</fullName>
    <registrationStatus>Registered</registrationStatus>
</participant>
```

---

# Required XPath Queries

## List all events

```xpath
//event
```

## List registered participants

```xpath
//participant[registrationStatus='Registered']
```

## List participants of a specific event

```xpath
//event[eventId='EVT-001']/participants/participant
```

## List upcoming events

```xpath
//event[eventDate > current-date()]
```

## Count all participants

```xpath
count(//participant)
```

---

# Required XQuery Example

```xquery
for $event in //event
return
<eventSummary>
    <eventName>{data($event/eventName)}</eventName>
    <participantCount>{count($event/participants/participant)}</participantCount>
</eventSummary>
```

---

# Example XSD Assertion

```xml
<xs:assert test="registrationDate le eventDate"/>
```

---

# Required Submission Files

## Core XML Files
- `events-data.xml`
- `events.dtd`
- `events-schema.xsd`

## Query Files
- `xpath-queries.txt`
- `event-reports.xquery`

## XSLT Files
- `events-transform.xsl`

## HTML Output Files
- `index.html`
- `events.html`
- `participants.html`
- `reports.html`

---

# Final Notes

To fully satisfy the project requirements:

- Ensure all XML documents are well-formed
- Use at least 100 hard-coded records
- Apply multiple XSLT templates
- Include dashboard-style HTML output
- Use advanced XPath expressions
- Include simple comments in the code
- Keep the system static and organized
- Integrate all records into one XML system
- Maintain a clean and professional UI design

