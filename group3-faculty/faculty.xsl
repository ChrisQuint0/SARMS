<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width,initial-scale=1"/>
                <title>Faculty Workload | FAMS</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
                <style>
                    :root{
                        --fams-green: #0b6b3e;
                        --fams-green-600: #0f8a4b;
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
                        background:linear-gradient(90deg,var(--fams-green),var(--fams-green-600));
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
                    .toolbar{display:flex;justify-content:space-between;align-items:center;padding:1.5rem 1.5rem 1.25rem;border-bottom:1px solid #e6f6ea;gap:1.5rem;flex-wrap:wrap}
                    .toolbar-info{flex:1;min-width:200px}
                    .toolbar-actions{display:flex;gap:1rem;align-items:center;flex:2;justify-content:flex-end;min-width:320px}
                    
                    .search-box{position:relative;flex:1;max-width:350px}
                    .search-box i{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:var(--muted);font-size:.85rem;pointer-events:none}
                    .search-box input{width:100%;padding:.65rem 1rem .65rem 2.4rem;border-radius:10px;border:1.5px solid #edf2ef;font-family:inherit;font-size:.9rem;transition:all .2s ease;background:#fcfdfc}
                    .search-box input:focus{outline:none;border-color:var(--fams-green);box-shadow:0 0 0 4px rgba(11,107,62,0.06);background:#fff}
                    
                    #deptFilter, #statusFilter, #subjectFilter, #sortFilter{padding:.65rem 1rem;border-radius:10px;border:1.5px solid #edf2ef;font-family:inherit;font-size:.9rem;background:#fcfdfc;cursor:pointer;transition:all .2s ease;min-width:180px;color:var(--text-dark);font-weight:500}
                    #deptFilter:focus, #statusFilter:focus, #subjectFilter:focus, #sortFilter:focus{outline:none;border-color:var(--fams-green);background:#fff}

                    .no-results{padding:4rem 2rem;text-align:center;color:var(--muted);display:none}
                    .no-results i{font-size:3rem;margin-bottom:1.5rem;color:#e2e8f0;display:block}
                    .no-results h3{margin:0;color:var(--text-dark);font-size:1.25rem}

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
                    .subject-tag{background:linear-gradient(180deg,#fafff9,#f6fff7);border:1px solid var(--border);padding:.4rem .7rem;border-radius:6px;color:var(--fams-green);font-weight:600;font-size:.8rem;white-space:nowrap}

                    /* Hours with progress */
                    .hours-cell{display:flex;flex-direction:column;gap:.6rem;align-items:flex-start;width:22%;min-width:220px}
                    .hours-val{font-weight:700;color:var(--text-dark);display:flex;align-items:center;gap:.4rem;font-size:1.05rem}
                    .hours-val .limit{font-weight:500;color:var(--muted);font-size:.85rem}
                    .progress{width:100%;max-width:220px;height:8px;background:#e6f6ea;border-radius:999px;overflow:hidden}
                    .progress-fill{height:100%;background:var(--fams-green-600);width:0%;transition:width .6s ease}

                    .normal-load .progress-fill{background:var(--fams-green-600)}
                    .heavy-load td{background:#fffbea}
                    .heavy-load .progress-fill{background:#d97706}
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
                        <a href="../sarms.xml" class="module-card">
                            <i class="fas fa-th"></i>
                            <h3>Dashboard</h3>
                            <p>Unified view with statistics and charts</p>
                            <span class="view-link">
                                <i class="fas fa-arrow-right" style="font-size: 10px;"></i> Go to Dashboard
                            </span>
                        </a>
                        <a href="../group1-enrollment/students.xml" class="module-card">
                            <i class="fas fa-user-graduate"></i>
                            <h3>Student Enrollment</h3>
                            <p>Manage student records, enrollments, and academic performance</p>
                            <span class="view-link">
                                <i class="fas fa-arrow-right" style="font-size: 10px;"></i> View Module
                            </span>
                        </a>
                        <a href="../group3-faculty/faculty.xml" class="module-card" style="border-color: #008a45; background: #f0fdf4;">
                            <i class="fas fa-chalkboard-teacher"></i>
                            <h3>Faculty Workload</h3>
                            <p>Track faculty assignments, teaching hours, and workload distribution (Current Page)</p>
                            <span class="view-link">
                                ✓ Current Module
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
                    //<![CDATA[
                    function toggleModal() {
                        const modal = document.getElementById('moduleModal');
                        const overlay = document.getElementById('modalOverlay');
                        const button = document.querySelector('.menu-button');
                        modal.classList.toggle('active');
                        overlay.classList.toggle('active');
                        button.classList.toggle('active');
                    }

                    function getLoadStatus(hours) {
                        if (hours > 20) return 'overloaded';
                        if (hours >= 15) return 'heavy';
                        return 'normal';
                    }

                    function sortRows(rows, sortValue) {
                        const sortedRows = [...rows];

                        sortedRows.sort((a, b) => {
                            if (sortValue === 'hours-desc') {
                                return Number(b.dataset.hours) - Number(a.dataset.hours);
                            }
                            if (sortValue === 'hours-asc') {
                                return Number(a.dataset.hours) - Number(b.dataset.hours);
                            }
                            if (sortValue === 'subjects-desc') {
                                return Number(b.dataset.subjectCount) - Number(a.dataset.subjectCount);
                            }
                            if (sortValue === 'subjects-asc') {
                                return Number(a.dataset.subjectCount) - Number(b.dataset.subjectCount);
                            }
                            if (sortValue === 'department') {
                                return a.dataset.department.localeCompare(b.dataset.department) || a.dataset.name.localeCompare(b.dataset.name);
                            }
                            return a.dataset.name.localeCompare(b.dataset.name);
                        });

                        return sortedRows;
                    }

                    function filterTable() {
                        const searchValue = document.getElementById('searchInput').value.toLowerCase().trim();
                        const deptValue = document.getElementById('deptFilter').value;
                        const subjectValue = document.getElementById('subjectFilter').value;
                        const statusValue = document.getElementById('statusFilter').value;
                        const sortValue = document.getElementById('sortFilter').value;
                        const tbody = document.querySelector('tbody');
                        const rows = document.querySelectorAll('tbody tr');
                        let visibleCount = 0;

                        const sortedRows = sortRows(rows, sortValue);
                        sortedRows.forEach(row => tbody.appendChild(row));

                        sortedRows.forEach(row => {
                            const name = row.dataset.name;
                            const id = row.dataset.id;
                            const dept = row.dataset.department;
                            const subjects = row.dataset.subjects;
                            const hours = Number(row.dataset.hours);
                            const loadStatus = getLoadStatus(hours);
                            
                            const matchesSearch = name.includes(searchValue) || id.includes(searchValue) || subjects.includes(searchValue);
                            const matchesDept = deptValue === 'all' || dept === deptValue;
                            const matchesSubject = subjectValue === 'all' || row.dataset.subjectList.split('|').includes(subjectValue);
                            const matchesStatus = statusValue === 'all' || statusValue === loadStatus;

                            if (matchesSearch && matchesDept && matchesSubject && matchesStatus) {
                                row.style.display = '';
                                visibleCount++;
                            } else {
                                row.style.display = 'none';
                            }
                        });

                        document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
                        document.querySelector('table').style.display = visibleCount === 0 ? 'none' : 'table';
                    }

                    // Populate departments dropdown dynamically
                    document.addEventListener('DOMContentLoaded', function() {
                        const depts = new Set();
                        const subjects = new Set();
                        document.querySelectorAll('.faculty-dept').forEach(dept => {
                            depts.add(dept.textContent.trim());
                        });
                        document.querySelectorAll('.subject-tag').forEach(subject => {
                            const subjectName = subject.getAttribute('data-subject-name');
                            if (subjectName) subjects.add(subjectName);
                        });
                        
                        const filter = document.getElementById('deptFilter');
                        Array.from(depts).sort().forEach(dept => {
                            const option = document.createElement('option');
                            option.value = dept;
                            option.textContent = dept;
                            filter.appendChild(option);
                        });

                        const subjectFilter = document.getElementById('subjectFilter');
                        Array.from(subjects).sort().forEach(subject => {
                            const option = document.createElement('option');
                            option.value = subject;
                            option.textContent = subject;
                            subjectFilter.appendChild(option);
                        });

                        filterTable();
                    });
                    //]]>
                </script>

                <header class="hero">
                    <div class="univ">Pamantasan ng Lungsod ng Pasig</div>
                    <h1>Faculty Workload Report</h1>
                    <div class="tag">FAMS: Faculty Academic Management System | Group 3</div>
                </header>

                <div class="container">

                    
                    <div class="card">
                        <div class="toolbar">
                            <div class="toolbar-info">
                                <strong style="font-size:1.05rem;color:var(--text-dark)">Faculty Workload</strong>
                                <div style="color:var(--muted);font-size:.92rem;margin-top:.25rem">Academic Resource Management — read-only</div>
                            </div>
                            <div class="toolbar-actions">
                                <div class="search-box">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="searchInput" placeholder="Search name, ID, or subj..." onkeyup="filterTable()" />
                                </div>
                                <select id="deptFilter" onchange="filterTable()">
                                    <option value="all">All Departments</option>
                                </select>
                                <select id="statusFilter" onchange="filterTable()">
                                    <option value="all">All Load Status</option>
                                    <option value="normal">Normal Load</option>
                                    <option value="heavy">Heavy Load</option>
                                    <option value="overloaded">Overloaded</option>
                                </select>
                                <select id="subjectFilter" onchange="filterTable()">
                                    <option value="all">All Subjects</option>
                                </select>
                                <select id="sortFilter" onchange="filterTable()">
                                    <option value="name">Sort: Name</option>
                                    <option value="hours-desc">Sort: Hours High-Low</option>
                                    <option value="hours-asc">Sort: Hours Low-High</option>
                                    <option value="subjects-desc">Sort: Subjects High-Low</option>
                                    <option value="subjects-asc">Sort: Subjects Low-High</option>
                                    <option value="department">Sort: Department</option>
                                </select>
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
                                    <xsl:variable name="subjectCount" select="count(subjects/subject)"/>
                                    <tr>
                                        <xsl:attribute name="class">
                                            <xsl:choose>
                                                <xsl:when test="number(totalHours) &gt; 20">overloaded</xsl:when>
                                                <xsl:when test="number(totalHours) &gt;= 15">heavy-load</xsl:when>
                                                <xsl:otherwise>normal-load</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:attribute name="data-id"><xsl:value-of select="translate(id, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:attribute>
                                        <xsl:attribute name="data-name"><xsl:value-of select="translate(name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:attribute>
                                        <xsl:attribute name="data-department"><xsl:value-of select="department"/></xsl:attribute>
                                        <xsl:attribute name="data-hours"><xsl:value-of select="totalHours"/></xsl:attribute>
                                        <xsl:attribute name="data-subject-count"><xsl:value-of select="$subjectCount"/></xsl:attribute>
                                        <xsl:attribute name="data-subjects">
                                            <xsl:for-each select="subjects/subject">
                                                <xsl:if test="position() &gt; 1"><xsl:text> </xsl:text></xsl:if>
                                                <xsl:value-of select="translate(subjectName, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                        <xsl:attribute name="data-subject-list">
                                            <xsl:for-each select="subjects/subject">
                                                <xsl:if test="position() &gt; 1"><xsl:text>|</xsl:text></xsl:if>
                                                <xsl:value-of select="subjectName"/>
                                            </xsl:for-each>
                                        </xsl:attribute>
                                        <td class="id"><xsl:value-of select="id"/></td>
                                        <td class="faculty-info">
                                            <span class="faculty-name"><xsl:value-of select="name"/></span>
                                            <span class="faculty-dept"><xsl:value-of select="department"/></span>
                                        </td>
                                        <td>
                                            <div class="load-list">
                                                <xsl:for-each select="subjects/subject">
                                                    <span class="subject-tag">
                                                        <xsl:attribute name="data-subject-name"><xsl:value-of select="subjectName"/></xsl:attribute>
                                                        <xsl:value-of select="subjectName"/>
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
                        <div id="noResults" class="no-results">
                            <i class="fas fa-search"></i>
                            <h3>No faculty members found</h3>
                            <p>Try adjusting your search or filter to find what you're looking for.</p>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
