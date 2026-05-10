<?xml version="1.0" encoding="UTF-8"?>
<!--
  SARMS - Smart Academic Records Management System
  Group 1: Student Enrollment System - XSLT Stylesheet
  
  This stylesheet transforms the students.xml data into a styled HTML grade report.
  Features:
    - Professional dashboard-style layout with PLP branding
    - Student enrollment summary table with grades and GPA
    - Color-coded GPA indicators (honors, regular, at-risk)
    - Responsive design for easy viewing
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Output method: HTML document -->
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- ============================================================ -->
  <!-- ROOT TEMPLATE: Main page structure                            -->
  <!-- ============================================================ -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>SARMS - Student Enrollment Grade Report</title>
        <style>
          /* ========== Global Styles ========== */
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9fafb;
            color: #111827;
            line-height: 1.6;
          }

          /* ========== Header ========== */
          .header {
            background: linear-gradient(135deg, #004d26 0%, #006b35 50%, #008a45 100%);
            color: #ffffff;
            padding: 40px 40px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
          }

          .header .school-name {
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #a7f3d0;
            margin-bottom: 4px;
          }

          .header h1 {
            font-size: 32px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 14px;
          }

          .header .subtitle {
            font-size: 15px;
            font-weight: 400;
            color: #d1fae5;
            opacity: 0.9;
            margin-top: 4px;
          }

          /* ========== Summary Stats ========== */
          .stats-bar {
            display: flex;
            justify-content: center;
            gap: 30px;
            padding: 20px 40px;
            background-color: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            flex-wrap: wrap;
          }

          .stat-item {
            text-align: center;
            min-width: 120px;
          }

          .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #006b35;
          }

          .stat-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #4b5563;
            margin-top: 4px;
          }

          /* ========== Container ========== */
          .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
          }

          /* ========== Student Card ========== */
          .student-card {
            background-color: #ffffff;
            border-radius: 10px;
            margin-bottom: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            border-left: 5px solid #008a45;
          }

          .student-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 24px;
            background-color: #f9fafb;
            border-bottom: 1px solid #e5e7eb;
            flex-wrap: wrap;
            gap: 10px;
          }

          .student-info h2 {
            font-size: 20px;
            font-weight: 600;
            color: #111827;
          }

          .student-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 10px;
            font-size: 13px;
            color: #4b5563;
          }

          .student-meta span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #f3f4f6;
            padding: 5px 12px;
            border-radius: 20px;
            border: 1px solid #e5e7eb;
            font-weight: 500;
          }

          .student-meta svg {
            color: #006b35;
          }

          /* ========== GPA Badge ========== */
          .gpa-badge {
            padding: 8px 18px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 15px;
            color: #ffffff;
            text-align: center;
            min-width: 100px;
          }

          .gpa-honors {
            background: linear-gradient(135deg, #10b981, #059669);
          }

          .gpa-regular {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
          }

          .gpa-warning {
            background: linear-gradient(135deg, #f59e0b, #d97706);
          }

          .gpa-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
          }

          /* ========== Subject Table ========== */
          .subjects-table {
            width: 100%;
            border-collapse: collapse;
          }

          .subjects-table th {
            background-color: #f9fafb;
            color: #6b7280;
            padding: 14px 24px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            font-weight: 600;
            border-top: 1px solid #e5e7eb;
            border-bottom: 1px solid #e5e7eb;
          }

          .subjects-table td {
            padding: 14px 24px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
            color: #374151;
            transition: background-color 0.15s ease;
          }

          .subjects-table tr:last-child td {
            border-bottom: none;
          }

          .subjects-table tr:hover td {
            background-color: #f9fafb;
          }

          .subject-id {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 12px;
            color: #6b7280;
            background-color: #f3f4f6;
            padding: 4px 8px;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
          }

          .subject-name {
            font-weight: 600;
            color: #111827;
          }

          .units-cell {
            color: #6b7280;
            font-weight: 500;
          }

          .grade-cell {
            font-weight: 700;
            text-align: center;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 13px;
            display: inline-block;
            min-width: 54px;
          }

          .grade-excellent { background-color: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
          .grade-good { background-color: #dbeafe; color: #1e40af; border: 1px solid #bfdbfe; }
          .grade-average { background-color: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
          .grade-poor { background-color: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

          /* ========== Footer ========== */
          .footer {
            text-align: center;
            padding: 24px;
            color: #6b7280;
            font-size: 12px;
            border-top: 1px solid #e5e7eb;
            margin-top: 20px;
          }

          /* ========== Legend ========== */
          .legend {
            display: flex;
            justify-content: center;
            gap: 24px;
            padding: 16px;
            margin-bottom: 24px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            flex-wrap: wrap;
          }

          .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #4b5563;
          }

          .legend-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
          }
        </style>
      </head>
      <body>

        <!-- Page Header -->
        <div class="header">
          <div class="school-name">Pamantasan ng Lungsod ng Pasig</div>
          <h1>
            <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
            Student Enrollment Grade Report
          </h1>
          <div class="subtitle">SARMS: Smart Academic Records Management System <span style="opacity: 0.5; margin: 0 8px;">|</span> Group 1</div>
        </div>

        <!-- Summary Statistics Bar -->
        <div class="stats-bar">
          <div class="stat-item">
            <div class="stat-value"><xsl:value-of select="count(students/student)"/></div>
            <div class="stat-label">Total Students</div>
          </div>
          <div class="stat-item">
            <div class="stat-value"><xsl:value-of select="count(students/student/enrolledSubjects/subject)"/></div>
            <div class="stat-label">Total Enrollments</div>
          </div>
          <div class="stat-item">
            <div class="stat-value"><xsl:value-of select="count(students/student[gpa &lt;= 1.75])"/></div>
            <div class="stat-label">Dean's Listers</div>
          </div>
          <div class="stat-item">
            <div class="stat-value"><xsl:value-of select="count(students/student[gpa &gt; 3.0])"/></div>
            <div class="stat-label">At Risk</div>
          </div>
        </div>

        <div class="container">

          <!-- GPA Legend -->
          <div class="legend">
            <div class="legend-item">
              <div class="legend-dot" style="background: linear-gradient(135deg, #10b981, #059669);"/>
              <span>Honors (1.00–1.75)</span>
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background: linear-gradient(135deg, #3b82f6, #2563eb);"/>
              <span>Regular (1.76–2.50)</span>
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background: linear-gradient(135deg, #f59e0b, #d97706);"/>
              <span>Warning (2.51–3.00)</span>
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background: linear-gradient(135deg, #ef4444, #dc2626);"/>
              <span>At Risk (&gt;3.00)</span>
            </div>
          </div>

          <!-- Apply student template for each student record -->
          <xsl:apply-templates select="students/student"/>

        </div>

        <!-- Footer -->
        <div class="footer">
          <p>SARMS — Smart Academic Records Management System | Pamantasan ng Lungsod ng Pasig</p>
          <p>Group 1: Student Enrollment System | Generated via XSLT Transformation</p>
        </div>

      </body>
    </html>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- STUDENT TEMPLATE: Renders each student as a card              -->
  <!-- ============================================================ -->
  <xsl:template match="student">
    <div class="student-card">

      <!-- Student Header with Name, Meta Info, and GPA Badge -->
      <div class="student-header">
        <div class="student-info">
          <h2>
            <xsl:value-of select="lastName"/>, <xsl:value-of select="firstName"/>
          </h2>
          <div class="student-meta">
            <span>
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 10h2"/><path d="M16 14h2"/><path d="M6.17 15a3 3 0 0 1 5.66 0"/><circle cx="9" cy="11" r="2"/><rect x="2" y="5" width="20" height="14" rx="2"/></svg>
              <xsl:value-of select="@studentId"/>
            </span>
            <span>
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/></svg>
              <xsl:value-of select="course"/>
            </span>
            <span>
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
              Year <xsl:value-of select="yearLevel"/>
            </span>
            <span>
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/><line x1="16" x2="8" y1="13" y2="13"/><line x1="16" x2="8" y1="17" y2="17"/><line x1="10" x2="8" y1="9" y2="9"/></svg>
              <xsl:value-of select="count(enrolledSubjects/subject)"/> Subjects
            </span>
          </div>
        </div>

        <!-- GPA Badge with conditional color coding -->
        <div>
          <xsl:attribute name="class">
            <xsl:text>gpa-badge </xsl:text>
            <xsl:choose>
              <xsl:when test="gpa &lt;= 1.75">gpa-honors</xsl:when>
              <xsl:when test="gpa &lt;= 2.50">gpa-regular</xsl:when>
              <xsl:when test="gpa &lt;= 3.00">gpa-warning</xsl:when>
              <xsl:otherwise>gpa-danger</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          GPA: <xsl:value-of select="gpa"/>
        </div>
      </div>

      <!-- Subject Grades Table -->
      <table class="subjects-table">
        <thead>
          <tr>
            <th>Subject ID</th>
            <th>Subject Name</th>
            <th style="text-align: center;">Units</th>
            <th style="text-align: center;">Grade</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="enrolledSubjects/subject"/>
        </tbody>
      </table>

    </div>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- SUBJECT TEMPLATE: Renders each subject row in the table       -->
  <!-- ============================================================ -->
  <xsl:template match="subject">
    <tr>
      <td><span class="subject-id"><xsl:value-of select="@subjectId"/></span></td>
      <td class="subject-name"><xsl:value-of select="subjectName"/></td>
      <td style="text-align: center;" class="units-cell"><xsl:value-of select="units"/></td>
      <td style="text-align: center;">
        <span>
          <xsl:attribute name="class">
            <xsl:text>grade-cell </xsl:text>
            <xsl:choose>
              <xsl:when test="grade &lt;= 1.50">grade-excellent</xsl:when>
              <xsl:when test="grade &lt;= 2.00">grade-good</xsl:when>
              <xsl:when test="grade &lt;= 3.00">grade-average</xsl:when>
              <xsl:otherwise>grade-poor</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="grade"/>
        </span>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
