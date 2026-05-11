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

    </style>

</head>

<body>

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