<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Faculty Workload | Minimal Dashboard</title>
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
                <style>
                    :root {
                        --bg-main: #ffffff;
                        --bg-subtle: #f9fafb;
                        --text-main: #111827;
                        --text-muted: #6b7280;
                        --border-color: #f3f4f6;
                        --accent: #000000;
                        --accent-hover: #374151;
                        --danger: #ef4444;
                        --danger-bg: #fef2f2;
                    }

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                        font-family: 'Inter', -apple-system, sans-serif;
                    }

                    body {
                        background-color: var(--bg-subtle);
                        color: var(--text-main);
                        min-height: 100vh;
                        padding: 4rem 2rem;
                        -webkit-font-smoothing: antialiased;
                    }

                    .container {
                        width: 100%;
                        margin: 0 auto;
                        background: var(--bg-main);
                        padding: 3rem;
                        border-radius: 12px;
                        box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.03);
                    }

                    header {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-end;
                        margin-bottom: 3rem;
                        padding-bottom: 1.5rem;
                        border-bottom: 1px solid var(--border-color);
                    }

                    h1 {
                        font-size: 1.5rem;
                        font-weight: 600;
                        letter-spacing: -0.02em;
                        color: var(--text-main);
                        margin-bottom: 0.25rem;
                    }

                    .subtitle {
                        font-size: 0.875rem;
                        color: var(--text-muted);
                    }

                    .btn {
                        padding: 0.5rem 1rem;
                        font-size: 0.875rem;
                        font-weight: 500;
                        border-radius: 6px;
                        border: 1px solid transparent;
                        cursor: pointer;
                        transition: all 0.15s ease;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-primary {
                        background: var(--accent);
                        color: white;
                    }

                    .btn-primary:hover {
                        background: var(--accent-hover);
                    }

                    .btn-outline {
                        background: transparent;
                        border-color: #e5e7eb;
                        color: var(--text-main);
                    }

                    .btn-outline:hover {
                        background: var(--bg-subtle);
                        border-color: #d1d5db;
                    }

                    /* Table Styling */
                    table {
                        width: 100%;
                        border-collapse: collapse;
                        text-align: left;
                    }

                    th {
                        padding: 1rem 0.5rem;
                        font-size: 0.75rem;
                        font-weight: 500;
                        color: var(--text-muted);
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        border-bottom: 1px solid #e5e7eb;
                    }

                    td {
                        padding: 1.25rem 0.5rem;
                        border-bottom: 1px solid var(--border-color);
                        vertical-align: top;
                        font-size: 0.875rem;
                        transition: background-color 0.15s ease;
                    }

                    tr:hover td {
                        background-color: #fafafa;
                    }

                    tr:last-child td {
                        border-bottom: none;
                    }

                    .faculty-id {
                        font-variant-numeric: tabular-nums;
                        color: var(--text-muted);
                        font-size: 0.75rem;
                    }

                    .faculty-name {
                        font-weight: 500;
                        color: var(--text-main);
                        display: block;
                        margin-bottom: 0.125rem;
                    }

                    .faculty-dept {
                        font-size: 0.75rem;
                        color: var(--text-muted);
                    }

                    .subjects-list {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 0.5rem;
                    }

                    .subject-tag {
                        background: var(--bg-subtle);
                        color: var(--text-muted);
                        padding: 0.125rem 0.5rem;
                        border-radius: 4px;
                        font-size: 0.75rem;
                        border: 1px solid var(--border-color);
                    }

                    .workload-cell {
                        width: 150px;
                    }

                    .hours-text {
                        font-variant-numeric: tabular-nums;
                        color: var(--text-main);
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .hours-text span.limit {
                        color: var(--text-muted);
                        font-size: 0.75rem;
                    }

                    .overloaded td {
                        background-color: var(--danger-bg);
                    }
                    .overloaded:hover td {
                        background-color: #fee2e2;
                    }
                    .overloaded .hours-text {
                        color: var(--danger);
                        font-weight: 600;
                    }

                    /* Modal Styling */
                    .modal-overlay {
                        position: fixed;
                        top: 0; left: 0; right: 0; bottom: 0;
                        background: rgba(17, 24, 39, 0.4);
                        backdrop-filter: blur(4px);
                        display: none;
                        place-items: center;
                        z-index: 1000;
                        opacity: 0;
                        transition: opacity 0.2s ease;
                    }

                    .modal-overlay.active {
                        display: grid;
                        opacity: 1;
                    }

                    .modal-content {
                        background: var(--bg-main);
                        border-radius: 12px;
                        width: 100%;
                        max-width: 480px;
                        padding: 2rem;
                        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                        transform: translateY(10px);
                        transition: transform 0.2s ease;
                    }

                    .modal-overlay.active .modal-content {
                        transform: translateY(0);
                    }

                    .modal-content h2 {
                        font-size: 1.25rem;
                        font-weight: 600;
                        margin-bottom: 1.5rem;
                    }

                    .form-group {
                        margin-bottom: 1.25rem;
                    }

                    label {
                        display: block;
                        margin-bottom: 0.375rem;
                        font-size: 0.75rem;
                        font-weight: 500;
                        color: var(--text-muted);
                        text-transform: uppercase;
                        letter-spacing: 0.025em;
                    }

                    input {
                        width: 100%;
                        background: var(--bg-main);
                        border: 1px solid #d1d5db;
                        border-radius: 6px;
                        padding: 0.625rem 0.75rem;
                        font-size: 0.875rem;
                        color: var(--text-main);
                        outline: none;
                        transition: border-color 0.15s ease;
                    }

                    input:focus {
                        border-color: var(--accent);
                        box-shadow: 0 0 0 1px var(--accent);
                    }

                    .subject-input-group {
                        display: grid;
                        grid-template-columns: 1fr 80px;
                        gap: 0.75rem;
                        margin-bottom: 0.75rem;
                    }

                    .modal-actions {
                        display: flex;
                        justify-content: flex-end;
                        gap: 0.75rem;
                        margin-top: 2rem;
                        padding-top: 1.5rem;
                        border-top: 1px solid var(--border-color);
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <header>
                        <div>
                            <h1>Faculty Workload</h1>
                            <div class="subtitle">Academic Resource Management</div>
                        </div>
                        <div style="display: flex; gap: 0.75rem;">
                            <button class="btn btn-outline" id="exportBtn">Export XML</button>
                            <button class="btn btn-primary" id="addFacultyBtn">Add Faculty</button>
                        </div>
                    </header>

                    <table>
                        <thead>
                            <tr>
                                <th style="width: 80px;">ID</th>
                                <th>Faculty Member</th>
                                <th>Teaching Load (Subjects)</th>
                                <th>Total Hours</th>
                            </tr>
                        </thead>
                        <tbody id="facultyTableBody">
                            <xsl:for-each select="faculty/facultyMember">
                                <tr>
                                    <xsl:if test="totalHours >= 30">
                                        <xsl:attribute name="class">overloaded</xsl:attribute>
                                    </xsl:if>
                                    <td>
                                        <div class="faculty-id"><xsl:value-of select="id"/></div>
                                    </td>
                                    <td>
                                        <span class="faculty-name"><xsl:value-of select="name"/></span>
                                        <span class="faculty-dept"><xsl:value-of select="department"/></span>
                                    </td>
                                    <td>
                                        <div class="subjects-list">
                                            <xsl:for-each select="subjects/subject">
                                                <span class="subject-tag">
                                                    <xsl:value-of select="subjectName"/> (<xsl:value-of select="hours"/>)
                                                </span>
                                            </xsl:for-each>
                                        </div>
                                    </td>
                                    <td class="workload-cell">
                                        <div class="hours-text">
                                            <xsl:value-of select="totalHours"/> 
                                            <span class="limit">/ 30</span>
                                        </div>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>

                <!-- Minimal Modal -->
                <div class="modal-overlay" id="modalOverlay">
                    <div class="modal-content">
                        <h2>New Faculty Record</h2>
                        <form id="facultyForm">
                            <div class="form-group">
                                <label for="facId">ID</label>
                                <input type="text" id="facId" placeholder="FAC-101" required="required"/>
                            </div>
                            <div class="form-group">
                                <label for="facName">Name</label>
                                <input type="text" id="facName" placeholder="Dr. Juan Dela Cruz" required="required"/>
                            </div>
                            <div class="form-group">
                                <label for="facDept">Department</label>
                                <input type="text" id="facDept" placeholder="College of Science" required="required"/>
                            </div>
                            <div class="form-group">
                                <label>Subjects</label>
                                <div id="subjectInputs">
                                    <div class="subject-input-group">
                                        <input type="text" placeholder="Subject Name" required="required"/>
                                        <input type="number" placeholder="Hrs" min="1" max="30" required="required"/>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-outline" id="addSubjectInputBtn" style="width: 100%; margin-top: 0.5rem; justify-content: center; font-size: 0.75rem;">
                                    + Add Subject
                                </button>
                            </div>
                            <div class="modal-actions">
                                <button type="button" class="btn btn-outline" id="closeModalBtn">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Record</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    <![CDATA[
                    let facultyData = [];

                    document.addEventListener('DOMContentLoaded', () => {
                        initializeDataFromDOM();
                        setupEventListeners();
                    });

                    function initializeDataFromDOM() {
                        const rows = document.querySelectorAll('#facultyTableBody tr');
                        facultyData = Array.from(rows).map(row => {
                            const id = row.querySelector('.faculty-id').textContent;
                            const name = row.querySelector('.faculty-name').textContent;
                            const department = row.querySelector('.faculty-dept').textContent;
                            const subjects = Array.from(row.querySelectorAll('.subject-tag')).map(tag => {
                                const text = tag.textContent;
                                const match = text.match(/(.+)\s\((\d+)\)/);
                                return {
                                    name: match ? match[1].trim() : text,
                                    hours: match ? parseInt(match[2]) : 0
                                };
                            });
                            const totalText = row.querySelector('.hours-text').childNodes[0].nodeValue;
                            const total = parseInt(totalText.trim());
                            
                            return { id, name, department, subjects, totalHours: total };
                        });
                    }

                    function renderDashboard() {
                        const tbody = document.getElementById('facultyTableBody');
                        tbody.innerHTML = '';
                        
                        facultyData.forEach(faculty => {
                            const isOverloaded = faculty.totalHours >= 30;
                            
                            const tr = document.createElement('tr');
                            if (isOverloaded) tr.className = 'overloaded';
                            
                            tr.innerHTML = `
                                <td><div class="faculty-id">${faculty.id}</div></td>
                                <td>
                                    <span class="faculty-name">${faculty.name}</span>
                                    <span class="faculty-dept">${faculty.department}</span>
                                </td>
                                <td>
                                    <div class="subjects-list">
                                        ${faculty.subjects.map(s => `
                                            <span class="subject-tag">${s.name} (${s.hours})</span>
                                        `).join('')}
                                    </div>
                                </td>
                                <td class="workload-cell">
                                    <div class="hours-text">${faculty.totalHours} <span class="limit">/ 30</span></div>
                                </td>
                            `;
                            tbody.appendChild(tr);
                        });
                    }

                    function setupEventListeners() {
                        const modal = document.getElementById('modalOverlay');
                        const addBtn = document.getElementById('addFacultyBtn');
                        const closeBtn = document.getElementById('closeModalBtn');
                        const addSubBtn = document.getElementById('addSubjectInputBtn');
                        const form = document.getElementById('facultyForm');
                        const exportBtn = document.getElementById('exportBtn');

                        function openModal() {
                            modal.style.display = 'grid';
                            void modal.offsetWidth;
                            modal.classList.add('active');
                        }

                        function closeModal() {
                            modal.classList.remove('active');
                            setTimeout(() => { modal.style.display = 'none'; }, 200);
                        }

                        addBtn.onclick = openModal;
                        closeBtn.onclick = closeModal;
                        
                        addSubBtn.onclick = () => {
                            const container = document.getElementById('subjectInputs');
                            const div = document.createElement('div');
                            div.className = 'subject-input-group';
                            div.innerHTML = `
                                <input type="text" placeholder="Subject Name" required>
                                <input type="number" placeholder="Hrs" min="1" max="30" required>
                            `;
                            container.appendChild(div);
                        };

                        form.onsubmit = (e) => {
                            e.preventDefault();
                            const subjects = [];
                            const subjectGroups = document.querySelectorAll('.subject-input-group');
                            let total = 0;
                            subjectGroups.forEach(group => {
                                const inputs = group.querySelectorAll('input');
                                const hours = parseInt(inputs[1].value);
                                subjects.push({ name: inputs[0].value, hours: hours });
                                total += hours;
                            });

                            if (total > 30) {
                                alert('Error: Total teaching hours cannot exceed 30 per week.');
                                return;
                            }

                            const newFaculty = {
                                id: document.getElementById('facId').value,
                                name: document.getElementById('facName').value,
                                department: document.getElementById('facDept').value,
                                subjects: subjects,
                                totalHours: total
                            };

                            facultyData.push(newFaculty);
                            renderDashboard();
                            closeModal();
                            form.reset();
                            document.getElementById('subjectInputs').innerHTML = `
                                <div class="subject-input-group">
                                    <input type="text" placeholder="Subject Name" required>
                                    <input type="number" placeholder="Hrs" min="1" max="30" required>
                                </div>
                            `;
                        };

                        exportBtn.onclick = exportToXML;
                    }

                    function exportToXML() {
                        let xml = '<?xml version="1.0" encoding="UTF-8"?>\n';
                        xml += '<?xml-stylesheet type="text/xsl" href="faculty.xsl"?>\n';
                        xml += '<faculty xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="faculty.xsd">\n';

                        facultyData.forEach(f => {
                            xml += '    <facultyMember>\n';
                            xml += `        <id>${f.id}</id>\n`;
                            xml += `        <name>${f.name}</name>\n`;
                            xml += `        <department>${f.department}</department>\n`;
                            xml += '        <subjects>\n';
                            f.subjects.forEach(s => {
                                xml += '            <subject>\n';
                                xml += `                <subjectName>${s.name}</subjectName>\n`;
                                xml += `                <hours>${s.hours}</hours>\n`;
                                xml += '            </subject>\n';
                            });
                            xml += '        </subjects>\n';
                            xml += `        <totalHours>${f.totalHours}</totalHours>\n`;
                            xml += '    </facultyMember>\n';
                        });

                        xml += '</faculty>';

                        const blob = new Blob([xml], { type: 'text/xml' });
                        const url = URL.createObjectURL(blob);
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = 'faculty.xml';
                        document.body.appendChild(a);
                        a.click();
                        document.body.removeChild(a);
                        URL.revokeObjectURL(url);
                    }
                    ]]>
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>