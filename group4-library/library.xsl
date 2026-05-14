<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Library Management System</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap"/>
        <style>
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

body {
  font-family: 'Inter', sans-serif;
  background: #f1f5f9;
  color: #1e293b;
  min-height: 100vh;
}

/* ── FIXED HEADER ── */
.site-header {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 100;
  background: #1e3a5f;
  box-shadow: 0 2px 16px rgba(0,0,0,0.18);
}
.header-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 32px 10px;
  border-bottom: 1px solid rgba(255,255,255,0.08);
}
.header-title {
  font-size: 18px;
  font-weight: 700;
  color: #fff;
  display: flex;
  align-items: center;
  gap: 9px;
}
.header-sub {
  font-size: 11px;
  color: #93c5fd;
  margin-top: 1px;
}
.header-badge {
  background: #2563eb;
  color: #fff;
  font-size: 11px;
  font-weight: 600;
  padding: 4px 14px;
  border-radius: 20px;
}

/* ── STAT CARDS IN HEADER ── */
.header-stats {
  display: flex;
  gap: 0;
  padding: 10px 32px 12px;
  overflow-x: auto;
  scrollbar-width: none;
}
.header-stats::-webkit-scrollbar { display: none; }
.hstat {
  display: flex;
  align-items: center;
  gap: 10px;
  background: rgba(255,255,255,0.07);
  border: 1px solid rgba(255,255,255,0.10);
  border-radius: 8px;
  padding: 9px 18px;
  margin-right: 8px;
  min-width: 130px;
  flex-shrink: 0;
  transition: background 0.15s;
}
.hstat:hover { background: rgba(255,255,255,0.12); }
.hstat-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.3px;
  flex-shrink: 0;
}
.hstat-icon.books   { background: rgba(96,165,250,0.18);  color: #93c5fd; }
.hstat-icon.records { background: rgba(167,139,250,0.18); color: #c4b5fd; }
.hstat-icon.active  { background: rgba(52,211,153,0.18);  color: #6ee7b7; }
.hstat-icon.returned{ background: rgba(96,165,250,0.18);  color: #93c5fd; }
.hstat-icon.overdue { background: rgba(248,113,113,0.18); color: #fca5a5; }
.hstat-icon.late    { background: rgba(251,191,36,0.18);  color: #fde68a; }
.hstat-num {
  font-size: 22px;
  font-weight: 800;
  color: #fff;
  line-height: 1;
}
.hstat-num.green  { color: #34d399; }
.hstat-num.blue   { color: #60a5fa; }
.hstat-num.red    { color: #f87171; }
.hstat-num.orange { color: #fbbf24; }
.hstat-num.purple { color: #c4b5fd; }
.hstat-lbl {
  font-size: 10px;
  color: #94a3b8;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.6px;
  margin-top: 1px;
}

/* ── BODY OFFSET ── */
.page-body {
  padding-top: 140px;
}

/* ── CONTAINER ── */
.container {
  max-width: 1300px;
  margin: 0 auto;
  padding: 32px 24px 60px;
}

/* ── SECTION TITLE ── */
.section-title {
  font-size: 14px;
  font-weight: 700;
  color: #1e3a5f;
  text-transform: uppercase;
  letter-spacing: 1px;
  padding-bottom: 10px;
  border-bottom: 2px solid #2563eb;
  margin-bottom: 18px;
  margin-top: 44px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.section-title:first-of-type { margin-top: 0; }
.section-count {
  margin-left: auto;
  background: #dbeafe;
  color: #1d4ed8;
  font-size: 11px;
  font-weight: 700;
  padding: 3px 12px;
  border-radius: 20px;
  text-transform: none;
  letter-spacing: 0;
}
.section-count.red { background: #fee2e2; color: #dc2626; }

/* ── CONTROLS ── */
.controls {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-bottom: 14px;
  align-items: center;
}
.search-wrap {
  flex: 1;
  min-width: 200px;
  position: relative;
}
.search-wrap input {
  width: 100%;
  padding: 9px 14px 9px 36px;
  border: 1.5px solid #cbd5e1;
  border-radius: 8px;
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  background: #fff;
  color: #1e293b;
  outline: none;
  transition: border-color .2s, box-shadow .2s;
}
.search-wrap input:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37,99,235,0.10);
}
.search-icon {
  position: absolute;
  left: 11px;
  top: 50%;
  transform: translateY(-50%);
  color: #94a3b8;
}
.filter-row { display: flex; gap: 6px; flex-wrap: wrap; }
.fbtn {
  padding: 7px 14px;
  border-radius: 6px;
  border: 1.5px solid #cbd5e1;
  background: #fff;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 600;
  color: #475569;
  cursor: pointer;
  transition: all .15s;
}
.fbtn:hover { border-color: #2563eb; color: #2563eb; }
.fbtn.on        { background: #2563eb; border-color: #2563eb; color: #fff; }
.fbtn.on-red    { background: #dc2626; border-color: #dc2626; color: #fff; }
.fbtn.on-orange { background: #d97706; border-color: #d97706; color: #fff; }
.fbtn.on-green  { background: #16a34a; border-color: #16a34a; color: #fff; }
.sel {
  padding: 7px 10px;
  border: 1.5px solid #cbd5e1;
  border-radius: 6px;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 600;
  background: #fff;
  color: #475569;
  cursor: pointer;
  outline: none;
}

/* ── BOOK TABLE ── */
.tbl-wrap {
  background: #fff;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  overflow: hidden;
}
.data-table {
  width: 100%;
  border-collapse: collapse;
}
.data-table thead { background: #1e3a5f; }
.data-table th {
  color: #bfdbfe;
  padding: 12px 16px;
  text-align: left;
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-weight: 700;
  white-space: nowrap;
}
.data-table td {
  padding: 12px 16px;
  font-size: 13px;
  border-bottom: 1px solid #f1f5f9;
  color: #334155;
}
.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover td { background: #f8fafc; }
.data-table tr.overdue-row td { background: #fff5f5; }
.data-table tr.overdue-row:hover td { background: #fee2e2; }

.mono { font-family: monospace; font-size: 11px; color: #475569; }
.bid  { font-family: monospace; font-size: 12px; color: #2563eb; font-weight: 600; }
.bold-cell { font-weight: 600; color: #1e293b; }
.copies-pill {
  display: inline-block;
  background: #dbeafe;
  color: #1d4ed8;
  font-size: 11px;
  font-weight: 700;
  padding: 2px 10px;
  border-radius: 12px;
}
.cat-pill {
  display: inline-block;
  background: #f0fdf4;
  color: #15803d;
  border: 1px solid #bbf7d0;
  font-size: 11px;
  font-weight: 600;
  padding: 2px 10px;
  border-radius: 12px;
}
.status-pill {
  display: inline-block;
  padding: 3px 12px;
  border-radius: 20px;
  font-size: 10px;
  font-weight: 700;
  color: #fff;
  white-space: nowrap;
}
.s-active   { background: #16a34a; }
.s-returned { background: #2563eb; }
.s-overdue  { background: #dc2626; }
.s-late     { background: #d97706; }

/* ── NOTICE MINI CARDS ── */
.notice-grid-wrap {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 14px;
}
.notice-mini {
  background: #fff;
  border-radius: 10px;
  border: 1px solid #fecaca;
  border-left: 4px solid #dc2626;
  padding: 16px 18px;
  cursor: pointer;
  transition: box-shadow .18s, transform .18s;
  position: relative;
}
.notice-mini:hover {
  box-shadow: 0 4px 18px rgba(220,38,38,0.13);
  transform: translateY(-2px);
}
.notice-mini-name {
  font-size: 14px;
  font-weight: 700;
  color: #991b1b;
  margin-bottom: 6px;
}
.notice-mini-row {
  font-size: 12px;
  color: #64748b;
  margin-bottom: 3px;
  display: flex;
  gap: 6px;
}
.notice-mini-row span:first-child {
  font-weight: 600;
  color: #94a3b8;
  width: 68px;
  flex-shrink: 0;
}
.notice-mini-due {
  color: #dc2626;
  font-weight: 700;
}
.notice-mini-tag {
  position: absolute;
  top: 12px;
  right: 14px;
  background: #fee2e2;
  color: #dc2626;
  font-size: 9px;
  font-weight: 800;
  padding: 3px 10px;
  border-radius: 20px;
  letter-spacing: 0.5px;
}
.notice-mini-footer {
  margin-top: 10px;
  font-size: 11px;
  color: #2563eb;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* ── MODAL ── */
.modal-overlay {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(15,23,42,0.55);
  z-index: 999;
  align-items: center;
  justify-content: center;
  padding: 20px;
}
.modal-overlay.open {
  display: flex;
}
.modal {
  background: #fff;
  border-radius: 14px;
  width: 100%;
  max-width: 560px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0,0,0,0.22);
  animation: modalIn .2s ease;
}
@keyframes modalIn {
  from { opacity: 0; transform: translateY(20px) scale(0.97); }
  to   { opacity: 1; transform: none; }
}
.modal-head {
  background: linear-gradient(135deg, #7f1d1d, #dc2626);
  padding: 20px 24px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  border-radius: 14px 14px 0 0;
}
.modal-head-name {
  font-size: 17px;
  font-weight: 700;
  color: #fff;
}
.modal-head-sub {
  font-size: 12px;
  color: #fca5a5;
  margin-top: 3px;
}
.modal-close {
  background: rgba(255,255,255,0.15);
  border: none;
  color: #fff;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: background .15s;
}
.modal-close:hover { background: rgba(255,255,255,0.28); }
.modal-body { padding: 20px 24px; }
.modal-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 16px;
}
.modal-field {
  padding: 11px 16px;
  border-bottom: 1px solid #f1f5f9;
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.modal-field:nth-child(odd)  { background: #fff; border-right: 1px solid #f1f5f9; }
.modal-field:nth-child(even) { background: #fafafa; }
.modal-field:nth-last-child(-n+2) { border-bottom: none; }
.mf-label {
  font-size: 10px;
  font-weight: 700;
  color: #94a3b8;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.mf-val {
  font-size: 13px;
  font-weight: 600;
  color: #1e293b;
}
.mf-val.due { color: #dc2626; }
.modal-warn {
  background: #fee2e2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  padding: 12px 16px;
  font-size: 13px;
  font-weight: 600;
  color: #991b1b;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

/* ── PAGER ── */
.pager {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 16px 0 4px;
  justify-content: center;
  flex-wrap: wrap;
}
.pager-info {
  font-size: 12px;
  color: #64748b;
  font-weight: 600;
  margin-right: 8px;
}
.pager-btn {
  min-width: 34px;
  height: 34px;
  padding: 0 8px;
  border-radius: 7px;
  border: 1.5px solid #e2e8f0;
  background: #fff;
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 600;
  color: #475569;
  cursor: pointer;
  transition: all .15s;
  display: flex;
  align-items: center;
  justify-content: center;
}
.pager-btn:hover:not(:disabled) { border-color: #2563eb; color: #2563eb; }
.pager-btn.on { background: #2563eb; border-color: #2563eb; color: #fff; }
.pager-btn:disabled { opacity: .3; cursor: not-allowed; }
.pager-dots { color: #94a3b8; font-weight: 700; padding: 0 2px; align-self: center; }

/* ── EMPTY ── */
.empty-msg {
  text-align: center;
  padding: 40px;
  background: #fff;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  color: #94a3b8;
  font-size: 14px;
  font-style: italic;
}

/* ── FOOTER ── */
.footer {
  text-align: center;
  padding: 18px;
  background: #fff;
  border-top: 1px solid #e2e8f0;
  font-size: 12px;
  color: #94a3b8;
  margin-top: 8px;
}

/* ── SCROLLBAR ── */
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: #f1f5f9; }
::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }

/* ── RESPONSIVE ── */
@media (max-width: 768px) {
  .header-stats { padding: 8px 16px 10px; }
  .header-top   { padding: 10px 16px; }
  .header-badge { display: none; }
  .page-body    { padding-top: 160px; }
  .container    { padding: 24px 14px 50px; }
  .tbl-wrap     { overflow-x: auto; }
  .notice-grid-wrap { grid-template-columns: 1fr; }
  .modal-grid   { grid-template-columns: 1fr; }
  .modal-field:nth-child(odd) { border-right: none; }
}
        </style>
      </head>
      <body>

        <!-- MODAL -->
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
                NOTICE: This book is OVERDUE. Please return immediately to avoid penalties.
              </div>
            </div>
          </div>
        </div>

        <!-- FIXED HEADER -->
        <div class="site-header">
          <div class="header-top">
            <div>
              <div class="header-title">
                Library Management System
              </div>
              <div class="header-sub">Pamantasan ng Lungsod ng Pasig — Group 4</div>
            </div>
            <div class="header-badge">LMS Report</div>
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

        <!-- PAGE BODY -->
        <div class="page-body">
          <div class="container">

            <!-- SECTION 1: BOOKS -->
            <div class="section-title">
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
                    <th>Book ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>ISBN</th>
                    <th>Copies</th>
                  </tr>
                </thead>
                <tbody id="book-tbody">
                  <xsl:apply-templates select="/library/books/book"/>
                </tbody>
              </table>
            </div>
            <div id="book-empty" class="empty-msg" style="display:none">No books match your search.</div>
            <div class="pager" id="book-pager"></div>

            <!-- SECTION 2: BORROWING RECORDS -->
            <div class="section-title">
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
                <input type="text" id="rec-q" placeholder="Search name, ID, course…" oninput="renderRecords()"/>
              </div>
              <div class="filter-row" id="rec-filter-row">
                <button class="fbtn on"        onclick="setRecStatus('all',this)">All</button>
                <button class="fbtn"           onclick="setRecStatus('Active',this)">Active</button>
                <button class="fbtn"           onclick="setRecStatus('Returned',this)">Returned</button>
                <button class="fbtn"           onclick="setRecStatus('Overdue',this)">Overdue</button>
                <button class="fbtn"           onclick="setRecStatus('Returned Late',this)">Late</button>
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
                    <th>Record ID</th>
                    <th>Book ID</th>
                    <th>Borrower</th>
                    <th>Type</th>
                    <th>Course</th>
                    <th>Borrow Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody id="rec-tbody">
                  <xsl:apply-templates select="/library/borrowingRecords/record"/>
                </tbody>
              </table>
            </div>
            <div id="rec-empty" class="empty-msg" style="display:none">No records match your filter.</div>
            <div class="pager" id="rec-pager"></div>

            <!-- SECTION 3: OVERDUE NOTICES -->
            <div class="section-title" style="border-bottom-color:#dc2626;color:#dc2626;">
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
                  <xsl:apply-templates
                    select="/library/borrowingRecords/record[status='Overdue']"
                    mode="notice"/>
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

/* ── DATE FORMATTER ── */
function fmtDate(raw) {
  if (!raw || raw.trim() === '' || raw.trim() === '—') return '—';
  var d = new Date(raw.trim());
  if (isNaN(d.getTime())) return raw;
  var months = ['January','February','March','April','May','June',
                'July','August','September','October','November','December'];
  return months[d.getMonth()] + ' ' + d.getDate() + ', ' + d.getFullYear();
}

/* Format all date cells in tables */
document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('td.date-cell').forEach(function (td) {
    td.textContent = fmtDate(td.textContent);
  });
});

/* ── PAGER ── */
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
    b.innerHTML = html;
    b.disabled = disabled;
    if (!disabled) b.onclick = function () { cb(goTo); };
    return b;
  }

  c.appendChild(mkBtn('&#8592;', page === 1, false, page - 1));

  var nums = [];
  if (pages <= 7) {
    for (var i = 1; i <= pages; i++) nums.push(i);
  } else {
    nums = [1];
    if (page > 3) nums.push('…');
    for (var i = Math.max(2, page-1); i <= Math.min(pages-1, page+1); i++) nums.push(i);
    if (page < pages - 2) nums.push('…');
    nums.push(pages);
  }

  nums.forEach(function (n) {
    if (n === '…') {
      var d = document.createElement('span');
      d.className = 'pager-dots'; d.textContent = '…';
      c.appendChild(d);
    } else {
      c.appendChild(mkBtn(n, false, n === page, n));
    }
  });

  c.appendChild(mkBtn('&#8594;', page === pages, false, page + 1));
}

/* ── BOOKS ── */
var bookCat  = 'all';
var bookPage = 1;

(function () {
  var cats = {};
  document.querySelectorAll('#book-tbody tr').forEach(function (r) {
    if (r.dataset.cat) cats[r.dataset.cat] = 1;
  });
  var wrap = document.getElementById('cat-btns');
  Object.keys(cats).forEach(function (cat) {
    var b = document.createElement('button');
    b.className = 'fbtn';
    b.textContent = cat;
    b.onclick = function () { setBookCat(cat, b); };
    wrap.appendChild(b);
  });
})();

function setBookCat(cat, el) {
  bookCat = cat; bookPage = 1;
  document.querySelectorAll('#cat-btns .fbtn').forEach(function (b) { b.classList.remove('on'); });
  el.classList.add('on');
  renderBooks();
}

function renderBooks() {
  var q  = (document.getElementById('book-q').value || '').toLowerCase();
  var pp = parseInt(document.getElementById('book-pp').value);
  var rows = Array.from(document.querySelectorAll('#book-tbody tr'));
  var vis = rows.filter(function (r) {
    return (bookCat === 'all' || r.dataset.cat === bookCat) &&
           (!q || (r.dataset.search || '').toLowerCase().includes(q));
  });
  rows.forEach(function (r) { r.style.display = 'none'; });
  vis.slice((bookPage-1)*pp, bookPage*pp).forEach(function (r) { r.style.display = ''; });
  document.getElementById('book-empty').style.display = vis.length ? 'none' : '';
  document.getElementById('book-count-pill').textContent = vis.length + ' Books';
  buildPager('book-pager', vis.length, bookPage, pp, function (p) { bookPage = p; renderBooks(); });
}
renderBooks();

/* ── RECORDS ── */
var recStatus = 'all';
var recPage   = 1;

function setRecStatus(s, el) {
  recStatus = s; recPage = 1;
  document.querySelectorAll('#rec-filter-row .fbtn').forEach(function (b) {
    b.classList.remove('on','on-red','on-orange','on-green');
  });
  el.classList.add(s==='Overdue' ? 'on-red' : s==='Returned Late' ? 'on-orange' : s==='Active' ? 'on-green' : 'on');
  renderRecords();
}

function renderRecords() {
  var q  = (document.getElementById('rec-q').value || '').toLowerCase();
  var pp = parseInt(document.getElementById('rec-pp').value);
  var rows = Array.from(document.querySelectorAll('#rec-tbody tr'));
  var vis = rows.filter(function (r) {
    return (recStatus === 'all' || r.dataset.status === recStatus) &&
           (!q || (r.dataset.search || '').toLowerCase().includes(q));
  });
  rows.forEach(function (r) { r.style.display = 'none'; });
  vis.slice((recPage-1)*pp, recPage*pp).forEach(function (r) { r.style.display = ''; });
  document.getElementById('rec-empty').style.display = vis.length ? 'none' : '';
  document.getElementById('rec-count-pill').textContent = vis.length + ' Records';
  buildPager('rec-pager', vis.length, recPage, pp, function (p) { recPage = p; renderRecords(); });
}
renderRecords();

/* ── NOTICES ── */
var noticePage = 1;

function renderNotices() {
  var q  = (document.getElementById('notice-q').value || '').toLowerCase();
  var pp = parseInt(document.getElementById('notice-pp').value);
  var cards = Array.from(document.querySelectorAll('#notice-wrap .notice-mini'));
  var vis = cards.filter(function (c) {
    return !q || (c.dataset.search || '').toLowerCase().includes(q);
  });
  cards.forEach(function (c) { c.style.display = 'none'; });
  vis.slice((noticePage-1)*pp, noticePage*pp).forEach(function (c) { c.style.display = ''; });
  document.getElementById('notice-count-pill').textContent = vis.length + ' Overdue';
  buildPager('notice-pager', vis.length, noticePage, pp, function (p) { noticePage = p; renderNotices(); });
}
renderNotices();

/* ── MODAL ── */
function openModal(data) {
  document.getElementById('m-name').textContent = data.name;
  var fields = [
    { l: 'Record ID',    v: data.recordId,  due: false },
    { l: 'Borrower ID',  v: data.borrowerId,due: false },
    { l: 'Type',         v: data.type,      due: false },
    { l: 'Course / Dept',v: data.course,    due: false },
    { l: 'Contact',      v: data.contact,   due: false },
    { l: 'Book ID',      v: data.bookId,    due: false },
    { l: 'Borrow Date',  v: fmtDate(data.borrowDate), due: false },
    { l: 'Due Date',     v: fmtDate(data.dueDate),    due: true  },
    { l: 'Return Date',  v: 'Not yet returned',        due: false },
  ];
  var grid = document.getElementById('m-grid');
  grid.innerHTML = '';
  fields.forEach(function (f) {
    var div = document.createElement('div');
    div.className = 'modal-field';
    div.innerHTML =
      '<span class="mf-label">' + f.l + '</span>' +
      '<span class="mf-val' + (f.due ? ' due' : '') + '">' + f.v + '</span>';
    grid.appendChild(div);
  });
  document.getElementById('notice-modal').classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeModal() {
  document.getElementById('notice-modal').classList.remove('open');
  document.body.style.overflow = '';
}

function closeModalOutside(e) {
  if (e.target === document.getElementById('notice-modal')) closeModal();
}

document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape') closeModal();
});
//]]>
        </script>

      </body>
    </html>
  </xsl:template>

  <!-- BOOK ROW -->
  <xsl:template match="book">
    <xsl:variable name="s">
      <xsl:value-of select="title"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="author"/>
      <xsl:text> </xsl:text>
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

  <!-- RECORD ROW -->
  <xsl:template match="record">
    <xsl:variable name="s">
      <xsl:value-of select="@recordId"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bookId"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="borrower/borrowerName"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="borrower/borrowerType"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="borrower/course"/>
    </xsl:variable>
    <xsl:variable name="oc">
      <xsl:if test="status='Overdue'">overdue-row</xsl:if>
    </xsl:variable>
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
      <td class="bold-cell"><xsl:value-of select="borrower/borrowerName"/></td>
      <td><xsl:value-of select="borrower/borrowerType"/></td>
      <td><xsl:value-of select="borrower/course"/></td>
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

  <!-- OVERDUE NOTICE MINI CARD -->
  <xsl:template match="record" mode="notice">
    <xsl:variable name="s">
      <xsl:value-of select="borrower/borrowerName"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="borrower/borrowerId"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="borrower/course"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@recordId"/>
    </xsl:variable>
    <div class="notice-mini" data-search="{$s}"
      onclick="openModal({{
        name:       '{borrower/borrowerName}',
        recordId:   '{@recordId}',
        borrowerId: '{borrower/borrowerId}',
        type:       '{borrower/borrowerType}',
        course:     '{borrower/course}',
        contact:    '{borrower/contactNo}',
        bookId:     '{bookId}',
        borrowDate: '{borrowDate}',
        dueDate:    '{dueDate}'
      }})">
      <span class="notice-mini-tag">OVERDUE</span>
      <div class="notice-mini-name"><xsl:value-of select="borrower/borrowerName"/></div>
      <div class="notice-mini-row">
        <span>Record</span>
        <span><xsl:value-of select="@recordId"/></span>
      </div>
      <div class="notice-mini-row">
        <span>Book</span>
        <span><xsl:value-of select="bookId"/></span>
      </div>
      <div class="notice-mini-row">
        <span>Due</span>
        <span class="notice-mini-due"><xsl:value-of select="dueDate"/></span>
      </div>
      <div class="notice-mini-row">
        <span>Course</span>
        <span><xsl:value-of select="borrower/course"/></span>
      </div>
      <div class="notice-mini-footer">
        View Full Notice &#8594;
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>