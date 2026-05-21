<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Load enrollment.xml as a variable for joining -->
  <xsl:variable name="enrollment" select="document('../group1-enrollment/students.xml')/students/student"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Library Management System</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&amp;display=swap"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --green:      #008A45;
  --green-dark: #006633;
  --green-light:#00C76F;
  --green-pale: #f0fdf4;
  --green-muted:#bbf7d0;
  --bg:         #f4f9f6;
  --card:       #ffffff;
  --text:       #0f172a;
  --muted:      #4b5563;
  --border:     #e6f6ea;
  --danger:     #dc2626;
  --danger-bg:  #fff1f2;
  --radius:     12px;
}

body {
  font-family: 'Inter', system-ui, sans-serif;
  background: var(--bg);
  color: var(--text);
  min-height: 100vh;
}

.site-header {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 100;
  background: linear-gradient(135deg, var(--green) 0%, var(--green-dark) 100%);
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  overflow: visible;
}

.site-header::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
  opacity: 1;
  pointer-events: none;
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
  padding: 16px 24px;
}

.header-logo {
  width: 64px; height: 64px;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.header-logo img { width: 100%; height: 100%; object-fit: contain; }
.header-text { flex: 1; }
.header-text h1 { font-size: 28px; font-weight: 700; color: #fff; margin-bottom: 2px; letter-spacing: -0.5px; }
.header-text .tagline { font-size: 14px; color: rgba(255,255,255,0.9); }

.header-stats { display: flex; gap: 8px; flex-wrap: nowrap; overflow-x: auto; scrollbar-width: none; }
.header-stats::-webkit-scrollbar { display: none; }

.hstat { display: flex; align-items: center; gap: 10px; background: rgba(255,255,255,0.10); border: 1px solid rgba(255,255,255,0.13); border-radius: 12px; padding: 10px 16px; flex-shrink: 0; transition: background 0.15s; backdrop-filter: blur(10px); }
.hstat:hover { background: rgba(255,255,255,0.20); }
.hstat-icon { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: 800; letter-spacing: 0.3px; flex-shrink: 0; }
.hstat-icon.books    { background: rgba(255,255,255,0.15); color: #d1fae5; }
.hstat-icon.records  { background: rgba(255,255,255,0.15); color: #d1fae5; }
.hstat-icon.active   { background: rgba(52,211,153,0.25);  color: #6ee7b7; }
.hstat-icon.returned { background: rgba(96,165,250,0.20);  color: #93c5fd; }
.hstat-icon.overdue  { background: rgba(248,113,113,0.22); color: #fca5a5; }
.hstat-icon.late     { background: rgba(251,191,36,0.22);  color: #fde68a; }
.hstat-num { font-size: 22px; font-weight: 800; color: #fff; line-height: 1; }
.hstat-num.green  { color: #34d399; }
.hstat-num.blue   { color: #93c5fd; }
.hstat-num.red    { color: #f87171; }
.hstat-num.orange { color: #fbbf24; }
.hstat-num.purple { color: #d1fae5; }
.hstat-lbl { font-size: 10px; color: #bbf7d0; font-weight: 600; text-transform: uppercase; letter-spacing: 0.6px; margin-top: 2px; }

.menu-button { position: fixed; top: 24px; left: 24px; width: 56px; height: 56px; background: var(--green); border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; z-index: 1100; box-shadow: 0 4px 12px rgba(0,138,69,0.35); transition: all 0.3s cubic-bezier(0.4,0,0.2,1); border: none; }
.menu-button:hover { transform: scale(1.05); box-shadow: 0 6px 16px rgba(0,138,69,0.45); }
.menu-button i { color: white; font-size: 22px; transition: transform 0.3s ease; }
.menu-button.active i { transform: rotate(90deg); }

.nav-modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); backdrop-filter: blur(4px); z-index: 999; opacity: 0; visibility: hidden; transition: all 0.3s ease; }
.nav-modal-overlay.active { opacity: 1; visibility: visible; }

.module-modal { position: fixed; top: 50%; left: 50%; transform: translate(-50%,-50%) scale(0.9); background: white; border-radius: 24px; padding: 40px; z-index: 1001; max-width: 900px; width: 90%; max-height: 80vh; overflow-y: auto; opacity: 0; visibility: hidden; transition: all 0.3s cubic-bezier(0.4,0,0.2,1); box-shadow: 0 20px 60px rgba(0,0,0,0.2); }
.module-modal.active { opacity: 1; visibility: visible; transform: translate(-50%,-50%) scale(1); }
.modal-nav-header { margin-bottom: 32px; }
.modal-nav-header h2 { font-size: 32px; font-weight: 800; color: var(--green); margin-bottom: 8px; }
.modal-nav-header p  { font-size: 16px; color: #6b7280; }

.module-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; }
.module-card { background: white; border: 2px solid #e5e7eb; border-radius: 16px; padding: 24px; cursor: pointer; transition: all 0.3s cubic-bezier(0.4,0,0.2,1); position: relative; overflow: hidden; text-decoration: none; color: inherit; display: block; }
.module-card::before { content: ""; position: absolute; inset: 0; background: linear-gradient(135deg, var(--green), var(--green-light)); opacity: 0; transition: all 0.3s ease; }
.module-card:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(0,138,69,0.15); border-color: var(--green); }
.module-card:hover::before { opacity: 0.03; }
.module-card i { font-size: 28px; color: var(--green); margin-bottom: 12px; display: block; position: relative; z-index: 1; }
.module-card h3 { font-size: 18px; font-weight: 700; color: #1a1a1a; margin-bottom: 8px; position: relative; z-index: 1; }
.module-card p  { font-size: 13px; color: #6b7280; line-height: 1.5; margin-bottom: 12px; position: relative; z-index: 1; }
.module-card .view-link { font-size: 13px; color: var(--green); font-weight: 600; display: flex; align-items: center; gap: 6px; position: relative; z-index: 1; transition: gap 0.2s ease; }
.module-card:hover .view-link { gap: 8px; }

.page-body { padding-top: 110px; }
.container { max-width: 1300px; margin: 0 auto; padding: 32px 24px 60px; }

.section-title { font-size: 14px; font-weight: 700; color: var(--green-dark); text-transform: uppercase; letter-spacing: 1px; padding-bottom: 10px; border-bottom: 2px solid var(--green); margin-bottom: 18px; margin-top: 44px; display: flex; align-items: center; gap: 10px; }
.section-title:first-of-type { margin-top: 0; }
.section-count { margin-left: auto; background: var(--green-pale); color: var(--green-dark); font-size: 11px; font-weight: 700; padding: 3px 12px; border-radius: 20px; text-transform: none; letter-spacing: 0; }
.section-count.red { background: #fee2e2; color: var(--danger); }

.controls { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 14px; align-items: center; }
.search-wrap { flex: 1; min-width: 200px; position: relative; }
.search-wrap input { width: 100%; padding: 9px 14px 9px 36px; border: 1.5px solid #cbd5e1; border-radius: 8px; font-family: 'Inter', sans-serif; font-size: 13px; background: #fff; color: var(--text); outline: none; transition: border-color .2s, box-shadow .2s; }
.search-wrap input:focus { border-color: var(--green); box-shadow: 0 0 0 3px rgba(0,138,69,0.10); }
.search-icon { position: absolute; left: 11px; top: 50%; transform: translateY(-50%); color: #94a3b8; }
.filter-row { display: flex; gap: 6px; flex-wrap: wrap; }
.fbtn { padding: 7px 14px; border-radius: 6px; border: 1.5px solid #cbd5e1; background: #fff; font-family: 'Inter', sans-serif; font-size: 12px; font-weight: 600; color: #475569; cursor: pointer; transition: all .15s; }
.fbtn:hover { border-color: var(--green); color: var(--green); }
.fbtn.on        { background: var(--green); border-color: var(--green); color: #fff; }
.fbtn.on-red    { background: #dc2626; border-color: #dc2626; color: #fff; }
.fbtn.on-orange { background: #d97706; border-color: #d97706; color: #fff; }
.fbtn.on-green  { background: #16a34a; border-color: #16a34a; color: #fff; }
.sel { padding: 7px 10px; border: 1.5px solid #cbd5e1; border-radius: 6px; font-family: 'Inter', sans-serif; font-size: 12px; font-weight: 600; background: #fff; color: #475569; cursor: pointer; outline: none; }

.tbl-wrap { background: #fff; border-radius: 10px; border: 1px solid #e2e8f0; overflow: hidden; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table thead { background: linear-gradient(90deg, var(--green-dark), var(--green)); }
.data-table th { color: #d1fae5; padding: 12px 16px; text-align: left; font-size: 10px; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; white-space: nowrap; }
.data-table td { padding: 12px 16px; font-size: 13px; border-bottom: 1px solid #f1f5f9; color: #334155; }
.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover td { background: var(--green-pale); }
.data-table tr.overdue-row td { background: #fff5f5; }
.data-table tr.overdue-row:hover td { background: #fee2e2; }

.mono      { font-family: monospace; font-size: 11px; color: #475569; }
.bid       { font-family: monospace; font-size: 12px; color: var(--green); font-weight: 600; }
.bold-cell { font-weight: 600; color: #1e293b; }
.copies-pill { display: inline-block; background: var(--green-pale); color: var(--green-dark); font-size: 11px; font-weight: 700; padding: 2px 10px; border-radius: 12px; }
.cat-pill    { display: inline-block; background: var(--green-pale); color: #15803d; border: 1px solid var(--green-muted); font-size: 11px; font-weight: 600; padding: 2px 10px; border-radius: 12px; }
.status-pill { display: inline-block; padding: 3px 12px; border-radius: 20px; font-size: 10px; font-weight: 700; color: #fff; white-space: nowrap; }
.s-active   { background: #16a34a; }
.s-returned { background: var(--green); }
.s-overdue  { background: #dc2626; }
.s-late     { background: #d97706; }
.yr-pill    { display: inline-block; background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; font-size: 11px; font-weight: 600; padding: 2px 10px; border-radius: 12px; }

.notice-grid-wrap { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px,1fr)); gap: 14px; }
.notice-mini { background: #fff; border-radius: 10px; border: 1px solid #fecaca; border-left: 4px solid #dc2626; padding: 16px 18px; cursor: pointer; transition: box-shadow .18s, transform .18s; position: relative; }
.notice-mini:hover { box-shadow: 0 4px 18px rgba(220,38,38,0.13); transform: translateY(-2px); }
.notice-mini-name  { font-size: 14px; font-weight: 700; color: #991b1b; margin-bottom: 6px; }
.notice-mini-row   { font-size: 12px; color: #64748b; margin-bottom: 3px; display: flex; gap: 6px; }
.notice-mini-row span:first-child { font-weight: 600; color: #94a3b8; width: 68px; flex-shrink: 0; }
.notice-mini-due   { color: #dc2626; font-weight: 700; }
.notice-mini-tag   { position: absolute; top: 12px; right: 14px; background: #fee2e2; color: #dc2626; font-size: 9px; font-weight: 800; padding: 3px 10px; border-radius: 20px; letter-spacing: 0.5px; }
.notice-mini-footer{ margin-top: 10px; font-size: 11px; color: var(--green); font-weight: 600; display: flex; align-items: center; gap: 4px; }

.modal-overlay { display: none; position: fixed; inset: 0; background: rgba(15,23,42,0.55); z-index: 1200; align-items: center; justify-content: center; padding: 20px; }
.modal-overlay.open { display: flex; }
.modal { background: #fff; border-radius: 14px; width: 100%; max-width: 560px; max-height: 90vh; overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,0.22); animation: modalIn .2s ease; }
@keyframes modalIn { from { opacity: 0; transform: translateY(20px) scale(0.97); } to { opacity: 1; transform: none; } }
.modal-head { background: linear-gradient(135deg, var(--green-dark), var(--green)); padding: 20px 24px; display: flex; justify-content: space-between; align-items: flex-start; gap: 12px; border-radius: 14px 14px 0 0; }
.modal-head-name { font-size: 17px; font-weight: 700; color: #fff; }
.modal-head-sub  { font-size: 12px; color: #bbf7d0; margin-top: 3px; }
.modal-close { background: rgba(255,255,255,0.15); border: none; color: #fff; width: 30px; height: 30px; border-radius: 50%; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; flex-shrink: 0; transition: background .15s; }
.modal-close:hover { background: rgba(255,255,255,0.28); }
.modal-body { padding: 20px 24px; }
.modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; margin-bottom: 16px; }
.modal-field { padding: 11px 16px; border-bottom: 1px solid #f1f5f9; display: flex; flex-direction: column; gap: 3px; }
.modal-field:nth-child(odd)  { background: #fff; border-right: 1px solid #f1f5f9; }
.modal-field:nth-child(even) { background: #fafafa; }
.modal-field:nth-last-child(-n+2) { border-bottom: none; }
.mf-label { font-size: 10px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; }
.mf-val   { font-size: 13px; font-weight: 600; color: #1e293b; }
.mf-val.due { color: #dc2626; }
.modal-warn { background: #fee2e2; border: 1px solid #fecaca; border-radius: 8px; padding: 12px 16px; font-size: 13px; font-weight: 600; color: #991b1b; text-align: center; display: flex; align-items: center; justify-content: center; gap: 8px; }

.pager { display: flex; align-items: center; gap: 4px; padding: 16px 0 4px; justify-content: center; flex-wrap: wrap; }
.pager-info { font-size: 12px; color: #64748b; font-weight: 600; margin-right: 8px; }
.pager-btn { min-width: 34px; height: 34px; padding: 0 8px; border-radius: 7px; border: 1.5px solid #e2e8f0; background: #fff; font-family: 'Inter', sans-serif; font-size: 13px; font-weight: 600; color: #475569; cursor: pointer; transition: all .15s; display: flex; align-items: center; justify-content: center; }
.pager-btn:hover:not(:disabled) { border-color: var(--green); color: var(--green); }
.pager-btn.on { background: var(--green); border-color: var(--green); color: #fff; }
.pager-btn:disabled { opacity: .3; cursor: not-allowed; }
.pager-dots { color: #94a3b8; font-weight: 700; padding: 0 2px; align-self: center; }

.empty-msg { text-align: center; padding: 40px; background: #fff; border-radius: 10px; border: 1px solid #e2e8f0; color: #94a3b8; font-size: 14px; font-style: italic; }
.footer { text-align: center; padding: 18px; background: #fff; border-top: 1px solid #e2e8f0; font-size: 12px; color: #94a3b8; margin-top: 8px; }

::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: var(--bg); }
::-webkit-scrollbar-thumb { background: var(--green-muted); border-radius: 4px; }

@media (max-width: 768px) {
  .header-content { margin-left: 80px; gap: 16px; padding: 12px 16px; }
  .header-logo { width: 48px; height: 48px; }
  .header-text h1 { font-size: 20px; }
  .header-text .tagline { font-size: 12px; }
  .header-stats { gap: 6px; }
  .page-body { padding-top: 130px; }
  .container { padding: 24px 14px 50px; }
  .tbl-wrap { overflow-x: auto; }
  .notice-grid-wrap { grid-template-columns: 1fr; }
  .modal-grid { grid-template-columns: 1fr; }
  .modal-field:nth-child(odd) { border-right: none; }
}
        </style>
      </head>
      <body>

        <button class="menu-button" onclick="toggleNavModal()">
          <i class="fas fa-th"></i>
        </button>

        <div class="nav-modal-overlay" id="navModalOverlay" onclick="toggleNavModal()"></div>

        <div class="module-modal" id="moduleModal">
          <div class="modal-nav-header">
            <h2>Module Navigation</h2>
            <p>Select a module to view detailed information</p>
          </div>
          <div class="module-grid">
            <a href="../sarms.xml" class="module-card">
              <i class="fas fa-th"></i>
              <h3>Dashboard</h3>
              <p>Unified view with statistics and charts</p>
              <span class="view-link"><i class="fas fa-arrow-right" style="font-size:10px"></i> Go to Dashboard</span>
            </a>
            <a href="../group1-enrollment/students.xml" class="module-card">
              <i class="fas fa-user-graduate"></i>
              <h3>Student Enrollment</h3>
              <p>Manage student records, enrollments, and academic performance</p>
              <span class="view-link"><i class="fas fa-arrow-right" style="font-size:10px"></i> View Module</span>
            </a>
            <a href="../group3-faculty/faculty.xml" class="module-card">
              <i class="fas fa-chalkboard-teacher"></i>
              <h3>Faculty Workload</h3>
              <p>Track faculty assignments, teaching hours, and workload distribution</p>
              <span class="view-link"><i class="fas fa-arrow-right" style="font-size:10px"></i> View Module</span>
            </a>
            <a href="../group4-library/library.xml" class="module-card" style="border-color:#008A45;background:#f0fdf4;">
              <i class="fas fa-book"></i>
              <h3>Library Management</h3>
              <p>Manage books, borrowing records, and library resources (Current Page)</p>
              <span class="view-link">&#10003; Current Module</span>
            </a>
            <a href="../group5-billing/billing.xml" class="module-card">
              <i class="fas fa-file-invoice-dollar"></i>
              <h3>Student Billing</h3>
              <p>Track tuition fees, payments, and outstanding balances</p>
              <span class="view-link"><i class="fas fa-arrow-right" style="font-size:10px"></i> View Module</span>
            </a>
            <a href="../group6-events/events.xml" class="module-card">
              <i class="fas fa-calendar-alt"></i>
              <h3>Event Management</h3>
              <p>Organize university events, registrations, and attendance</p>
              <span class="view-link"><i class="fas fa-arrow-right" style="font-size:10px"></i> View Module</span>
            </a>
          </div>
        </div>

        <div class="modal-overlay" id="notice-modal" onclick="closeModalOutside(event)">
          <div class="modal" id="modal-box">
            <div class="modal-head">
              <div>
                <div class="modal-head-name" id="m-name"></div>
                <div class="modal-head-sub">Overdue Notice</div>
              </div>
              <button class="modal-close" onclick="closeModal()">&#215;</button>
            </div>
            <div class="modal-body">
              <div class="modal-grid" id="m-grid"></div>
              <div class="modal-warn">
                <i class="fas fa-exclamation-triangle"></i>
                NOTICE: This book is OVERDUE. Please return immediately to avoid penalties.
              </div>
            </div>
          </div>
        </div>

        <header class="site-header">
          <div class="header-content">
            <div class="header-logo">
              <img src="../group6-events/PLP_logo.png" alt="PLP Logo"/>
            </div>
            <div class="header-text">
              <h1>Library Management System</h1>
              <div class="tagline">Pamantasan ng Lungsod ng Pasig — Group 4</div>
            </div>
            <div class="header-stats">
              <div class="hstat">
                <div class="hstat-icon books">BK</div>
                <div>
                  <div class="hstat-num purple"><xsl:value-of select="count(/library/books/book)"/></div>
                  <div class="hstat-lbl">Books</div>
                </div>
              </div>
              <div class="hstat">
                <div class="hstat-icon records">RC</div>
                <div>
                  <div class="hstat-num"><xsl:value-of select="count(/library/borrowingRecords/record)"/></div>
                  <div class="hstat-lbl">Records</div>
                </div>
              </div>
              <div class="hstat">
                <div class="hstat-icon active">AC</div>
                <div>
                  <div class="hstat-num green"><xsl:value-of select="count(/library/borrowingRecords/record[status='Active'])"/></div>
                  <div class="hstat-lbl">Active</div>
                </div>
              </div>
              <div class="hstat">
                <div class="hstat-icon returned">RT</div>
                <div>
                  <div class="hstat-num blue"><xsl:value-of select="count(/library/borrowingRecords/record[status='Returned'])"/></div>
                  <div class="hstat-lbl">Returned</div>
                </div>
              </div>
              <div class="hstat">
                <div class="hstat-icon overdue">OD</div>
                <div>
                  <div class="hstat-num red"><xsl:value-of select="count(/library/borrowingRecords/record[status='Overdue'])"/></div>
                  <div class="hstat-lbl">Overdue</div>
                </div>
              </div>
              <div class="hstat">
                <div class="hstat-icon late">LT</div>
                <div>
                  <div class="hstat-num orange"><xsl:value-of select="count(/library/borrowingRecords/record[status='Returned Late'])"/></div>
                  <div class="hstat-lbl">Late</div>
                </div>
              </div>
            </div>
          </div>
        </header>

        <div class="page-body">
          <div class="container">

            <div class="section-title">
              <i class="fas fa-book" style="color:var(--green)"></i>
              Book Inventory
              <span class="section-count" id="book-count-pill">
                <xsl:value-of select="count(/library/books/book)"/> Books
              </span>
            </div>

            <div class="controls">
              <div class="search-wrap">
                <svg class="search-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                </svg>
                <input type="text" id="book-q" placeholder="Search title, author, category…" oninput="renderBooks()"/>
              </div>
              <div class="filter-row" id="cat-btns">
                <button class="fbtn on" onclick="setBookCat('all',this)">All</button>
              </div>
              <select class="sel" id="book-pp" onchange="renderBooks()">
                <option value="6">6 / page</option>
                <option value="10" selected="selected">10 / page</option>
                <option value="20">20 / page</option>
                <option value="9999">All</option>
              </select>
            </div>

            <div class="tbl-wrap">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Book ID</th><th>Title</th><th>Author</th>
                    <th>Category</th><th>ISBN</th><th>Copies</th>
                  </tr>
                </thead>
                <tbody id="book-tbody">
                  <xsl:apply-templates select="/library/books/book"/>
                </tbody>
              </table>
            </div>
            <div id="book-empty" class="empty-msg" style="display:none">No books match your search.</div>
            <div class="pager" id="book-pager"></div>

            <div class="section-title">
              <i class="fas fa-clipboard-list" style="color:var(--green)"></i>
              Borrowing Records
              <span class="section-count" id="rec-count-pill">
                <xsl:value-of select="count(/library/borrowingRecords/record)"/> Records
              </span>
            </div>

            <div class="controls">
              <div class="search-wrap">
                <svg class="search-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                </svg>
                <input type="text" id="rec-q" placeholder="Search name, ID, course, year level…" oninput="renderRecords()"/>
              </div>
              <div class="filter-row" id="rec-filter-row">
                <button class="fbtn on"  onclick="setRecStatus('all',this)">All</button>
                <button class="fbtn"     onclick="setRecStatus('Active',this)">Active</button>
                <button class="fbtn"     onclick="setRecStatus('Returned',this)">Returned</button>
                <button class="fbtn"     onclick="setRecStatus('Overdue',this)">Overdue</button>
                <button class="fbtn"     onclick="setRecStatus('Returned Late',this)">Late</button>
              </div>
              <select class="sel" id="rec-pp" onchange="renderRecords()">
                <option value="5">5 / page</option>
                <option value="10" selected="selected">10 / page</option>
                <option value="20">20 / page</option>
                <option value="9999">All</option>
              </select>
            </div>

            <div class="tbl-wrap">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Record ID</th><th>Book ID</th><th>Borrower ID</th>
                    <th>Full Name</th><th>Type</th><th>Course</th>
                    <th>Year Level</th><th>Borrow Date</th>
                    <th>Due Date</th><th>Return Date</th><th>Status</th>
                  </tr>
                </thead>
                <tbody id="rec-tbody">
                  <xsl:apply-templates select="/library/borrowingRecords/record"/>
                </tbody>
              </table>
            </div>
            <div id="rec-empty" class="empty-msg" style="display:none">No records match your filter.</div>
            <div class="pager" id="rec-pager"></div>

            <div class="section-title" style="border-bottom-color:#dc2626;color:#dc2626;">
              <i class="fas fa-exclamation-circle" style="color:#dc2626"></i>
              Overdue Notices
              <span class="section-count red" id="notice-count-pill">
                <xsl:value-of select="count(/library/borrowingRecords/record[status='Overdue'])"/> Overdue
              </span>
            </div>

            <div class="controls">
              <div class="search-wrap">
                <svg class="search-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                </svg>
                <input type="text" id="notice-q" placeholder="Search overdue notices…" oninput="renderNotices()"/>
              </div>
              <select class="sel" id="notice-pp" onchange="renderNotices()">
                <option value="3">3 / page</option>
                <option value="6" selected="selected">6 / page</option>
                <option value="9999">All</option>
              </select>
            </div>

            <div id="notice-wrap" class="notice-grid-wrap">
              <xsl:choose>
                <xsl:when test="/library/borrowingRecords/record[status='Overdue']">
                  <xsl:apply-templates select="/library/borrowingRecords/record[status='Overdue']" mode="notice"/>
                </xsl:when>
                <xsl:otherwise>
                  <div class="empty-msg">No overdue records.</div>
                </xsl:otherwise>
              </xsl:choose>
            </div>
            <div class="pager" id="notice-pager"></div>

          </div>
          <div class="footer">
            Library Management System — Group 4 | Pamantasan ng Lungsod ng Pasig
          </div>
        </div>

        <script>
//<![CDATA[

function toggleNavModal() {
  var modal   = document.getElementById('moduleModal');
  var overlay = document.getElementById('navModalOverlay');
  var button  = document.querySelector('.menu-button');
  modal.classList.toggle('active');
  overlay.classList.toggle('active');
  button.classList.toggle('active');
}

function fmtDate(raw) {
  if (!raw || raw.trim() === '' || raw.trim() === '—') return '—';
  var d = new Date(raw.trim());
  if (isNaN(d.getTime())) return raw;
  var months = ['January','February','March','April','May','June',
                'July','August','September','October','November','December'];
  return months[d.getMonth()] + ' ' + d.getDate() + ', ' + d.getFullYear();
}

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('td.date-cell').forEach(function (td) {
    td.textContent = fmtDate(td.textContent);
  });
});

function buildPager(id, total, page, pp, cb) {
  var c = document.getElementById(id);
  if (!c) return;
  c.innerHTML = '';
  if (pp >= 9999 || total === 0) return;
  var pages = Math.ceil(total / pp);
  if (pages <= 1) return;
  var info = document.createElement('span');
  info.className = 'pager-info';
  info.textContent = 'Page ' + page + ' of ' + pages;
  c.appendChild(info);
  function mkBtn(html, disabled, active, goTo) {
    var b = document.createElement('button');
    b.className = 'pager-btn' + (active ? ' on' : '');
    b.innerHTML = html; b.disabled = disabled;
    if (!disabled) b.onclick = function () { cb(goTo); };
    return b;
  }
  c.appendChild(mkBtn('&#8592;', page === 1, false, page - 1));
  var nums = [];
  if (pages <= 7) { for (var i = 1; i <= pages; i++) nums.push(i); }
  else {
    nums = [1];
    if (page > 3) nums.push('…');
    for (var i = Math.max(2,page-1); i <= Math.min(pages-1,page+1); i++) nums.push(i);
    if (page < pages-2) nums.push('…');
    nums.push(pages);
  }
  nums.forEach(function (n) {
    if (n === '…') { var d = document.createElement('span'); d.className='pager-dots'; d.textContent='…'; c.appendChild(d); }
    else { c.appendChild(mkBtn(n, false, n===page, n)); }
  });
  c.appendChild(mkBtn('&#8594;', page===pages, false, page+1));
}

var bookCat='all', bookPage=1;
(function(){
  var cats={};
  document.querySelectorAll('#book-tbody tr').forEach(function(r){ if(r.dataset.cat) cats[r.dataset.cat]=1; });
  var wrap=document.getElementById('cat-btns');
  Object.keys(cats).forEach(function(cat){
    var b=document.createElement('button'); b.className='fbtn'; b.textContent=cat;
    b.onclick=function(){ setBookCat(cat,b); }; wrap.appendChild(b);
  });
})();
function setBookCat(cat,el){
  bookCat=cat; bookPage=1;
  document.querySelectorAll('#cat-btns .fbtn').forEach(function(b){ b.classList.remove('on'); });
  el.classList.add('on'); renderBooks();
}
function renderBooks(){
  var q=(document.getElementById('book-q').value||'').toLowerCase();
  var pp=parseInt(document.getElementById('book-pp').value);
  var rows=Array.from(document.querySelectorAll('#book-tbody tr'));
  var vis=rows.filter(function(r){
    return (bookCat==='all'||r.dataset.cat===bookCat)&&(!q||(r.dataset.search||'').toLowerCase().includes(q));
  });
  rows.forEach(function(r){ r.style.display='none'; });
  vis.slice((bookPage-1)*pp,bookPage*pp).forEach(function(r){ r.style.display=''; });
  document.getElementById('book-empty').style.display=vis.length?'none':'';
  document.getElementById('book-count-pill').textContent=vis.length+' Books';
  buildPager('book-pager',vis.length,bookPage,pp,function(p){ bookPage=p; renderBooks(); });
}
renderBooks();

var recStatus='all', recPage=1;
function setRecStatus(s,el){
  recStatus=s; recPage=1;
  document.querySelectorAll('#rec-filter-row .fbtn').forEach(function(b){ b.classList.remove('on','on-red','on-orange','on-green'); });
  el.classList.add(s==='Overdue'?'on-red':s==='Returned Late'?'on-orange':s==='Active'?'on-green':'on');
  renderRecords();
}
function renderRecords(){
  var q=(document.getElementById('rec-q').value||'').toLowerCase();
  var pp=parseInt(document.getElementById('rec-pp').value);
  var rows=Array.from(document.querySelectorAll('#rec-tbody tr'));
  var vis=rows.filter(function(r){
    return (recStatus==='all'||r.dataset.status===recStatus)&&(!q||(r.dataset.search||'').toLowerCase().includes(q));
  });
  rows.forEach(function(r){ r.style.display='none'; });
  vis.slice((recPage-1)*pp,recPage*pp).forEach(function(r){ r.style.display=''; });
  document.getElementById('rec-empty').style.display=vis.length?'none':'';
  document.getElementById('rec-count-pill').textContent=vis.length+' Records';
  buildPager('rec-pager',vis.length,recPage,pp,function(p){ recPage=p; renderRecords(); });
}
renderRecords();

var noticePage=1;
function renderNotices(){
  var q=(document.getElementById('notice-q').value||'').toLowerCase();
  var pp=parseInt(document.getElementById('notice-pp').value);
  var cards=Array.from(document.querySelectorAll('#notice-wrap .notice-mini'));
  var vis=cards.filter(function(c){ return !q||(c.dataset.search||'').toLowerCase().includes(q); });
  cards.forEach(function(c){ c.style.display='none'; });
  vis.slice((noticePage-1)*pp,noticePage*pp).forEach(function(c){ c.style.display=''; });
  document.getElementById('notice-count-pill').textContent=vis.length+' Overdue';
  buildPager('notice-pager',vis.length,noticePage,pp,function(p){ noticePage=p; renderNotices(); });
}
renderNotices();

function openModal(data){
  document.getElementById('m-name').textContent=data.name;
  var fields=[
    {l:'Record ID',    v:data.recordId,   due:false},
    {l:'Borrower ID',  v:data.borrowerId, due:false},
    {l:'Type',         v:data.type,       due:false},
    {l:'Course',       v:data.course,     due:false},
    {l:'Year Level',   v:data.yearLevel,  due:false},
    {l:'Contact',      v:data.contact,    due:false},
    {l:'Book ID',      v:data.bookId,     due:false},
    {l:'Borrow Date',  v:fmtDate(data.borrowDate), due:false},
    {l:'Due Date',     v:fmtDate(data.dueDate),    due:true},
    {l:'Return Date',  v:'Not yet returned',        due:false},
  ];
  var grid=document.getElementById('m-grid'); grid.innerHTML='';
  fields.forEach(function(f){
    var div=document.createElement('div'); div.className='modal-field';
    div.innerHTML='<span class="mf-label">'+f.l+'</span><span class="mf-val'+(f.due?' due':'')+'">' +f.v+'</span>';
    grid.appendChild(div);
  });
  document.getElementById('notice-modal').classList.add('open');
  document.body.style.overflow='hidden';
}
function closeModal(){
  document.getElementById('notice-modal').classList.remove('open');
  document.body.style.overflow='';
}
function closeModalOutside(e){ if(e.target===document.getElementById('notice-modal')) closeModal(); }
document.addEventListener('keydown',function(e){ if(e.key==='Escape') closeModal(); });

//]]>
        </script>
      </body>
    </html>
  </xsl:template>

  <!-- ==================== BOOK TEMPLATE ==================== -->
  <xsl:template match="book">
    <xsl:variable name="s">
      <xsl:value-of select="title"/><xsl:text> </xsl:text>
      <xsl:value-of select="author"/><xsl:text> </xsl:text>
      <xsl:value-of select="category"/>
    </xsl:variable>
    <tr data-cat="{category}" data-search="{$s}">
      <td><span class="bid"><xsl:value-of select="@bookId"/></span></td>
      <td class="bold-cell"><xsl:value-of select="title"/></td>
      <td><xsl:value-of select="author"/></td>
      <td><span class="cat-pill"><xsl:value-of select="category"/></span></td>
      <td><span class="mono"><xsl:value-of select="isbn"/></span></td>
      <td><span class="copies-pill"><xsl:value-of select="copies"/></span></td>
    </tr>
  </xsl:template>

  <!-- ==================== RECORD TEMPLATE (with enrollment join) ==================== -->
  <xsl:template match="record">
    <!-- JOIN: find the matching student from enrollment.xml using borrowerId -->
    <xsl:variable name="bid" select="borrower/borrowerId"/>
    <xsl:variable name="stu" select="$enrollment[@studentId = $bid]"/>
    <xsl:variable name="fac" select="document('../group3-faculty/faculty.xml')//facultyMember[id = $bid][1]"/>

    <!-- Build full name from enrollment -->
    <xsl:variable name="fullName">
      <xsl:choose>
        <xsl:when test="$stu">
          <xsl:value-of select="$stu/firstName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$stu/lastName"/>
        </xsl:when>
        <xsl:when test="$fac">
          <xsl:value-of select="$fac/name"/>
        </xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Get course/program from enrollment -->
    <xsl:variable name="course">
      <xsl:choose>
        <xsl:when test="$stu"><xsl:value-of select="$stu/program"/></xsl:when>
        <xsl:when test="$fac"><xsl:value-of select="$fac/department"/></xsl:when>
        <xsl:otherwise>N/A</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Get year level from enrollment -->
    <xsl:variable name="yearLevel">
      <xsl:choose>
        <xsl:when test="$stu">Year <xsl:value-of select="$stu/yearLevel"/></xsl:when>
        <xsl:otherwise>N/A</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="computedType">
      <xsl:choose>
        <xsl:when test="starts-with($bid, 'FAC-')">Faculty</xsl:when>
        <xsl:otherwise>Student</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="s">
      <xsl:value-of select="@recordId"/><xsl:text> </xsl:text>
      <xsl:value-of select="$bid"/><xsl:text> </xsl:text>
      <xsl:value-of select="$fullName"/><xsl:text> </xsl:text>
      <xsl:value-of select="$course"/><xsl:text> </xsl:text>
      <xsl:value-of select="$yearLevel"/><xsl:text> </xsl:text>
      <xsl:value-of select="$computedType"/>
    </xsl:variable>

    <xsl:variable name="oc"><xsl:if test="status='Overdue'">overdue-row</xsl:if></xsl:variable>
    <xsl:variable name="sc">
      <xsl:choose>
        <xsl:when test="status='Active'">status-pill s-active</xsl:when>
        <xsl:when test="status='Returned'">status-pill s-returned</xsl:when>
        <xsl:when test="status='Overdue'">status-pill s-overdue</xsl:when>
        <xsl:when test="status='Returned Late'">status-pill s-late</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <tr class="{$oc}" data-status="{status}" data-search="{$s}">
      <td><span class="mono"><xsl:value-of select="@recordId"/></span></td>
      <td><span class="mono"><xsl:value-of select="bookId"/></span></td>
      <td><span class="bid"><xsl:value-of select="$bid"/></span></td>
      <td class="bold-cell"><xsl:value-of select="$fullName"/></td>
      <td><xsl:value-of select="$computedType"/></td>
      <td><xsl:value-of select="$course"/></td>
      <td><span class="yr-pill"><xsl:value-of select="$yearLevel"/></span></td>
      <td class="date-cell"><xsl:value-of select="borrowDate"/></td>
      <td class="date-cell"><xsl:value-of select="dueDate"/></td>
      <td class="date-cell">
        <xsl:choose>
          <xsl:when test="returnDate != ''"><xsl:value-of select="returnDate"/></xsl:when>
          <xsl:otherwise>—</xsl:otherwise>
        </xsl:choose>
      </td>
      <td><span class="{$sc}"><xsl:value-of select="status"/></span></td>
    </tr>
  </xsl:template>

  <!-- ==================== NOTICE TEMPLATE (with enrollment join) ==================== -->
  <xsl:template match="record" mode="notice">
    <xsl:variable name="bid" select="borrower/borrowerId"/>
    <xsl:variable name="stu" select="$enrollment[@studentId = $bid]"/>
    <xsl:variable name="fac" select="document('../group3-faculty/faculty.xml')//facultyMember[id = $bid][1]"/>

    <xsl:variable name="fullName">
      <xsl:choose>
        <xsl:when test="$stu">
          <xsl:value-of select="$stu/firstName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$stu/lastName"/>
        </xsl:when>
        <xsl:when test="$fac">
          <xsl:value-of select="$fac/name"/>
        </xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="course">
      <xsl:choose>
        <xsl:when test="$stu"><xsl:value-of select="$stu/program"/></xsl:when>
        <xsl:when test="$fac"><xsl:value-of select="$fac/department"/></xsl:when>
        <xsl:otherwise>N/A</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="yearLevel">
      <xsl:choose>
        <xsl:when test="$stu">Year <xsl:value-of select="$stu/yearLevel"/></xsl:when>
        <xsl:otherwise>N/A</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="computedType">
      <xsl:choose>
        <xsl:when test="starts-with($bid, 'FAC-')">Faculty</xsl:when>
        <xsl:otherwise>Student</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="s">
      <xsl:value-of select="$fullName"/><xsl:text> </xsl:text>
      <xsl:value-of select="$bid"/><xsl:text> </xsl:text>
      <xsl:value-of select="$course"/><xsl:text> </xsl:text>
      <xsl:value-of select="@recordId"/>
    </xsl:variable>

    <div class="notice-mini" data-search="{$s}"
      onclick="openModal({{
        name:       '{$fullName}',
        recordId:   '{@recordId}',
        borrowerId: '{$bid}',
        type:       '{$computedType}',
        course:     '{$course}',
        yearLevel:  '{$yearLevel}',
        contact:    '{borrower/contactNo}',
        bookId:     '{bookId}',
        borrowDate: '{borrowDate}',
        dueDate:    '{dueDate}'
      }})">
      <span class="notice-mini-tag">OVERDUE</span>
      <div class="notice-mini-name"><xsl:value-of select="$fullName"/></div>
      <div class="notice-mini-row"><span>Record</span><span><xsl:value-of select="@recordId"/></span></div>
      <div class="notice-mini-row"><span>ID</span><span><xsl:value-of select="$bid"/></span></div>
      <div class="notice-mini-row"><span>Book</span><span><xsl:value-of select="bookId"/></span></div>
      <div class="notice-mini-row"><span>Due</span><span class="notice-mini-due"><xsl:value-of select="dueDate"/></span></div>
      <div class="notice-mini-row"><span>Course</span><span><xsl:value-of select="$course"/></span></div>
      <div class="notice-mini-row"><span>Year</span><span><xsl:value-of select="$yearLevel"/></span></div>
      <div class="notice-mini-footer">View Full Notice &#8594;</div>
    </div>
  </xsl:template>

</xsl:stylesheet>