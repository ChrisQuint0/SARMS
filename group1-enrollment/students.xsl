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
            padding-top: 100px;
          }

          /* ========== Header ========== */
          .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            width: 100%;
            z-index: 1000;
            background: linear-gradient(135deg, #008a45 0%, #005a2e 100%);
            color: #ffffff;
            padding: 16px 24px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
          }

          .header-inner {
            max-width: 96%;
            margin: 0 auto;
            margin-left: 90px;
            display: flex;
            justify-content: space-between;
            align-items: center;
          }

          .header-title { 
            font-size: 20px; 
            font-weight: 700; 
            letter-spacing: -0.02em; 
          }

          .header-sub { 
            font-size: 14px; 
            color: rgba(255, 255, 255, 0.7); 
            margin-top: 2px; 
          }

          .navbar {
            display: flex;
            gap: 16px;
            list-style: none;
          }

          .navbar a {
            color: #ffffff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
          }

          .navbar a:hover { 
            background-color: rgba(255, 255, 255, 0.15); 
          }

          .navbar a.active {
            background-color: rgba(255, 255, 255, 0.15);
            font-weight: 600;
          }

          /* ========== Page Navigation and Widgets ========== */
          .page-section {
            display: none;
            animation: fadeIn 0.4s ease forwards;
          }
          .page-section.active {
            display: block;
          }
          
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
          }

          .dashboard-widgets {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 32px;
            max-width: 96%;
            margin: 0 auto 40px auto;
            padding: 0 20px;
          }

          .widget-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 28px 32px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid #e2e8f0;
          }
          
          .widget-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 16px;
          }
          .widget-title {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
          }

          /* Mock Chart */
          .mock-chart {
            height: 250px;
            background: linear-gradient(to top, #f8fafc 0%, transparent 100%);
            border-bottom: 2px solid #e2e8f0;
            border-left: 2px solid #e2e8f0;
            display: flex;
            align-items: flex-end;
            gap: 8%;
            padding: 20px 5% 0 5%;
            margin-top: 30px;
            position: relative;
          }
          .chart-bar {
            flex: 1;
            background: linear-gradient(to top, #008a45, #10b981);
            border-radius: 6px 6px 0 0;
            position: relative;
            transition: all 0.3s ease;
          }
          .chart-bar:hover { filter: brightness(1.1); transform: translateY(-2px); }
          .chart-bar::after {
            content: attr(data-label);
            position: absolute;
            bottom: -28px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
          }
          .chart-bar::before {
            content: attr(data-val);
            position: absolute;
            top: -28px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 13px;
            font-weight: 700;
            color: #006b35;
          }

          /* Activity Feed */
          .activity-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 20px;
          }
          .activity-item {
            display: flex;
            gap: 16px;
            align-items: flex-start;
          }
          .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: #ecfdf5;
            color: #059669;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 16px;
          }
          .activity-content h4 {
            font-size: 14px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 2px;
          }
          .activity-content p {
            font-size: 13px;
            color: #64748b;
          }
          .activity-time {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 6px;
            display: block;
            font-weight: 500;
          }

          /* ========== Summary Stats ========== */
          .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 32px;
            padding: 40px 20px;
            max-width: 96%;
            margin: 0 auto;
          }

          .stat-item {
            text-align: center;
            border-radius: 20px;
            padding: 28px 24px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
          }

          .stat-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.1);
          }

          .stat-item:nth-child(1) { background: linear-gradient(135deg, #EFF6FF, #DBEAFE); border-bottom: 4px solid #3B82F6; }
          .stat-item:nth-child(2) { background: linear-gradient(135deg, #F5F3FF, #EDE9FE); border-bottom: 4px solid #8B5CF6; }
          .stat-item:nth-child(3) { background: linear-gradient(135deg, #ECFDF5, #D1FAE5); border-bottom: 4px solid #10B981; }
          .stat-item:nth-child(4) { background: linear-gradient(135deg, #FFF1F2, #FFE4E6); border-bottom: 4px solid #F43F5E; }

          .stat-value {
            font-size: 42px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 16px;
            line-height: 1.1;
          }
          
          .stat-item:nth-child(1) .stat-value, .stat-item:nth-child(1) .stat-value svg { color: #1D4ED8; }
          .stat-item:nth-child(2) .stat-value, .stat-item:nth-child(2) .stat-value svg { color: #6D28D9; }
          .stat-item:nth-child(3) .stat-value, .stat-item:nth-child(3) .stat-value svg { color: #047857; }
          .stat-item:nth-child(4) .stat-value, .stat-item:nth-child(4) .stat-value svg { color: #BE123C; }

          .stat-label {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-top: 12px;
            font-weight: 700;
          }

          .stat-item:nth-child(1) .stat-label { color: #2563EB; }
          .stat-item:nth-child(2) .stat-label { color: #7C3AED; }
          .stat-item:nth-child(3) .stat-label { color: #059669; }
          .stat-item:nth-child(4) .stat-label { color: #E11D48; }

          /* ========== Container ========== */
          .container {
            max-width: 96%;
            margin: 0 auto;
            padding: 30px 20px;
          }

          /* ========== Student Card Layout ========== */
          .grades-content {
            display: grid;
            grid-template-columns: 1fr;
            gap: 24px;
            width: 100%;
          }
          .grades-content.collapsed-mode {
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
          }
          .grades-content.collapsed-mode .card-main {
            display: none !important;
          }
          .grades-content.collapsed-mode .card-sidebar {
            width: 100%;
          }

          .student-card {
            display: flex;
            gap: 24px;
            background: transparent;
            width: 100%;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
          }

          .student-card:hover {
            transform: translateY(-4px);
          }

          .card-sidebar {
            width: 320px;
            background: #ffffff;
            border-radius: 24px;
            padding: 32px 24px;
            display: flex;
            flex-direction: column;
            gap: 24px;
            flex-shrink: 0;
            align-items: center;
            color: #1e293b;
            box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            position: relative;
            overflow: hidden;
          }

          .card-main {
            flex: 1;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            border-radius: 24px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            overflow: hidden;
          }

          .student-info-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: 16px;
          }

          .avatar {
            width: 84px;
            height: 84px;
            border-radius: 50%;
            background: linear-gradient(135deg, #00994d, #007339);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: 1px;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(0, 153, 77, 0.3);
            position: relative;
            z-index: 2;
          }

          .student-info h2 {
            font-size: 20px;
            font-weight: 800;
            color: #1e293b;
            line-height: 1.2;
          }

          .student-meta {
            display: flex;
            flex-direction: column;
            gap: 12px;
            width: 100%;
          }

          .student-meta span {
            display: flex;
            align-items: center;
            gap: 10px;
            background-color: #f8fafc;
            padding: 8px 16px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            letter-spacing: 0.5px;
            border: 1px solid #e2e8f0;
          }

          .student-meta svg {
            color: #008a45;
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
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
            border: 1px solid rgba(255, 255, 255, 0.2);
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

          .subjects-table thead {
            background-color: #f8fafc;
            color: #475569;
            border-bottom: 2px solid #e2e8f0;
          }
          
          .subjects-table tbody tr:hover td {
            background-color: #f1f5f9;
          }

          .subjects-table th {
            padding: 16px 32px;
            text-align: left;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.02em;
            font-weight: 700;
            border-top: none;
            border-bottom: none;
          }

          .subjects-table td {
            padding: 14px 32px;
            border-bottom: 1px solid #e2e8f0;
            border-left: none;
            border-right: none;
            font-size: 14px;
            color: #334155;
            transition: background-color 0.15s ease;
          }

          .subjects-table tbody tr {
            transition: all 0.2s ease;
          }

          .subjects-table tbody tr:hover {
            background: linear-gradient(90deg, #e6f4ec, transparent);
          }

          .subjects-table tbody tr:last-child td {
            border-bottom: none;
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
            display: flex;
            justify-content: center;
            gap: 16px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            padding-top: 10px;
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

          /* ========== Filter Controls ========== */
          .filter-controls {
            display: flex;
            gap: 16px;
            align-items: flex-end;
            margin-bottom: 24px;
            flex-wrap: wrap;
          }

          .filter-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1;
            min-width: 150px;
          }

          .filter-label { 
            font-weight: 700; 
            color: #1e293b; 
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
          }

          .filter-select {
            padding: 6px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 13px;
            color: #334155;
            background-color: #ffffff;
            cursor: pointer;
            width: 100%;
            transition: all 0.2s ease;
          }
          .filter-select:hover { border-color: #94a3b8; }
          .filter-select:focus { outline: none; border-color: #008a45; box-shadow: 0 0 0 3px rgba(0,138,69,0.1); }

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
            z-index: 1100;
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
            <a href="../sarms.xml" class="module-card">
              <i class="fas fa-th"></i>
              <h3>Dashboard</h3>
              <p>Unified view with statistics and charts</p>
              <span class="view-link">
                <i class="fas fa-arrow-right" style="font-size: 10px;"></i> Go to Dashboard
              </span>
            </a>
            <a href="../group1-enrollment/students.xml" class="module-card" style="border-color: #008a45; background: #f0fdf4;">
              <i class="fas fa-user-graduate"></i>
              <h3>Student Enrollment</h3>
              <p>Student records and grades (Current Page)</p>
              <span class="view-link">
                ✓ Current Module
              </span>
            </a>
            <a href="../group3-faculty/faculty.xml" class="module-card">
              <i class="fas fa-chalkboard-teacher"></i>
              <h3>Faculty Workload</h3>
              <p>Track faculty assignments, teaching hours, and workload distribution</p>
              <span class="view-link">
                <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
              </span>
            </a>
            <a href="../group4-library/library.xml" class="module-card">
              <i class="fas fa-book"></i>
              <h3>Library Management</h3>
              <p>Manage books, borrowing records, and library resources</p>
              <span class="view-link">
                <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
              </span>
            </a>
            <a href="../group5-billing/billing.xml" class="module-card">
              <i class="fas fa-file-invoice-dollar"></i>
              <h3>Student Billing</h3>
              <p>Track tuition fees, payments, and outstanding balances</p>
              <span class="view-link">
                <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
              </span>
            </a>
            <a href="../group6-events/events.xml" class="module-card">
              <i class="fas fa-calendar-alt"></i>
              <h3>Event Management</h3>
              <p>Organize university events, registrations, and attendance</p>
              <span class="view-link">
                <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
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

        <!-- Page Header -->
        <header class="header">
          <div class="header-inner">
            <div class="header-left">
              <div style="display: flex; align-items: center; gap: 12px;">
                <img src="PLP_logo.png" alt="PLP Logo" style="height: 45px; width: auto;"/>
                <div>
                  <div class="header-title">Student Enrollment Grade Report</div>
                  <div class="header-sub">Pamantasan ng Lungsod ng Pasig</div>
                </div>
              </div>
            </div>
            <nav>
              <ul class="navbar">
                <li><a href="#dashboard" class="nav-link active" onclick="switchTab(event, 'dashboard')"><i class="fas fa-th-large"></i> Dashboard</a></li>
                <li><a href="#grades" class="nav-link" onclick="switchTab(event, 'grades')"><i class="fas fa-award"></i> Grades</a></li>
              </ul>
            </nav>
          </div>
        </header>

        <!-- Main Application Content -->
        <main>
          <!-- DASHBOARD SECTION -->
          <section id="dashboard" class="page-section active">
            
            <!-- Dashboard Page Header -->
            <div class="dashboard-header" style="max-width: 96%; margin: 30px auto 0 auto; padding: 0 20px; display: flex; align-items: center; gap: 12px;">
              <div style="background: #ecfdf5; padding: 12px; border-radius: 12px; color: #008a45;">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
              </div>
              <div>
                <h1 style="font-size: 26px; font-weight: 800; color: #1e293b; margin: 0; letter-spacing: -0.5px;">Dashboard Overview</h1>
                <p style="font-size: 14px; color: #64748b; margin: 2px 0 0 0;">High-level statistics and recent enrollment activity</p>
              </div>
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

            <!-- Dashboard Dynamic Widgets -->
            <div class="dashboard-widgets">
              <div class="widget-card">
                <div class="widget-header">
                  <div class="widget-title">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: #008a45;"><path d="M3 3v18h18"/><path d="m19 9-5 5-4-4-3 3"/></svg>
                    Population by Year Level
                  </div>
                </div>
                <div class="mock-chart">
                  <div class="chart-bar" style="height: {floor((count(students/student[yearLevel='1']) div count(students/student)) * 200)}%;" data-label="1st Year" data-val="{count(students/student[yearLevel='1'])}"></div>
                  <div class="chart-bar" style="height: {floor((count(students/student[yearLevel='2']) div count(students/student)) * 200)}%;" data-label="2nd Year" data-val="{count(students/student[yearLevel='2'])}"></div>
                  <div class="chart-bar" style="height: {floor((count(students/student[yearLevel='3']) div count(students/student)) * 200)}%;" data-label="3rd Year" data-val="{count(students/student[yearLevel='3'])}"></div>
                  <div class="chart-bar" style="height: {floor((count(students/student[yearLevel='4']) div count(students/student)) * 200)}%; background: linear-gradient(to top, #3b82f6, #60a5fa);" data-label="4th Year" data-val="{count(students/student[yearLevel='4'])}"></div>
                </div>
              </div>
              
              <div class="widget-card">
                <div class="widget-header">
                  <div class="widget-title">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: #008a45;"><path d="M12 2v20"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    Recent Enrollments
                  </div>
                </div>
                <ul class="activity-list">
                  <xsl:for-each select="students/student">
                    <xsl:sort select="@studentId" order="descending"/>
                    <xsl:if test="position() &lt;= 3">
                      <li class="activity-item">
                        <xsl:choose>
                          <xsl:when test="position() = 1">
                            <div class="activity-icon"><i class="fas fa-user-plus"></i></div>
                          </xsl:when>
                          <xsl:when test="position() = 2">
                            <div class="activity-icon" style="background: #eff6ff; color: #3b82f6;"><i class="fas fa-user-check"></i></div>
                          </xsl:when>
                          <xsl:otherwise>
                            <div class="activity-icon" style="background: #fef3c7; color: #d97706;"><i class="fas fa-id-card"></i></div>
                          </xsl:otherwise>
                        </xsl:choose>
                        <div class="activity-content">
                          <h4><xsl:value-of select="course"/> Enrollment</h4>
                          <p><xsl:value-of select="lastName"/>, <xsl:value-of select="firstName"/> was enrolled successfully.</p>
                          <span class="activity-time">Student ID: <xsl:value-of select="@studentId"/></span>
                        </div>
                      </li>
                    </xsl:if>
                  </xsl:for-each>
                </ul>
              </div>
            </div>
          </section>

          <!-- GRADES SECTION -->
          <section id="grades" class="page-section">

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

          <!-- Filter Controls (Implements XQuery logic interactively) -->
          <div class="filter-controls">
            <div class="filter-group">
              <label for="courseFilter" class="filter-label">Filter by Course</label>
              <select id="courseFilter" class="filter-select" onchange="filterStudents()">
                <option value="">All Courses</option>
                <option value="BSIT">BSIT</option>
                <option value="BSCS">BSCS</option>
              </select>
            </div>
            
            <div class="filter-group">
              <label for="yearFilter" class="filter-label">Filter by Year</label>
              <select id="yearFilter" class="filter-select" onchange="filterStudents()">
                <option value="">All Years</option>
                <option value="1">1st Year</option>
                <option value="2">2nd Year</option>
                <option value="3">3rd Year</option>
                <option value="4">4th Year</option>
              </select>
            </div>

            <div class="filter-group">
              <label for="gpaFilter" class="filter-label">Academic Status</label>
              <select id="gpaFilter" class="filter-select" onchange="filterStudents()">
                <option value="">All Students</option>
                <option value="intervention">Needs Intervention (GPA &gt; 2.0)</option>
                <option value="deans">Dean's Listers (GPA &lt;= 1.75)</option>
              </select>
            </div>
            
            <div class="filter-group">
              <label for="loadFilter" class="filter-label">Course Load</label>
              <select id="loadFilter" class="filter-select" onchange="filterStudents()">
                <option value="">All Loads</option>
                <option value="heavy">Heavy Load (&gt; 3 Subjects)</option>
              </select>
            </div>
            
            <div class="filter-group" style="flex: 0 0 auto; margin-left: auto;">
              <label class="filter-label" style="opacity: 0; user-select: none;">Toggle</label>
              <button type="button" id="globalToggleBtn" onclick="toggleAllSubjects()" style="background: linear-gradient(135deg, #008a45, #005a2e); color: white; border: none; padding: 0 16px; border-radius: 8px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; font-size: 13px; height: 38px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); transition: transform 0.1s;">
                <i class="fas fa-eye-slash"></i> <span>Hide All Subjects</span>
              </button>
            </div>
          </div>

          <!-- Apply student template for each student record -->
          <div id="gradesContainer" class="grades-content">
            <xsl:apply-templates select="students/student"/>
          </div>

        </div>
          </section>
        </main>

        <!-- Footer -->
        <div class="footer">
          <p>SARMS — Smart Academic Records Management System | Pamantasan ng Lungsod ng Pasig</p>
          <p>Group 1: Student Enrollment System | Generated via XSLT Transformation</p>
        </div>

        <script><![CDATA[
          function switchTab(e, sectionId) {
            if(e) e.preventDefault();
            
            document.querySelectorAll('.nav-link').forEach(link => {
              link.classList.remove('active');
            });
            if(e) e.currentTarget.classList.add('active');
            
            document.querySelectorAll('.page-section').forEach(section => {
              section.style.display = 'none';
              section.classList.remove('active');
            });
            
            const target = document.getElementById(sectionId);
            target.style.display = 'block';
            setTimeout(() => target.classList.add('active'), 10);
          }

          function filterStudents() {
            const courseVal = document.getElementById('courseFilter').value;
            const yearVal = document.getElementById('yearFilter').value;
            const gpaVal = document.getElementById('gpaFilter').value;
            const loadVal = document.getElementById('loadFilter').value;
            
            const students = document.querySelectorAll('.student-card');
            
            students.forEach(student => {
              const course = student.getAttribute('data-course');
              const year = student.getAttribute('data-year');
              const gpa = parseFloat(student.getAttribute('data-gpa'));
              const subjectsCount = parseInt(student.getAttribute('data-subjects'));
              
              let show = true;
              
              if (courseVal && course !== courseVal) show = false;
              if (yearVal && year !== yearVal) show = false;
              
              if (gpaVal === 'intervention' && gpa <= 2.0) show = false;
              if (gpaVal === 'deans' && gpa > 1.75) show = false;
              
              if (loadVal === 'heavy' && subjectsCount <= 3) show = false;
              
              student.style.display = show ? 'flex' : 'none';
            });
          }

          let allSubjectsHidden = false;
          function toggleAllSubjects() {
            allSubjectsHidden = !allSubjectsHidden;
            const btnSpan = document.querySelector('#globalToggleBtn span');
            const btnIcon = document.querySelector('#globalToggleBtn i');
            const container = document.getElementById('gradesContainer');
            
            if (allSubjectsHidden) {
              container.classList.add('collapsed-mode');
              btnSpan.textContent = 'View All Subjects';
              btnIcon.className = 'fas fa-eye';
            } else {
              container.classList.remove('collapsed-mode');
              btnSpan.textContent = 'Hide All Subjects';
              btnIcon.className = 'fas fa-eye-slash';
            }
          }
        ]]></script>

      </body>
    </html>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- STUDENT TEMPLATE: Renders each student as a card              -->
  <!-- ============================================================ -->
  <xsl:template match="student">
    <div class="student-card" data-course="{course}" data-year="{yearLevel}" data-gpa="{gpa}" data-subjects="{count(enrolledSubjects/subject)}">

      <!-- Left Section: Student Profile Sidebar -->
      <div class="card-sidebar">
        <div class="student-info-wrapper">
          <div class="avatar">
            <xsl:value-of select="substring(firstName, 1, 1)"/><xsl:value-of select="substring(lastName, 1, 1)"/>
          </div>
          <div class="student-info">
            <h2>
              <xsl:value-of select="lastName"/>, <xsl:value-of select="firstName"/>
            </h2>
          </div>
        </div>

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

        <!-- GPA Badge -->
        <div style="width: 100%;">
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

      <!-- Right Section: Enrolled Subjects Table -->
      <div class="card-main">
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
