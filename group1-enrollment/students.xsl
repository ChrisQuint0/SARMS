<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
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
            background-color: #f8fafc;
            color: #334155;
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
            gap: 24px;
            padding: 30px 40px 10px;
            background-color: transparent;
            border-bottom: none;
            flex-wrap: wrap;
            max-width: 1200px;
            margin: 0 auto;
          }

          .stat-item {
            text-align: center;
            min-width: 180px;
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            align-items: center;
          }

          .stat-value {
            font-size: 36px;
            font-weight: 800;
            color: #006b35;
            display: flex;
            align-items: center;
            gap: 12px;
          }
          
          .stat-value svg {
            color: #10b981;
            opacity: 0.8;
          }

          .stat-label {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #64748b;
            margin-top: 8px;
            font-weight: 600;
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
            border-radius: 12px;
            margin-bottom: 32px;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            overflow: hidden;
            border-left: 6px solid #008a45;
          }

          .student-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 24px 32px;
            background-color: #ffffff;
            border-bottom: 1px solid #e2e8f0;
            flex-wrap: wrap;
            gap: 16px;
          }

          .student-info-wrapper {
            display: flex;
            align-items: center;
            gap: 20px;
          }

          .avatar {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e2e8f0, #cbd5e1);
            color: #475569;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 1px;
            flex-shrink: 0;
            border: 2px solid #ffffff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
          }

          .student-info h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
          }

          .student-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            font-size: 13px;
            color: #64748b;
          }

          .student-meta span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #f8fafc;
            padding: 5px 12px;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            font-weight: 500;
          }

          .student-meta svg {
            color: #006b35;
          }

          /* ========== GPA Badge ========== */
          .gpa-badge {
            padding: 8px 20px;
            border-radius: 24px;
            font-weight: 700;
            font-size: 16px;
            color: #ffffff;
            text-align: center;
            min-width: 110px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
            background-color: #f8fafc;
            color: #64748b;
            padding: 16px 32px;
            text-align: left;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            font-weight: 600;
            border-top: none;
            border-bottom: 1px solid #e2e8f0;
          }

          .subjects-table td {
            padding: 16px 32px;
            border-bottom: 1px solid #e2e8f0; /* Thin, light-gray horizontal line */
            border-left: none; /* No vertical lines */
            border-right: none;
            font-size: 14px;
            color: #334155;
            transition: background-color 0.15s ease;
          }

          .subjects-table tr:last-child td {
            border-bottom: none;
          }

          .subjects-table tr:hover td {
            background-color: #f8fafc;
          }

          .subject-id {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 13px;
            color: #475569;
          }

          .subject-name {
            font-weight: 600;
            color: #1e293b;
          }

          .units-cell {
            color: #64748b;
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

          .grade-excellent { background-color: #d1fae5; color: #065f46; }
          .grade-good { background-color: #dbeafe; color: #1e40af; }
          .grade-average { background-color: #fef3c7; color: #92400e; }
          .grade-poor { background-color: #fee2e2; color: #991b1b; }

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
            position: sticky;
            top: 20px;
            z-index: 10;
            display: flex;
            justify-content: center;
            gap: 16px;
            padding: 16px 24px;
            margin-bottom: 30px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(8px);
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            flex-wrap: wrap;
          }

          .legend-item {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
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
            <div class="stat-value">
              <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
              <xsl:value-of select="count(students/student)"/>
            </div>
            <div class="stat-label">Total Students</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">
              <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/></svg>
              <xsl:value-of select="count(students/student/enrolledSubjects/subject)"/>
            </div>
            <div class="stat-label">Total Enrollments</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">
              <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
              <xsl:value-of select="count(students/student[gpa &lt;= 1.75])"/>
            </div>
            <div class="stat-label">Dean's Listers</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">
              <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
              <xsl:value-of select="count(students/student[gpa &gt; 3.0])"/>
            </div>
            <div class="stat-label">At Risk</div>
          </div>
        </div>

        <div class="container">

          <!-- GPA Legend -->
          <div class="legend">
            <div class="legend-item" style="background: linear-gradient(135deg, #10b981, #059669);">
              <span>Honors (1.00–1.75)</span>
            </div>
            <div class="legend-item" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
              <span>Regular (1.76–2.50)</span>
            </div>
            <div class="legend-item" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
              <span>Warning (2.51–3.00)</span>
            </div>
            <div class="legend-item" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
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
        <div class="student-info-wrapper">
          <div class="avatar">
            <xsl:value-of select="substring(firstName, 1, 1)"/><xsl:value-of select="substring(lastName, 1, 1)"/>
          </div>
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
