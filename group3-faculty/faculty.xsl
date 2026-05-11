<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width,initial-scale=1"/>
                <title>Faculty Workload | SARMS</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
                <style>
                    :root{
                        --sarms-green: #0b6b3e;
                        --sarms-green-600: #0f8a4b;
                        --bg-light: #f4f9f6;
                        --card-white: #ffffff;
                        --muted: #4b5563;
                        --text-dark: #0f172a;
                        --border: #e6f6ea;
                        --danger: #dc2626;
                        --danger-bg: #fff1f2;
                        --radius-lg: 12px;
                    }

                    *{box-sizing:border-box}
                    html,body{height:100%}
                    body{
                        margin:0;
                        font-family:'Inter',system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial;
                        background:linear-gradient(180deg,var(--bg-light),#ffffff 60%);
                        color:var(--text-dark);
                        -webkit-font-smoothing:antialiased;
                        padding:0;
                    }

                    /* Hero */
                    .hero{
                        background:linear-gradient(90deg,var(--sarms-green),var(--sarms-green-600));
                        color:#fff;
                        padding:3.25rem 1rem 3.5rem;
                        text-align:center;
                    }
                    .hero .univ{letter-spacing:.12em;font-size:.78rem;font-weight:600;opacity:.95;margin-bottom:.5rem}
                    .hero h1{font-size:2.125rem;margin:0;font-weight:700}
                    .hero .tag{opacity:.9;margin-top:.5rem;font-size:.9rem}

                    /* Layout */
                    .container{max-width:1350px;margin: 2.5rem auto 3rem;padding:0 1rem}
                    
                    .card{
                        background:var(--card-white);
                        border-radius:var(--radius-lg);
                        box-shadow:0 10px 30px rgba(11,107,62,0.08);
                        overflow:hidden;border:1px solid #e6f6ea;
                    }

                    /* Toolbar */
                    .toolbar{display:flex;justify-content:space-between;align-items:center;padding:1.5rem 1.5rem 1rem;border-bottom:1px solid #e6f6ea;gap:1rem}
                    .toolbar > div:first-child{flex:1}

                    table{width:100%;border-collapse:collapse;font-size:.95rem;padding:0}
                    thead th{position:sticky;top:0;background:#f9fdf9;padding:1.4rem 2rem;text-align:left;font-size:.75rem;color:var(--muted);text-transform:uppercase;letter-spacing:.06em;border-bottom:2px solid var(--border);font-weight:600}
                    tbody tr{transition:background .2s ease;border-bottom:1px solid #e6f6ea}
                    tbody tr:hover td{background:#fbfff9}
                    td{padding:1.35rem 2rem;vertical-align:middle;border:none}

                    .id{font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,monospace;color:var(--muted);width:10%;font-weight:600}
                    .faculty-info{width:28%}
                    .faculty-name{display:block;font-weight:700;color:var(--text-dark);font-size:1rem;margin-bottom:.35rem}
                    .faculty-dept{display:block;color:var(--muted);font-size:.85rem;font-weight:500}

                    .load-list{display:flex;flex-wrap:wrap;gap:.5rem;align-items:center}
                    .subject-tag{background:linear-gradient(180deg,#fafff9,#f6fff7);border:1px solid var(--border);padding:.4rem .7rem;border-radius:6px;color:var(--sarms-green);font-weight:600;font-size:.8rem;white-space:nowrap}

                    /* Hours with progress */
                    .hours-cell{display:flex;flex-direction:column;gap:.6rem;align-items:flex-start;width:22%;min-width:220px}
                    .hours-val{font-weight:700;color:var(--text-dark);display:flex;align-items:center;gap:.4rem;font-size:1.05rem}
                    .hours-val .limit{font-weight:500;color:var(--muted);font-size:.85rem}
                    .progress{width:100%;max-width:220px;height:8px;background:#e6f6ea;border-radius:999px;overflow:hidden}
                    .progress-fill{height:100%;background:var(--sarms-green-600);width:0%;transition:width .6s ease}

                    /* overloaded */
                    .overloaded td{background:var(--danger-bg)}
                    .overloaded .progress-fill{background:var(--danger)}

                    /* Responsive */
                    @media (max-width:800px){
                        .faculty-dept{font-size:.78rem}
                        thead th{display:none}
                        table,tbody,td,tr{display:block}
                        td{border-bottom:none;padding:.6rem}
                        .id{display:inline-block;margin-bottom:.5rem}
                        .hours-cell{align-items:flex-end}
                    }
                </style>
            </head>
            <body>
                <header class="hero">
                    <div class="univ">Pamantasan ng Lungsod ng Pasig</div>
                    <h1>Faculty Workload Report</h1>
                    <div class="tag">SARMS: Smart Academic Records Management System | Group 3</div>
                </header>

                <div class="container">
                    
                    <div class="card">
                        <div class="toolbar">
                            <div>
                                <strong style="font-size:1.05rem;color:var(--text-dark)">Faculty Workload</strong>
                                <div style="color:var(--muted);font-size:.92rem;margin-top:.25rem">Academic Resource Management — read-only</div>
                            </div>
                        </div>

                        <table>
                            <thead>
                                <tr>
                                    <th style="width:10%">ID</th>
                                    <th style="width:30%">Faculty Member</th>
                                    <th style="width:45%">Teaching Load</th>
                                    <th style="width:15%">Total Hours</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="faculty/facultyMember">
                                    <xsl:variable name="pct" select="(number(totalHours) * 100) div 30"/>
                                    <tr>
                                        <xsl:if test="number(totalHours) &gt;= 30">
                                            <xsl:attribute name="class">overloaded</xsl:attribute>
                                        </xsl:if>
                                        <td class="id"><xsl:value-of select="id"/></td>
                                        <td class="faculty-info">
                                            <span class="faculty-name"><xsl:value-of select="name"/></span>
                                            <span class="faculty-dept"><xsl:value-of select="department"/></span>
                                        </td>
                                        <td>
                                            <div class="load-list">
                                                <xsl:for-each select="subjects/subject">
                                                    <span class="subject-tag"><xsl:value-of select="subjectName"/>
                                                        <xsl:text> </xsl:text>
                                                        <small style="color:var(--muted);font-weight:500;margin-left:.25rem">(<xsl:value-of select="hours"/>)</small>
                                                    </span>
                                                </xsl:for-each>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="hours-cell">
                                                <div class="hours-val"><xsl:value-of select="totalHours"/><span class="limit">/ 30</span></div>
                                                <div class="progress" role="progressbar" aria-valuemin="0" aria-valuemax="30" aria-valuenow="{totalHours}">
                                                    <div class="progress-fill">
                                                        <xsl:attribute name="style">width: <xsl:value-of select="$pct"/>%;</xsl:attribute>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>