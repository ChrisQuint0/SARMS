<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Events Management System - XSLT Transformation Stylesheet
  Transforms events-data.xml into professional dashboard HTML
  
  Multiple templates for:
  - Dashboard summary (index.html)
  - Events listing (events.html)
  - Participants listing (participants.html)
  - Reports and statistics (reports.html)
  
  Design: Applies CSS classes for professional styling with green accents
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- =============================================
       OUTPUT SETTINGS
       ============================================= -->
  
  <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>
  
  <!-- =============================================
       KEY DECLARATIONS FOR EFFICIENT LOOKUPS
       ============================================= -->
  
  <xsl:key name="eventById" match="event" use="@eventId"/>
  <xsl:key name="participantById" match="participant" use="@participantId"/>
  <xsl:key name="registrationByEvent" match="registration" use="eventId"/>
  <xsl:key name="registrationByParticipant" match="registration" use="participantId"/>
  
  <!-- =============================================
       MAIN TEMPLATE - DASHBOARD (index.html)
       ============================================= -->
  
  <xsl:template name="dashboard-page">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Events Management System - Dashboard</title>
        <link rel="stylesheet" href="../css/style.css"/>
      </head>
      <body>
        <header class="header">
          <div class="container">
            <div class="header-content">
              <div class="logo">📅 Events Management</div>
              <nav class="nav">
                <a href="index.html" class="active">Dashboard</a>
                <a href="events.html">Events</a>
                <a href="participants.html">Participants</a>
                <a href="reports.html">Reports</a>
              </nav>
            </div>
          </div>
        </header>

        <main class="main">

          <div class="container">
            
            <!-- SUMMARY STATISTICS CARDS -->
            <section class="stats-grid">
              <xsl:call-template name="stat-card-total-events"/>
              <xsl:call-template name="stat-card-total-participants"/>
              <xsl:call-template name="stat-card-total-registrations"/>
              <xsl:call-template name="stat-card-confirmation-rate"/>
            </section>

            <!-- UPCOMING EVENTS SECTION -->
            <section class="section">
              <h2>Upcoming Events</h2>
              <div class="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>Event ID</th>
                      <th>Event Name</th>
                      <th>Date</th>
                      <th>Venue</th>
                      <th>Registrations</th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="//event">
                      <xsl:sort select="eventDate" order="ascending"/>
                      <xsl:if test="position() &lt;= 10">
                        <tr>
                          <td><xsl:value-of select="@eventId"/></td>
                          <td><xsl:value-of select="eventName"/></td>
                          <td><xsl:call-template name="format-date"><xsl:with-param name="date" select="eventDate"/></xsl:call-template></td>
                          <td><xsl:value-of select="venue"/></td>
                          <td>
                            <xsl:value-of select="count(//registration[eventId=current()/@eventId])"/>
                          </td>
                        </tr>
                      </xsl:if>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>
            </section>

            <!-- QUICK STATISTICS CARDS -->
            <section class="section">
              <h2>Registration Overview</h2>
              <div class="stats-grid">
                <div class="stat-card">
                  <div class="stat-label">Registered</div>
                  <div class="stat-value"><xsl:value-of select="count(//registration[registrationStatus='Registered'])"/></div>
                  <div class="badge badge-success">Confirmed</div>
                </div>
                <div class="stat-card">
                  <div class="stat-label">Pending Approval</div>
                  <div class="stat-value"><xsl:value-of select="count(//registration[registrationStatus='Pending'])"/></div>
                  <div class="badge badge-pending">Awaiting</div>
                </div>
                <div class="stat-card">
                  <div class="stat-label">Confirmation Rate</div>
                  <div class="stat-value">
                    <xsl:value-of select="round(count(//registration[registrationStatus='Registered']) div count(//registration) * 100)"/>%
                  </div>
                  <div class="badge badge-primary">Metric</div>
                </div>
              </div>
            </section>

            <!-- DEPARTMENTS BREAKDOWN -->
            <section class="section">
              <h2>Participants by Department</h2>
              <div class="grid grid-cols-2">
                <xsl:for-each select="/eventManagementSystem">
                  <xsl:variable name="depts" select="//participant[generate-id(.) = generate-id(//participant[department=current()/department][1])]"/>
                  <xsl:for-each select="//participant[not(department = preceding::participant/department)]">
                    <div class="card">
                      <div class="card-title"><xsl:value-of select="department"/></div>
                      <div class="card-content">
                        <p><strong>Total Participants:</strong> <xsl:value-of select="count(//participant[department=current()/department])"/></p>
                        <p><strong>Total Registrations:</strong> <xsl:value-of select="count(//registration[participantId=//participant[department=current()/department]/@participantId])"/></p>
                      </div>
                    </div>
                  </xsl:for-each>
                </xsl:for-each>
              </div>
            </section>

          </div>
        </main>

        <footer class="footer">
        <p>&#169; 2026 University Events Management System. All rights reserved.</p>
        </footer>
      </body>
    </html>
  </xsl:template>

  <!-- =============================================
       STAT CARD TEMPLATES
       ============================================= -->
  
  <xsl:template name="stat-card-total-events">
    <div class="stat-card">
      <div class="stat-label">Total Events</div>
      <div class="stat-value"><xsl:value-of select="count(//event)"/></div>
      <div class="stat-unit">University-wide</div>
    </div>
  </xsl:template>

  <xsl:template name="stat-card-total-participants">
    <div class="stat-card">
      <div class="stat-label">Total Participants</div>
      <div class="stat-value"><xsl:value-of select="count(//participant)"/></div>
      <div class="stat-unit">Registered students</div>
    </div>
  </xsl:template>

  <xsl:template name="stat-card-total-registrations">
    <div class="stat-card">
      <div class="stat-label">Total Registrations</div>
      <div class="stat-value"><xsl:value-of select="count(//registration)"/></div>
      <div class="stat-unit">Event sign-ups</div>
    </div>
  </xsl:template>

  <xsl:template name="stat-card-confirmation-rate">
    <div class="stat-card">
      <div class="stat-label">Avg per Event</div>
      <div class="stat-value"><xsl:value-of select="round(count(//registration) div count(//event))"/></div>
      <div class="stat-unit">registrations per event</div>
    </div>
  </xsl:template>

  <!-- =============================================
       EVENTS LISTING PAGE TEMPLATE
       ============================================= -->
  
  <xsl:template name="events-page">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Events Management System - Events Listing</title>
        <link rel="stylesheet" href="../css/style.css"/>
      </head>
      <body>
        <header class="header">
          <div class="container">
            <div class="header-content">
              <div class="logo">📅 Events Management</div>
              <nav class="nav">
                <a href="index.html">Dashboard</a>
                <a href="events.html" class="active">Events</a>
                <a href="participants.html">Participants</a>
                <a href="reports.html">Reports</a>
              </nav>
            </div>
          </div>
        </header>

        <main class="main">
          <div class="container">
            
            <h1>All Events</h1>
            <p>Complete listing of all university events with registration status.</p>

            <div class="table-container">
              <table>
                <thead>
                  <tr>
                    <th>Event ID</th>
                    <th>Event Name</th>
                    <th>Date</th>
                    <th>Venue</th>
                    <th>Status</th>
                    <th>Registrations</th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each select="//event">
                    <xsl:sort select="eventDate" order="ascending"/>
                    <tr>
                      <td><xsl:value-of select="@eventId"/></td>
                      <td><xsl:value-of select="eventName"/></td>
                      <td><xsl:call-template name="format-date"><xsl:with-param name="date" select="eventDate"/></xsl:call-template></td>
                      <td><xsl:value-of select="venue"/></td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="eventDate > '2026-05-11'">
                            <span class="badge badge-primary">Upcoming</span>
                          </xsl:when>
                          <xsl:otherwise>
                            <span class="badge badge-danger">Past</span>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td><xsl:value-of select="count(//registration[eventId=current()/@eventId])"/></td>
                    </tr>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>

            <!-- EVENT DETAILS BY CATEGORY -->
            <section class="section">
              <h2>Events by Category</h2>
              <xsl:for-each select="//event[contains(eventName, 'Tech') or contains(eventName, 'AI') or contains(eventName, 'Cloud')]">
                <xsl:if test="position() = 1">
                  <h3>Technology Events</h3>
                </xsl:if>
                <div class="card">
                  <div class="card-title"><xsl:value-of select="eventName"/></div>
                  <div class="card-content">
                    <p><strong>Date:</strong> <xsl:call-template name="format-date"><xsl:with-param name="date" select="eventDate"/></xsl:call-template></p>
                    <p><strong>Venue:</strong> <xsl:value-of select="venue"/></p>
                    <p><strong>Description:</strong> <xsl:value-of select="eventDescription"/></p>
                    <p><strong>Registrations:</strong> <xsl:value-of select="count(//registration[eventId=current()/@eventId])"/></p>
                  </div>
                </div>
              </xsl:for-each>
            </section>

          </div>
        </main>
      </body>
    </html>
  </xsl:template>

  <!-- =============================================
       PARTICIPANTS LISTING PAGE TEMPLATE
       ============================================= -->
  
  <xsl:template name="participants-page">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Events Management System - Participants</title>
        <link rel="stylesheet" href="../css/style.css"/>
      </head>
      <body>
        <header class="header">
          <div class="container">
            <div class="header-content">
              <div class="logo">📅 Events Management</div>
              <nav class="nav">
                <a href="index.html">Dashboard</a>
                <a href="events.html">Events</a>
                <a href="participants.html" class="active">Participants</a>
                <a href="reports.html">Reports</a>
              </nav>
            </div>
          </div>
        </header>

        <main class="main">
          <div class="container">
            
            <h1>All Participants</h1>
            <p>Complete listing of registered participants and their registration status.</p>

            <div class="table-container">
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Department</th>
                    <th>Events Registered</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each select="//participant">
                    <xsl:sort select="fullName" order="ascending"/>
                    <xsl:variable name="regCount" select="count(//registration[participantId=current()/@participantId])"/>
                    <xsl:variable name="confirmedCount" select="count(//registration[participantId=current()/@participantId and registrationStatus='Registered'])"/>
                    <tr>
                      <td><xsl:value-of select="@participantId"/></td>
                      <td><xsl:value-of select="fullName"/></td>
                      <td><xsl:value-of select="department"/></td>
                      <td><xsl:value-of select="$regCount"/></td>
                      <td>
                        <xsl:if test="$confirmedCount > 0">
                          <span class="badge badge-success">
                            <xsl:value-of select="$confirmedCount"/> Confirmed
                          </span>
                        </xsl:if>
                        <xsl:if test="$regCount - $confirmedCount > 0">
                          <span class="badge badge-pending">
                            <xsl:value-of select="$regCount - $confirmedCount"/> Pending
                          </span>
                        </xsl:if>
                      </td>
                    </tr>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>

          </div>
        </main>
      </body>
    </html>
  </xsl:template>

  <!-- =============================================
       REPORTS PAGE TEMPLATE
       ============================================= -->
  
  <xsl:template name="reports-page">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Events Management System - Reports</title>
        <link rel="stylesheet" href="../css/style.css"/>
      </head>
      <body>
        <header class="header">
          <div class="container">
            <div class="header-content">
              <div class="logo">📅 Events Management</div>
              <nav class="nav">
                <a href="index.html">Dashboard</a>
                <a href="events.html">Events</a>
                <a href="participants.html">Participants</a>
                <a href="reports.html" class="active">Reports</a>
              </nav>
            </div>
          </div>
        </header>

        <main class="main">
          <div class="container">
            
            <h1>Reports &amp; Statistics</h1>
            <p>Detailed analysis, attendance projections, and event statistics.</p>

            <!-- ATTENDANCE PROJECTION -->
            <section class="section">
              <h2>Attendance Projection</h2>
              <div class="stats-grid">
                <div class="stat-card">
                  <div class="stat-label">Total Events</div>
                  <div class="stat-value"><xsl:value-of select="count(//event)"/></div>
                </div>
                <div class="stat-card">
                  <div class="stat-label">Total Participants</div>
                  <div class="stat-value"><xsl:value-of select="count(//participant)"/></div>
                </div>
                <div class="stat-card">
                  <div class="stat-label">Confirmed Attendance</div>
                  <div class="stat-value"><xsl:value-of select="count(//registration[registrationStatus='Registered'])"/></div>
                </div>
                <div class="stat-card">
                  <div class="stat-label">Confirmation Rate</div>
                  <div class="stat-value">
                    <xsl:value-of select="round(count(//registration[registrationStatus='Registered']) div count(//registration) * 100)"/>%
                  </div>
                </div>
              </div>
            </section>

            <!-- ATTENDANCE SHEET BY EVENT -->
            <section class="section">
              <h2>Attendance Sheet</h2>
              <xsl:for-each select="//event[count(//registration[eventId=current()/@eventId]) > 0]">
                <xsl:sort select="eventDate" order="ascending"/>
                <xsl:if test="position() &lt;= 15">
                  <div class="card">
                    <div class="card-title">
                      <xsl:value-of select="eventName"/>
                      <span style="color: #4B5563; font-size: 0.875rem;">
                        (<xsl:call-template name="format-date"><xsl:with-param name="date" select="eventDate"/></xsl:call-template>)
                      </span>
                    </div>
                    <div class="card-content">
                      <p><strong>Venue:</strong> <xsl:value-of select="venue"/></p>
                      <p><strong>Total Registrations:</strong> <xsl:value-of select="count(//registration[eventId=current()/@eventId])"/></p>
                      <p><strong>Confirmed:</strong> <xsl:value-of select="count(//registration[eventId=current()/@eventId and registrationStatus='Registered'])"/></p>
                      <p><strong>Pending:</strong> <xsl:value-of select="count(//registration[eventId=current()/@eventId and registrationStatus='Pending'])"/></p>
                    </div>
                  </div>
                </xsl:if>
              </xsl:for-each>
            </section>

            <!-- REGISTRATION SUMMARY -->
            <section class="section">
              <h2>Registration Summary</h2>
              <div class="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>Status</th>
                      <th>Count</th>
                      <th>Percentage</th>
                      <th>Status Indicator</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Registered (Confirmed)</td>
                      <td><xsl:value-of select="count(//registration[registrationStatus='Registered'])"/></td>
                      <td><xsl:value-of select="round(count(//registration[registrationStatus='Registered']) div count(//registration) * 100)"/>%</td>
                      <td><span class="badge badge-success">Confirmed</span></td>
                    </tr>
                    <tr>
                      <td>Pending (Awaiting Approval)</td>
                      <td><xsl:value-of select="count(//registration[registrationStatus='Pending'])"/></td>
                      <td><xsl:value-of select="round(count(//registration[registrationStatus='Pending']) div count(//registration) * 100)"/>%</td>
                      <td><span class="badge badge-pending">Pending</span></td>
                    </tr>
                    <tr>
                      <td><strong>Total</strong></td>
                      <td><strong><xsl:value-of select="count(//registration)"/></strong></td>
                      <td><strong>100%</strong></td>
                      <td><span class="badge badge-primary">All</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </section>

          </div>
        </main>
      </body>
    </html>
  </xsl:template>

  <!-- =============================================
       UTILITY TEMPLATES
       ============================================= -->
  
  <!-- Format date from YYYY-MM-DD to readable format -->
  <xsl:template name="format-date">
    <xsl:param name="date"/>
    <xsl:variable name="year" select="substring($date, 1, 4)"/>
    <xsl:variable name="month" select="substring($date, 6, 2)"/>
    <xsl:variable name="day" select="substring($date, 9, 2)"/>
    <xsl:variable name="monthName">
      <xsl:choose>
        <xsl:when test="$month='01'">January</xsl:when>
        <xsl:when test="$month='02'">February</xsl:when>
        <xsl:when test="$month='03'">March</xsl:when>
        <xsl:when test="$month='04'">April</xsl:when>
        <xsl:when test="$month='05'">May</xsl:when>
        <xsl:when test="$month='06'">June</xsl:when>
        <xsl:when test="$month='07'">July</xsl:when>
        <xsl:when test="$month='08'">August</xsl:when>
        <xsl:when test="$month='09'">September</xsl:when>
        <xsl:when test="$month='10'">October</xsl:when>
        <xsl:when test="$month='11'">November</xsl:when>
        <xsl:when test="$month='12'">December</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($monthName, ' ', number($day), ', ', $year)"/>
  </xsl:template>

  <!-- Main root template that generates all pages -->
  <xsl:template match="/">
    <xsl:call-template name="dashboard-page"/>
  </xsl:template>

</xsl:stylesheet>
