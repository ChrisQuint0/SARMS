<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

<!-- Variables to load external XML documents -->
<xsl:variable name="studentsDoc" select="document('group1-enrollment/students.xml')"/>
<xsl:variable name="facultyDoc" select="document('group3-faculty/faculty.xml')"/>
<xsl:variable name="libraryDoc" select="document('group4-library/library.xml')"/>
<xsl:variable name="billingDoc" select="document('group5-billing/billing.xml')"/>
<xsl:variable name="eventsDoc" select="document('group6-events/events.xml')"/>

<xsl:template match="/">
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>SARMS - Smart Academic Records Management System</title>
    
    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&amp;display=swap" rel="stylesheet"/>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary-color: #008A45;
            --primary-light: #00C76F;
            --primary-dark: #006633;
            --secondary-color: #00A854;
            --accent-color: #FFB800;
            --background: #F8F9FA;
            --surface: #FFFFFF;
            --surface-hover: #F5F5F5;
            --text-primary: #1A1A1A;
            --text-secondary: #6B7280;
            --border: #E5E7EB;
            --shadow: rgba(0, 0, 0, 0.05);
            --shadow-lg: rgba(0, 0, 0, 0.1);
            --success: #10B981;
            --warning: #F59E0B;
            --error: #EF4444;
            --info: #3B82F6;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: var(--background);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }
        
        /* ==================== CIRCULAR MENU ==================== */
        .menu-button {
            position: fixed;
            top: 24px;
            left: 24px;
            width: 56px;
            height: 56px;
            background: var(--primary-color);
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
        
        /* Modal */
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
            color: var(--primary-color);
            margin-bottom: 8px;
        }
        
        .modal-header p {
            font-size: 16px;
            color: var(--text-secondary);
        }
        
        .module-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }
        
        .module-card {
            background: white;
            border: 2px solid var(--border);
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
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            opacity: 0;
            transition: all 0.3s ease;
        }
        
        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 138, 69, 0.15);
            border-color: var(--primary-color);
        }
        
        .module-card:hover::before {
            opacity: 0.03;
        }
        
        .module-card i {
            font-size: 36px;
            color: var(--primary-color);
            margin-bottom: 16px;
            display: block;
            transition: transform 0.3s ease;
        }
        
        .module-card:hover i {
            transform: scale(1.1);
        }
        
        .module-card h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }
        
        .module-card p {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.5;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
        }
        
        .module-card .view-link {
            font-size: 13px;
            color: var(--primary-color);
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
        
        /* ==================== CIRCULAR MENU ==================== */
        .menu-button {
            position: fixed;
            top: 24px;
            left: 24px;
            width: 56px;
            height: 56px;
            background: var(--primary-color);
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
        
        /* Modal */
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
            color: var(--primary-color);
            margin-bottom: 8px;
        }
        
        .modal-header p {
            font-size: 16px;
            color: var(--text-secondary);
        }
        
        .module-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }
        
        .module-card {
            background: white;
            border: 2px solid var(--border);
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
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            opacity: 0;
            transition: all 0.3s ease;
        }
        
        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 138, 69, 0.15);
            border-color: var(--primary-color);
        }
        
        .module-card:hover::before {
            opacity: 0.03;
        }
        
        .module-card i {
            font-size: 28px;
            color: var(--primary-color);
            margin-bottom: 12px;
            display: block;
            position: relative;
            z-index: 1;
        }
        
        .module-card h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }
        
        .module-card p {
            font-size: 13px;
            color: var(--text-secondary);
            line-height: 1.5;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
        }
        
        .module-card .view-link {
            font-size: 13px;
            color: var(--primary-color);
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
        
        /* ==================== HEADER ==================== */
        .header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 24px;
            position: sticky;
            top: 0;
            z-index: 100;
            overflow: visible;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            opacity: 1;
        }
        
        .header-content {
            position: relative;
            z-index: 1;
            max-width: 1600px;
            margin: 0 auto;
            margin-left: 90px;
            display: grid;
            grid-template-columns: auto 1fr auto;
            align-items: center;
            gap: 32px;
        }
        
        .header-logo {
            width: 64px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .header-logo img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        
        .header-text {
            flex: 1;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 2px;
            letter-spacing: -0.5px;
        }
        
        .header .tagline {
            font-size: 14px;
            opacity: 0.9;
        }
        
        /* ==================== MAIN CONTAINER ==================== */
        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 32px 24px 60px;
            position: relative;
            z-index: 2;
        }
        
        /* ==================== TABS ==================== */
        .tabs-container {
            background: transparent;
        }
        
        .tabs-header {
            display: flex;
            gap: 8px;
            flex-wrap: nowrap;
        }
        
        .tab-button {
            padding: 12px 20px;
            border: 2px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border-radius: 12px;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            backdrop-filter: blur(10px);
            white-space: nowrap;
        }
        
        .tab-button i {
            font-size: 16px;
        }
        
        .tab-button:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.4);
            transform: translateY(-2px);
        }
        
        .tab-button.active {
            background: white;
            color: var(--primary-color);
            border-color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .tab-content {
            display: none;
            animation: fadeIn 0.4s ease;
        }
        
        .tab-content.active {
            display: block;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* ==================== STATISTICS CARDS ==================== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, var(--surface) 0%, var(--surface-hover) 100%);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--primary-color);
            transition: width 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px var(--shadow-lg);
        }
        
        .stat-card:hover::before {
            width: 8px;
        }
        
        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: white;
        }
        
        .stat-icon.primary { background: var(--primary-color); }
        .stat-icon.success { background: var(--success); }
        .stat-icon.warning { background: var(--warning); }
        .stat-icon.error { background: var(--error); }
        .stat-icon.info { background: var(--info); }
        
        .stat-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-value {
            font-size: 36px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 4px;
            line-height: 1;
        }
        
        .stat-description {
            font-size: 13px;
            color: var(--text-secondary);
        }
        
        /* ==================== CHARTS ==================== */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
            gap: 28px;
            margin-bottom: 40px;
        }
        
        .chart-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 28px;
            box-shadow: 0 2px 8px var(--shadow);
        }
        
        .chart-header {
            margin-bottom: 24px;
        }
        
        .chart-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 6px;
        }
        
        .chart-subtitle {
            font-size: 14px;
            color: var(--text-secondary);
        }
        
        .chart-container {
            position: relative;
            height: 350px;
        }
        
        /* ==================== SECTION TITLE ==================== */
        .section-title {
            font-size: 26px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 28px;
            padding-bottom: 16px;
            border-bottom: 3px solid var(--primary-color);
            display: inline-block;
        }
        
        /* ==================== RESPONSIVE ==================== */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 32px;
            }
            
            .header .subtitle {
                font-size: 16px;
            }
            
            .tabs-header {
                flex-direction: column;
            }
            
            .tab-button {
                width: 100%;
            }
            
            .tab-content {
                padding: 24px;
            }
            
            .stats-grid,
            .charts-grid {
                grid-template-columns: 1fr;
            }
            
            .chart-container {
                height: 250px;
            }
            
            .module-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Scrollbar styles removed - using browser default */
    </style>
</head>
<body>
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
            <a href="sarms.xml" class="module-card" style="border-color: #008a45; background: #f0fdf4;">
                <i class="fas fa-th"></i>
                <h3>Dashboard</h3>
                <p>Unified view with statistics and charts (Current Page)</p>
                <span class="view-link">
                    ✓ Current Module
                </span>
            </a>
            <a href="group1-enrollment/students.xml" class="module-card">
                <i class="fas fa-user-graduate"></i>
                <h3>Student Enrollment</h3>
                <p>Manage student records, enrollments, and academic performance</p>
                <span class="view-link">
                    <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
                </span>
            </a>
            <a href="group3-faculty/faculty.xml" class="module-card">
                <i class="fas fa-chalkboard-teacher"></i>
                <h3>Faculty Workload</h3>
                <p>Track faculty assignments, teaching hours, and workload distribution</p>
                <span class="view-link">
                    <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
                </span>
            </a>
            <a href="group4-library/library.xml" class="module-card">
                <i class="fas fa-book"></i>
                <h3>Library Management</h3>
                <p>Manage books, borrowing records, and library resources</p>
                <span class="view-link">
                    <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
                </span>
            </a>
            <a href="group5-billing/billing.xml" class="module-card">
                <i class="fas fa-file-invoice-dollar"></i>
                <h3>Student Billing</h3>
                <p>Track tuition fees, payments, and outstanding balances</p>
                <span class="view-link">
                    <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
                </span>
            </a>
            <a href="group6-events/events.xml" class="module-card">
                <i class="fas fa-calendar-alt"></i>
                <h3>Event Management</h3>
                <p>Organize university events, registrations, and attendance</p>
                <span class="view-link">
                    <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
                </span>
            </a>
        </div>
    </div>

    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="header-logo">
                <img src="group6-events/PLP_logo.png" alt="PLP Logo"/>
            </div>
            <div class="header-text">
                <h1>SARMS Dashboard</h1>
                <div class="tagline">Pamantasan ng Lungsod ng Pasig</div>
            </div>
            <!-- Tabs in Header -->
            <div class="tabs-header">
                <button class="tab-button active" onclick="switchTab('enrollment')">
                    <i class="fas fa-user-graduate"></i>
                    <span>Enrollment</span>
                </button>
                <button class="tab-button" onclick="switchTab('faculty')">
                    <i class="fas fa-chalkboard-teacher"></i>
                    <span>Faculty</span>
                </button>
                <button class="tab-button" onclick="switchTab('library')">
                    <i class="fas fa-book"></i>
                    <span>Library</span>
                </button>
                <button class="tab-button" onclick="switchTab('billing')">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <span>Billing</span>
                </button>
                <button class="tab-button" onclick="switchTab('events')">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Events</span>
                </button>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container">
        <div class="tabs-container">

            <!-- ENROLLMENT TAB -->
            <div id="enrollment-tab" class="tab-content active">
                <h2 class="section-title">Student Enrollment Overview</h2>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon primary">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Students</div>
                        <div class="stat-value"><xsl:value-of select="count($studentsDoc//student)"/></div>
                        <div class="stat-description">Enrolled students</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                        <div class="stat-label">High Achievers</div>
                        <div class="stat-value"><xsl:value-of select="count($studentsDoc//student[gpa &lt; 2.0])"/></div>
                        <div class="stat-description">GPA below 2.0</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-book-open"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Subjects</div>
                        <div class="stat-value"><xsl:value-of select="count($studentsDoc//student/enrolledSubjects/subject)"/></div>
                        <div class="stat-description">Subject enrollments</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon warning">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                        <div class="stat-label">Average GPA</div>
                        <div class="stat-value">
                            <xsl:variable name="total" select="sum($studentsDoc//student/gpa)"/>
                            <xsl:variable name="count" select="count($studentsDoc//student/gpa)"/>
                            <xsl:value-of select="format-number($total div $count, '0.00')"/>
                        </div>
                        <div class="stat-description">Overall performance</div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Students by Program</div>
                            <div class="chart-subtitle">Distribution across programs</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="programChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Students by Year Level</div>
                            <div class="chart-subtitle">Enrollment distribution</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="yearLevelChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">GPA Distribution</div>
                            <div class="chart-subtitle">Academic performance ranges</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="gpaChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- FACULTY TAB -->
            <div id="faculty-tab" class="tab-content">
                <h2 class="section-title">Faculty Workload Overview</h2>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon primary">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Faculty</div>
                        <div class="stat-value"><xsl:value-of select="count($facultyDoc//facultyMember)"/></div>
                        <div class="stat-description">Active faculty members</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon error">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Overloaded</div>
                        <div class="stat-value"><xsl:value-of select="count($facultyDoc//facultyMember[totalHours &gt; 24])"/></div>
                        <div class="stat-description">Faculty with high workload</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Optimal Load</div>
                        <div class="stat-value"><xsl:value-of select="count($facultyDoc//facultyMember[totalHours &lt;= 24])"/></div>
                        <div class="stat-description">Within recommended hours</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                        <div class="stat-label">Avg. Hours</div>
                        <div class="stat-value">
                            <xsl:variable name="total" select="sum($facultyDoc//facultyMember/totalHours)"/>
                            <xsl:variable name="count" select="count($facultyDoc//facultyMember)"/>
                            <xsl:value-of select="format-number($total div $count, '0.0')"/>
                        </div>
                        <div class="stat-description">Per faculty member</div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Faculty by Department</div>
                            <div class="chart-subtitle">Distribution across departments</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="departmentChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Workload Distribution</div>
                            <div class="chart-subtitle">Teaching hours per faculty</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="workloadChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- LIBRARY TAB -->
            <div id="library-tab" class="tab-content">
                <h2 class="section-title">Library Management Overview</h2>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon primary">
                                <i class="fas fa-book"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Books</div>
                        <div class="stat-value"><xsl:value-of select="count($libraryDoc//books/book)"/></div>
                        <div class="stat-description">Books in collection</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-layer-group"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Copies</div>
                        <div class="stat-value"><xsl:value-of select="sum($libraryDoc//books/book/copies)"/></div>
                        <div class="stat-description">Physical copies available</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-hand-holding"></i>
                            </div>
                        </div>
                        <div class="stat-label">Active Loans</div>
                        <div class="stat-value"><xsl:value-of select="count($libraryDoc//borrowingRecords/record[status='Active'])"/></div>
                        <div class="stat-description">Currently borrowed</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon error">
                                <i class="fas fa-exclamation-circle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Overdue</div>
                        <div class="stat-value"><xsl:value-of select="count($libraryDoc//borrowingRecords/record[status='Overdue'])"/></div>
                        <div class="stat-description">Books past due date</div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Books by Category</div>
                            <div class="chart-subtitle">Collection distribution</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Borrowing Status</div>
                            <div class="chart-subtitle">Current loan status</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="borrowingStatusChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- BILLING TAB -->
            <div id="billing-tab" class="tab-content">
                <h2 class="section-title">Student Billing Overview</h2>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon primary">
                                <i class="fas fa-file-invoice"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Students</div>
                        <div class="stat-value"><xsl:value-of select="count($billingDoc//record)"/></div>
                        <div class="stat-description">Billing records</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value">₱<xsl:value-of select="format-number(sum($billingDoc//record/tuitionFee), '#,##0')"/></div>
                        <div class="stat-description">Expected tuition</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-check-double"></i>
                            </div>
                        </div>
                        <div class="stat-label">Collected</div>
                        <div class="stat-value">₱<xsl:value-of select="format-number(sum($billingDoc//record/paymentsMade), '#,##0')"/></div>
                        <div class="stat-description">Total payments received</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon warning">
                                <i class="fas fa-exclamation"></i>
                            </div>
                        </div>
                        <div class="stat-label">Outstanding</div>
                        <div class="stat-value">₱<xsl:value-of select="format-number(sum($billingDoc//record/balance), '#,##0')"/></div>
                        <div class="stat-description">Unpaid balances</div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Payment Status</div>
                            <div class="chart-subtitle">Collection overview</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="paymentStatusChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Top 10 Balances</div>
                            <div class="chart-subtitle">Highest outstanding amounts</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="balanceChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- EVENTS TAB -->
            <div id="events-tab" class="tab-content">
                <h2 class="section-title">Event Management Overview</h2>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon primary">
                                <i class="fas fa-calendar"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Events</div>
                        <div class="stat-value"><xsl:value-of select="count($eventsDoc//event)"/></div>
                        <div class="stat-description">All events</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                        <div class="stat-label">Upcoming</div>
                        <div class="stat-value"><xsl:value-of select="count($eventsDoc//event[@eventStatus='upcoming'])"/></div>
                        <div class="stat-description">Future events</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-play-circle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Current</div>
                        <div class="stat-value"><xsl:value-of select="count($eventsDoc//event[@eventStatus='current'])"/></div>
                        <div class="stat-description">Ongoing events</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon warning">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Participants</div>
                        <div class="stat-value"><xsl:value-of select="count($eventsDoc//participant)"/></div>
                        <div class="stat-description">Registered attendees</div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Events by Category</div>
                            <div class="chart-subtitle">Event type distribution</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="eventCategoryChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Event Registration</div>
                            <div class="chart-subtitle">Top 10 events by attendance</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="registrationChart"></canvas>
                        </div>
                    </div>

                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Event Status</div>
                            <div class="chart-subtitle">Distribution by status</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="eventStatusChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        // ==================== DATA EMBEDDED BY XSLT ====================
        const chartData = {
            // ENROLLMENT DATA
            programs: {
                <xsl:for-each select="$studentsDoc//student/course[not(. = preceding::student/course)]">
                    '<xsl:value-of select="."/>': <xsl:value-of select="count($studentsDoc//student[course = current()])"/><xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            },
            yearLevels: {
                <xsl:for-each select="$studentsDoc//student/yearLevel[not(. = preceding::student/yearLevel)]">
                    'Year <xsl:value-of select="."/>': <xsl:value-of select="count($studentsDoc//student[yearLevel = current()])"/><xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            },
            gpaRanges: {
                '1.00-1.50 (Excellent)': <xsl:value-of select="count($studentsDoc//student[gpa &gt;= 1.0 and gpa &lt;= 1.50])"/>,
                '1.51-2.00 (Very Good)': <xsl:value-of select="count($studentsDoc//student[gpa &gt; 1.50 and gpa &lt;= 2.00])"/>,
                '2.01-2.50 (Good)': <xsl:value-of select="count($studentsDoc//student[gpa &gt; 2.00 and gpa &lt;= 2.50])"/>,
                '2.51-3.00 (Fair)': <xsl:value-of select="count($studentsDoc//student[gpa &gt; 2.50 and gpa &lt;= 3.00])"/>,
                '3.01-5.00 (Passing)': <xsl:value-of select="count($studentsDoc//student[gpa &gt; 3.00])"/>
            },
            
            // FACULTY DATA
            departments: {
                <xsl:for-each select="$facultyDoc//facultyMember/department[not(. = preceding::facultyMember/department)]">
                    '<xsl:value-of select="."/>': <xsl:value-of select="count($facultyDoc//facultyMember[department = current()])"/><xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            },
            facultyWorkload: [
                <xsl:for-each select="$facultyDoc//facultyMember">
                    {
                        name: '<xsl:value-of select="substring-after(name, ' ')"/>',
                        hours: <xsl:value-of select="totalHours"/>
                    }<xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            ],
            
            // LIBRARY DATA
            bookCategories: {
                <xsl:for-each select="$libraryDoc//books/book/category[not(. = preceding::book/category)]">
                    '<xsl:value-of select="."/>': <xsl:value-of select="count($libraryDoc//books/book[category = current()])"/><xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            },
            borrowingStatus: {
                'Borrowed': <xsl:value-of select="count($libraryDoc//borrowingRecords/record[status='Active'])"/>,
                'Returned': <xsl:value-of select="count($libraryDoc//borrowingRecords/record[status='Returned'])"/>,
                'Overdue': <xsl:value-of select="count($libraryDoc//borrowingRecords/record[status='Overdue'])"/>
            },
            
            // BILLING DATA
            paymentStatus: {
                'Paid': <xsl:value-of select="sum($billingDoc//record/paymentsMade)"/>,
                'Outstanding': <xsl:value-of select="sum($billingDoc//record/balance)"/>
            },
            topBalances: [
                <xsl:for-each select="$billingDoc//record">
                    <xsl:sort select="balance" data-type="number" order="descending"/>
                    <xsl:if test="position() &lt;= 10">
                    {
                        name: '<xsl:value-of select="substring(name, 1, 15)"/>',
                        balance: <xsl:value-of select="balance"/>
                    }<xsl:if test="position() != 10 and position() != last()">,</xsl:if>
                    </xsl:if>
                </xsl:for-each>
            ],
            
            // EVENTS DATA
            eventCategories: {
                <xsl:for-each select="$eventsDoc//event/category[not(. = preceding::event/category)]">
                    '<xsl:value-of select="."/>': <xsl:value-of select="count($eventsDoc//event[category = current()])"/><xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            },
            eventRegistrations: [
                <xsl:for-each select="$eventsDoc//event">
                    <xsl:sort select="registrationCount" data-type="number" order="descending"/>
                    <xsl:if test="position() &lt;= 10">
                    <xsl:variable name="eventId" select="@eventId"/>
                    <xsl:variable name="regCount" select="count($eventsDoc//registration[@eventId=$eventId])"/>
                    {
                        name: '<xsl:value-of select="substring(eventName, 1, 20)"/>',
                        eventId: '<xsl:value-of select="$eventId"/>',
                        count: <xsl:value-of select="$regCount"/>,
                        capacity: <xsl:choose>
                            <xsl:when test="capacity"><xsl:value-of select="capacity"/></xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    }<xsl:if test="position() != 10 and position() != last()">,</xsl:if>
                    </xsl:if>
                </xsl:for-each>
            ],
            eventStatus: {
                'Upcoming': <xsl:value-of select="count($eventsDoc//event[@eventStatus='upcoming'])"/>,
                'Ongoing': <xsl:value-of select="count($eventsDoc//event[@eventStatus='current'])"/>,
                'Completed': <xsl:value-of select="count($eventsDoc//event[@eventStatus='closed'])"/>
            }
        };

        // ==================== MODAL FUNCTIONS ====================
        function toggleModal() {
            const modal = document.getElementById('moduleModal');
            const overlay = document.getElementById('modalOverlay');
            const button = document.querySelector('.menu-button');
            
            modal.classList.toggle('active');
            overlay.classList.toggle('active');
            button.classList.toggle('active');
        }

        // ==================== TAB FUNCTIONS ====================
        function switchTab(tabName) {
            const tabs = document.querySelectorAll('.tab-content');
            const buttons = document.querySelectorAll('.tab-button');
            
            tabs.forEach(tab => tab.classList.remove('active'));
            buttons.forEach(btn => btn.classList.remove('active'));
            
            document.getElementById(tabName + '-tab').classList.add('active');
            event.target.closest('.tab-button').classList.add('active');
            
            initializeCharts(tabName);
        }

        // ==================== CHART INITIALIZATION ====================
        function initializeCharts(tabName) {
            switch(tabName) {
                case 'enrollment':
                    createProgramChart();
                    createYearLevelChart();
                    createGPAChart();
                    break;
                case 'faculty':
                    createDepartmentChart();
                    createWorkloadChart();
                    break;
                case 'library':
                    createCategoryChart();
                    createBorrowingStatusChart();
                    break;
                case 'billing':
                    createPaymentStatusChart();
                    createBalanceChart();
                    break;
                case 'events':
                    createEventCategoryChart();
                    createRegistrationChart();
                    createEventStatusChart();
                    break;
            }
        }

        // ==================== ENROLLMENT CHARTS ====================
        function createProgramChart() {
            const ctx = document.getElementById('programChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(chartData.programs),
                    datasets: [{
                        data: Object.values(chartData.programs),
                        backgroundColor: ['#008A45', '#00C76F', '#FFB800', '#3B82F6', '#F59E0B', '#EF4444', '#10B981']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        function createYearLevelChart() {
            const ctx = document.getElementById('yearLevelChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(chartData.yearLevels),
                    datasets: [{
                        label: 'Students',
                        data: Object.values(chartData.yearLevels),
                        backgroundColor: '#008A45'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        function createGPAChart() {
            const ctx = document.getElementById('gpaChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(chartData.gpaRanges),
                    datasets: [{
                        label: 'Students',
                        data: Object.values(chartData.gpaRanges),
                        backgroundColor: ['#10B981', '#00C76F', '#FFB800', '#F59E0B', '#EF4444']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        // ==================== FACULTY CHARTS ====================
        function createDepartmentChart() {
            const ctx = document.getElementById('departmentChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(chartData.departments),
                    datasets: [{
                        data: Object.values(chartData.departments),
                        backgroundColor: ['#008A45', '#00C76F', '#FFB800', '#3B82F6', '#F59E0B', '#EF4444', '#10B981']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        function createWorkloadChart() {
            const ctx = document.getElementById('workloadChart');
            if (!ctx || ctx.chart) return;
            
            const names = chartData.facultyWorkload.map(f => f.name);
            const hours = chartData.facultyWorkload.map(f => f.hours);
            
            ctx.chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: names,
                    datasets: [{
                        label: 'Teaching Hours',
                        data: hours,
                        backgroundColor: hours.map(h => h > 24 ? '#F59E0B' : '#008A45')
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        // ==================== LIBRARY CHARTS ====================
        function createCategoryChart() {
            const ctx = document.getElementById('categoryChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(chartData.bookCategories),
                    datasets: [{
                        data: Object.values(chartData.bookCategories),
                        backgroundColor: ['#008A45', '#00C76F', '#FFB800', '#3B82F6', '#F59E0B', '#EF4444', '#10B981']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        function createBorrowingStatusChart() {
            const ctx = document.getElementById('borrowingStatusChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: Object.keys(chartData.borrowingStatus),
                    datasets: [{
                        data: Object.values(chartData.borrowingStatus),
                        backgroundColor: ['#FFB800', '#10B981', '#EF4444']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        // ==================== BILLING CHARTS ====================
        function createPaymentStatusChart() {
            const ctx = document.getElementById('paymentStatusChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(chartData.paymentStatus),
                    datasets: [{
                        data: Object.values(chartData.paymentStatus),
                        backgroundColor: ['#10B981', '#F59E0B']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        function createBalanceChart() {
            const ctx = document.getElementById('balanceChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartData.topBalances.map(b => b.name),
                    datasets: [{
                        label: 'Balance (₱)',
                        data: chartData.topBalances.map(b => b.balance),
                        backgroundColor: '#EF4444'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        // ==================== EVENTS CHARTS ====================
        function createEventCategoryChart() {
            const ctx = document.getElementById('eventCategoryChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(chartData.eventCategories),
                    datasets: [{
                        label: 'Events',
                        data: Object.values(chartData.eventCategories),
                        backgroundColor: '#008A45'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    indexAxis: 'y',
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        function createRegistrationChart() {
            const ctx = document.getElementById('registrationChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartData.eventRegistrations.map(e => e.name),
                    datasets: [{
                        label: 'Registered',
                        data: chartData.eventRegistrations.map(e => e.count),
                        backgroundColor: '#008A45'
                    }, {
                        label: 'Capacity',
                        data: chartData.eventRegistrations.map(e => e.capacity),
                        backgroundColor: '#E5E7EB'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        function createEventStatusChart() {
            const ctx = document.getElementById('eventStatusChart');
            if (!ctx || ctx.chart) return;
            
            ctx.chart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(chartData.eventStatus),
                    datasets: [{
                        data: Object.values(chartData.eventStatus),
                        backgroundColor: ['#3B82F6', '#FFB800', '#10B981']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        // Initialize enrollment charts on page load
        window.addEventListener('DOMContentLoaded', function() {
            initializeCharts('enrollment');
        });
    </script>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
