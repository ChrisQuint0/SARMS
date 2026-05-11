<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- XSLT Stylesheet for Events Management System -->
  <!-- Transforms XML into a single-page HTML dashboard -->

  <xsl:output method="html" indent="yes"/>

  <!-- ============================================================ -->
  <!-- ROOT TEMPLATE                                                 -->
  <!-- ============================================================ -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Events Management System</title>
        <style>
          /* -------------------------------------------------------
             Design Tokens
          ------------------------------------------------------- */
          :root {
            /* Green palette — dark to light */
            --green-900: #004D26;
            --green-700: #006B35;
            --green-500: #008A45;
            --green-100: #E6F4EC;

            /* Yellow — minimal, reserved for current-status only */
            --yellow-400: #FFCE00;
            --yellow-100: #FFFBE6;

            /* Surfaces */
            --surface-0:  #FFFFFF;
            --surface-50: #F8FAFC;

            /* Borders and text */
            --border:         #E5E7EB;
            --text-primary:   #111827;
            --text-secondary: #4B5563;
            --text-inverted:  #FFFFFF;

            /* Semantic */
            --danger-500: #DC2626;
            --danger-100: #FEE2E2;

            /* Spacing */
            --sp-1: 0.5rem;
            --sp-2: 1rem;
            --sp-3: 1.5rem;
            --sp-4: 2rem;

            /* Type scale */
            --text-sm:   0.875rem;
            --text-base: 1rem;
            --text-lg:   1.125rem;
            --text-xl:   1.25rem;
          }

          /* -------------------------------------------------------
             Reset
          ------------------------------------------------------- */
          *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          /* -------------------------------------------------------
             Base
          ------------------------------------------------------- */
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
                         'Helvetica Neue', Arial, sans-serif;
            background-color: var(--surface-50);
            color: var(--text-primary);
            line-height: 1.6;
          }

          /* -------------------------------------------------------
             Header — deepest green with navbar
          ------------------------------------------------------- */
          .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            width: 100%;
            z-index: 1000;
            background-color: var(--green-900);
            color: var(--text-inverted);
            padding: var(--sp-2) var(--sp-3);
            border-bottom: 4px solid var(--green-900);
          }

          .header-inner {
            max-width: 96%;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
          }

          .header-left {
            display: flex;
            flex-direction: column;
          }

          .header-title {
            font-size: var(--text-xl);
            font-weight: 700;
            letter-spacing: 0.02em;
          }

          .header-sub {
            font-size: var(--text-sm);
            color: rgba(255, 255, 255, 0.65);
            margin-top: 2px;
          }

          .navbar {
            display: flex;
            gap: var(--sp-3);
            list-style: none;
          }

          .navbar li {
            margin: 0;
          }

          .navbar a {
            color: var(--text-inverted);
            text-decoration: none;
            font-size: var(--text-sm);
            font-weight: 500;
            padding: var(--sp-1) var(--sp-2);
            border-radius: 4px;
            transition: background-color 0.2s ease;
          }

          .navbar a:hover {
            background-color: rgba(255, 255, 255, 0.15);
          }

          /* -------------------------------------------------------
             Layout
          ------------------------------------------------------- */
          main {
            margin-top: 80px;
          }

          .container {
            max-width: 96%; /* Changed from 1300px to 96% */
            margin: 0 auto;
            padding: var(--sp-3) 1rem; /* Increased side padding slightly for better breathing room */
          }

          .section {
            margin-bottom: var(--sp-4);
          }

          /* -------------------------------------------------------
             Section Headings
          ------------------------------------------------------- */
          h2 {
            font-size: var(--text-lg);
            font-weight: 700;
            color: var(--green-900);
            border-left: 4px solid var(--green-900);
            padding-left: var(--sp-2);
            margin-bottom: var(--sp-3);
          }

          h3 {
            font-size: var(--text-base);
            font-weight: 600;
            color: var(--green-900);
            margin-bottom: var(--sp-2);
          }

          .mt-3 { margin-top: var(--sp-3); }

          /* -------------------------------------------------------
             Dashboard Stat Cards
          ------------------------------------------------------- */
          .stats-grid {
            display: grid;
            /* Allow more cards per row on wide screens */
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); 
            gap: var(--sp-3);
            margin-bottom: var(--sp-4);
          }

          .stat-card {
            background-color: var(--surface-0);
            border: 1px solid var(--border);
            border-top: 3px solid var(--green-900);
            border-radius: 6px;
            padding: var(--sp-3);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.07);
            text-align: center;
          }

          .stat-value {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--green-900);
            line-height: 1.2;
          }

          .stat-label {
            font-size: var(--text-sm);
            color: var(--text-secondary);
            margin-top: 4px;
          }

          /* -------------------------------------------------------
             Event Cards — Current Events
          ------------------------------------------------------- */
          .events-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: var(--sp-3);
            margin-bottom: var(--sp-3);
          }

          .event-card {
            background-color: var(--surface-0);
            border: 1px solid var(--border);
            border-radius: 6px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.07);
          }

          .event-card-header {
            padding: var(--sp-2);
            border-bottom: 2px solid var(--green-900);
          }

          .event-card-title {
            font-size: var(--text-base);
            font-weight: 600;
            color: var(--green-900);
            margin-bottom: 4px;
          }

          .event-card-body {
            padding: var(--sp-2);
          }

          .event-row {
            display: flex;
            justify-content: space-between;
            font-size: var(--text-sm);
            padding: 3px 0;
            border-bottom: 1px solid var(--surface-50);
          }

          .event-row:last-of-type { border-bottom: none; }

          .event-lbl { color: var(--text-secondary); font-weight: 500; }
          .event-val { color: var(--text-primary); }

          .card-desc {
            font-size: var(--text-sm);
            color: var(--text-secondary);
            margin-top: var(--sp-1);
            font-style: italic;
          }

          /* -------------------------------------------------------
             Status Badges
          ------------------------------------------------------- */
          .badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
          }

          /* upcoming — dark green */
          .badge-upcoming {
            background-color: rgba(0, 77, 38, 0.15);
            color: var(--green-900);
          }

          /* current — yellow (minimal; only status that uses yellow) */
          .badge-current {
            background-color: var(--yellow-100);
            color: #7A5F00;
            border: 1px solid var(--yellow-400);
          }

          /* closed — red */
          .badge-closed {
            background-color: var(--danger-100);
            color: var(--danger-500);
          }

          /* Registration status badges */
          .badge-registered { background-color: rgba(0, 77, 38, 0.15);  color: var(--green-900); }
          .badge-attended   { background-color: #DBEAFE;           color: #1E40AF; }
          .badge-cancelled  { background-color: var(--danger-100); color: var(--danger-500); }
          .badge-noshow     { background-color: #F3F4F6;           color: #6B7280; }

          /* -------------------------------------------------------
             Tables
          ------------------------------------------------------- */
          .table-wrap {
            background-color: var(--surface-0);
            border: 1px solid var(--border);
            border-radius: 6px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.07);
            margin-bottom: var(--sp-3);
          }

          table {
            width: 100%;
            border-collapse: collapse;
          }

          /* Table header — dark green */
          thead {
            background-color: var(--green-900);
            color: var(--text-inverted);
          }

          th {
            padding: var(--sp-2);
            text-align: left;
            font-size: var(--text-sm);
            font-weight: 600;
          }

          td {
            padding: var(--sp-1) var(--sp-2);
            border-bottom: 1px solid var(--border);
            font-size: var(--text-sm);
          }

          tbody tr:hover { background-color: rgba(0, 77, 38, 0.1); }
          tbody tr:last-child td { border-bottom: none; }

          /* -------------------------------------------------------
             Filter Controls
          ------------------------------------------------------- */
          .filter-controls {
            display: flex;
            gap: var(--sp-2);
            align-items: center;
            margin-bottom: var(--sp-3);
            flex-wrap: wrap;
          }

          .filter-label {
            font-weight: 600;
            color: var(--text-primary);
            font-size: var(--text-sm);
          }

          .filter-select {
            padding: var(--sp-1) var(--sp-2);
            border: 2px solid var(--border);
            background-color: var(--surface-0);
            color: var(--text-primary);
            border-radius: 4px;
            font-size: var(--text-sm);
            font-weight: 500;
            cursor: pointer;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
          }

          .filter-select:hover {
            border-color: var(--green-900);
          }

          .filter-select:focus {
            outline: none;
            border-color: var(--green-900);
            box-shadow: 0 0 0 3px rgba(0, 77, 38, 0.1);
          }

          .hidden-row {
            display: none;
          }

          /* -------------------------------------------------------
             Footer — deepest green, matches header
          ------------------------------------------------------- */
          .footer {
            background-color: var(--green-900);
            color: rgba(255, 255, 255, 0.7);
            text-align: center;
            padding: var(--sp-3) var(--sp-4);
            margin-top: var(--sp-4);
            font-size: var(--text-sm);
            border-top: 3px solid var(--green-900);
          }
        </style>
      </head>
      <body>

        <!-- ====================================================== -->
        <!-- HEADER with NAVBAR                                     -->
        <!-- ====================================================== -->
        <header class="header">
          <div class="header-inner">
            <div class="header-left">
              <div class="header-title">Events Management System</div>
              <div class="header-sub">Pamantasan ng Lungsod ng Pasig</div>
            </div>
            <nav>
              <ul class="navbar">
                <li><a href="#dashboard">Dashboard</a></li>
                <li><a href="#events">Events</a></li>
                <li><a href="#participants">Participants</a></li>
                <li><a href="#registrations">Registrations</a></li>
                <li><a href="#attendance">Attendance</a></li>
                <li><a href="#reports">Reports</a></li>
              </ul>
            </nav>
          </div>
        </header>

        <main>
          <div class="container">

            <!-- ================================================== -->
            <!-- SECTION 1 — Dashboard Summary                       -->
            <!-- Uses XPath count() and sum() to extract totals      -->
            <!-- ================================================== -->
            <section class="section" id="dashboard">
              <h2>Dashboard Summary</h2>
              <div class="stats-grid">

                <div class="stat-card">
                  <div class="stat-value">
                    <xsl:value-of select="count(//event)"/>
                  </div>
                  <div class="stat-label">Total Events</div>
                </div>

                <div class="stat-card">
                  <div class="stat-value">
                    <xsl:value-of select="count(//participant)"/>
                  </div>
                  <div class="stat-label">Total Participants</div>
                </div>

                <div class="stat-card">
                  <div class="stat-value">
                    <xsl:value-of select="count(//registration[@registrationStatus='Registered'])"/>
                  </div>
                  <div class="stat-label">Active Registrations</div>
                </div>

                <div class="stat-card">
                  <div class="stat-value">
                    <xsl:value-of select="count(//event[@eventStatus='upcoming'])"/>
                  </div>
                  <div class="stat-label">Upcoming Events</div>
                </div>

                <div class="stat-card">
                  <div class="stat-value">
                    <xsl:value-of select="count(//registration[@registrationStatus='Attended'])"/>
                  </div>
                  <div class="stat-label">Attended</div>
                </div>

                <div class="stat-card">
                  <!-- sum() aggregates capacity across all events -->
                  <div class="stat-value">
                    <xsl:value-of select="sum(//event/capacity)"/>
                  </div>
                  <div class="stat-label">Total Capacity</div>
                </div>

              </div>
            </section>

            <!-- ================================================== -->
            <!-- SECTION 2 — Current Events (card grid)              -->
            <!-- Filtered with @eventStatus attribute predicate      -->
            <!-- ================================================== -->
            <section class="section" id="current">
              <h2>Current Events</h2>
              <div class="events-grid">
                <xsl:for-each select="//event[@eventStatus='current']">
                  <xsl:if test="position() &lt;= 5">
                  <div class="event-card">
                    <div class="event-card-header">
                      <div class="event-card-title">
                        <xsl:value-of select="eventName"/>
                      </div>
                      <!-- Description placed after title -->
                      <p class="card-desc">
                        <xsl:value-of select="substring(description, 1, 100)"/>
                        <xsl:text>...</xsl:text>
                      </p>
                    </div>
                    <div class="event-card-body">
                      <div class="event-row">
                        <span class="event-lbl">ID</span>
                        <span class="event-val"><xsl:value-of select="@eventId"/></span>
                      </div>
                      <div class="event-row">
                        <span class="event-lbl">Date</span>
                        <span class="event-val"><xsl:value-of select="eventDate"/></span>
                      </div>
                      <div class="event-row">
                        <span class="event-lbl">Time</span>
                        <span class="event-val"><xsl:value-of select="eventTime"/></span>
                      </div>
                      <div class="event-row">
                        <span class="event-lbl">Venue</span>
                        <span class="event-val"><xsl:value-of select="venue"/></span>
                      </div>
                      <div class="event-row">
                        <span class="event-lbl">Category</span>
                        <span class="event-val"><xsl:value-of select="category"/></span>
                      </div>
                      <div class="event-row">
                        <span class="event-lbl">Registrations</span>
                        <span class="event-val">
                          <xsl:value-of select="registrationCount"/>
                          <xsl:text> / </xsl:text>
                          <xsl:value-of select="capacity"/>
                        </span>
                      </div>

                    </div>
                  </div>
                  </xsl:if>
                </xsl:for-each>
              </div>
            </section>

            <!-- ================================================== -->
            <!-- SECTION 3 — All Events Table with Filter           -->
            <!-- Filter by status and category                      -->
            <!-- ================================================== -->
            <section class="section" id="events">
              <h2>All Events</h2>
              
              <!-- Filter Controls -->
              <div class="filter-controls">
                <label for="eventStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="eventStatusFilter" class="filter-select" onchange="filterEvents()">
                  <option value="">All</option>
                  <option value="current">Current</option>
                  <option value="upcoming">Upcoming</option>
                  <option value="closed">Closed</option>
                </select>
                
                <label for="eventCategoryFilter" class="filter-label">Filter by Category:</label>
                <select id="eventCategoryFilter" class="filter-select" onchange="filterEvents()">
                  <option value="">All Categories</option>
                  <option value="Academic">Academic</option>
                  <option value="Professional Development">Professional Development</option>
                  <option value="Cultural">Cultural</option>
                  <option value="Sports">Sports</option>
                  <option value="Workshop">Workshop</option>
                  <option value="Seminar">Seminar</option>
                  <option value="Forum">Forum</option>
                  <option value="Symposium">Symposium</option>
                </select>
              </div>

              <div class="table-wrap">
                <table id="eventsTable">
                  <thead>
                    <tr>
                      <th>Event ID</th>
                      <th>Event Name</th>
                      <th>Date</th>
                      <th>Time</th>
                      <th>Venue</th>
                      <th>Category</th>
                      <th>Registrations / Capacity</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//event">
                      <xsl:sort select="eventDate"/>
                      <tr data-status="{@eventStatus}" data-category="{category}">
                        <td><xsl:value-of select="@eventId"/></td>
                        <td><xsl:value-of select="eventName"/></td>
                        <td><xsl:value-of select="eventDate"/></td>
                        <td><xsl:value-of select="eventTime"/></td>
                        <td><xsl:value-of select="venue"/></td>
                        <td><xsl:value-of select="category"/></td>
                        <td>
                          <xsl:value-of select="registrations"/>
                          <xsl:text> / </xsl:text>
                          <xsl:value-of select="capacity"/>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="@eventStatus='upcoming'">
                              <span class="badge badge-upcoming">upcoming</span>
                            </xsl:when>
                            <xsl:when test="@eventStatus='current'">
                              <span class="badge badge-current">current</span>
                            </xsl:when>
                            <xsl:otherwise>
                              <span class="badge badge-closed">closed</span>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </section>

            <!-- ================================================== -->
            <!-- SECTION 6 — Participants Table with Filter         -->
            <!-- Filter by department and year level                -->
            <!-- ================================================== -->
            <section class="section" id="participants">
              <h2>Participants</h2>
              
              <!-- Department and Year Level Filters (Side by Side) -->
              <div class="filter-controls">
                <label for="deptFilter" class="filter-label">Filter by Department:</label>
                <select id="deptFilter" class="filter-select" onchange="filterParticipants()">
                  <option value="">All Departments</option>
                  <option value="Computer Science">Computer Science</option>
                  <option value="Information Technology">Information Technology</option>
                  <option value="Engineering">Engineering</option>
                  <option value="Business">Business</option>
                  <option value="Arts">Arts</option>
                </select>
                
                <label for="yearFilter" class="filter-label">Filter by Year Level:</label>
                <select id="yearFilter" class="filter-select" onchange="filterParticipants()">
                  <option value="">All Years</option>
                  <option value="1">1st Year</option>
                  <option value="2">2nd Year</option>
                  <option value="3">3rd Year</option>
                  <option value="4">4th Year</option>
                </select>
              </div>

              <div class="table-wrap">
                <table id="participantsTable">
                  <thead>
                    <tr>
                      <th>Participant ID</th>
                      <th>Full Name</th>
                      <th>Email</th>
                      <th>Department</th>
                      <th>Year Level</th>
                    </tr>
                  </thead>
                  <tbody>
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
            </section>

            <!-- ================================================== -->
            <!-- SECTION 7 — Registrations Table with Filter        -->
            <!-- Filter by status: Registered, Attended, Cancelled, No-show -->
            <!-- ================================================== -->
            <section class="section" id="registrations">
              <h2>Registrations</h2>
              
              <!-- Filter Controls -->
              <div class="filter-controls">
                <label for="registrationStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="registrationStatusFilter" class="filter-select" onchange="filterRegistrations()">
                  <option value="">All</option>
                  <option value="Registered">Registered</option>
                  <option value="Attended">Attended</option>
                  <option value="Cancelled">Cancelled</option>
                  <option value="No-show">No-show</option>
                </select>
              </div>

              <div class="table-wrap">
                <table id="registrationsTable">
                  <thead>
                    <tr>
                      <th>Registration ID</th>
                      <th>Event ID</th>
                      <th>Participant ID</th>
                      <th>Registration Date</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//registration">
                      <tr data-status="{@registrationStatus}">
                        <td><xsl:value-of select="@registrationId"/></td>
                        <td><xsl:value-of select="@eventId"/></td>
                        <td><xsl:value-of select="@participantId"/></td>
                        <td><xsl:value-of select="@registrationDate"/></td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="@registrationStatus='Registered'">
                              <span class="badge badge-registered">Registered</span>
                            </xsl:when>
                            <xsl:when test="@registrationStatus='Attended'">
                              <span class="badge badge-attended">Attended</span>
                            </xsl:when>
                            <xsl:when test="@registrationStatus='Cancelled'">
                              <span class="badge badge-cancelled">Cancelled</span>
                            </xsl:when>
                            <xsl:otherwise>
                              <span class="badge badge-noshow">No-show</span>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </section>

            <!-- ================================================== -->
            <!-- SECTION 8 — Event Attendance Sheet                  -->
            <!-- Lists participants registered for each event        -->
            <!-- ================================================== -->
            <section class="section" id="attendance">
              <h2>Event Attendance Sheet</h2>

              <!-- Filter Controls for Attendance Sheet -->
              <div class="filter-controls">
                <label for="attendanceEventFilter" class="filter-label">Filter by Event:</label>
                <select id="attendanceEventFilter" class="filter-select" onchange="filterAttendance()">
                  <option value="">All Events</option>
                  <xsl:for-each select="//event">
                    <xsl:sort select="eventName"/>
                    <option value="{@eventId}"><xsl:value-of select="eventName"/></option>
                  </xsl:for-each>
                </select>

                <label for="attendanceStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="attendanceStatusFilter" class="filter-select" onchange="filterAttendance()">
                  <option value="">All Statuses</option>
                  <option value="Registered">Registered</option>
                  <option value="Attended">Attended</option>
                  <option value="Cancelled">Cancelled</option>
                  <option value="No-show">No-show</option>
                </select>
              </div>

              <div class="table-wrap">
                <table id="attendanceTable">
                  <thead>
                    <tr>
                      <th>Event ID</th>
                      <th>Event Name</th>
                      <th>Date</th>
                      <th>Venue</th>
                      <th>Participant Name</th>
                      <th>Email</th>
                      <th>Registration Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//event">
                      <xsl:sort select="eventName"/>
                      <xsl:variable name="eventId" select="@eventId"/>
                      <xsl:for-each select="//registration[@eventId=$eventId]">
                        <xsl:sort select="@registrationDate"/>
                        <xsl:variable name="participantId" select="@participantId"/>
                        <xsl:variable name="participant" select="//participant[@participantId=$participantId]"/>
                        <tr data-event="{$eventId}" data-reg-status="{@registrationStatus}">
                          <td><xsl:value-of select="$eventId"/></td>
                          <td><xsl:value-of select="../eventName"/></td>
                          <td><xsl:value-of select="../eventDate"/></td>
                          <td><xsl:value-of select="../venue"/></td>
                          <td><xsl:value-of select="$participant/fullName"/></td>
                          <td><xsl:value-of select="$participant/email"/></td>
                          <td>
                            <xsl:choose>
                              <xsl:when test="@registrationStatus='Registered'">
                                <span class="badge badge-registered">Registered</span>
                              </xsl:when>
                              <xsl:when test="@registrationStatus='Attended'">
                                <span class="badge badge-attended">Attended</span>
                              </xsl:when>
                              <xsl:when test="@registrationStatus='Cancelled'">
                                <span class="badge badge-cancelled">Cancelled</span>
                              </xsl:when>
                              <xsl:otherwise>
                                <span class="badge badge-noshow">No-show</span>
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                        </tr>
                      </xsl:for-each>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </section>

            <!-- ================================================== -->
            <!-- SECTION 9 — Reports                                 -->
            <!-- Event capacity and attendance analysis              -->
            <!-- ================================================== -->
            <section class="section" id="reports">
              <h2>Reports</h2>

              <!-- Filter Controls for Reports -->
              <div class="filter-controls">
                <label for="reportStatusFilter" class="filter-label">Filter by Status:</label>
                <select id="reportStatusFilter" class="filter-select" onchange="filterReports()">
                  <option value="">All</option>
                  <option value="current">Current</option>
                  <option value="upcoming">Upcoming</option>
                  <option value="closed">Closed</option>
                </select>
                
                <label for="reportCategoryFilter" class="filter-label">Filter by Category:</label>
                <select id="reportCategoryFilter" class="filter-select" onchange="filterReports()">
                  <option value="">All Categories</option>
                  <option value="Academic">Academic</option>
                  <option value="Professional Development">Professional Development</option>
                  <option value="Cultural">Cultural</option>
                  <option value="Sports">Sports</option>
                  <option value="Workshop">Workshop</option>
                  <option value="Seminar">Seminar</option>
                  <option value="Forum">Forum</option>
                  <option value="Symposium">Symposium</option>
                </select>
              </div>

              <!-- Top 20 Events by Registrations — descending sort -->
              <h3>Top 20 Events by Registrations</h3>
              <div class="table-wrap">
                <table id="reportsTable">
                  <thead>
                    <tr>
                      <th>Event Name</th>
                      <th>Category</th>
                      <th>Registered</th>
                      <th>Capacity</th>
                      <th>Occupancy %</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//event">
                      <xsl:sort select="registrations" data-type="number" order="descending"/>
                      <xsl:if test="position() &lt;= 20">
                        <tr data-status="{@eventStatus}" data-category="{category}">
                          <td><xsl:value-of select="eventName"/></td>
                          <td><xsl:value-of select="category"/></td>
                          <td><xsl:value-of select="registrations"/></td>
                          <td><xsl:value-of select="capacity"/></td>
                          <td>
                            <!-- round(x div y * 100) occupancy percentage -->
                            <xsl:value-of select="round((registrations div capacity) * 100)"/>%
                          </td>
                          <td>
                            <xsl:choose>
                              <xsl:when test="@eventStatus='upcoming'">
                                <span class="badge badge-upcoming">upcoming</span>
                              </xsl:when>
                              <xsl:when test="@eventStatus='current'">
                                <span class="badge badge-current">current</span>
                              </xsl:when>
                              <xsl:otherwise>
                                <span class="badge badge-closed">closed</span>
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                        </tr>
                      </xsl:if>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>

            </section>

          </div>
        </main>

        <!-- ====================================================== -->
        <!-- FOOTER                                                  -->
        <!-- ====================================================== -->
        <footer class="footer">
          <p>2026 Pamantasan ng Lungsod ng Pasig — Events Management System</p>
        </footer>

        <!-- JavaScript for Filter Functionality -->
        <script>
          function filterEvents() {
            const table = document.getElementById('eventsTable');
            const rows = table.querySelectorAll('tbody tr');
            const selectedStatus = document.getElementById('eventStatusFilter').value;
            const selectedCategory = document.getElementById('eventCategoryFilter').value;
            
            // Filter rows by both status and category
            rows.forEach(row => {
              const rowStatus = row.getAttribute('data-status');
              const rowCategory = row.getAttribute('data-category');
              
              let statusMatch = (selectedStatus === '' || selectedStatus === rowStatus);
              let categoryMatch = (selectedCategory === '' || selectedCategory === rowCategory);
              
              if (statusMatch &amp;&amp; categoryMatch) {
                row.classList.remove('hidden-row');
              } else {
                row.classList.add('hidden-row');
              }
            });
          }

          function filterRegistrations() {
            const table = document.getElementById('registrationsTable');
            const rows = table.querySelectorAll('tbody tr');
            const selectedStatus = document.getElementById('registrationStatusFilter').value;
            
            // Filter rows by status
            rows.forEach(row => {
              const rowStatus = row.getAttribute('data-status');
              if (selectedStatus === '' || selectedStatus === rowStatus) {
                row.classList.remove('hidden-row');
              } else {
                row.classList.add('hidden-row');
              }
            });
          }

          function filterParticipants() {
            const table = document.getElementById('participantsTable');
            const rows = table.querySelectorAll('tbody tr');
            
            // Get selected values from dropdowns
            const selectedDept = document.getElementById('deptFilter').value;
            const selectedYear = document.getElementById('yearFilter').value;
            
            // Filter rows by both department and year level
            rows.forEach(row => {
              const rowDept = row.getAttribute('data-dept');
              const rowYear = row.getAttribute('data-year');
              
              let deptMatch = (selectedDept === '' || selectedDept === rowDept);
              let yearMatch = (selectedYear === '' || selectedYear === rowYear);
              
              if (deptMatch &amp;&amp; yearMatch) {
                row.classList.remove('hidden-row');
              } else {
                row.classList.add('hidden-row');
              }
            });
          }

          function filterAttendance() {
            const table = document.getElementById('attendanceTable');
            const rows = table.querySelectorAll('tbody tr');
            
            // Get selected values from dropdowns
            const selectedEvent = document.getElementById('attendanceEventFilter').value;
            const selectedStatus = document.getElementById('attendanceStatusFilter').value;
            
            // Filter rows by both event and registration status
            rows.forEach(row => {
              const rowEvent = row.getAttribute('data-event');
              const rowStatus = row.getAttribute('data-reg-status');
              
              let eventMatch = (selectedEvent === '' || selectedEvent === rowEvent);
              let statusMatch = (selectedStatus === '' || selectedStatus === rowStatus);
              
              if (eventMatch &amp;&amp; statusMatch) {
                row.classList.remove('hidden-row');
              } else {
                row.classList.add('hidden-row');
              }
            });
          }

          function filterReports() {
            const table = document.getElementById('reportsTable');
            const rows = table.querySelectorAll('tbody tr');
            
            // Get selected values from dropdowns
            const selectedStatus = document.getElementById('reportStatusFilter').value;
            const selectedCategory = document.getElementById('reportCategoryFilter').value;
            
            // Filter rows by both status and category
            rows.forEach(row => {
              const rowStatus = row.getAttribute('data-status');
              const rowCategory = row.getAttribute('data-category');
              
              let statusMatch = (selectedStatus === '' || selectedStatus === rowStatus);
              let categoryMatch = (selectedCategory === '' || selectedCategory === rowCategory);
              
              if (statusMatch &amp;&amp; categoryMatch) {
                row.classList.remove('hidden-row');
              } else {
                row.classList.add('hidden-row');
              }
            });
          }
        </script>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
