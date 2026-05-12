<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">

    <!-- SUMMARY VARIABLES -->
    <xsl:variable name="recordCount" select="count(billing/record)"/>
    <xsl:variable name="totalTuition" select="format-number(sum(billing/record/tuitionFee), '#,##0')"/>
    <xsl:variable name="totalPayments" select="format-number(sum(billing/record/paymentsMade), '#,##0')"/>
    <xsl:variable name="totalBalance" select="format-number(sum(billing/record/balance), '#,##0')"/>

<html>
<head>

    <title>Student Billing Management System</title>

    <style>

        :root {
            --gsds-primary: #008A45;
            --gsds-accent: #FFCE00;
            --gsds-white: #FFFFFF;
            --gsds-surface: #FAFAFA;
            --gsds-border: #E5E7EB;
            --gsds-text-dark: #111827;
            --gsds-text-muted: #6B7280;
        }

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            font-family:'Inter','Segoe UI',sans-serif;
            background-color:#ffffff;
            color:var(--gsds-text-dark);
            padding:40px;
            line-height:1.6;
        }

        /* CONTAINER */

        .container{
            width:100%;
            max-width:1400px;
            margin:auto;
        }

        /* HEADER */

        .header{
            background-color:var(--gsds-white);
            border:1px solid var(--gsds-border);
            border-left:8px solid var(--gsds-primary);
            border-radius:14px;
            padding:30px;
            margin-bottom:32px;
            box-shadow:0 2px 6px rgba(0,0,0,0.04);
        }

        .header h1{
            font-size:32px;
            font-weight:800;
            color:var(--gsds-text-dark);
            margin-bottom:6px;
        }

        .header p{
            color:var(--gsds-text-muted);
            font-size:14px;
        }

        /* DASHBOARD CARDS */

        .dashboard-grid{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
            gap:20px;
            margin-bottom:32px;
        }

        .card{
            background:var(--gsds-white);
            border:1px solid var(--gsds-border);
            border-radius:14px;
            padding:24px;
            transition:0.25s ease;
        }

        .card:hover{
            border-color:var(--gsds-primary);
            transform:translateY(-3px);
        }

        .card h3{
            color:var(--gsds-primary);
            font-size:12px;
            text-transform:uppercase;
            letter-spacing:0.08em;
            margin-bottom:12px;
            font-weight:700;
        }

        .card .value{
            font-size:34px;
            font-weight:800;
            color:var(--gsds-text-dark);
        }

        .card .subtext{
            margin-top:8px;
            color:var(--gsds-text-muted);
            font-size:13px;
        }

        /* TABLE */

        .table-container{
            background:var(--gsds-white);
            border:1px solid var(--gsds-border);
            border-radius:14px;
            overflow:hidden;
        }

        .table-header{
            padding:24px;
            border-bottom:1px solid var(--gsds-border);
            background:#fcfcfc;
        }

        .table-header h2{
            font-size:22px;
            margin-bottom:4px;
        }

        .table-header p{
            color:var(--gsds-text-muted);
            font-size:14px;
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        thead{
            background-color:var(--gsds-primary);
        }

        thead th{
            color:white;
            font-size:13px;
            font-weight:600;
            text-transform:uppercase;
            letter-spacing:0.05em;
            padding:16px;
            text-align:left;
        }

        tbody td{
            padding:16px;
            border-bottom:1px solid var(--gsds-border);
            font-size:14px;
        }

        tbody tr:last-child td{
            border-bottom:none;
        }

        tbody tr:hover{
            background:#f8fffb;
        }

        /* TABLE COLORS */

        .student-id{
            color:var(--gsds-primary);
            font-weight:700;
        }

        .student-name{
            font-weight:600;
        }

        .tuition{
            color:#B45309;
            font-weight:700;
        }

        .payment{
            color:#166534;
            font-weight:700;
        }

        .balance{
            color:#991B1B;
            font-weight:700;
        }

        /* STATUS */

        .status-pill{
            display:inline-block;
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            font-weight:700;
        }

        .paid{
            background:#DCFCE7;
            color:#166534;
        }

        .pending{
            background:#FEF2F2;
            color:#991B1B;
        }

        /* FOOTER */

        .footer{
            margin-top:22px;
            text-align:center;
            color:var(--gsds-text-muted);
            font-size:13px;
        }

        /* RESPONSIVE */

        @media screen and (max-width:900px){

            body{
                padding:16px;
            }

            .dashboard-grid{
                grid-template-columns:1fr;
            }

            .header h1{
                font-size:26px;
            }

            table{
                font-size:12px;
            }

            thead th,
            tbody td{
                padding:12px;
            }
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

<!-- Navigation Menu Button -->
<button class="menu-button" onclick="toggleNav()">
    <svg viewBox="0 0 24 24" width="24" height="24" fill="white"><path d="M3 9h18v2H3V9zm0-4h18v2H3V5zm0 8h18v2H3v-2zm0 4h18v2H3v-2z"/></svg>
</button>

<!-- Navigation Overlay -->
<div class="modal-overlay" id="navOverlay" onclick="toggleNav()"></div>

<!-- Navigation Modal -->
<div class="module-modal" id="navModal">
    <div class="modal-header">
        <h2>SARMS Navigation</h2>
        <p>Navigate between modules and return to dashboard</p>
    </div>
    <div class="module-grid">
        <a href="../sarms-dashboard.html" class="module-card">
            <i>📊</i>
            <h3>Dashboard</h3>
            <p>Unified view with statistics and charts</p>
            <span class="view-link">
                Go to Dashboard →
            </span>
        </a>
        <a href="../group1-enrollment/students.xml" class="module-card">
            <i>👥</i>
            <h3>Student Enrollment</h3>
            <p>Student records and grades</p>
            <span class="view-link">
                View Module →
            </span>
        </a>
        <a href="../group3-faculty/faculty.xml" class="module-card">
            <i>👨‍🏫</i>
            <h3>Faculty Workload</h3>
            <p>Faculty assignments and teaching hours</p>
            <span class="view-link">
                View Module →
            </span>
        </a>
        <a href="../group4-library/library.xml" class="module-card">
            <i>📚</i>
            <h3>Library Management</h3>
            <p>Books and borrowing records</p>
            <span class="view-link">
                View Module →
            </span>
        </a>
        <a href="../group5-billing/billing.xml" class="module-card" style="border-color: #008a45; background: #f0fdf4;">
            <i>💰</i>
            <h3>Student Billing</h3>
            <p>Tuition fees and payments (Current Page)</p>
            <span class="view-link">
                ✓ Current Module
            </span>
        </a>
        <a href="../group6-events/events.xml" class="module-card">
            <i>📅</i>
            <h3>Event Management</h3>
            <p>University events and registrations</p>
            <span class="view-link">
                View Module →
            </span>
        </a>
    </div>
</div>

<script>
    function toggleNav() {
        document.getElementById('navOverlay').classList.toggle('active');
        document.getElementById('navModal').classList.toggle('active');
    }
</script>

<div class="container">

    <!-- HEADER -->

    <div class="header">
        <h1>Student Billing System</h1>
        <p>
            Manage tuition fees, payment records, and outstanding balances efficiently.
        </p>
    </div>

    <!-- SUMMARY DASHBOARD -->

    <div class="dashboard-grid">

        <div class="card">
            <h3>Total Students</h3>
            <div class="value">
                <xsl:value-of select="$recordCount"/>
            </div>
            <div class="subtext">
                Registered billing records
            </div>
        </div>

        <div class="card">
            <h3>Total Tuition</h3>
            <div class="value">
                ₱<xsl:value-of select="$totalTuition"/>
            </div>
            <div class="subtext">
                Total billed tuition fees
            </div>
        </div>

        <div class="card">
            <h3>Payments Received</h3>
            <div class="value">
                ₱<xsl:value-of select="$totalPayments"/>
            </div>
            <div class="subtext">
                Collected student payments
            </div>
        </div>

        <div class="card">
            <h3>Outstanding Balance</h3>
            <div class="value">
                ₱<xsl:value-of select="$totalBalance"/>
            </div>
            <div class="subtext">
                Remaining unpaid balances
            </div>
        </div>

    </div>

    <!-- BILLING TABLE -->

    <div class="table-container">

        <div class="table-header">
            <h2>Billing Statements</h2>
            <p>
                Tuition fees, payment history, and remaining balances of students.
            </p>
        </div>

        <table>

            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Tuition Fee</th>
                    <th>Payments Made</th>
                    <th>Balance</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>

                <xsl:for-each select="billing/record">

                <tr>

                    <td class="student-id">
                        <xsl:value-of select="studentId"/>
                    </td>

                    <td class="student-name">
                        <xsl:value-of select="name"/>
                    </td>

                    <td class="tuition">
                        ₱<xsl:value-of select="format-number(tuitionFee, '#,##0')"/>
                    </td>

                    <td class="payment">
                        ₱<xsl:value-of select="format-number(paymentsMade, '#,##0')"/>
                    </td>

                    <td class="balance">
                        ₱<xsl:value-of select="format-number(balance, '#,##0')"/>
                    </td>

                    <td>

                        <xsl:choose>

                            <xsl:when test="balance = 0">
                                <span class="status-pill paid">
                                    Fully Paid
                                </span>
                            </xsl:when>

                            <xsl:when test="balance &lt;= 5000">
                                <span class="status-pill paid">
                                    Nearly Paid
                                </span>
                            </xsl:when>

                            <xsl:otherwise>
                                <span class="status-pill pending">
                                    With Balance
                                </span>
                            </xsl:otherwise>

                        </xsl:choose>

                    </td>

                </tr>

                </xsl:for-each>

            </tbody>

        </table>

    </div>

    <!-- FOOTER -->

    <div class="footer">
        Student Billing System
    </div>

</div>

</body>
</html>

</xsl:template>

</xsl:stylesheet>