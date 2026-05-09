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
            background-color: #f0f2f5;
            color: #1a1a2e;
            line-height: 1.6;
          }

          /* ========== Header ========== */
          .header {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: #ffffff;
            padding: 30px 40px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
          }

          .header h1 {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: 1.5px;
            margin-bottom: 8px;
          }

          .header .subtitle {
            font-size: 14px;
            font-weight: 300;
            opacity: 0.85;
            letter-spacing: 0.5px;
          }

          .header .school-name {
            font-size: 16px;
            font-weight: 500;
            margin-top: 4px;
            color: #e2b714;
          }

          /* ========== Summary Stats ========== */
          .stats-bar {
            display: flex;
            justify-content: center;
            gap: 30px;
            padding: 20px 40px;
            background-color: #ffffff;
            border-bottom: 1px solid #e0e0e0;
            flex-wrap: wrap;
          }

          .stat-item {
            text-align: center;
            min-width: 120px;
          }

          .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #0f3460;
          }

          .stat-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #666;
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
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            border-left: 5px solid #0f3460;
          }

          .student-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 24px;
            background-color: #fafbfc;
            border-bottom: 1px solid #eee;
            flex-wrap: wrap;
            gap: 10px;
          }

          .student-info h2 {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a2e;
          }

          .student-meta {
            display: flex;
            gap: 16px;
            margin-top: 4px;
            font-size: 13px;
            color: #555;
          }

          .student-meta span {
            display: inline-flex;
            align-items: center;
            gap: 4px;
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
            background: linear-gradient(135deg, #00b894, #00cec9);
          }

          .gpa-regular {
            background: linear-gradient(135deg, #0984e3, #6c5ce7);
          }

          .gpa-warning {
            background: linear-gradient(135deg, #fdcb6e, #e17055);
          }

          .gpa-danger {
            background: linear-gradient(135deg, #d63031, #e84393);
          }

          /* ========== Subject Table ========== */
          .subjects-table {
            width: 100%;
            border-collapse: collapse;
          }

          .subjects-table th {
            background-color: #16213e;
            color: #ffffff;
            padding: 12px 24px;
            text-align: left;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
          }

          .subjects-table td {
            padding: 12px 24px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
          }

          .subjects-table tr:last-child td {
            border-bottom: none;
          }

          .subjects-table tr:hover {
            background-color: #f8f9fa;
          }

          .grade-cell {
            font-weight: 600;
            text-align: center;
            border-radius: 4px;
            padding: 4px 10px;
          }

          .grade-excellent { color: #00b894; }
          .grade-good { color: #0984e3; }
          .grade-average { color: #fdcb6e; }
          .grade-poor { color: #d63031; }

          /* ========== Footer ========== */
          .footer {
            text-align: center;
            padding: 24px;
            color: #999;
            font-size: 12px;
            border-top: 1px solid #e0e0e0;
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
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            flex-wrap: wrap;
          }

          .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #555;
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
          <h1>&#x1F393; SARMS — Student Enrollment Grade Report</h1>
          <div class="school-name">Pamantasan ng Lungsod ng Pasig</div>
          <div class="subtitle">Smart Academic Records Management System — Group 1: Student Enrollment</div>
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
              <div class="legend-dot" style="background: linear-gradient(135deg, #00b894, #00cec9);"/>
              <span>Honors (1.00–1.75)</span>
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background: linear-gradient(135deg, #0984e3, #6c5ce7);"/>
              <span>Regular (1.76–2.50)</span>
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background: linear-gradient(135deg, #fdcb6e, #e17055);"/>
              <span>Warning (2.51–3.00)</span>
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background: linear-gradient(135deg, #d63031, #e84393);"/>
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
            <span>&#x1F194; <xsl:value-of select="@studentId"/></span>
            <span>&#x1F4DA; <xsl:value-of select="course"/></span>
            <span>&#x1F4C5; Year <xsl:value-of select="yearLevel"/></span>
            <span>&#x1F4DD; <xsl:value-of select="count(enrolledSubjects/subject)"/> Subjects</span>
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
      <td><xsl:value-of select="@subjectId"/></td>
      <td><xsl:value-of select="subjectName"/></td>
      <td style="text-align: center;"><xsl:value-of select="units"/></td>
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
