# University Events Management System

## Project Overview

A comprehensive XML-based events management system designed for university-wide event coordination, participant tracking, and registration management. The system provides professional dashboard interfaces for viewing events, participants, and detailed reports with attendance analytics.

## Project Structure

```
group6-events/
├── README.md                          # This file
├── xml/
│   ├── events-data.xml               # Central XML data repository (50 events, 125 participants, 200 registrations)
│   ├── events.dtd                    # Document Type Definition for structural validation
│   └── events-schema.xsd             # XML Schema with type validation and business rule assertions
├── xpath/
│   └── xpath-queries.txt             # 33 XPath queries for data extraction and filtering
├── xquery/
│   └── event-reports.xquery          # 10 advanced XQuery queries for reporting and analysis
├── xslt/
│   └── events-transform.xsl          # XSLT 1.0 stylesheet transforming XML to HTML pages
├── html/
│   ├── index.html                    # Dashboard with summary statistics and upcoming events
│   ├── events.html                   # Complete events listing with all 50 events
│   ├── participants.html             # All 125 participants with registration status
│   └── reports.html                  # Detailed reports, attendance projections, and analytics
└── css/
    └── style.css                     # Professional design system with responsive styling
```

## Data Architecture

### Events (50 total)
- **ID Format:** EVT-001 to EVT-050
- **Categories:** Technology, Business, Science, Arts, Professional Development
- **Date Range:** May 25, 2026 - July 25, 2026
- **Attributes:** eventId, eventName, eventDate, venue, eventDescription, eventStatus

### Participants (125 total)
- **ID Format:** PAR-001 to PAR-125
- **Departments:** Computer Science, Engineering, Business, Science, Humanities (25 each)
- **Attributes:** participantId, fullName, department, email, registrationDate, status

### Registrations (200 total)
- **ID Format:** REG-001 to REG-200
- **Status Distribution:** 160 Registered (80%), 40 Pending (20%)
- **Attributes:** registrationId, eventId, participantId, registrationDate, registrationStatus

## Key Features

### 1. Dashboard (index.html)
- **Summary Statistics:** Total events, participants, registrations, average per event
- **Upcoming Events:** Top 10 upcoming events sorted by date
- **Registration Overview:** Confirmed vs. pending counts with confirmation rate
- **Department Breakdown:** Participant distribution across 5 departments

### 2. Events Listing (events.html)
- **Complete Events Table:** All 50 events with ID, name, date, venue, status, and registration count
- **Status Indicators:** "Upcoming" for future dates, "Past" for historical events
- **Technology Events Showcase:** Featured tech event cards
- **Sorted Display:** Events ordered by date for easy planning

### 3. Participants Directory (participants.html)
- **Full Participant Database:** All 125 participants with ID, name, department, event count, and status
- **Status Badges:** Displays number of confirmed and pending registrations per participant
- **Department Grouping:** Logical organization by academic department
- **Engagement Tracking:** Shows total events registered per participant

### 4. Reports & Analytics (reports.html)
- **Attendance Projections:** Summary statistics on expected attendance
- **Detailed Attendance Sheets:** Top 15 events with venue and registration breakdown
- **Registration Summary:** Status distribution with percentages
- **Key Insights:** Registration patterns, department engagement, category performance
- **Recommendations:** Actionable suggestions for event managers

## Design System

### Color Palette
| Element | Color | Hex Code |
|---------|-------|----------|
| Primary | Green | #0F8A5F |
| Primary Light | Light Green | #E8F5EE |
| Success | Green | #16A34A |
| Warning | Amber | #F59E0B |
| Danger | Red | #DC2626 |
| Text | Dark Gray | #4B5563 |
| Background | Light Gray | #F8FAFC |
| Surface | White | #FFFFFF |

### Typography
- **Font Family:** -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, etc.
- **Sizes:** sm (0.875rem), base (1rem), lg (1.125rem), xl (1.25rem), 2xl (1.5rem), 3xl (1.875rem), 4xl (2.25rem)
- **Weights:** Regular (400), Semi-bold (600), Bold (700)

### Components
- **Cards:** White background with subtle shadows and hover effects
- **Stat Cards:** Left-bordered cards with large numeric values and labels
- **Tables:** Green headers with alternating row colors on hover
- **Badges:** Color-coded status indicators (Success/Pending/Danger/Primary)
- **Buttons:** Primary, secondary, and danger variants
- **Navigation:** Sticky header with active state indicator

## Validation & Technical Specifications

### XML Validation
- **Well-Formedness:** All files validate against XML 1.0 standard
- **DTD Validation:** events-data.xml validates against events.dtd
- **XSD Validation:** events-data.xml validates against events-schema.xsd with assertions

### Business Rules (XSD Assertions)
- Event dates must be >= 2026-05-11 (no past events)
- Registration status restricted to "Registered" or "Pending"
- Email format validation using regex pattern
- Referential integrity between registrations and events/participants

### Query Capabilities

#### XPath Queries (33 total)
- **Basic Queries (5):** List all events/participants, count totals
- **Filtering (5):** Status-based, department-based filtering
- **Date-Based (3):** Upcoming events, month filtering
- **Venue-Based (4):** Venue filtering, unique venue extraction
- **Registration (5):** Participant per event, events per participant
- **Complex (8):** Multi-event participants, tech events, date ranges
- **Statistical (3):** Registration ratios, popularity ranking

#### XQuery Queries (10 total)
1. Event summaries with participant counts
2. Participant activity reports
3. Department statistics
4. Attendance projections
5. Event popularity rankings
6. Unpopular event identification
7. Cross-department participation diversity
8. Monthly registration timeline
9. Active participants (>2 event registrations)
10. Executive summary dashboard

## How to Use

### Viewing the Dashboard
1. Open `html/index.html` in a web browser
2. Use navigation menu to switch between Dashboard, Events, Participants, and Reports
3. Click on any link to navigate between pages
4. All pages are responsive and work on mobile devices

### Validating XML Files
```bash
# Check well-formedness (using xmllint or similar tool)
xmllint xml/events-data.xml

# Validate against DTD
xmllint --dtdvalid xml/events.dtd xml/events-data.xml

# Validate against XSD
xmllint --schema xml/events-schema.xsd xml/events-data.xml
```

### Running XPath Queries
Refer to `xpath/xpath-queries.txt` for 33 documented queries that can be executed against `events-data.xml` using any XPath 1.0 compatible tool.

### Running XQuery Reports
Execute queries from `xquery/event-reports.xquery` using any XQuery processor:
```bash
# Using Saxon (example)
java -cp saxon.jar net.sf.saxon.Query event-reports.xquery
```

### XSLT Transformation
Transform XML to HTML using `xslt/events-transform.xsl`:
```bash
# Using xsltproc
xsltproc xslt/events-transform.xsl xml/events-data.xml > output.html

# Using Saxon
java -cp saxon.jar net.sf.saxon.Transform -o output.html \
  xml/events-data.xml xslt/events-transform.xsl
```

## Data Summary

| Category | Count | Details |
|----------|-------|---------|
| Events | 50 | Spanning May 25 - July 25, 2026 |
| Participants | 125 | Across 5 departments, 25 per department |
| Registrations | 200 | 160 Confirmed (80%), 40 Pending (20%) |
| Event Categories | 5 | Tech, Business, Science, Arts, Professional |
| Departments | 5 | CS, Engineering, Business, Science, Humanities |

## Key Metrics

- **Average Registrations per Event:** 4.0
- **Tech Events (10 events):** 5 registrations each
- **Science Events (10 events):** 1 registration each
- **Arts/Humanities (10 events):** 1 registration each
- **Professional Development (10 events):** 4.4 registrations average
- **Business Events (10 events):** 5 registrations each
- **Overall Confirmation Rate:** 80%
- **Average Participants per Event:** 3.2

## Technical Stack

| Component | Technology |
|-----------|-----------|
| Data Format | XML 1.0 |
| Structure Validation | DTD 1.0 |
| Schema Validation | XSD 1.0 with Assertions |
| Data Querying | XPath 1.0 |
| Advanced Reporting | XQuery 1.0 |
| HTML Transformation | XSLT 1.0 |
| Styling | CSS3 with Custom Properties |
| HTML Output | HTML5 Semantic Markup |
| Responsive Design | CSS Grid & Flexbox |

## Browser Compatibility

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+
- Mobile browsers (iOS Safari, Chrome Mobile)

## Files Description

### xml/events-data.xml
Central data repository containing all 50 events, 125 participants, and 200 registrations. Serves as the single source of truth for the entire system.

### xml/events.dtd
Validates the structure of events-data.xml using Document Type Definition. Defines element declarations, attribute lists, and ID/IDREF relationships.

### xml/events-schema.xsd
Advanced schema with XSD 1.0 type definitions and assertions. Enforces business rules such as date constraints, email validation, and enum restrictions.

### xpath/xpath-queries.txt
Documentation of 33 XPath 1.0 queries for data extraction, filtering, and analysis. Each query includes expected results and use cases.

### xquery/event-reports.xquery
Collection of 10 advanced XQuery queries generating formatted reports, statistics, and analysis from the event data.

### xslt/events-transform.xsl
Master XSLT stylesheet with named templates for transforming XML data into 4 professional HTML dashboard pages. Includes utility templates for date formatting and data filtering.

### html/index.html
Dashboard home page with summary statistics, upcoming events table, registration overview, and department breakdown cards.

### html/events.html
Complete listing of all 50 events with table view, status indicators, and technology events showcase section.

### html/participants.html
Directory of all 125 participants organized by department with event registration counts and confirmation status.

### html/reports.html
Comprehensive reports page with attendance projections, detailed attendance sheets, registration summary, and recommendations.

### css/style.css
Professional design system with CSS custom properties, component styling, responsive layouts, and utility classes. Covers all elements from typography to tables to forms.

## Future Enhancements

- Interactive event registration forms
- Real-time attendance tracking
- Email notification system
- Export to CSV/PDF functionality
- Advanced filtering and search
- User authentication and roles
- Event calendar view
- Department-specific dashboards
- Mobile app version
- Analytics dashboard with charts

## License

This project is provided as-is for educational and university event management purposes.

## Contact & Support

For questions or issues regarding this Events Management System, please contact the development team or refer to the project documentation.

---

**Last Updated:** 2026-05-11  
**Version:** 1.0  
**Status:** Complete Implementation
