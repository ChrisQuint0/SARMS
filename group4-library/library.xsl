<?xml version="1.0" encoding="UTF-8"?>
<!--
  SARMS - Smart Academic Records Management System
  Module  : Group 4 - Library Management System
  File    : library.xsl
  Purpose : Transforms library.xml into an HTML report
            Green theme - SARMS unified design
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>SARMS - Library Management Report</title>
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }

          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0faf4;
            color: #1a3a2a;
            line-height: 1.6;
          }

          /* ── Header ── */
          .header {
            background: linear-gradient(135deg, #064e3b 0%, #065f46 50%, #047857 100%);
            color: #ffffff;
            padding: 48px 40px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(6,78,59,0.4);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            position: relative;
            overflow: hidden;
          }
          .header::before {
            content: "";
            position: absolute;
            top: -60px; right: -60px;
            width: 220px; height: 220px;
            background: rgba(255,255,255,0.04);
            border-radius: 50%;
          }
          .header::after {
            content: "";
            position: absolute;
            bottom: -80px; left: -40px;
            width: 280px; height: 280px;
            background: rgba(255,255,255,0.03);
            border-radius: 50%;
          }
          .header .school-name {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 3px;
            color: #6ee7b7;
            margin-bottom: 6px;
          }
          .header h1 {
            font-size: 34px;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #ffffff;
          }
          .header .subtitle {
            font-size: 14px;
            color: #a7f3d0;
            margin-top: 6px;
          }
          .header .badges {
            display: flex;
            gap: 10px;
            margin-top: 14px;
            flex-wrap: wrap;
            justify-content: center;
          }
          .header-badge {
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            color: #d1fae5;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.5px;
            padding: 5px 16px;
            border-radius: 20px;
          }

          /* ── Stats Bar ── */
          .stats-bar {
            display: flex;
            justify-content: center;
            gap: 20px;
            padding: 32px 40px 8px;
            flex-wrap: wrap;
            max-width: 1200px;
            margin: 0 auto;
          }
          .stat-item {
            text-align: center;
            min-width: 160px;
            background: #ffffff;
            border: 1px solid #d1fae5;
            border-top: 4px solid #059669;
            border-radius: 12px;
            padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(6,78,59,0.08);
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: transform 0.2s;
          }
          .stat-item:hover { transform: translateY(-2px); }
          .stat-item.danger  { border-top-color: #dc2626; }
          .stat-item.warning { border-top-color: #d97706; }
          .stat-item.blue    { border-top-color: #2563eb; }
          .stat-value {
            font-size: 38px;
            font-weight: 800;
            color: #065f46;
            line-height: 1;
          }
          .stat-item.danger  .stat-value { color: #dc2626; }
          .stat-item.warning .stat-value { color: #d97706; }
          .stat-item.blue    .stat-value { color: #2563eb; }
          .stat-label {
            font-size: 10px;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: #6b7280;
            margin-top: 8px;
            font-weight: 700;
          }

          /* ── Container ── */
          .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 20px;
          }

          /* ── Legend ── */
          .legend {
            position: sticky;
            top: 16px;
            z-index: 10;
            display: flex;
            justify-content: center;
            gap: 12px;
            padding: 14px 24px;
            margin-bottom: 32px;
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(8px);
            border-radius: 12px;
            border: 1px solid #d1fae5;
            box-shadow: 0 4px 12px rgba(6,78,59,0.1);
            flex-wrap: wrap;
          }
          .legend-label {
            font-size: 11px;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            letter-spacing: 1px;
            align-self: center;
            margin-right: 4px;
          }
          .legend-item {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: 0.3px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
          }

          /* ── Section Header ── */
          .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 36px 0 16px;
            padding-bottom: 12px;
            border-bottom: 2px solid #059669;
          }
          .section-header.danger { border-bottom-color: #dc2626; }
          .section-number {
            background: #059669;
            color: white;
            font-size: 12px;
            font-weight: 800;
            width: 28px; height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
          }
          .section-header.danger .section-number { background: #dc2626; }
          .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #064e3b;
          }
          .section-header.danger .section-title { color: #dc2626; }
          .section-count {
            margin-left: auto;
            background: #d1fae5;
            color: #065f46;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 14px;
            border-radius: 20px;
          }
          .section-header.danger .section-count {
            background: #fee2e2;
            color: #dc2626;
          }

          /* ── Book Card ── */
          .book-card {
            background: #ffffff;
            border-radius: 14px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(6,78,59,0.08);
            overflow: hidden;
            border-left: 6px solid #059669;
            transition: box-shadow 0.2s, transform 0.2s;
          }
          .book-card:hover {
            box-shadow: 0 6px 20px rgba(6,78,59,0.15);
            transform: translateY(-1px);
          }
          .book-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 28px;
            flex-wrap: wrap;
            gap: 16px;
          }
          .book-info-wrapper {
            display: flex;
            align-items: center;
            gap: 18px;
          }
          .avatar {
            width: 52px; height: 52px;
            border-radius: 12px;
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 800;
            flex-shrink: 0;
            border: 2px solid #6ee7b7;
          }
          .book-info h2 {
            font-size: 17px;
            font-weight: 700;
            color: #1a3a2a;
            margin-bottom: 6px;
          }
          .book-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
          }
          .book-meta span {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #065f46;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
          }
          .isbn-tag {
            font-family: ui-monospace, monospace;
            font-size: 11px;
            color: #6b7280;
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            padding: 6px 14px;
            border-radius: 8px;
            align-self: center;
          }

          /* ── Records Table ── */
          .table-wrapper {
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 2px 8px rgba(6,78,59,0.08);
            overflow: hidden;
            margin-bottom: 8px;
          }
          .records-table {
            width: 100%;
            border-collapse: collapse;
          }
          .records-table thead {
            background: linear-gradient(135deg, #064e3b, #065f46);
          }
          .records-table th {
            color: #a7f3d0;
            padding: 14px 20px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            font-weight: 700;
          }
          .records-table td {
            padding: 14px 20px;
            border-bottom: 1px solid #ecfdf5;
            font-size: 13px;
            color: #374151;
          }
          .records-table tr:last-child td { border-bottom: none; }
          .records-table tbody tr:hover td { background: #f0fdf4; }
          .records-table tr.row-overdue td { background: #fff5f5; }
          .records-table tr.row-overdue:hover td { background: #fee2e2; }
          .id-mono {
            font-family: ui-monospace, monospace;
            font-size: 12px;
            color: #059669;
            font-weight: 700;
          }
          .borrower-name { font-weight: 700; color: #1a3a2a; }

          /* ── Status Badge ── */
          .status-badge {
            display: inline-block;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.3px;
            color: #fff;
          }
          .s-active       { background: linear-gradient(135deg, #10b981, #059669); }
          .s-returned     { background: linear-gradient(135deg, #3b82f6, #2563eb); }
          .s-overdue      { background: linear-gradient(135deg, #ef4444, #dc2626); }
          .s-late         { background: linear-gradient(135deg, #f59e0b, #d97706); }

          /* ── Overdue Notice Card ── */
          .notice-card {
            background: #ffffff;
            border-radius: 14px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(220,38,38,0.1);
            overflow: hidden;
            border-left: 6px solid #dc2626;
          }
          .notice-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 28px;
            background: linear-gradient(135deg, #fff5f5, #fee2e2);
            border-bottom: 1px solid #fecaca;
            flex-wrap: wrap;
            gap: 12px;
          }
          .notice-top h3 {
            font-size: 17px;
            font-weight: 700;
            color: #991b1b;
          }
          .notice-tag {
            background: #dc2626;
            color: white;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 5px 16px;
            border-radius: 20px;
          }
          .notice-body {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0;
          }
          .notice-row {
            display: flex;
            padding: 11px 28px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 13px;
          }
          .notice-row:nth-child(odd)  { background: #ffffff; }
          .notice-row:nth-child(even) { background: #fafafa; }
          .notice-label {
            color: #6b7280;
            font-weight: 700;
            width: 130px;
            flex-shrink: 0;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
          }
          .notice-value { color: #1f2937; font-weight: 500; }
          .notice-value.due { color: #dc2626; font-weight: 800; }
          .warning-bar {
            background: linear-gradient(135deg, #dc2626, #b91c1c);
            color: white;
            text-align: center;
            padding: 14px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.3px;
          }

          .no-data {
            text-align: center;
            color: #9ca3af;
            font-style: italic;
            padding: 40px;
            background: white;
            border-radius: 14px;
          }

          /* ── Footer ── */
          .footer {
            text-align: center;
            padding: 28px;
            color: #6b7280;
            font-size: 12px;
            border-top: 1px solid #d1fae5;
            margin-top: 20px;
            background: #ffffff;
          }

          /* ========== Navigation Menu ========== */
          .menu-button {
            position: fixed;
            top: 24px;
            left: 24px;
            width: 56px;
            height: 56px;
            background: #008a45;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0, 138, 69, 0.3);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: none;
          }

          .menu-button:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 16px rgba(0, 138, 69, 0.4);
          }

          .menu-button i {
            color: white;
            font-size: 22px;
            transition: transform 0.3s ease;
          }

          .menu-button.active i {
            transform: rotate(90deg);
          }

          .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
          }

          .modal-overlay.active {
            opacity: 1;
            visibility: visible;
          }

          .module-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.9);
            background: white;
            border-radius: 24px;
            padding: 40px;
            z-index: 1001;
            max-width: 900px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
          }

          .module-modal.active {
            opacity: 1;
            visibility: visible;
            transform: translate(-50%, -50%) scale(1);
          }

          .modal-header {
            margin-bottom: 32px;
          }

          .modal-header h2 {
            font-size: 32px;
            font-weight: 800;
            color: #008a45;
            margin-bottom: 8px;
          }

          .modal-header p {
            font-size: 16px;
            color: #6b7280;
          }

          .module-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
          }

          .module-card {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            padding: 24px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            text-decoration: none;
            color: inherit;
            display: block;
          }

          .module-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, #008a45, #00c76f);
            opacity: 0;
            transition: all 0.3s ease;
          }

          .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 138, 69, 0.15);
            border-color: #008a45;
          }

          .module-card:hover::before {
            opacity: 0.03;
          }

          .module-card i {
            font-size: 28px;
            color: #008a45;
            margin-bottom: 12px;
            display: block;
            position: relative;
            z-index: 1;
          }

          .module-card h3 {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
          }

          .module-card p {
            font-size: 13px;
            color: #6b7280;
            line-height: 1.5;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
          }

          .module-card .view-link {
            font-size: 13px;
            color: #008a45;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
            position: relative;
            z-index: 1;
            transition: gap 0.2s ease;
          }

          .module-card:hover .view-link {
            gap: 8px;
          }
        </style>
      </head>
      <body>

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

        <!-- Circular Menu Button -->
        <button class="menu-button" onclick="toggleModal()">
          <i class="fas fa-th"></i>
        </button>

        <!-- Modal Overlay -->
        <div class="modal-overlay" id="modalOverlay" onclick="toggleModal()"></div>

        <!-- Module Navigation Modal -->
        <div class="module-modal" id="moduleModal">
          <div class="modal-header">
            <h2>Module Navigation</h2>
            <p>Select a module to view detailed information</p>
          </div>
          <div class="module-grid">
            <a href="../sarms-dashboard.html" class="module-card">
              <i class="fas fa-th"></i>
              <h3>Dashboard</h3>
              <p>Unified view with statistics and charts</p>
              <span class="view-link">
                <i class="fas fa-arrow-right"></i> Go to Dashboard
              </span>
            </a>
            <a href="../group1-enrollment/students.xml" target="_blank" class="module-card">
              <i class="fas fa-user-graduate"></i>
              <h3>Student Enrollment</h3>
              <p>Manage student records, enrollments, and academic performance</p>
              <span class="view-link">
                <i class="fas fa-external-link-alt"></i> View Module →
              </span>
            </a>
            <a href="../group3-faculty/faculty.xml" target="_blank" class="module-card">
              <i class="fas fa-chalkboard-teacher"></i>
              <h3>Faculty Workload</h3>
              <p>Track faculty assignments, teaching hours, and workload distribution</p>
              <span class="view-link">
                <i class="fas fa-external-link-alt"></i> View Module →
              </span>
            </a>
            <a href="../group4-library/library.xml" target="_blank" class="module-card" style="border-color: #008a45; background: #f0fdf4;">
              <i class="fas fa-book"></i>
              <h3>Library Management</h3>
              <p>Manage books, borrowing records, and library resources (Current Page)</p>
              <span class="view-link">
                ✓ Current Module
              </span>
            </a>
            <a href="../group5-billing/billing.xml" target="_blank" class="module-card">
              <i class="fas fa-file-invoice-dollar"></i>
              <h3>Student Billing</h3>
              <p>Track tuition fees, payments, and outstanding balances</p>
              <span class="view-link">
                <i class="fas fa-external-link-alt"></i> View Module →
              </span>
            </a>
            <a href="../group6-events/events.xml" target="_blank" class="module-card">
              <i class="fas fa-calendar-alt"></i>
              <h3>Event Management</h3>
              <p>Organize university events, registrations, and attendance</p>
              <span class="view-link">
                <i class="fas fa-external-link-alt"></i> View Module →
              </span>
            </a>
          </div>
        </div>

        <script>
          function toggleModal() {
            const modal = document.getElementById('moduleModal');
            const overlay = document.getElementById('modalOverlay');
            const button = document.querySelector('.menu-button');
            modal.classList.toggle('active');
            overlay.classList.toggle('active');
            button.classList.toggle('active');
          }
        </script>

        <!-- Header -->
        <div class="header">
          <div class="school-name">Pamantasan ng Lungsod ng Pasig</div>
          <h1>Library Management Report</h1>
          <div class="subtitle">
            SARMS: Smart Academic Records Management System
            <span style="opacity:0.4; margin:0 8px;">|</span>
            Group 4
          </div>
          <div class="badges">
            <span class="header-badge">Library Management System</span>
            <span class="header-badge">library.xml via library.xsl</span>
            <span class="header-badge">XSLT 1.0</span>
          </div>
        </div>

        <!-- Stats -->
        <div class="stats-bar">
          <div class="stat-item">
            <div class="stat-value">
              <xsl:value-of select="count(/library/books/book)"/>
            </div>
            <div class="stat-label">Total Books</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">
              <xsl:value-of select="count(/library/borrowingRecords/record)"/>
            </div>
            <div class="stat-label">Total Records</div>
          </div>
          <div class="stat-item">
            <div class="stat-value">
              <xsl:value-of select="count(/library/borrowingRecords/record[status='Active'])"/>
            </div>
            <div class="stat-label">Active Borrows</div>
          </div>
          <div class="stat-item danger">
            <div class="stat-value">
              <xsl:value-of select="count(/library/borrowingRecords/record[status='Overdue'])"/>
            </div>
            <div class="stat-label">Overdue</div>
          </div>
          <div class="stat-item blue">
            <div class="stat-value">
              <xsl:value-of select="count(/library/borrowingRecords/record[status='Returned'])"/>
            </div>
            <div class="stat-label">Returned</div>
          </div>
          <div class="stat-item warning">
            <div class="stat-value">
              <xsl:value-of select="count(/library/borrowingRecords/record[status='Returned Late'])"/>
            </div>
            <div class="stat-label">Returned Late</div>
          </div>
        </div>

        <div class="container">

          <!-- Legend -->
          <div class="legend">
            <span class="legend-label">Status:</span>
            <span class="legend-item" style="background:linear-gradient(135deg,#10b981,#059669);">Active</span>
            <span class="legend-item" style="background:linear-gradient(135deg,#3b82f6,#2563eb);">Returned</span>
            <span class="legend-item" style="background:linear-gradient(135deg,#ef4444,#dc2626);">Overdue</span>
            <span class="legend-item" style="background:linear-gradient(135deg,#f59e0b,#d97706);">Returned Late</span>
          </div>

          <!-- SECTION 1: Book Inventory -->
          <div class="section-header">
            <div class="section-number">1</div>
            <div class="section-title">Book Inventory</div>
            <div class="section-count">
              <xsl:value-of select="count(/library/books/book)"/> Books
            </div>
          </div>
          <xsl:apply-templates select="/library/books/book"/>

          <!-- SECTION 2: Borrowing Records -->
          <div class="section-header">
            <div class="section-number">2</div>
            <div class="section-title">Borrowing Records</div>
            <div class="section-count">
              <xsl:value-of select="count(/library/borrowingRecords/record)"/> Records
            </div>
          </div>
          <div class="table-wrapper">
            <table class="records-table">
              <thead>
                <tr>
                  <th>Record ID</th>
                  <th>Book ID</th>
                  <th>Borrower Name</th>
                  <th>Type</th>
                  <th>Course</th>
                  <th>Borrow Date</th>
                  <th>Due Date</th>
                  <th>Return Date</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <xsl:apply-templates select="/library/borrowingRecords/record"/>
              </tbody>
            </table>
          </div>

          <!-- SECTION 3: Overdue Notices -->
          <div class="section-header danger">
            <div class="section-number">3</div>
            <div class="section-title">Overdue Notices</div>
            <div class="section-count">
              <xsl:value-of select="count(/library/borrowingRecords/record[status='Overdue'])"/> Overdue
            </div>
          </div>
          <xsl:choose>
            <xsl:when test="/library/borrowingRecords/record[status='Overdue']">
              <xsl:apply-templates
                select="/library/borrowingRecords/record[status='Overdue']"
                mode="notice"/>
            </xsl:when>
            <xsl:otherwise>
              <div class="no-data">No overdue records found.</div>
            </xsl:otherwise>
          </xsl:choose>

        </div>

        <!-- Footer -->
        <div class="footer">
          <p>SARMS — Smart Academic Records Management System | Pamantasan ng Lungsod ng Pasig</p>
          <p style="margin-top:4px;">Group 4: Library Management System | Generated via XSLT Transformation from library.xml</p>
        </div>

      </body>
    </html>
  </xsl:template>

  <!-- Book card template -->
  <xsl:template match="book">
    <div class="book-card">
      <div class="book-header">
        <div class="book-info-wrapper">
          <div class="avatar">
            <xsl:value-of select="substring(title,1,2)"/>
          </div>
          <div class="book-info">
            <h2><xsl:value-of select="title"/></h2>
            <div class="book-meta">
              <span><xsl:value-of select="@bookId"/></span>
              <span><xsl:value-of select="author"/></span>
              <span><xsl:value-of select="category"/></span>
              <span><xsl:value-of select="copies"/> Copies</span>
            </div>
          </div>
        </div>
        <div class="isbn-tag"><xsl:value-of select="isbn"/></div>
      </div>
    </div>
  </xsl:template>

  <!-- Record row template -->
  <xsl:template match="record">
    <xsl:variable name="rc">
      <xsl:if test="status = 'Overdue'">row-overdue</xsl:if>
    </xsl:variable>
    <tr class="{$rc}">
      <td><span class="id-mono"><xsl:value-of select="@recordId"/></span></td>
      <td><span class="id-mono"><xsl:value-of select="bookId"/></span></td>
      <td class="borrower-name"><xsl:value-of select="borrower/borrowerName"/></td>
      <td><xsl:value-of select="borrower/borrowerType"/></td>
      <td><xsl:value-of select="borrower/course"/></td>
      <td><xsl:value-of select="borrowDate"/></td>
      <td><xsl:value-of select="dueDate"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="returnDate != ''"><xsl:value-of select="returnDate"/></xsl:when>
          <xsl:otherwise>—</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:variable name="sc">
          <xsl:choose>
            <xsl:when test="status = 'Overdue'">status-badge s-overdue</xsl:when>
            <xsl:when test="status = 'Active'">status-badge s-active</xsl:when>
            <xsl:when test="status = 'Returned'">status-badge s-returned</xsl:when>
            <xsl:when test="status = 'Returned Late'">status-badge s-late</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <span class="{$sc}"><xsl:value-of select="status"/></span>
      </td>
    </tr>
  </xsl:template>

  <!-- Overdue notice template -->
  <xsl:template match="record" mode="notice">
    <div class="notice-card">
      <div class="notice-top">
        <h3>Notice for: <xsl:value-of select="borrower/borrowerName"/></h3>
        <span class="notice-tag">Overdue Notice</span>
      </div>
      <div class="notice-body">
        <div class="notice-row">
          <span class="notice-label">Record ID</span>
          <span class="notice-value"><xsl:value-of select="@recordId"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Borrower ID</span>
          <span class="notice-value"><xsl:value-of select="borrower/borrowerId"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Borrower Type</span>
          <span class="notice-value"><xsl:value-of select="borrower/borrowerType"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Course / Dept.</span>
          <span class="notice-value"><xsl:value-of select="borrower/course"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Contact No.</span>
          <span class="notice-value"><xsl:value-of select="borrower/contactNo"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Book ID</span>
          <span class="notice-value"><xsl:value-of select="bookId"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Borrow Date</span>
          <span class="notice-value"><xsl:value-of select="borrowDate"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Due Date</span>
          <span class="notice-value due"><xsl:value-of select="dueDate"/></span>
        </div>
        <div class="notice-row">
          <span class="notice-label">Return Date</span>
          <span class="notice-value">Not yet returned</span>
        </div>
      </div>
      <div class="warning-bar">
        This book is OVERDUE. Please return immediately to avoid penalties.
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>