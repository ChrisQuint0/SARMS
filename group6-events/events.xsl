<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

  <!-- Date Formatting Template: YYYY-MM-DD to MM/DD/YYYY -->
  <xsl:template name="formatDate">
    <xsl:param name="dateString"/>
    <xsl:choose>
      <xsl:when test="string-length($dateString) >= 10">
        <xsl:variable name="year" select="substring($dateString, 1, 4)"/>
        <xsl:variable name="month" select="substring($dateString, 6, 2)"/>
        <xsl:variable name="day" select="substring($dateString, 9, 2)"/>
        <xsl:value-of select="concat($month, '/', $day, '/', $year)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dateString"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Time Formatting Template: 24-hour to 12-hour with AM/PM -->
  <xsl:template name="formatTime">
    <xsl:param name="timeString"/>
    <xsl:choose>
      <xsl:when test="string-length($timeString) >= 5">
        <xsl:variable name="hour" select="number(substring($timeString, 1, 2))"/>
        <xsl:variable name="minute" select="substring($timeString, 4, 2)"/>
        <xsl:choose>
          <xsl:when test="$hour = 0">
            <xsl:value-of select="concat('12:', $minute, ' AM')"/>
          </xsl:when>
          <xsl:when test="$hour = 12">
            <xsl:value-of select="concat('12:', $minute, ' PM')"/>
          </xsl:when>
          <xsl:when test="$hour > 12">
            <xsl:value-of select="concat($hour - 12, ':', $minute, ' PM')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($hour, ':', $minute, ' AM')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$timeString"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="attendanceSheet">
    <div class="table-wrap">
      <table id="attendanceTable">
        <thead><tr><th>Event ID</th><th>Event Name</th><th>Date</th><th>Venue</th><th>Participant Name</th><th>Email</th><th>Status</th></tr></thead>
        <tbody id="attendanceTableBody">
          <xsl:for-each select="//event">
            <xsl:sort select="eventName"/>
            <xsl:variable name="eventId" select="@eventId"/>
            <xsl:variable name="eventNameVal" select="eventName"/>
            <xsl:variable name="eventDateVal" select="eventDate"/>
            <xsl:variable name="eventVenueVal" select="venue"/>
            <xsl:for-each select="//registration[@eventId=$eventId]">
              <xsl:sort select="@registrationDate"/>
              <xsl:variable name="participantId" select="@participantId"/>
              <xsl:variable name="participant" select="//participant[@participantId=$participantId]"/>
              <tr data-reg-status="{@registrationStatus}">
                <td><xsl:value-of select="$eventId"/></td>
                <td><xsl:choose><xsl:when test="$eventNameVal!=''"><xsl:value-of select="$eventNameVal"/></xsl:when><xsl:otherwise><span class="empty-cell">-</span></xsl:otherwise></xsl:choose></td>
                <td><xsl:choose><xsl:when test="$eventDateVal!=''"><xsl:value-of select="$eventDateVal"/></xsl:when><xsl:otherwise><span class="empty-cell">-</span></xsl:otherwise></xsl:choose></td>
                <td><xsl:choose><xsl:when test="$eventVenueVal!=''"><xsl:value-of select="$eventVenueVal"/></xsl:when><xsl:otherwise><span class="empty-cell">-</span></xsl:otherwise></xsl:choose></td>
                <td><xsl:value-of select="$participant/fullName"/></td>
                <td><xsl:value-of select="$participant/email"/></td>
                <td><xsl:choose><xsl:when test="@registrationStatus='Registered'"><span class="badge badge-registered">Registered</span></xsl:when><xsl:when test="@registrationStatus='Attended'"><span class="badge badge-attended">Attended</span></xsl:when><xsl:when test="@registrationStatus='Cancelled'"><span class="badge badge-cancelled">Cancelled</span></xsl:when><xsl:otherwise><span class="badge badge-noshow">No-show</span></xsl:otherwise></xsl:choose></td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Events Management System</title>
        <style>
          :root {
            --green-700: #006B35;
            --green-500: #008A45;
            --green-100: #E6F4EC;
            --surface-0: #FFFFFF;
            --surface-50: #F8FAFC;
            --border: #E5E7EB;
            --text-primary: #111827;
            --text-secondary: #4B5563;
            --text-muted: #6B7280;
            --text-inverted: #FFFFFF;
            --danger-500: #DC2626;
            --danger-100: #FEE2E2;
            --success-500: #10B981;
            --success-100: #D1FAE5;
            --warning-500: #F59E0B;
            --warning-100: #FEF3C7;
            --info-500: #3B82F6;
            --info-100: #DBEAFE;
            --sp-1: 0.5rem;
            --sp-2: 1rem;
            --sp-3: 1.5rem;
            --sp-4: 2rem;
            --text-xs: 0.75rem;
            --text-sm: 0.875rem;
            --text-base: 1rem;
            --text-lg: 1.125rem;
            --text-xl: 1.25rem;
            --text-2xl: 1.5rem;
            --text-3xl: 1.875rem;
          }

          *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, var(--surface-50) 0%, #F1F5F9 100%);
            color: var(--text-primary);
            line-height: 1.5;
          }

          .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            width: 100%;
            z-index: 1000;
            background: linear-gradient(135deg, var(--green-700), var(--green-500));
            color: var(--text-inverted);
            padding: var(--sp-2) var(--sp-3);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
          }

          .header-inner {
            max-width: 96%;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
          }

          .header-title { font-size: var(--text-xl); font-weight: 700; letter-spacing: -0.02em; }
          .header-sub { font-size: var(--text-sm); color: rgba(255, 255, 255, 0.7); margin-top: 2px; }

          .navbar {
            display: flex;
            gap: var(--sp-2);
            list-style: none;
          }

          .navbar a {
            color: var(--text-inverted);
            text-decoration: none;
            font-size: var(--text-sm);
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.2s ease;
          }

          .navbar a:hover { background-color: rgba(255, 255, 255, 0.15); }
          .navbar a.active {
            background-color: rgba(255, 255, 255, 0.15);
            font-weight: 600;
          }

          main { margin-top: 85px; }
          .container { max-width: 96%; margin: 0 auto; padding: var(--sp-3) 1rem; }
          .section { margin-bottom: var(--sp-4); }

          .section-header { margin-bottom: var(--sp-3); }

          .section-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: var(--sp-2);
            flex-wrap: wrap;
          }

          .see-all-btn {
            display: inline-block;
            padding: 10px 16px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--green-500), var(--green-700));
            color: var(--text-inverted);
            text-decoration: none;
            font-size: var(--text-sm);
            font-weight: 700;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
          }

          .see-all-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 14px rgba(0, 0, 0, 0.16);
          }

          h2 {
            font-size: var(--text-3xl);
            font-weight: 700;
            color: var(--green-700);
            border-left: 5px solid var(--green-500);
            padding-left: var(--sp-2);
            margin-bottom: 8px;
            letter-spacing: -0.01em;
          }

          .section-desc {
            font-size: var(--text-base);
            color: var(--text-muted);
            margin-left: var(--sp-2);
            margin-bottom: var(--sp-3);
            padding-left: 4px;
          }

          h3 {
            font-size: var(--text-xl);
            font-weight: 600;
            color: var(--green-700);
            margin-bottom: var(--sp-2);
          }

          /* Dashboard Stats Cards */
          .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: var(--sp-3);
            margin-bottom: var(--sp-4);
          }

          .stat-card {
            border-radius: 20px;
            padding: var(--sp-3);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            text-align: center;
            transition: all 0.3s ease;
          }

          .stat-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); }

          .stat-card:nth-child(1) { background: linear-gradient(135deg, #EFF6FF, #DBEAFE); border-bottom: 3px solid #3B82F6; }
          .stat-card:nth-child(2) { background: linear-gradient(135deg, #F5F3FF, #EDE9FE); border-bottom: 3px solid #8B5CF6; }
          .stat-card:nth-child(3) { background: linear-gradient(135deg, #FFF7ED, #FFEDD5); border-bottom: 3px solid #F97316; }
          .stat-card:nth-child(4) { background: linear-gradient(135deg, #F0FDFA, #CCFBF1); border-bottom: 3px solid #14B8A6; }
          .stat-card:nth-child(5) { background: linear-gradient(135deg, #FFFBEB, #FEF3C7); border-bottom: 3px solid #F59E0B; }
          .stat-card:nth-child(6) { background: linear-gradient(135deg, #FFF1F2, #FFE4E6); border-bottom: 3px solid #F43F5E; }

          .stat-value { font-size: 3rem; font-weight: 800; line-height: 1.2; }
          .stat-card:nth-child(1) .stat-value { color: #2563EB; }
          .stat-card:nth-child(2) .stat-value { color: #7C3AED; }
          .stat-card:nth-child(3) .stat-value { color: #EA580C; }
          .stat-card:nth-child(4) .stat-value { color: #0D9488; }
          .stat-card:nth-child(5) .stat-value { color: #D97706; }
          .stat-card:nth-child(6) .stat-value { color: #E11D48; }

          .stat-label { font-size: var(--text-base); font-weight: 600; color: var(--text-secondary); margin-top: 8px; }

          /* Enhanced Current Events Cards */
          .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: var(--sp-3);
            margin-bottom: var(--sp-3);
          }

          .event-card {
            background: var(--surface-0);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
          }

          .event-card:hover { transform: translateY(-5px); box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12); }

          .event-card-header {
            padding: 18px 16px;
            background: linear-gradient(135deg, var(--green-500), var(--green-700));
            color: white;
            min-height: 100px;
            display: flex;
            flex-direction: column;
            justify-content: center;
          }

          .event-card-title { font-size: var(--text-xl); font-weight: 700; margin-bottom: 8px; }

          .card-desc {
            font-size: var(--text-sm);
            opacity: 0.9;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
          }

          .event-card-body { padding: 16px; flex: 1; }

          .event-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: var(--text-base);
            padding: 10px 0;
            border-bottom: 1px solid var(--border);
          }

          .event-row:last-of-type { border-bottom: none; }
          .event-lbl { color: var(--text-secondary); font-weight: 600; }
          .event-val { color: var(--text-primary); font-weight: 500; }

          /* Larger Status Badges */
          .badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 24px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
          }

          .badge-upcoming { background: var(--info-100); color: var(--info-500); border: 1px solid var(--info-500); }
          .badge-current { background: var(--warning-100); color: #B45309; border: 1px solid var(--warning-500); }
          .badge-closed { background: var(--danger-100); color: var(--danger-500); border: 1px solid var(--danger-500); }
          .badge-registered { background: var(--info-100); color: var(--info-500); border: 1px solid var(--info-500); }
          .badge-attended { background: var(--success-100); color: var(--success-500); border: 1px solid var(--success-500); }
          .badge-cancelled { background: var(--danger-100); color: var(--danger-500); border: 1px solid var(--danger-500); }
          .badge-noshow { background: #F3F4F6; color: var(--text-secondary); border: 1px solid #D1D5DB; }

          /* Enhanced Tables */
          .table-wrap {
            background: var(--surface-0);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            margin-bottom: var(--sp-3);
          }

          table { width: 100%; border-collapse: collapse; }

          thead {
            background: linear-gradient(135deg, var(--green-700), var(--green-500));
            color: var(--text-inverted);
          }

          th {
            padding: 16px var(--sp-2);
            text-align: left;
            font-size: var(--text-base);
            font-weight: 700;
            letter-spacing: 0.02em;
          }

          td {
            padding: 14px var(--sp-2);
            border-bottom: 1px solid var(--border);
            font-size: var(--text-base);
          }

          tbody tr { transition: all 0.2s ease; }
          tbody tr:hover { background: linear-gradient(90deg, var(--green-100), transparent); }
          tbody tr:last-child td { border-bottom: none; }

          /* Filter Controls */
          .filter-controls {
            display: flex;
            gap: var(--sp-2);
            align-items: center;
            margin-bottom: var(--sp-3);
            flex-wrap: wrap;
          }

          .filter-label { font-weight: 700; color: var(--green-700); font-size: var(--text-base); }
          .filter-select {
            padding: 10px 16px;
            border: 2px solid var(--border);
            background: var(--surface-0);
            border-radius: 10px;
            font-size: var(--text-base);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
          }

          .filter-select:hover { border-color: var(--green-500); }
          .filter-select:focus { outline: none; border-color: var(--green-500); box-shadow: 0 0 0 3px rgba(0, 77, 38, 0.1); }

          .hidden-row { display: none; }
          
          /* No Records Message */
          .no-records {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-muted);
            font-size: var(--text-base);
            background: var(--surface-0);
            border-radius: 16px;
          }

          .footer {
            background: linear-gradient(135deg, var(--green-700), var(--green-500));
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            padding: var(--sp-3) var(--sp-4);
            margin-top: var(--sp-4);
            font-size: var(--text-base);
          }

          .empty-cell { color: #9CA3AF; font-style: italic; }

          /* ========== Navigation Menu ========== */
          .nav-menu-button {
            position: fixed;
            top: 24px;
            left: 24px;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: #008a45;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(0, 138, 69, 0.3);
            transition: all 0.3s ease;
            z-index: 1000;
          }

          .nav-menu-button:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(0, 138, 69, 0.4);
          }

          .nav-menu-button svg {
            width: 24px;
            height: 24px;
            fill: white;
          }

          .nav-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
          }

          .nav-overlay.active {
            opacity: 1;
            visibility: visible;
          }

          .nav-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.9);
            background: white;
            border-radius: 24px;
            padding: 40px;
            max-width: 900px;
            width: 90%;
            max-height: 85vh;
            overflow-y: auto;
            z-index: 1001;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
          }

          .nav-modal.active {
            opacity: 1;
            visibility: visible;
            transform: translate(-50%, -50%) scale(1);
          }

          .nav-modal h2 {
            font-size: 28px;
            color: #008a45;
            margin-bottom: 8px;
          }

          .nav-modal p {
            color: #64748b;
            margin-bottom: 32px;
          }

          .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 16px;
          }

          .nav-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 20px;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
          }

          .nav-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, #008a45, #00c76f);
            opacity: 0;
            transition: opacity 0.3s ease;
          }

          .nav-card:hover {
            transform: translateY(-4px);
            border-color: #008a45;
            box-shadow: 0 8px 20px rgba(0, 138, 69, 0.15);
          }

          .nav-card:hover::before {
            opacity: 0.03;
          }

          .nav-card svg {
            width: 28px;
            height: 28px;
            color: #008a45;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
          }

          .nav-card h3 {
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 6px;
            position: relative;
            z-index: 1;
          }

          .nav-card .nav-desc {
            font-size: 13px;
            color: #64748b;
            line-height: 1.4;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
          }

          .nav-card .nav-link-text {
            font-size: 13px;
            color: #008a45;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
            position: relative;
            z-index: 1;
          }

          .nav-card:hover .nav-link-text {
            gap: 8px;
          }
        </style>
      </head>
      <body>

        <!-- Navigation Menu Button -->
        <button class="nav-menu-button" onclick="toggleNav()">
          <svg viewBox="0 0 24 24"><path d="M3 9h18v2H3V9zm0-4h18v2H3V5zm0 8h18v2H3v-2zm0 4h18v2H3v-2z"/></svg>
        </button>

        <!-- Navigation Overlay -->
        <div class="nav-overlay" id="navOverlay" onclick="toggleNav()"></div>

        <!-- Navigation Modal -->
        <div class="nav-modal" id="navModal">
          <h2>SARMS Navigation</h2>
          <p>Navigate between modules and return to dashboard</p>
          <div class="nav-grid">
            <a href="../sarms-dashboard.html" class="nav-card">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
              <h3>Dashboard</h3>
              <div class="nav-desc">Unified view with statistics and charts</div>
              <div class="nav-link-text">
                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                Go to Dashboard
              </div>
            </a>
            <a href="../group1-enrollment/students.xml" class="nav-card">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
              <h3>Student Enrollment</h3>
              <div class="nav-desc">Student records and grades</div>
              <div class="nav-link-text">
                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                View Module
              </div>
            </a>
            <a href="../group3-faculty/faculty.xml" class="nav-card">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
              <h3>Faculty Workload</h3>
              <div class="nav-desc">Faculty assignments and teaching hours</div>
              <div class="nav-link-text">
                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                View Module
              </div>
            </a>
            <a href="../group4-library/library.xml" class="nav-card">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
              <h3>Library Management</h3>
              <div class="nav-desc">Books and borrowing records</div>
              <div class="nav-link-text">
                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                View Module
              </div>
            </a>
            <a href="../group5-billing/billing.xml" class="nav-card">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
              <h3>Student Billing</h3>
              <div class="nav-desc">Tuition fees and payments</div>
              <div class="nav-link-text">
                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                View Module
              </div>
            </a>
            <a href="../group6-events/events.xml" class="nav-card" style="border-color: #008a45; background: #f0fdf4;">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
              <h3>Event Management</h3>
              <div class="nav-desc">University events and registrations (Current Page)</div>
              <div class="nav-link-text">
                ✓ Current Module
              </div>
            </a>
          </div>
        </div>

        <script>
          function toggleNav() {
            document.getElementById('navOverlay').classList.toggle('active');
            document.getElementById('navModal').classList.toggle('active');
          }
        </script>

        <header class="header">
          <div class="header-inner">
            <div class="header-left">
              <div style="display: flex; align-items: center; gap: 12px;">
                <img src="PLP_logo.png" alt="PLP Logo" style="height: 45px; width: auto;"/>
                <div>
                  <div class="header-title">Events Management System</div>
                  <div class="header-sub">Pamantasan ng Lungsod ng Pasig</div>
                </div>
              </div>
            </div>
            <nav>
              <ul class="navbar">
                <li><a href="#dashboard" class="nav-link" data-section="dashboard">Dashboard</a></li>
                <li><a href="#events" class="nav-link" data-section="events">Events</a></li>
                <li><a href="#participants" class="nav-link" data-section="participants">Participants</a></li>
                <li><a href="#registrations" class="nav-link" data-section="registrations">Registrations</a></li>
                <li><a href="#attendance" class="nav-link" data-section="attendance">Attendance</a></li>
                <li><a href="#reports" class="nav-link" data-section="reports">Reports</a></li>
              </ul>
            </nav>
          </div>
        </header>

        <main>
          <div class="container">

            <!-- Dashboard Summary -->
            <section class="section" id="dashboard">
              <div class="section-header">
                <h2>Dashboard Summary</h2>
                <p class="section-desc">Key metrics and statistics overview of the events management system</p>
              </div>
              <div class="stats-grid">
                <div class="stat-card"><div class="stat-value"><xsl:value-of select="count(//event)"/></div><div class="stat-label">Total Events</div></div>
                <div class="stat-card"><div class="stat-value"><xsl:value-of select="count(//participant)"/></div><div class="stat-label">Total Participants</div></div>
                <div class="stat-card"><div class="stat-value"><xsl:value-of select="count(//registration[@registrationStatus='Registered'])"/></div><div class="stat-label">Active Registrations</div></div>
                <div class="stat-card"><div class="stat-value"><xsl:value-of select="count(//event[@eventStatus='upcoming'])"/></div><div class="stat-label">Upcoming Events</div></div>
              </div>
            </section>

            <!-- Current Events -->
            <section class="section" id="current">
              <div class="section-header">
                <div class="section-header-row">
                  <h2>Current Events</h2>
                  <a href="#events" class="see-all-btn">See All Events</a>
                </div>
                <p class="section-desc">Events happening this week - join before they end!</p>
              </div>
              <div class="events-grid">
                <xsl:for-each select="//event[@eventStatus='current']">
                  <div class="event-card">
                    <div class="event-card-header">
                      <div class="event-card-title"><xsl:value-of select="eventName"/></div>
                      <p class="card-desc"><xsl:value-of select="substring(description, 1, 100)"/><xsl:if test="string-length(description) > 100">...</xsl:if></p>
                    </div>
                    <div class="event-card-body">
                      <div class="event-row"><span class="event-lbl">ID</span><span class="event-val"><xsl:value-of select="@eventId"/></span></div>
                      <div class="event-row">
                        <span class="event-lbl">Date</span>
                        <span class="event-val">
                          <xsl:call-template name="formatDate">
                            <xsl:with-param name="dateString" select="eventDate"/>
                          </xsl:call-template>
                        </span>
                      </div>
                      <div class="event-row">
                        <span class="event-lbl">Time</span>
                        <span class="event-val">
                          <xsl:call-template name="formatTime">
                            <xsl:with-param name="timeString" select="eventTime"/>
                          </xsl:call-template>
                        </span>
                      </div>
                      <div class="event-row"><span class="event-lbl">Venue</span><span class="event-val"><xsl:value-of select="venue"/></span></div>
                      <div class="event-row"><span class="event-lbl">Category</span><span class="event-val"><xsl:value-of select="category"/></span></div>
                      <div class="event-row"><span class="event-lbl">Registrations</span><span class="event-val"><xsl:value-of select="registrationCount"/> / <xsl:value-of select="capacity"/></span></div>
                    </div>
                  </div>
                </xsl:for-each>
    
              </div>
            </section>

            <!-- All Events -->
            <section class="section" id="events">
              <div class="section-header">
                <h2>All Events</h2>
                <p class="section-desc">Complete list of all events with filtering options by status and category</p>
              </div>
              <div class="filter-controls">
                <label for="eventStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="eventStatusFilter" class="filter-select" onchange="filterEvents()">
                  <option value="">All</option><option value="current">Current</option><option value="upcoming">Upcoming</option><option value="closed">Closed</option>
                </select>
                <label for="eventCategoryFilter" class="filter-label">Filter by Category:</label>
                <select id="eventCategoryFilter" class="filter-select" onchange="filterEvents()">
                  <option value="">All Categories</option>
                  <option value="Academic">Academic</option><option value="Professional Development">Professional Development</option>
                  <option value="Cultural">Cultural</option><option value="Sports">Sports</option><option value="Workshop">Workshop</option>
                  <option value="Seminar">Seminar</option><option value="Forum">Forum</option><option value="Symposium">Symposium</option>
                </select>
                <label for="eventSearchFilter" class="filter-label">Search:</label>
                <input id="eventSearchFilter" class="filter-select" type="text" placeholder="Search by ID, name, venue, category" oninput="filterEvents()"/>
              </div>
              <div class="table-wrap">
                <table id="eventsTable">
                  <thead><tr><th>Event ID</th><th>Event Name</th><th>Date</th><th>Time</th><th>Venue</th><th>Category</th><th>Registrations</th><th>Status</th></tr></thead>
                  <tbody id="eventsTableBody">
                    <xsl:for-each select="//event">
                      <xsl:sort select="eventDate"/>
                      <tr data-status="{@eventStatus}" data-category="{category}">
                        <td><xsl:value-of select="@eventId"/></td>
                        <td><xsl:value-of select="eventName"/></td>
                        <td><xsl:value-of select="eventDate"/></td>
                        <td><xsl:value-of select="eventTime"/></td>
                        <td><xsl:value-of select="venue"/></td>
                        <td><xsl:value-of select="category"/></td>
                        <td><xsl:value-of select="registrationCount"/> / <xsl:value-of select="capacity"/></td>
                        <td><xsl:choose><xsl:when test="@eventStatus='upcoming'"><span class="badge badge-upcoming">Upcoming</span></xsl:when><xsl:when test="@eventStatus='current'"><span class="badge badge-current">Current</span></xsl:when><xsl:otherwise><span class="badge badge-closed">Closed</span></xsl:otherwise></xsl:choose></td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
              <div id="eventsNoRecords" class="no-records" style="display: none;">No events found matching your filters.</div>
            </section>

            <!-- Participants -->
            <section class="section" id="participants">
              <div class="section-header">
                <h2>Participants</h2>
                <p class="section-desc">Registered participants organized by college and year level</p>
              </div>
              <div class="filter-controls">
                <label for="deptFilter" class="filter-label">Filter by College:</label>
                <select id="deptFilter" class="filter-select" onchange="filterParticipants()">
                  <option value="">All Colleges</option>
                  <option value="College of Education">College of Education</option>
                  <option value="College of Business and Accountancy">College of Business &amp; Accountancy</option>
                  <option value="College of Engineering">College of Engineering</option>
                  <option value="College of Computer Studies">College of Computer Studies</option>
                  <option value="College of Nursing">College of Nursing</option>
                  <option value="College of International Hospitality Management">College of International Hospitality Management</option>
                  <option value="College of Arts and Science">College of Arts &amp; Science</option>
                </select>
                <label for="yearFilter" class="filter-label">Filter by Year Level:</label>
                <select id="yearFilter" class="filter-select" onchange="filterParticipants()">
                  <option value="">All Years</option><option value="1">1st Year</option><option value="2">2nd Year</option><option value="3">3rd Year</option><option value="4">4th Year</option>
                </select>
                <label for="participantSearchFilter" class="filter-label">Search:</label>
                <input id="participantSearchFilter" class="filter-select" type="text" placeholder="Search by ID, name, email, college" oninput="filterParticipants()"/>
              </div>
              <div class="table-wrap">
                <table id="participantsTable">
                  <thead><tr><th>ID</th><th>Full Name</th><th>Email</th><th>College</th><th>Year Level</th></tr></thead>
                  <tbody id="participantsTableBody">
                    <xsl:for-each select="//participant">
                      <xsl:sort select="fullName"/>
                      <tr data-dept="{department}" data-year="{yearLevel}">
                        <td><xsl:value-of select="@participantId"/></td>
                        <td><xsl:value-of select="fullName"/></td>
                        <td><xsl:value-of select="email"/></td>
                        <td><xsl:value-of select="department"/></td>
                        <td>Year <xsl:value-of select="yearLevel"/></td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
              <div id="participantsNoRecords" class="no-records" style="display: none;">No participants found matching your filters.</div>
            </section>

            <!-- Registrations -->
            <section class="section" id="registrations">
              <div class="section-header">
                <h2>Registrations</h2>
                <p class="section-desc">Track participant registration status for all events</p>
              </div>
              <div class="filter-controls">
                <label for="registrationStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="registrationStatusFilter" class="filter-select" onchange="filterRegistrations()">
                  <option value="">All</option><option value="Registered">Registered</option><option value="Attended">Attended</option>
                  <option value="Cancelled">Cancelled</option><option value="No-show">No-show</option>
                </select>
                <label for="registrationSearchFilter" class="filter-label">Search:</label>
                <input id="registrationSearchFilter" class="filter-select" type="text" placeholder="Search by registration, event, participant" oninput="filterRegistrations()"/>
              </div>
              <div class="table-wrap">
                <table id="registrationsTable">
                  <thead><tr><th>Registration ID</th><th>Event ID</th><th>Participant ID</th><th>Registration Date</th><th>Status</th></tr></thead>
                  <tbody id="registrationsTableBody">
                    <xsl:for-each select="//registration">
                      <tr data-status="{@registrationStatus}">
                        <td><xsl:value-of select="@registrationId"/></td>
                        <td><xsl:value-of select="@eventId"/></td>
                        <td><xsl:value-of select="@participantId"/></td>
                        <td><xsl:value-of select="@registrationDate"/></td>
                        <td><xsl:choose><xsl:when test="@registrationStatus='Registered'"><span class="badge badge-registered">Registered</span></xsl:when><xsl:when test="@registrationStatus='Attended'"><span class="badge badge-attended">Attended</span></xsl:when><xsl:when test="@registrationStatus='Cancelled'"><span class="badge badge-cancelled">Cancelled</span></xsl:when><xsl:otherwise><span class="badge badge-noshow">No-show</span></xsl:otherwise></xsl:choose></td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
              <div id="registrationsNoRecords" class="no-records" style="display: none;">No registrations found matching your filters.</div>
            </section>

            <!-- Event Attendance Sheet (removed Filter by Event) -->
            <section class="section" id="attendance">
              <div class="section-header">
                <h2>Event Attendance Sheet</h2>
                <p class="section-desc">Monitor participant attendance per event with real-time status tracking</p>
              </div>
              <div class="filter-controls">
                <label for="attendanceStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="attendanceStatusFilter" class="filter-select" onchange="filterAttendance()">
                  <option value="">All</option><option value="Registered">Registered</option><option value="Attended">Attended</option>
                  <option value="Cancelled">Cancelled</option><option value="No-show">No-show</option>
                </select>
                <label for="attendanceSearchFilter" class="filter-label">Search:</label>
                <input id="attendanceSearchFilter" class="filter-select" type="text" placeholder="Search by event, participant, email" oninput="filterAttendance()"/>
              </div>
              <xsl:call-template name="attendanceSheet"/>
              <div id="attendanceNoRecords" class="no-records" style="display: none;">No attendance records found matching your filters.</div>
            </section>

            <!-- Reports -->
            <section class="section" id="reports">
              <div class="section-header">
                <h2>Reports</h2>
                <p class="section-desc">Event analytics and performance metrics including registration rates and occupancy</p>
              </div>
              <div class="filter-controls">
                <label for="reportStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="reportStatusFilter" class="filter-select" onchange="filterReports()">
                  <option value="">All</option><option value="current">Current</option><option value="upcoming">Upcoming</option><option value="closed">Closed</option>
                </select>
                <label for="reportCategoryFilter" class="filter-label">Filter by Category:</label>
                <select id="reportCategoryFilter" class="filter-select" onchange="filterReports()">
                  <option value="">All Categories</option>
                  <option value="Academic">Academic</option><option value="Professional Development">Professional Development</option>
                  <option value="Cultural">Cultural</option><option value="Sports">Sports</option><option value="Workshop">Workshop</option>
                  <option value="Seminar">Seminar</option><option value="Forum">Forum</option><option value="Symposium">Symposium</option>
                </select>
                <label for="reportSearchFilter" class="filter-label">Search:</label>
                <input id="reportSearchFilter" class="filter-select" type="text" placeholder="Search by event or category" oninput="filterReports()"/>
              </div>
              <div class="table-wrap">
                <table id="reportsTable">
                  <thead><tr><th>Event Name</th><th>Category</th><th>Registered</th><th>Capacity</th><th>Occupancy %</th><th>Status</th></tr></thead>
                  <tbody id="reportsTableBody">
                    <xsl:for-each select="//event">
                      <xsl:sort select="registrationCount" data-type="number" order="descending"/>
                      <tr data-status="{@eventStatus}" data-category="{category}">
                        <td><xsl:value-of select="eventName"/></td>
                        <td><xsl:value-of select="category"/></td>
                        <td><xsl:value-of select="registrationCount"/></td>
                        <td><xsl:value-of select="capacity"/></td>
                        <td><xsl:value-of select="round((registrationCount div capacity) * 100)"/>%</td>
                        <td><xsl:choose><xsl:when test="@eventStatus='upcoming'"><span class="badge badge-upcoming">Upcoming</span></xsl:when><xsl:when test="@eventStatus='current'"><span class="badge badge-current">Current</span></xsl:when><xsl:otherwise><span class="badge badge-closed">Closed</span></xsl:otherwise></xsl:choose></td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
              <div id="reportsNoRecords" class="no-records" style="display: none;">No reports found matching your filters.</div>
            </section>

          </div>
        </main>

        <footer class="footer">
          <p>&#169; 2026 Pamantasan ng Lungsod ng Pasig &#8212; Events Management System</p>
        </footer>

        <script>
          <![CDATA[
          const sections = document.querySelectorAll('section');
          const navLinks = document.querySelectorAll('.nav-link');

          function updateActivePage() {
            let current = '';
            const scrollPosition = window.scrollY + 100;
            sections.forEach(section => {
              const sectionTop = section.offsetTop;
              const sectionBottom = sectionTop + section.offsetHeight;
              if (scrollPosition >= sectionTop && scrollPosition < sectionBottom) { current = section.getAttribute('id'); }
            });
            navLinks.forEach(link => { link.classList.remove('active'); if (link.getAttribute('data-section') === current) { link.classList.add('active'); } });
          }

          window.addEventListener('scroll', updateActivePage);
          window.addEventListener('load', updateActivePage);

          function filterEvents() {
            const table = document.getElementById('eventsTable');
            const tbody = document.getElementById('eventsTableBody');
            const rows = tbody.querySelectorAll('tr');
            const noRecords = document.getElementById('eventsNoRecords');
            const selectedStatus = document.getElementById('eventStatusFilter').value;
            const selectedCategory = document.getElementById('eventCategoryFilter').value;
            const searchInput = document.getElementById('eventSearchFilter');
            const searchTerm = searchInput.value.trim().toLowerCase();
            let visibleCount = 0;
            
            rows.forEach(row => {
              const rowStatus = row.getAttribute('data-status');
              const rowCategory = row.getAttribute('data-category');
              const rowText = row.textContent.toLowerCase();
              let statusMatch = (selectedStatus === '' || selectedStatus === rowStatus);
              let categoryMatch = (selectedCategory === '' || selectedCategory === rowCategory);
              let searchMatch = (searchTerm === '' || rowText.includes(searchTerm));
              if (statusMatch && categoryMatch && searchMatch) { 
                row.classList.remove('hidden-row'); 
                visibleCount++;
              } else { 
                row.classList.add('hidden-row'); 
              }
            });
            
            if (visibleCount === 0) {
              noRecords.style.display = 'block';
              table.style.display = 'none';
            } else {
              noRecords.style.display = 'none';
              table.style.display = 'table';
            }
          }

          function filterRegistrations() {
            const table = document.getElementById('registrationsTable');
            const tbody = document.getElementById('registrationsTableBody');
            const rows = tbody.querySelectorAll('tr');
            const noRecords = document.getElementById('registrationsNoRecords');
            const selectedStatus = document.getElementById('registrationStatusFilter').value;
            const searchInput = document.getElementById('registrationSearchFilter');
            const searchTerm = searchInput.value.trim().toLowerCase();
            let visibleCount = 0;
            
            rows.forEach(row => { 
              const rowStatus = row.getAttribute('data-status'); 
              const rowText = row.textContent.toLowerCase();
              const statusMatch = (selectedStatus === '' || selectedStatus === rowStatus);
              const searchMatch = (searchTerm === '' || rowText.includes(searchTerm));
              if (statusMatch && searchMatch) { 
                row.classList.remove('hidden-row'); 
                visibleCount++;
              } else { 
                row.classList.add('hidden-row'); 
              }
            });
            
            if (visibleCount === 0) {
              noRecords.style.display = 'block';
              table.style.display = 'none';
            } else {
              noRecords.style.display = 'none';
              table.style.display = 'table';
            }
          }

          function filterParticipants() {
            const table = document.getElementById('participantsTable');
            const tbody = document.getElementById('participantsTableBody');
            const rows = tbody.querySelectorAll('tr');
            const noRecords = document.getElementById('participantsNoRecords');
            const selectedDept = document.getElementById('deptFilter').value;
            const selectedYear = document.getElementById('yearFilter').value;
            const searchInput = document.getElementById('participantSearchFilter');
            const searchTerm = searchInput.value.trim().toLowerCase();
            let visibleCount = 0;
            
            rows.forEach(row => {
              const rowDept = row.getAttribute('data-dept');
              const rowYear = row.getAttribute('data-year');
              const rowText = row.textContent.toLowerCase();
              let deptMatch = (selectedDept === '' || selectedDept === rowDept);
              let yearMatch = (selectedYear === '' || selectedYear === rowYear);
              let searchMatch = (searchTerm === '' || rowText.includes(searchTerm));
              if (deptMatch && yearMatch && searchMatch) { 
                row.classList.remove('hidden-row'); 
                visibleCount++;
              } else { 
                row.classList.add('hidden-row'); 
              }
            });
            
            if (visibleCount === 0) {
              noRecords.style.display = 'block';
              table.style.display = 'none';
            } else {
              noRecords.style.display = 'none';
              table.style.display = 'table';
            }
          }

          function filterAttendance() {
            const table = document.getElementById('attendanceTable');
            const tbody = document.getElementById('attendanceTableBody');
            const rows = tbody.querySelectorAll('tr');
            const noRecords = document.getElementById('attendanceNoRecords');
            const selectedStatus = document.getElementById('attendanceStatusFilter').value;
            const searchInput = document.getElementById('attendanceSearchFilter');
            const searchTerm = searchInput.value.trim().toLowerCase();
            let visibleCount = 0;
            
            rows.forEach(row => {
              const rowStatus = row.getAttribute('data-reg-status');
              const rowText = row.textContent.toLowerCase();
              let statusMatch = (selectedStatus === '' || selectedStatus === rowStatus);
              let searchMatch = (searchTerm === '' || rowText.includes(searchTerm));
              if (statusMatch && searchMatch) { 
                row.classList.remove('hidden-row'); 
                visibleCount++;
              } else { 
                row.classList.add('hidden-row'); 
              }
            });
            
            if (visibleCount === 0) {
              noRecords.style.display = 'block';
              table.style.display = 'none';
            } else {
              noRecords.style.display = 'none';
              table.style.display = 'table';
            }
          }

          function filterReports() {
            const table = document.getElementById('reportsTable');
            const tbody = document.getElementById('reportsTableBody');
            const rows = tbody.querySelectorAll('tr');
            const noRecords = document.getElementById('reportsNoRecords');
            const selectedStatus = document.getElementById('reportStatusFilter').value;
            const selectedCategory = document.getElementById('reportCategoryFilter').value;
            const searchInput = document.getElementById('reportSearchFilter');
            const searchTerm = searchInput.value.trim().toLowerCase();
            let visibleCount = 0;
            
            rows.forEach(row => {
              const rowStatus = row.getAttribute('data-status');
              const rowCategory = row.getAttribute('data-category');
              const rowText = row.textContent.toLowerCase();
              let statusMatch = (selectedStatus === '' || selectedStatus === rowStatus);
              let categoryMatch = (selectedCategory === '' || selectedCategory === rowCategory);
              let searchMatch = (searchTerm === '' || rowText.includes(searchTerm));
              if (statusMatch && categoryMatch && searchMatch) { 
                row.classList.remove('hidden-row'); 
                visibleCount++;
              } else { 
                row.classList.add('hidden-row'); 
              }
            });
            
            if (visibleCount === 0) {
              noRecords.style.display = 'block';
              table.style.display = 'none';
            } else {
              noRecords.style.display = 'none';
              table.style.display = 'table';
            }
          }
          ]]>
        </script>
      </body>
    </html>
  </xsl:template>
  
</xsl:stylesheet>
