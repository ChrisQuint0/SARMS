<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude">
    
<xsl:output method="html" encoding="UTF-8" indent="yes" 
    doctype-system="about:legacy-compat"/>

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
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0, 138, 69, 0.3);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            border-radius: 16px;
            padding: 28px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        
        .module-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0);
            transition: all 0.3s ease;
        }
        
        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 138, 69, 0.3);
        }
        
        .module-card:hover::before {
            background: rgba(255, 255, 255, 0.1);
        }
        
        .module-card i {
            font-size: 36px;
            color: white;
            margin-bottom: 16px;
            display: block;
        }
        
        .module-card h3 {
            font-size: 20px;
            font-weight: 700;
            color: white;
            margin-bottom: 8px;
        }
        
        .module-card p {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.5;
        }
        
        /* ==================== HEADER ==================== */
        .header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 48px 24px 64px;
            text-align: center;
            position: relative;
            overflow: hidden;
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
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header h1 {
            font-size: 48px;
            font-weight: 900;
            margin-bottom: 12px;
            letter-spacing: -1px;
        }
        
        .header .subtitle {
            font-size: 20px;
            font-weight: 400;
            opacity: 0.95;
            margin-bottom: 8px;
        }
        
        .header .tagline {
            font-size: 16px;
            opacity: 0.85;
        }
        
        /* ==================== MAIN CONTAINER ==================== */
        .container {
            max-width: 1400px;
            margin: -40px auto 60px;
            padding: 0 24px;
            position: relative;
            z-index: 2;
        }
        
        /* ==================== TABS ==================== */
        .tabs-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 20px var(--shadow-lg);
            overflow: hidden;
        }
        
        .tabs-header {
            display: flex;
            background: var(--surface-hover);
            padding: 8px;
            gap: 8px;
            overflow-x: auto;
            border-bottom: 1px solid var(--border);
        }
        
        .tab-button {
            flex: 1;
            min-width: 140px;
            padding: 16px 24px;
            border: none;
            background: transparent;
            color: var(--text-secondary);
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            border-radius: 12px;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .tab-button i {
            font-size: 18px;
        }
        
        .tab-button:hover {
            background: rgba(0, 138, 69, 0.08);
            color: var(--primary-color);
        }
        
        .tab-button.active {
            background: var(--primary-color);
            color: white;
            box-shadow: 0 2px 8px rgba(0, 138, 69, 0.3);
        }
        
        .tab-content {
            display: none;
            padding: 40px;
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
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
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
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 24px;
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
            height: 300px;
        }
        
        /* ==================== DATA TABLES ==================== */
        .table-container {
            background: white;
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 24px;
        }
        
        .table-header {
            padding: 24px;
            background: var(--surface-hover);
            border-bottom: 1px solid var(--border);
        }
        
        .table-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-primary);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: var(--surface-hover);
        }
        
        th {
            padding: 16px 24px;
            text-align: left;
            font-size: 13px;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid var(--border);
        }
        
        td {
            padding: 16px 24px;
            font-size: 14px;
            color: var(--text-primary);
            border-bottom: 1px solid var(--border);
        }
        
        tr:hover {
            background: var(--surface-hover);
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        /* ==================== BADGES ==================== */
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }
        
        .badge-warning {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }
        
        .badge-error {
            background: rgba(239, 68, 68, 0.1);
            color: var(--error);
        }
        
        .badge-info {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }
        
        .badge-primary {
            background: rgba(0, 138, 69, 0.1);
            color: var(--primary-color);
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
            
            table {
                font-size: 12px;
            }
            
            th, td {
                padding: 12px 16px;
            }
        }
        
        /* ==================== UTILITIES ==================== */
        .text-center {
            text-align: center;
        }
        
        .mb-4 {
            margin-bottom: 24px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 20px;
        }
        
        /* ==================== SCROLLBAR ==================== */
        ::-webkit-scrollbar {
            width: 10px;
            height: 10px;
        }
        
        ::-webkit-scrollbar-track {
            background: var(--surface-hover);
        }
        
        ::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 5px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: var(--primary-dark);
        }
    </style>
</head>
<body>
    <!-- Circular Menu Button -->
    <div class="menu-button" onclick="toggleModal()">
        <i class="fas fa-th"></i>
    </div>
    
    <!-- Modal Overlay -->
    <div class="modal-overlay" id="modalOverlay" onclick="toggleModal()"></div>
    
    <!-- Module Navigation Modal -->
    <div class="module-modal" id="moduleModal">
        <div class="modal-header">
            <h2>Module Navigation</h2>
            <p>Select a module to view detailed information</p>
        </div>
        <div class="module-grid">
            <div class="module-card" onclick="alert('Navigate to Student Enrollment Module')">
                <i class="fas fa-user-graduate"></i>
                <h3>Student Enrollment</h3>
                <p>Manage student records, enrollments, and academic performance</p>
            </div>
            <div class="module-card" onclick="alert('Navigate to Faculty Module')">
                <i class="fas fa-chalkboard-teacher"></i>
                <h3>Faculty Workload</h3>
                <p>Track faculty assignments, teaching hours, and workload distribution</p>
            </div>
            <div class="module-card" onclick="alert('Navigate to Library Module')">
                <i class="fas fa-book"></i>
                <h3>Library Management</h3>
                <p>Manage books, borrowing records, and library resources</p>
            </div>
            <div class="module-card" onclick="alert('Navigate to Billing Module')">
                <i class="fas fa-file-invoice-dollar"></i>
                <h3>Student Billing</h3>
                <p>Track tuition fees, payments, and outstanding balances</p>
            </div>
            <div class="module-card" onclick="alert('Navigate to Events Module')">
                <i class="fas fa-calendar-alt"></i>
                <h3>Event Management</h3>
                <p>Organize university events, registrations, and attendance</p>
            </div>
        </div>
    </div>
    
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <h1>SARMS Dashboard</h1>
            <div class="subtitle">Smart Academic Records Management System</div>
            <div class="tagline">Pamantasan ng Lungsod ng Pasig</div>
        </div>
    </header>
    
    <!-- Main Container -->
    <main class="container">
        <div class="tabs-container">
            <!-- Tabs Header -->
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
                        <div class="stat-value" id="total-students">
                            <xsl:value-of select="count(//students/student)"/>
                        </div>
                        <div class="stat-description">Enrolled students</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-award"></i>
                            </div>
                        </div>
                        <div class="stat-label">High Achievers</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//students/student[gpa &lt; 2.0])"/>
                        </div>
                        <div class="stat-description">GPA below 2.0</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-book-open"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Subjects</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//students/student/enrolledSubjects/subject)"/>
                        </div>
                        <div class="stat-description">Subject enrollments</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon warning">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                        <div class="stat-label">Average GPA</div>
                        <div class="stat-value" id="avg-gpa">
                            <xsl:value-of select="format-number(sum(//students/student/gpa) div count(//students/student), '0.00')"/>
                        </div>
                        <div class="stat-description">Overall performance</div>
                    </div>
                </div>
                
                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Students by Course</div>
                            <div class="chart-subtitle">Distribution across programs</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="courseChart"></canvas>
                        </div>
                    </div>
                    
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Students by Year Level</div>
                            <div class="chart-subtitle">Academic level distribution</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="yearLevelChart"></canvas>
                        </div>
                    </div>
                    
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">GPA Distribution</div>
                            <div class="chart-subtitle">Student performance ranges</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="gpaChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Top Performers Table -->
                <div class="table-container">
                    <div class="table-header">
                        <div class="table-title">Top Performing Students (GPA &lt; 2.0)</div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Student ID</th>
                                <th>Name</th>
                                <th>Course</th>
                                <th>Year Level</th>
                                <th>GPA</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//students/student[gpa &lt; 2.0]">
                                <xsl:sort select="gpa" data-type="number"/>
                                <tr>
                                    <td><xsl:value-of select="@studentId"/></td>
                                    <td><xsl:value-of select="concat(firstName, ' ', lastName)"/></td>
                                    <td><xsl:value-of select="course"/></td>
                                    <td><xsl:value-of select="yearLevel"/></td>
                                    <td><strong><xsl:value-of select="gpa"/></strong></td>
                                    <td>
                                        <span class="badge badge-success">Excellent</span>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
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
                        <div class="stat-value">
                            <xsl:value-of select="count(//faculty/facultyMember)"/>
                        </div>
                        <div class="stat-description">Active faculty members</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon warning">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Overloaded</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//faculty/facultyMember[totalHours &gt; 24])"/>
                        </div>
                        <div class="stat-description">Faculty with high workload</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Optimal Load</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//faculty/facultyMember[totalHours &lt;= 24])"/>
                        </div>
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
                            <xsl:value-of select="format-number(sum(//faculty/facultyMember/totalHours) div count(//faculty/facultyMember), '0.0')"/>
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
                
                <!-- Faculty Table -->
                <div class="table-container">
                    <div class="table-header">
                        <div class="table-title">Faculty Workload Details</div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Faculty ID</th>
                                <th>Name</th>
                                <th>Department</th>
                                <th>Subjects</th>
                                <th>Total Hours</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//faculty/facultyMember">
                                <tr>
                                    <td><xsl:value-of select="id"/></td>
                                    <td><xsl:value-of select="name"/></td>
                                    <td><xsl:value-of select="department"/></td>
                                    <td><xsl:value-of select="count(subjects/subject)"/> subjects</td>
                                    <td><strong><xsl:value-of select="totalHours"/> hrs</strong></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="totalHours &gt; 24">
                                                <span class="badge badge-warning">Overloaded</span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="badge badge-success">Optimal</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
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
                        <div class="stat-value">
                            <xsl:value-of select="count(//library/books/book)"/>
                        </div>
                        <div class="stat-description">Books in collection</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-bookmark"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Copies</div>
                        <div class="stat-value">
                            <xsl:value-of select="sum(//library/books/book/copies)"/>
                        </div>
                        <div class="stat-description">Physical copies available</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-hand-holding-heart"></i>
                            </div>
                        </div>
                        <div class="stat-label">Active Loans</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//library/borrowingRecords/record[status='Active'])"/>
                        </div>
                        <div class="stat-description">Currently borrowed</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon error">
                                <i class="fas fa-exclamation-circle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Overdue</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//library/borrowingRecords/record[status='Overdue'])"/>
                        </div>
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
                            <div class="chart-subtitle">Current circulation status</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="borrowingStatusChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Overdue Books Table -->
                <div class="table-container">
                    <div class="table-header">
                        <div class="table-title">Overdue Books</div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Record ID</th>
                                <th>Book ID</th>
                                <th>Borrower</th>
                                <th>Borrow Date</th>
                                <th>Due Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//library/borrowingRecords/record[status='Overdue']">
                                <tr>
                                    <td><xsl:value-of select="@recordId"/></td>
                                    <td><xsl:value-of select="bookId"/></td>
                                    <td><xsl:value-of select="borrower/borrowerName"/></td>
                                    <td><xsl:value-of select="borrowDate"/></td>
                                    <td><xsl:value-of select="dueDate"/></td>
                                    <td>
                                        <span class="badge badge-error">Overdue</span>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
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
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Students</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//billing/record)"/>
                        </div>
                        <div class="stat-description">Billing records</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-money-bill-wave"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value">
                            ₱<xsl:value-of select="format-number(sum(//billing/record/tuitionFee), '#,###')"/>
                        </div>
                        <div class="stat-description">Expected tuition</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Collected</div>
                        <div class="stat-value">
                            ₱<xsl:value-of select="format-number(sum(//billing/record/paymentsMade), '#,###')"/>
                        </div>
                        <div class="stat-description">Total payments received</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon warning">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Outstanding</div>
                        <div class="stat-value">
                            ₱<xsl:value-of select="format-number(sum(//billing/record/balance), '#,###')"/>
                        </div>
                        <div class="stat-description">Unpaid balances</div>
                    </div>
                </div>
                
                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Payment Status</div>
                            <div class="chart-subtitle">Revenue collection overview</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="paymentStatusChart"></canvas>
                        </div>
                    </div>
                    
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Balance Distribution</div>
                            <div class="chart-subtitle">Students by outstanding amount</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="balanceDistChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Unpaid Balances Table -->
                <div class="table-container">
                    <div class="table-header">
                        <div class="table-title">Students with Outstanding Balances</div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Student ID</th>
                                <th>Name</th>
                                <th>Tuition Fee</th>
                                <th>Payments Made</th>
                                <th>Balance</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//billing/record[balance &gt; 0]">
                                <xsl:sort select="balance" data-type="number" order="descending"/>
                                <tr>
                                    <td><xsl:value-of select="studentId"/></td>
                                    <td><xsl:value-of select="name"/></td>
                                    <td>₱<xsl:value-of select="format-number(tuitionFee, '#,###.00')"/></td>
                                    <td>₱<xsl:value-of select="format-number(paymentsMade, '#,###.00')"/></td>
                                    <td><strong>₱<xsl:value-of select="format-number(balance, '#,###.00')"/></strong></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="balance &gt; 20000">
                                                <span class="badge badge-error">High</span>
                                            </xsl:when>
                                            <xsl:when test="balance &gt; 10000">
                                                <span class="badge badge-warning">Medium</span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="badge badge-info">Low</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
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
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Events</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//events/event)"/>
                        </div>
                        <div class="stat-description">All events</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon info">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                        <div class="stat-label">Upcoming</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//events/event[@eventStatus='upcoming'])"/>
                        </div>
                        <div class="stat-description">Future events</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon success">
                                <i class="fas fa-play-circle"></i>
                            </div>
                        </div>
                        <div class="stat-label">Current</div>
                        <div class="stat-value">
                            <xsl:value-of select="count(//events/event[@eventStatus='current'])"/>
                        </div>
                        <div class="stat-description">Ongoing events</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon warning">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-label">Total Participants</div>
                        <div class="stat-value">
                            <xsl:value-of select="sum(//events/event/registrationCount)"/>
                        </div>
                        <div class="stat-description">Registered attendees</div>
                    </div>
                </div>
                
                <!-- Charts -->
                <div class="charts-grid">
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-title">Events by Status</div>
                            <div class="chart-subtitle">Timeline distribution</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="eventStatusChart"></canvas>
                        </div>
                    </div>
                    
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
                            <div class="chart-title">Registration Trends</div>
                            <div class="chart-subtitle">Participants per event</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="registrationChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Upcoming Events Table -->
                <div class="table-container">
                    <div class="table-header">
                        <div class="table-title">Upcoming Events</div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Event ID</th>
                                <th>Event Name</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Venue</th>
                                <th>Participants</th>
                                <th>Capacity</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="//events/event[@eventStatus='upcoming']">
                                <tr>
                                    <td><xsl:value-of select="@eventId"/></td>
                                    <td><xsl:value-of select="eventName"/></td>
                                    <td><xsl:value-of select="eventDate"/></td>
                                    <td><xsl:value-of select="eventTime"/></td>
                                    <td><xsl:value-of select="venue"/></td>
                                    <td><xsl:value-of select="registrationCount"/></td>
                                    <td><xsl:value-of select="capacity"/></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="registrationCount &gt;= capacity">
                                                <span class="badge badge-error">Full</span>
                                            </xsl:when>
                                            <xsl:when test="registrationCount &gt;= capacity * 0.8">
                                                <span class="badge badge-warning">Almost Full</span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="badge badge-success">Available</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
    
    <script>
        // ==================== MODAL FUNCTIONS ====================
        function toggleModal() {
            const modal = document.getElementById('moduleModal');
            const overlay = document.getElementById('modalOverlay');
            const button = document.querySelector('.menu-button');
            
            modal.classList.toggle('active');
            overlay.classList.toggle('active');
            button.classList.toggle('active');
        }
        
        // ==================== TAB SWITCHING ====================
        function switchTab(tabName) {
            // Hide all tabs
            const tabs = document.querySelectorAll('.tab-content');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Remove active class from all buttons
            const buttons = document.querySelectorAll('.tab-button');
            buttons.forEach(btn => btn.classList.remove('active'));
            
            // Show selected tab
            document.getElementById(tabName + '-tab').classList.add('active');
            
            // Add active class to clicked button
            event.target.closest('.tab-button').classList.add('active');
            
            // Initialize charts for the selected tab
            initializeCharts(tabName);
        }
        
        // ==================== CHART INITIALIZATION ====================
        let chartsInitialized = {
            enrollment: false,
            faculty: false,
            library: false,
            billing: false,
            events: false
        };
        
        function initializeCharts(tabName) {
            if (chartsInitialized[tabName]) return;
            
            if (tabName === 'enrollment') {
                createCourseChart();
                createYearLevelChart();
                createGPAChart();
                chartsInitialized.enrollment = true;
            } else if (tabName === 'faculty') {
                createDepartmentChart();
                createWorkloadChart();
                chartsInitialized.faculty = true;
            } else if (tabName === 'library') {
                createCategoryChart();
                createBorrowingStatusChart();
                chartsInitialized.library = true;
            } else if (tabName === 'billing') {
                createPaymentStatusChart();
                createBalanceDistChart();
                chartsInitialized.billing = true;
            } else if (tabName === 'events') {
                createEventStatusChart();
                createEventCategoryChart();
                createRegistrationChart();
                chartsInitialized.events = true;
            }
        }
        
        // ==================== ENROLLMENT CHARTS ====================
        function createCourseChart() {
            const ctx = document.getElementById('courseChart');
            if (!ctx) return;
            
            // Extract course data from XML
            const students = Array.from(document.querySelectorAll('students > student'));
            const courses = {};
            students.forEach(student => {
                const course = student.querySelector('course').textContent;
                courses[course] = (courses[course] || 0) + 1;
            });
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(courses),
                    datasets: [{
                        data: Object.values(courses),
                        backgroundColor: [
                            '#008A45',
                            '#00C76F',
                            '#FFB800',
                            '#3B82F6',
                            '#F59E0B'
                        ]
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
            if (!ctx) return;
            
            const students = Array.from(document.querySelectorAll('students > student'));
            const yearLevels = {1: 0, 2: 0, 3: 0, 4: 0};
            students.forEach(student => {
                const year = parseInt(student.querySelector('yearLevel').textContent);
                yearLevels[year]++;
            });
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['1st Year', '2nd Year', '3rd Year', '4th Year'],
                    datasets: [{
                        label: 'Students',
                        data: Object.values(yearLevels),
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
                    }
                }
            });
        }
        
        function createGPAChart() {
            const ctx = document.getElementById('gpaChart');
            if (!ctx) return;
            
            const students = Array.from(document.querySelectorAll('students > student'));
            const ranges = {
                'Excellent (1.0-1.5)': 0,
                'Very Good (1.6-2.0)': 0,
                'Good (2.1-2.5)': 0,
                'Fair (2.6-3.0)': 0,
                'Passing (3.1-5.0)': 0
            };
            
            students.forEach(student => {
                const gpa = parseFloat(student.querySelector('gpa').textContent);
                if (gpa <= 1.5) ranges['Excellent (1.0-1.5)']++;
                else if (gpa <= 2.0) ranges['Very Good (1.6-2.0)']++;
                else if (gpa <= 2.5) ranges['Good (2.1-2.5)']++;
                else if (gpa <= 3.0) ranges['Fair (2.6-3.0)']++;
                else ranges['Passing (3.1-5.0)']++;
            });
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(ranges),
                    datasets: [{
                        label: 'Students',
                        data: Object.values(ranges),
                        backgroundColor: [
                            '#10B981',
                            '#00C76F',
                            '#FFB800',
                            '#F59E0B',
                            '#EF4444'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        }
        
        // ==================== FACULTY CHARTS ====================
        function createDepartmentChart() {
            const ctx = document.getElementById('departmentChart');
            if (!ctx) return;
            
            const faculty = Array.from(document.querySelectorAll('faculty > facultyMember'));
            const departments = {};
            faculty.forEach(member => {
                const dept = member.querySelector('department').textContent;
                departments[dept] = (departments[dept] || 0) + 1;
            });
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(departments),
                    datasets: [{
                        data: Object.values(departments),
                        backgroundColor: [
                            '#008A45',
                            '#00C76F',
                            '#FFB800',
                            '#3B82F6',
                            '#F59E0B'
                        ]
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
            if (!ctx) return;
            
            const faculty = Array.from(document.querySelectorAll('faculty > facultyMember'));
            const names = faculty.map(m => m.querySelector('name').textContent.split(' ').slice(-1)[0]);
            const hours = faculty.map(m => parseInt(m.querySelector('totalHours').textContent));
            
            new Chart(ctx, {
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
                    }
                }
            });
        }
        
        // ==================== LIBRARY CHARTS ====================
        function createCategoryChart() {
            const ctx = document.getElementById('categoryChart');
            if (!ctx) return;
            
            const books = Array.from(document.querySelectorAll('library > books > book'));
            const categories = {};
            books.forEach(book => {
                const cat = book.querySelector('category').textContent;
                categories[cat] = (categories[cat] || 0) + 1;
            });
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(categories),
                    datasets: [{
                        data: Object.values(categories),
                        backgroundColor: [
                            '#008A45',
                            '#00C76F',
                            '#FFB800',
                            '#3B82F6',
                            '#F59E0B',
                            '#EF4444'
                        ]
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
            if (!ctx) return;
            
            const records = Array.from(document.querySelectorAll('borrowingRecords > record'));
            const statuses = {};
            records.forEach(record => {
                const status = record.querySelector('status').textContent;
                statuses[status] = (statuses[status] || 0) + 1;
            });
            
            new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: Object.keys(statuses),
                    datasets: [{
                        data: Object.values(statuses),
                        backgroundColor: [
                            '#10B981',
                            '#FFB800',
                            '#EF4444'
                        ]
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
            if (!ctx) return;
            
            const records = Array.from(document.querySelectorAll('billing > record'));
            let totalFees = 0;
            let totalPayments = 0;
            let totalBalance = 0;
            
            records.forEach(record => {
                totalFees += parseFloat(record.querySelector('tuitionFee').textContent);
                totalPayments += parseFloat(record.querySelector('paymentsMade').textContent);
                totalBalance += parseFloat(record.querySelector('balance').textContent);
            });
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Collected', 'Outstanding'],
                    datasets: [{
                        data: [totalPayments, totalBalance],
                        backgroundColor: ['#10B981', '#FFB800']
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
        
        function createBalanceDistChart() {
            const ctx = document.getElementById('balanceDistChart');
            if (!ctx) return;
            
            const records = Array.from(document.querySelectorAll('billing > record'));
            const dist = {
                'Fully Paid': 0,
                'Low (< ₱10k)': 0,
                'Medium (₱10k-20k)': 0,
                'High (> ₱20k)': 0
            };
            
            records.forEach(record => {
                const balance = parseFloat(record.querySelector('balance').textContent);
                if (balance === 0) dist['Fully Paid']++;
                else if (balance < 10000) dist['Low (< ₱10k)']++;
                else if (balance <= 20000) dist['Medium (₱10k-20k)']++;
                else dist['High (> ₱20k)']++;
            });
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(dist),
                    datasets: [{
                        label: 'Students',
                        data: Object.values(dist),
                        backgroundColor: [
                            '#10B981',
                            '#3B82F6',
                            '#FFB800',
                            '#EF4444'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        }
        
        // ==================== EVENTS CHARTS ====================
        function createEventStatusChart() {
            const ctx = document.getElementById('eventStatusChart');
            if (!ctx) return;
            
            const events = Array.from(document.querySelectorAll('events > event'));
            const statuses = {};
            events.forEach(event => {
                const status = event.getAttribute('eventStatus');
                statuses[status] = (statuses[status] || 0) + 1;
            });
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(statuses).map(s => s.charAt(0).toUpperCase() + s.slice(1)),
                    datasets: [{
                        data: Object.values(statuses),
                        backgroundColor: [
                            '#3B82F6',
                            '#10B981',
                            '#6B7280'
                        ]
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
        
        function createEventCategoryChart() {
            const ctx = document.getElementById('eventCategoryChart');
            if (!ctx) return;
            
            const events = Array.from(document.querySelectorAll('events > event'));
            const categories = {};
            events.forEach(event => {
                const cat = event.querySelector('category').textContent;
                categories[cat] = (categories[cat] || 0) + 1;
            });
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(categories),
                    datasets: [{
                        label: 'Events',
                        data: Object.values(categories),
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
                    }
                }
            });
        }
        
        function createRegistrationChart() {
            const ctx = document.getElementById('registrationChart');
            if (!ctx) return;
            
            const events = Array.from(document.querySelectorAll('events > event'));
            const data = events.slice(0, 10).map(event => ({
                name: event.querySelector('eventName').textContent.substring(0, 20),
                count: parseInt(event.querySelector('registrationCount').textContent),
                capacity: parseInt(event.querySelector('capacity').textContent)
            }));
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.map(d => d.name),
                    datasets: [{
                        label: 'Registered',
                        data: data.map(d => d.count),
                        backgroundColor: '#008A45'
                    }, {
                        label: 'Capacity',
                        data: data.map(d => d.capacity),
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
