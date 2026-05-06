# Smart Academic Records Management System (SARMS)

**Pamantasan ng Lungsod ng Pasig — Integrative Programming**  
**Case Study 4 — XML-Based Academic Records System**

---

## Overview

SARMS is an XML-based academic records management system prototype developed for Pamantasan ng Lungsod ng Pasig (PLP). The system stores, validates, transforms, and queries structured academic data using core XML technologies including DTD, XSD, XPath, and XSLT.

This repository is the central integration point for all group modules. Group 2 (Integration) is responsible for maintaining the unified XML file, schemas, and the dashboard XSLT output.

---

## Repository Structure

```
SARMS/
│
├── sarms.xml                  # Unified XML file containing all modules
├── sarms.dtd                  # Unified Document Type Definition
├── sarms.xsd                  # Unified XML Schema Definition
├── sarms.xsl                  # Unified XSLT stylesheet (dashboard output)
├── sarms-output.html          # Final rendered HTML dashboard
├── README.md                  # Project documentation
│
├── group1-enrollment/         # Student Enrollment System
│   ├── students.xml
│   ├── students.dtd
│   ├── students.xsd
│   ├── students.xsl
│   └── xpath-queries.txt
│
├── group3-faculty/            # Faculty Workload System
│   ├── faculty.xml
│   ├── faculty.dtd
│   ├── faculty.xsd
│   ├── faculty.xsl
│   └── xpath-queries.txt
│
├── group4-library/            # Library Management System
│   ├── library.xml
│   ├── library.dtd
│   ├── library.xsd
│   ├── library.xsl
│   └── xpath-queries.txt
│
├── group5-billing/            # Student Billing System
│   ├── billing.xml
│   ├── billing.dtd
│   ├── billing.xsd
│   ├── billing.xsl
│   └── xpath-queries.txt
│
└── group6-events/             # Event Management System
    ├── events.xml
    ├── events.dtd
    ├── events.xsd
    ├── events.xsl
    └── xpath-queries.txt
```

---

## Group Assignments

| Group   | Module                         | Section in sarms.xml |
| ------- | ------------------------------ | -------------------- |
| Group 1 | Student Enrollment System      | `<students>`         |
| Group 2 | Integration and Unified System | Root `<sarms>`       |
| Group 3 | Faculty Workload System        | `<faculty>`          |
| Group 4 | Library Management System      | `<library>`          |
| Group 5 | Student Billing System         | `<billing>`          |
| Group 6 | Event Management System        | `<events>`           |

---

## Technology Stack

- **XML** — Structured data storage for all academic records
- **DTD** — Document Type Definition for structural validation
- **XSD** — XML Schema Definition for advanced type and constraint validation
- **XPath** — Query language for extracting and filtering XML data
- **XSLT** — Stylesheet language for transforming XML into HTML reports
- **XQuery** _(self-study)_ — Advanced querying of XML data
- **XSD Assertions** _(self-study)_ — Rule-based constraint enforcement

---

## Unified XML Structure

All module data must be merged under the following root structure in `sarms.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE sarms SYSTEM "sarms.dtd">
<sarms>
  <students>
    <!-- Group 1 content -->
  </students>
  <faculty>
    <!-- Group 3 content -->
  </faculty>
  <library>
    <!-- Group 4 content -->
  </library>
  <billing>
    <!-- Group 5 content -->
  </billing>
  <events>
    <!-- Group 6 content -->
  </events>
</sarms>
```

---

## Contribution Workflow

### Initial Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/<org>/SARMS.git
   cd SARMS
   ```

2. Create your group branch using the naming convention below:
   ```bash
   git checkout -b group<number>-<module>
   ```

### Branch Naming Convention

| Group   | Branch Name         |
| ------- | ------------------- |
| Group 1 | `group1-enrollment` |
| Group 3 | `group3-faculty`    |
| Group 4 | `group4-library`    |
| Group 5 | `group5-billing`    |
| Group 6 | `group6-events`     |

### Submitting Work

1. Complete all required files inside your group folder only.
2. Do not modify files outside your assigned folder.
3. Commit your changes with a clear message:
   ```bash
   git add group<number>-<module>/
   git commit -m "Group <number>: Add <module> XML, DTD, XSD, and XSLT"
   git push origin group<number>-<module>
   ```
4. Open a Pull Request (PR) to the `main` branch on GitHub.
5. Group 2 will review and merge the PR into the unified files.

---

## Naming Conventions

- All element names use **camelCase** (e.g., `studentId`, `yearLevel`, `dueDate`)
- All attribute names use **camelCase**
- All file names use **kebab-case** for group files (e.g., `xpath-queries.txt`)
- All ID values follow the format: `<MODULE>-<NUMBER>` (e.g., `STU-001`, `FAC-001`, `BK-001`)

---

## Notes

- Ensure all XML documents are **well-formed** before submitting a PR.
- Include comments in your code to explain structure and validation rules.
- Do not commit directly to `main`. All changes go through a pull request.
- Coordinate with Group 2 if there are naming conflicts or structural issues.
