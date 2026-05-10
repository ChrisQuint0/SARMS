# Technical Documentation: Faculty Workload Module (Group 3)

This document outlines the structure, validation, and querying mechanisms for the Group 3 module of the **Smart Academic Records Management System (SARMS)**.

---

## 1. Data Structure Overview
To align with the **Group 2 Unified Structure**, our module is designed to be a standalone section that can be easily merged into the master `sarms.xml` file.

### XML Hierarchy
We use a **Plural/Singular** naming convention to avoid element name collisions and ensure clarity:
- **`<faculty>`**: The root wrapper for the entire module section.
- **`<faculty_member>`**: An individual faculty record.
  - **`<id>`**: Unique identifier (e.g., F001).
  - **`<name>`**: Full name with titles.
  - **`<department>`**: Academic department.
  - **`<subjects>`**: Wrapper for teaching assignments.
    - **`<subject>`**: Individual teaching unit (Name + Hours).
  - **`<total_hours>`**: Calculated weekly teaching load.

---

## 2. Schema Validation Strategy

### DTD (Document Type Definition)
Used for a high-level structural overview. It ensures that every record contains the required fields in the correct order.
> **Why we use it**: It is lightweight and easy to read for humans to understand the "skeleton" of our XML.

### XSD (XML Schema Definition)
Used for strict data typing and business rules.
- **Data Typing**: Ensures `hours` and `total_hours` are integers.
- **Constraints**: Restricts `total_hours` to a maximum of **30** per week using `<xs:maxInclusive>`.

---

## 3. Advanced XML Technologies (Self-Study)

### XPath: Data Extraction
**Purpose**: To quickly find specific pieces of data without searching the whole file.
- **Example**: `//faculty_member[count(subjects/subject) > 3]`
- **How it works**: It navigates the XML tree like a file system. In this example, it looks for any "faculty_member" where the count of their child "subject" elements is greater than 3.

### XQuery: Data Processing
**Purpose**: To filter, sort, and transform XML data into new formats.
- **Our Implementation**:
  ```xquery
  for $f in doc("faculty.xml")//faculty_member
  where $f/total_hours >= 30
  return <overloaded>{$f/name/text()}</overloaded>
  ```
- **How to do it**: Use the **FLWOR** expression (For, Let, Where, Order by, Return). It allows us to perform "SQL-like" operations on our XML data.

### XSD Assertions: Rule Enforcement
**Purpose**: To enforce complex logic that standard XSD can't handle (requires XSD 1.1).
- **Our Implementation**: 
  - `<xs:assert test="sum(subjects/subject/hours) = total_hours"/>`
- **How it works**: It checks a boolean condition. If the sum of individual subject hours does not exactly match the `total_hours` value, the XML is marked as invalid. This prevents data entry errors.

---

## 4. Integration Guide
When merging into the unified `sarms.xml`:
1. Copy the content inside our `<faculty>` wrapper.
2. Paste it into the corresponding `<faculty>` section in `sarms.xml`.
3. The `sarms.xsd` will then include our structural rules to ensure the entire system remains valid.
