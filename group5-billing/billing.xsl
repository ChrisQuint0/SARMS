<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>

<xsl:template match="/">

    <!-- Variables -->
    <xsl:variable name="recordCount" select="count(billing/record)"/>
    <xsl:variable name="totalTuition" select="format-number(sum(billing/record/tuitionFee), '#,##0')"/>
    <xsl:variable name="totalPayments" select="format-number(sum(billing/record/paymentsMade), '#,##0')"/>
    <xsl:variable name="totalBalance" select="format-number(sum(billing/record/balance), '#,##0')"/>
    <xsl:variable name="enrollmentData" select="document('../group1-enrollment/students.xml')"/>

<html>
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Student Billing Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&amp;display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        :root {
            /* Colors */
            --plp-green-50: #F8FAFC;
            --plp-green-100: #E6F4EC;
            --plp-green-400: #008A45;
            --plp-green-500: #008A45;
            --plp-green-600: #006B35;
            --plp-green-700: #006B35;
            --plp-green-800: #004D26;
            --plp-green-900: #004D26;

            /* Backgrounds */
            --bg-color: #F3F4F6;
            --surface-glass: rgba(255, 255, 255, 0.85);
            --surface-glass-border: rgba(255, 255, 255, 0.4);
            
            /* Text */
            --text-main: #111827;
            --text-muted: #6B7280;

            /* Status Colors */
            --success-bg: #DCFCE7;
            --success-text: #166534;
            --warning-bg: #FEF3C7;
            --warning-text: #92400E;
            --danger-bg: #FEE2E2;
            --danger-text: #991B1B;

            /* Effects */
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-glow: 0 0 20px rgba(0, 138, 69, 0.15);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #F8FAFC 0%, #F1F5F9 100%);
            background-attachment: fixed;
            color: var(--text-main);
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px;
            padding-top: 100px; /* Space for fixed header */
        }

        /* Header */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            width: 100%;
            background: linear-gradient(135deg, var(--plp-green-900), #003318);
            color: #FFFFFF;
            padding: 16px 40px 16px 100px; /* Padding left for menu button */
            z-index: 1000;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .header img {
            height: 45px;
            width: auto;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.2));
        }

        .header h1 {
            font-size: 20px;
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: -0.02em;
        }

        .header p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 14px;
            font-weight: 500;
            margin-top: 2px;
        }

        /* Cards */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
            animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .card {
            background: var(--surface-glass);
            backdrop-filter: blur(16px);
            border: 1px solid var(--surface-glass-border);
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--shadow-md);
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 4px;
            background: linear-gradient(90deg, var(--plp-green-400), var(--plp-green-700));
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg), var(--shadow-glow);
        }

        .card:hover::before {
            opacity: 1;
        }

        .card h3 {
            color: var(--text-muted);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .card .value {
            font-size: 40px;
            font-weight: 800;
            color: var(--plp-green-900);
            line-height: 1.1;
            letter-spacing: -1px;
        }

        .card .subtext {
            margin-top: 12px;
            color: var(--plp-green-600);
            font-size: 14px;
            font-weight: 500;
        }

        /* Filters */
        .controls-wrapper {
            background: var(--surface-glass);
            backdrop-filter: blur(16px);
            border: 1px solid var(--surface-glass-border);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 24px;
            display: flex;
            gap: 20px;
            align-items: flex-end;
            box-shadow: var(--shadow-md);
            animation: slideUp 0.7s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            opacity: 0;
        }

        .input-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }

        .input-group label {
            font-size: 13px;
            font-weight: 700;
            color: var(--plp-green-900);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .premium-input {
            width: 100%;
            padding: 14px 20px;
            border: 2px solid #E5E7EB;
            border-radius: 12px;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            font-weight: 500;
            color: var(--text-main);
            background: rgba(255,255,255,0.9);
            transition: all 0.3s ease;
        }

        .premium-input:focus, .premium-input:hover {
            outline: none;
            border-color: var(--plp-green-400);
            box-shadow: 0 0 0 4px rgba(52, 211, 153, 0.15);
            background: #ffffff;
        }

        .premium-button {
            padding: 14px 24px;
            background: linear-gradient(135deg, var(--plp-green-400), var(--plp-green-600));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0, 138, 69, 0.2);
            transition: all 0.3s ease;
            height: 52px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .premium-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0, 138, 69, 0.3);
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 24px;
            text-align: left;
        }

        /* Table */
        .table-container {
            background: var(--surface-glass);
            backdrop-filter: blur(16px);
            border: 1px solid var(--surface-glass-border);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            opacity: 0;
        }

        .table-wrapper {
            overflow-x: auto;
            max-height: 600px;
        }

        .table-wrapper::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        .table-wrapper::-webkit-scrollbar-track {
            background: transparent;
        }

        .table-wrapper::-webkit-scrollbar-thumb {
            background-color: var(--plp-green-100);
            border-radius: 20px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        thead th {
            position: sticky;
            top: 0;
            background: rgba(243, 244, 246, 0.95);
            backdrop-filter: blur(8px);
            color: var(--plp-green-900);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            padding: 20px 24px;
            text-align: left;
            border-bottom: 2px solid var(--plp-green-100);
            z-index: 10;
        }

        tbody td {
            padding: 20px 24px;
            font-size: 15px;
            border-bottom: 1px solid #E5E7EB;
            transition: all 0.2s ease;
        }

        tbody tr {
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: rgba(209, 250, 229, 0.3); /* ultra light green */
            transform: scale(1.002);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .hidden-row {
            display: none !important;
        }

        /* Typography */
        .student-id { font-weight: 700; color: var(--plp-green-700); }
        .student-name { font-weight: 600; color: var(--text-main); }
        .currency { font-weight: 700; font-variant-numeric: tabular-nums; }
        .tuition { color: #92400E; }
        .payment { color: #065F46; }
        .balance { color: #991B1B; }

        /* Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .status-badge::before {
            content: '';
            display: block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .badge-paid {
            background: #D1FAE5; /* var(--success-100) */
            color: #10B981; /* var(--success-500) */
            border: 1px solid #10B981;
        }
        .badge-paid::before { background: #10B981; }

        .badge-nearly {
            background: #FEF3C7; /* var(--warning-100) */
            color: #B45309; 
            border: 1px solid #F59E0B; /* var(--warning-500) */
        }
        .badge-nearly::before { background: #B45309; }

        .badge-balance {
            background: #FEE2E2; /* var(--danger-100) */
            color: #DC2626; /* var(--danger-500) */
            border: 1px solid #DC2626;
            animation: pulse-danger 2s infinite;
        }
        .badge-balance::before { background: #DC2626; }

        @keyframes pulse-danger {
            0% { box-shadow: 0 0 0 0 rgba(220, 38, 38, 0.4); }
            70% { box-shadow: 0 0 0 6px rgba(220, 38, 38, 0); }
            100% { box-shadow: 0 0 0 0 rgba(220, 38, 38, 0); }
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Empty State */
        .no-records {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-muted);
            font-size: 16px;
            font-weight: 500;
        }

        .no-records-icon {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        /* Navigation */
        .menu-button {
            position: fixed;
            top: 10px;
            left: 24px;
            width: 56px;
            height: 56px;
            background: #008A45;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1001; /* Above header */
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
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            z-index: 9999;
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
            z-index: 10000;
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

        .modal-header { margin-bottom: 32px; text-align: left; }
        .modal-header h2 { font-size: 32px; font-weight: 800; color: #008A45; margin-bottom: 8px; }
        .modal-header p { font-size: 16px; color: #6B7280; }

        .module-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }

        .module-card {
            background: white;
            border: 2px solid #E5E7EB;
            border-radius: 16px;
            padding: 24px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            text-decoration: none;
            display: block;
            text-align: left;
        }

        .module-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, #008A45, #00C76F);
            opacity: 0;
            transition: all 0.3s ease;
        }

        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 138, 69, 0.15);
            border-color: #008A45;
        }

        .module-card:hover::before { opacity: 0.03; }
        .module-card i.card-icon { font-size: 28px; color: #008A45; margin-bottom: 12px; display: block; position: relative; z-index: 1; }
        .module-card h3 { font-size: 18px; font-weight: 700; color: #111827; margin-bottom: 8px; position: relative; z-index: 1; }
        .module-card p { font-size: 13px; color: #6B7280; line-height: 1.5; margin-bottom: 12px; position: relative; z-index: 1; }
        
        .module-card .view-link {
            font-size: 13px;
            color: #008A45;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
            position: relative;
            z-index: 1;
            transition: gap 0.2s ease;
        }
        .module-card .view-link i { font-size: 13px; margin: 0; color: #008A45; display: inline; }
        .module-card:hover .view-link { gap: 8px; }
        
        .footer {
            text-align: center;
            padding: 40px;
            color: var(--text-muted);
            font-size: 14px;
            font-weight: 500;
        }
    </style>
</head>
<body>

<!-- Header -->
<div class="header">
    <img src="PLP_logo.png" alt="PLP Logo"/>
    <div>
        <h1>Student Billing System</h1>
        <p>Pamantasan ng Lungsod ng Pasig</p>
    </div>
</div>

<!-- Navigation Menu Button -->
<button class="menu-button" onclick="toggleNav()">
    <i class="fas fa-th"></i>
</button>

<!-- Navigation Overlay -->
<div class="modal-overlay" id="navOverlay" onclick="toggleNav()"></div>

<!-- Navigation Modal -->
<div class="module-modal" id="navModal">
    <div class="modal-header">
        <h2>Module Navigation</h2>
        <p>Select a module to view detailed information</p>
    </div>
    <div class="module-grid">
        <a href="../sarms.xml" class="module-card">
            <i class="fas fa-th card-icon"></i>
            <h3>Dashboard</h3>
            <p>Unified view with statistics and charts</p>
            <span class="view-link"><i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module</span>
        </a>
        <a href="../group1-enrollment/students.xml" class="module-card">
            <i class="fas fa-user-graduate card-icon"></i>
            <h3>Student Enrollment</h3>
            <p>Manage student records, enrollments, and academic performance</p>
            <span class="view-link"><i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module</span>
        </a>
        <a href="../group3-faculty/faculty.xml" class="module-card">
            <i class="fas fa-chalkboard-teacher card-icon"></i>
            <h3>Faculty Workload</h3>
            <p>Track faculty assignments, teaching hours, and workload distribution</p>
            <span class="view-link"><i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module</span>
        </a>
        <a href="../group4-library/library.xml" class="module-card">
            <i class="fas fa-book card-icon"></i>
            <h3>Library Management</h3>
            <p>Manage books, borrowing records, and library resources</p>
            <span class="view-link"><i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module</span>
        </a>
        <a href="../group5-billing/billing.xml" class="module-card" style="border-color: #008A45; background: #f0fdf4;">
            <i class="fas fa-file-invoice-dollar card-icon"></i>
            <h3>Student Billing</h3>
            <p>Track tuition fees, payments, and outstanding balances (Current Page)</p>
            <span class="view-link">✓ Current Module</span>
        </a>
        <a href="../group6-events/events.xml" class="module-card">
            <i class="fas fa-calendar-alt card-icon"></i>
            <h3>Event Management</h3>
            <p>Organize university events, registrations, and attendance</p>
            <span class="view-link"><i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module</span>
        </a>
    </div>
</div>

<script>
    function toggleNav() {
        document.getElementById('navOverlay').classList.toggle('active');
        document.getElementById('navModal').classList.toggle('active');
        document.querySelector('.menu-button').classList.toggle('active');
    }
</script>

<!--  Modal Overlay -->
<div class="modal-overlay" id="billingModalOverlay" onclick="closeModal()"></div>

<!-- Add Form Modal -->
<div class="module-modal" id="billingModal" style="max-width: 600px;">
    <div class="modal-header">
        <h2 id="modalTitle">Add Billing Record</h2>
        <p id="modalSubtitle">Enter Student ID to automatically fetch enrollment data.</p>
    </div>
    <div class="form-grid">
        <div class="input-group">
            <label for="newStudentId">Student ID</label>
            <input type="text" id="newStudentId" class="premium-input" placeholder="e.g. 23-00001" onblur="fetchStudentData()"/>
        </div>
        <div class="input-group">
            <label for="newName">Student Name</label>
            <input type="text" id="newName" class="premium-input" placeholder="Auto-populated" readonly="readonly" style="background: #F3F4F6;"/>
        </div>
        <div class="input-group">
            <label for="newTuition">Tuition Fee (₱)</label>
            <input type="number" id="newTuition" class="premium-input" placeholder="0.00"/>
        </div>
        <div class="input-group">
            <label for="newPayment">Payment Made (₱)</label>
            <input type="number" id="newPayment" class="premium-input" placeholder="0.00"/>
        </div>
    </div>
    <div style="text-align: right; margin-top: 24px;">
        <button class="premium-button" style="background: #6B7280; display: inline-flex; margin-right: 12px;" onclick="closeModal()">Cancel</button>
        <button class="premium-button" style="display: inline-flex;" onclick="saveBillingRecord()">Save Record</button>
    </div>
</div>

<!-- Confirm Modal -->
<div class="modal-overlay" id="confirmModalOverlay" onclick="closeConfirmModal()"></div>
<div class="module-modal" id="confirmModal" style="max-width: 400px; text-align: center; padding: 30px;">
    <div style="font-size: 48px; color: #F59E0B; margin-bottom: 16px;">
        <i class="fas fa-exclamation-circle"></i>
    </div>
    <h2 style="font-size: 24px; color: #111827; margin-bottom: 12px;" id="confirmTitle">Confirm Action</h2>
    <p style="color: #6B7280; font-size: 15px; margin-bottom: 24px;" id="confirmMessage">Are you sure you want to proceed?</p>
    <div style="display: flex; gap: 12px; justify-content: center;">
        <button class="premium-button" style="background: #E5E7EB; color: #4B5563; box-shadow: none;" onclick="closeConfirmModal()">Cancel</button>
        <button class="premium-button" id="confirmActionBtn" style="background: #008A45;">Yes, Confirm</button>
    </div>
</div>

<!-- Alert Modal -->
<div class="modal-overlay" id="alertModalOverlay" onclick="closeAlertModal()"></div>
<div class="module-modal" id="alertModal" style="max-width: 400px; text-align: center; padding: 30px;">
    <div id="alertIcon" style="font-size: 48px; color: #10B981; margin-bottom: 16px;">
        <i class="fas fa-check-circle"></i>
    </div>
    <h2 style="font-size: 24px; color: #111827; margin-bottom: 12px;" id="alertTitle">Success!</h2>
    <p style="color: #6B7280; font-size: 15px; margin-bottom: 24px;" id="alertMessage">Action completed successfully.</p>
    <button class="premium-button" style="margin: 0 auto;" onclick="closeAlertModal()">OK</button>
</div>


<div class="container">

    <!-- Dashboard -->
    <div class="dashboard-grid">
        <div class="card">
            <h3>Total Students</h3>
            <div class="value"><xsl:value-of select="$recordCount"/></div>
            <div class="subtext">Active billing accounts</div>
        </div>
        <div class="card">
            <h3>Total Tuition Billed</h3>
            <div class="value">₱<xsl:value-of select="$totalTuition"/></div>
            <div class="subtext">Total expected revenue</div>
        </div>
        <div class="card">
            <h3>Payments Collected</h3>
            <div class="value">₱<xsl:value-of select="$totalPayments"/></div>
            <div class="subtext">Total verified payments</div>
        </div>
        <div class="card">
            <h3>Outstanding Balance</h3>
            <div class="value">₱<xsl:value-of select="$totalBalance"/></div>
            <div class="subtext">Pending collections</div>
        </div>
    </div>

    <!-- Filters -->
    <div class="controls-wrapper">
        <div class="input-group">
            <label for="searchFilter">Search Records</label>
            <input type="text" id="searchFilter" class="premium-input" placeholder="Search by ID or Name..." onkeyup="filterTable()"/>
        </div>
        <div class="input-group">
            <label for="statusFilter">Payment Status</label>
            <select id="statusFilter" class="premium-input" onchange="filterTable()">
                <option value="all">All Statements</option>
                <option value="paid">Fully Paid</option>
                <option value="nearly">Nearly Paid</option>
                <option value="balance">With Balance</option>
            </select>
        </div>
        <div class="input-group" style="flex: 0 0 auto;">
            <button class="premium-button" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Add Record
            </button>
        </div>
    </div>

    <!-- Table -->
    <div class="table-container">
        <div class="table-wrapper">
            <table id="billingTable">
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Student Name</th>
                        <th>Tuition Fee</th>
                        <th>Payments Made</th>
                        <th>Current Balance</th>
                        <th>Status</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="billing/record">
                        <!-- Determine row status for filtering -->
                        <tr>
                            <xsl:attribute name="data-status">
                                <xsl:choose>
                                    <xsl:when test="balance = 0">paid</xsl:when>
                                    <xsl:when test="balance &lt;= 5000">nearly</xsl:when>
                                    <xsl:otherwise>balance</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            
                            <xsl:variable name="currentStudentId" select="studentId" />
                            <xsl:variable name="studentNode" select="$enrollmentData//student[@studentId = $currentStudentId]" />
                            
                            <td class="student-id"><xsl:value-of select="studentId"/></td>
                            <td class="student-name">
                                <xsl:choose>
                                    <xsl:when test="$studentNode">
                                        <xsl:value-of select="$studentNode/firstName"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$studentNode/lastName"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span style="color:red; font-style:italic;">Name Not Found</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td class="currency tuition">₱<xsl:value-of select="format-number(tuitionFee, '#,##0')"/></td>
                            <td class="currency payment">₱<xsl:value-of select="format-number(paymentsMade, '#,##0')"/></td>
                            <td class="currency balance">₱<xsl:value-of select="format-number(balance, '#,##0')"/></td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="balance = 0">
                                        <span class="status-badge badge-paid">Fully Paid</span>
                                    </xsl:when>
                                    <xsl:when test="balance &lt;= 5000">
                                        <span class="status-badge badge-nearly">Nearly Paid</span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="status-badge badge-balance">With Balance</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td style="text-align: right;">
                                <button class="premium-button" style="padding: 8px 16px; height: auto; font-size: 13px;" onclick="openEditModal('{studentId}', '{tuitionFee}', '{paymentsMade}')">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
            
            <div id="noRecords" class="no-records" style="display: none;">
                <div class="no-records-icon">🔍</div>
                <p>No billing statements match your current filters.</p>
                <p style="font-size: 14px; color: #9CA3AF; margin-top: 8px;">Try adjusting your search terms or status selection.</p>
            </div>
            
        </div>
    </div>

    <div class="footer">
        © 2026 Pamantasan ng Lungsod ng Pasig. All rights reserved.
    </div>

</div>

<script><![CDATA[
    function filterTable() {
        const table = document.getElementById('billingTable');
        const rows = table.querySelectorAll('tbody tr');
        const noRecords = document.getElementById('noRecords');
        
        const searchVal = document.getElementById('searchFilter').value.toLowerCase();
        const statusVal = document.getElementById('statusFilter').value;
        
        let visibleCount = 0;
        
        rows.forEach(row => {
            const rowStatus = row.getAttribute('data-status');
            const textContent = row.textContent.toLowerCase();
            
            const matchSearch = searchVal === '' || textContent.includes(searchVal);
            const matchStatus = statusVal === 'all' || statusVal === rowStatus;
            
            if (matchSearch && matchStatus) {
                row.classList.remove('hidden-row');
                visibleCount++;
            } else {
                row.classList.add('hidden-row');
            }
        });
        
        if (visibleCount === 0) {
            table.style.display = 'none';
            noRecords.style.display = 'block';
        } else {
            table.style.display = 'table';
            noRecords.style.display = 'none';
        }
    }

    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Add Billing Record';
        document.getElementById('modalSubtitle').innerText = 'Enter Student ID to automatically fetch enrollment data.';
        
        const idInput = document.getElementById('newStudentId');
        idInput.value = '';
        idInput.removeAttribute('readonly');
        idInput.style.background = '#ffffff';
        
        document.getElementById('newName').value = '';
        document.getElementById('newTuition').value = '';
        document.getElementById('newPayment').value = '';
        
        document.getElementById('billingModalOverlay').classList.add('active');
        document.getElementById('billingModal').classList.add('active');
    }

    function openEditModal(studentId, tuition, payment) {
        document.getElementById('modalTitle').innerText = 'Edit Billing Record';
        document.getElementById('modalSubtitle').innerText = 'Update financial details for this student.';
        
        const idInput = document.getElementById('newStudentId');
        idInput.value = studentId;
        idInput.setAttribute('readonly', 'readonly');
        idInput.style.background = '#F3F4F6';
        
        document.getElementById('newTuition').value = tuition;
        document.getElementById('newPayment').value = payment;
        
        // Trigger name fetch immediately
        fetchStudentData();
        
        document.getElementById('billingModalOverlay').classList.add('active');
        document.getElementById('billingModal').classList.add('active');
    }

    function closeModal() {
        document.getElementById('billingModalOverlay').classList.remove('active');
        document.getElementById('billingModal').classList.remove('active');
    }

    function fetchStudentData() {
        const studentId = document.getElementById('newStudentId').value;
        if (!studentId) return;

        // Visual feedback
        const nameInput = document.getElementById('newName');
        nameInput.placeholder = "Fetching data...";

        // Fetch XML from the enrollment module
        fetch('../group1-enrollment/students.xml')
            .then(response => {
                if (!response.ok) throw new Error("Could not load students.xml");
                return response.text();
            })
            .then(str => new window.DOMParser().parseFromString(str, "text/xml"))
            .then(xml => {
                // Find student by attribute
                const studentNodes = xml.getElementsByTagName("student");
                let found = false;
                for (let i = 0; i < studentNodes.length; i++) {
                    if (studentNodes[i].getAttribute("studentId") === studentId) {
                        const firstName = studentNodes[i].getElementsByTagName("firstName")[0].textContent;
                        const lastName = studentNodes[i].getElementsByTagName("lastName")[0].textContent;
                        nameInput.value = firstName + " " + lastName;
                        found = true;
                        break;
                    }
                }
                
                if (!found) {
                    nameInput.value = "";
                    nameInput.placeholder = "Student not found.";
                    showAlert("Student Not Found", "The Student ID you entered does not exist in the enrollment module.", "error");
                }
            })
            .catch(err => {
                console.error("Error fetching student data:", err);
                nameInput.value = "";
                nameInput.placeholder = "Error loading data.";
                showAlert("Connection Error", "Could not load enrollment data. Ensure you are running this on a local server.", "error");
            });
    }

    function saveBillingRecord() {
        const studentId = document.getElementById('newStudentId').value;
        const tuition = document.getElementById('newTuition').value;
        const payment = document.getElementById('newPayment').value;
        const name = document.getElementById('newName').value;

        if (!studentId || tuition === '' || payment === '') {
            showAlert("Error", "Please fill in all fields (Student ID, Tuition Fee, and Payment) before saving.", "error");
            return;
        }
        
        if (name === "" || name === "Student not found." || name === "Error loading data.") {
            showAlert("Error", "Valid student name is required. Please enter a valid Student ID.", "error");
            return;
        }

        const isEdit = document.getElementById('newStudentId').hasAttribute('readonly');
        const actionText = isEdit ? "update" : "add";
        
        showConfirm("Confirm Action", `Are you sure you want to ${actionText} the billing record for Student ID: ${studentId}?`, () => {
            executeSave(studentId, name, parseFloat(tuition), parseFloat(payment), isEdit);
        });
    }

    function executeSave(studentId, name, tuition, payment, isEdit) {
        const balance = tuition - payment;
        const tbody = document.querySelector('#billingTable tbody');
        
        const formatCurrency = (num) => num.toLocaleString('en-US', {minimumFractionDigits: 0, maximumFractionDigits: 0});
        
        let statusClass, statusText, filterStatus;
        if (balance <= 0) {
            statusClass = 'badge-paid'; statusText = 'Fully Paid'; filterStatus = 'paid';
        } else if (balance <= 5000) {
            statusClass = 'badge-nearly'; statusText = 'Nearly Paid'; filterStatus = 'nearly';
        } else {
            statusClass = 'badge-balance'; statusText = 'With Balance'; filterStatus = 'balance';
        }

        if (isEdit) {
            const rows = tbody.querySelectorAll('tr');
            for(let i=0; i<rows.length; i++) {
                const row = rows[i];
                if(row.querySelector('.student-id') && row.querySelector('.student-id').textContent === studentId) {
                    row.setAttribute('data-status', filterStatus);
                    row.querySelector('.tuition').textContent = "₱" + formatCurrency(tuition);
                    row.querySelector('.payment').textContent = "₱" + formatCurrency(payment);
                    row.querySelector('.balance').textContent = "₱" + formatCurrency(balance);
                    row.querySelector('td:nth-child(6)').innerHTML = `<span class="status-badge ${statusClass}">${statusText}</span>`;
                    row.querySelector('button').setAttribute('onclick', `openEditModal('${studentId}', '${tuition}', '${payment}')`);
                    break;
                }
            }
        } else {
            const tr = document.createElement('tr');
            tr.setAttribute('data-status', filterStatus);
            
            tr.innerHTML = `
                <td class="student-id">${studentId}</td>
                <td class="student-name">${name}</td>
                <td class="currency tuition">₱${formatCurrency(tuition)}</td>
                <td class="currency payment">₱${formatCurrency(payment)}</td>
                <td class="currency balance">₱${formatCurrency(balance)}</td>
                <td><span class="status-badge ${statusClass}">${statusText}</span></td>
                <td style="text-align: right;">
                    <button class="premium-button" style="padding: 8px 16px; height: auto; font-size: 13px;" onclick="openEditModal('${studentId}', '${tuition}', '${payment}')">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                </td>
            `;
            tbody.insertBefore(tr, tbody.firstChild);
        }
        
        updateDashboardStats();
        
        closeModal();
        showAlert("Success!", `Record successfully ${isEdit ? "updated" : "added"} in the dashboard.`);
    }

    function updateDashboardStats() {
        const rows = document.querySelectorAll('#billingTable tbody tr');
        let totalTuition = 0;
        let totalPayments = 0;
        let totalBalance = 0;
        let validRows = 0;
        
        for(let i=0; i<rows.length; i++) {
            const row = rows[i];
            if(row.querySelector('.tuition')) {
                const t = parseFloat(row.querySelector('.tuition').textContent.replace(/[^0-9.-]+/g,""));
                const p = parseFloat(row.querySelector('.payment').textContent.replace(/[^0-9.-]+/g,""));
                const b = parseFloat(row.querySelector('.balance').textContent.replace(/[^0-9.-]+/g,""));
                totalTuition += t;
                totalPayments += p;
                totalBalance += b;
                validRows++;
            }
        }
        
        const cards = document.querySelectorAll('.dashboard-grid .card .value');
        if(cards.length >= 4) {
            cards[0].textContent = validRows;
            cards[1].textContent = "₱" + totalTuition.toLocaleString('en-US', {minimumFractionDigits: 0, maximumFractionDigits: 0});
            cards[2].textContent = "₱" + totalPayments.toLocaleString('en-US', {minimumFractionDigits: 0, maximumFractionDigits: 0});
            cards[3].textContent = "₱" + totalBalance.toLocaleString('en-US', {minimumFractionDigits: 0, maximumFractionDigits: 0});
        }
    }



    function showConfirm(title, message, callback) {
        document.getElementById('confirmTitle').innerText = title;
        document.getElementById('confirmMessage').innerText = message;
        document.getElementById('confirmModalOverlay').classList.add('active');
        document.getElementById('confirmModal').classList.add('active');
        
        const btn = document.getElementById('confirmActionBtn');
        btn.onclick = function() {
            closeConfirmModal();
            if(callback) callback();
        };
    }

    function closeConfirmModal() {
        document.getElementById('confirmModalOverlay').classList.remove('active');
        document.getElementById('confirmModal').classList.remove('active');
    }

    function showAlert(title, message, type="success") {
        document.getElementById('alertTitle').innerText = title;
        document.getElementById('alertMessage').innerText = message;
        
        const icon = document.getElementById('alertIcon');
        if(type === "error") {
            icon.style.color = "#DC2626";
            icon.innerHTML = '<i class="fas fa-times-circle"></i>';
        } else {
            icon.style.color = "#10B981";
            icon.innerHTML = '<i class="fas fa-check-circle"></i>';
        }
        
        document.getElementById('alertModalOverlay').classList.add('active');
        document.getElementById('alertModal').classList.add('active');
    }

    function closeAlertModal() {
        document.getElementById('alertModalOverlay').classList.remove('active');
        document.getElementById('alertModal').classList.remove('active');
    }
]]></script>

</body>
</html>
</xsl:template>
</xsl:stylesheet>