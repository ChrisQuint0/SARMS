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
             Header — deepest green, title + subtitle only
          ------------------------------------------------------- */
          .header {
            background-color: var(--green-900);
            color: var(--text-inverted);
            padding: var(--sp-3) 0.25rem;
            border-bottom: 4px solid var(--green-900);
            text-align: center;
          }

          .header-inner {
            max-width: 96%; /* Changed from 1300px to 96% */
            margin: 0 auto;
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

          /* -------------------------------------------------------
             Layout
          ------------------------------------------------------- */
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
            background-color: rgba(0, 77, 38, 0.1);
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
        <!-- HEADER — title and institution only, no navigation      -->
        <!-- ====================================================== -->
        <header class="header">
          <div class="header-inner">
            <div class="header-title">Events Management System</div>
            <div class="header-sub">Pamantasan ng Lungsod ng Pasig</div>
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
            <!-- SECTION 3 — Upcoming Events Table                   -->
            <!-- xsl:sort on eventDate; @eventStatus attribute pred  -->
            <!-- ================================================== -->
            <section class="section" id="upcoming">
              <h2>Upcoming Events</h2>
              <div class="table-wrap">
                <table>
                  <thead>
                    <tr>
                      <th>Event ID</th>
                      <th>Event Name</th>
                      <th>Date</th>
                      <th>Time</th>
                      <th>Venue</th>
                      <th>Category</th>
                      <th>Registrations / Capacity</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//event[@eventStatus='upcoming']">
                      <xsl:sort select="eventDate"/>
                      <tr>
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
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </section>

            <!-- ================================================== -->
            <!-- SECTION 4 — Closed Events Table                     -->
            <!-- xsl:sort on eventDate; @eventStatus attribute pred  -->
            <!-- ================================================== -->
            <section class="section" id="closed">
              <h2>Closed Events</h2>
              <div class="table-wrap">
                <table>
                  <thead>
                    <tr>
                      <th>Event ID</th>
                      <th>Event Name</th>
                      <th>Date</th>
                      <th>Time</th>
                      <th>Venue</th>
                      <th>Category</th>
                      <th>Registrations / Capacity</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//event[@eventStatus='closed']">
                      <xsl:sort select="eventDate"/>
                      <tr>
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
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </section>

            <!-- ================================================== -->
            <!-- SECTION 5 — All Events Table                        -->
            <!-- xsl:choose on @eventStatus for badge color          -->
            <!-- ================================================== -->
            <section class="section" id="events">
              <h2>All Events</h2>
              <div class="table-wrap">
                <table>
                  <thead>
                    <tr>
                      <th>Event ID</th>
                      <th>Event Name</th>
                      <th>Date</th>
                      <th>Venue</th>
                      <th>Category</th>
                      <th>Registrations</th>
                      <th>Capacity</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//event">
                      <xsl:sort select="eventDate"/>
                      <tr>
                        <td><xsl:value-of select="@eventId"/></td>
                        <td><xsl:value-of select="eventName"/></td>
                        <td><xsl:value-of select="eventDate"/></td>
                        <td><xsl:value-of select="venue"/></td>
                        <td><xsl:value-of select="category"/></td>
                        <td><xsl:value-of select="registrations"/></td>
                        <td><xsl:value-of select="capacity"/></td>
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
            <!-- SECTION 6 — Participants Table                      -->
            <!-- xsl:sort alphabetically by fullName                 -->
            <!-- ================================================== -->
            <section class="section" id="participants">
              <h2>Participants</h2>
              <div class="table-wrap">
                <table>
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
                      <tr>
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
            <!-- SECTION 7 — Registrations Table                     -->
            <!-- xsl:choose on @registrationStatus for badge color   -->
            <!-- ================================================== -->
            <section class="section" id="registrations">
              <h2>Registrations</h2>
              <div class="table-wrap">
                <table>
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
                      <tr>
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
            <!-- SECTION 8 — Reports                                 -->
            <!-- Attendance stats, status summary, category totals   -->
            <!-- ================================================== -->
            <section class="section" id="reports">
              <h2>Reports</h2>

              <!-- Top 20 Events by Registrations — descending sort -->
              <h3>Top 20 Events by Registrations</h3>
              <div class="table-wrap">
                <table>
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
                        <tr>
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

              <!-- Registration Summary by Status -->
              <h3 class="mt-3">Registration Summary by Status</h3>
              <div class="table-wrap">
                <table>
                  <thead>
                    <tr>
                      <th>Status</th>
                      <th>Count</th>
                      <th>Percentage</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><span class="badge badge-registered">Registered</span></td>
                      <td>
                        <xsl:value-of select="count(//registration[@registrationStatus='Registered'])"/>
                      </td>
                      <td>
                        <xsl:value-of select="round((count(//registration[@registrationStatus='Registered']) div count(//registration)) * 100)"/>%
                      </td>
                    </tr>
                    <tr>
                      <td><span class="badge badge-attended">Attended</span></td>
                      <td>
                        <xsl:value-of select="count(//registration[@registrationStatus='Attended'])"/>
                      </td>
                      <td>
                        <xsl:value-of select="round((count(//registration[@registrationStatus='Attended']) div count(//registration)) * 100)"/>%
                      </td>
                    </tr>
                    <tr>
                      <td><span class="badge badge-cancelled">Cancelled</span></td>
                      <td>
                        <xsl:value-of select="count(//registration[@registrationStatus='Cancelled'])"/>
                      </td>
                      <td>
                        <xsl:value-of select="round((count(//registration[@registrationStatus='Cancelled']) div count(//registration)) * 100)"/>%
                      </td>
                    </tr>
                    <tr>
                      <td><span class="badge badge-noshow">No-show</span></td>
                      <td>
                        <xsl:value-of select="count(//registration[@registrationStatus='No-show'])"/>
                      </td>
                      <td>
                        <xsl:value-of select="round((count(//registration[@registrationStatus='No-show']) div count(//registration)) * 100)"/>%
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- Events by Category — count, sum, avg per category -->
              <h3 class="mt-3">Events by Category</h3>
              <div class="table-wrap">
                <table>
                  <thead>
                    <tr>
                      <th>Category</th>
                      <th>Total Events</th>
                      <th>Total Registrations</th>
                      <th>Total Capacity</th>
                      <th>Avg. Registrations</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Academic</td>
                      <td><xsl:value-of select="count(//event[category='Academic'])"/></td>
                      <td><xsl:value-of select="sum(//event[category='Academic']/registrations)"/></td>
                      <td><xsl:value-of select="sum(//event[category='Academic']/capacity)"/></td>
                      <td>
                        <xsl:value-of select="round(sum(//event[category='Academic']/registrations) div count(//event[category='Academic']))"/>
                      </td>
                    </tr>
                    <tr>
                      <td>Professional Development</td>
                      <td><xsl:value-of select="count(//event[category='Professional Development'])"/></td>
                      <td><xsl:value-of select="sum(//event[category='Professional Development']/registrations)"/></td>
                      <td><xsl:value-of select="sum(//event[category='Professional Development']/capacity)"/></td>
                      <td>
                        <xsl:value-of select="round(sum(//event[category='Professional Development']/registrations) div count(//event[category='Professional Development']))"/>
                      </td>
                    </tr>
                    <tr>
                      <td>Cultural</td>
                      <td><xsl:value-of select="count(//event[category='Cultural'])"/></td>
                      <td><xsl:value-of select="sum(//event[category='Cultural']/registrations)"/></td>
                      <td><xsl:value-of select="sum(//event[category='Cultural']/capacity)"/></td>
                      <td>
                        <xsl:value-of select="round(sum(//event[category='Cultural']/registrations) div count(//event[category='Cultural']))"/>
                      </td>
                    </tr>
                    <tr>
                      <td>Sports</td>
                      <td><xsl:value-of select="count(//event[category='Sports'])"/></td>
                      <td><xsl:value-of select="sum(//event[category='Sports']/registrations)"/></td>
                      <td><xsl:value-of select="sum(//event[category='Sports']/capacity)"/></td>
                      <td>
                        <xsl:value-of select="round(sum(//event[category='Sports']/registrations) div count(//event[category='Sports']))"/>
                      </td>
                    </tr>
                    <tr>
                      <td>Workshop</td>
                      <td><xsl:value-of select="count(//event[category='Workshop'])"/></td>
                      <td><xsl:value-of select="sum(//event[category='Workshop']/registrations)"/></td>
                      <td><xsl:value-of select="sum(//event[category='Workshop']/capacity)"/></td>
                      <td>
                        <xsl:value-of select="round(sum(//event[category='Workshop']/registrations) div count(//event[category='Workshop']))"/>
                      </td>
                    </tr>
                    <tr>
                      <td>Seminar</td>
                      <td><xsl:value-of select="count(//event[category='Seminar'])"/></td>
                      <td><xsl:value-of select="sum(//event[category='Seminar']/registrations)"/></td>
                      <td><xsl:value-of select="sum(//event[category='Seminar']/capacity)"/></td>
                      <td>
                        <xsl:value-of select="round(sum(//event[category='Seminar']/registrations) div count(//event[category='Seminar']))"/>
                      </td>
                    </tr>
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

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
