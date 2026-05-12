// ==================== SARMS Dashboard JavaScript ====================
// Smart Academic Records Management System
// Group 2 - Unified Integration Module

let xmlData = null;

// Embedded XML data to avoid CORS issues when opening from file system
const EMBEDDED_XML = `<?xml version="1.0" encoding="UTF-8"?>
<sarms>
    <students>
        <student studentId="23-00001">
            <firstName>Juan</firstName>
            <lastName>Dela Cruz</lastName>
            <course>BSIT</course>
            <yearLevel>4</yearLevel>
            <enrolledSubjects>
                <subject subjectId="SUB-001">
                    <subjectName>Integrative Programming</subjectName>
                    <units>3</units>
                    <grade>1.25</grade>
                </subject>
                <subject subjectId="SUB-002">
                    <subjectName>Capstone Project 2</subjectName>
                    <units>3</units>
                    <grade>1.50</grade>
                </subject>
                <subject subjectId="SUB-003">
                    <subjectName>Information Assurance</subjectName>
                    <units>3</units>
                    <grade>1.75</grade>
                </subject>
                <subject subjectId="SUB-004">
                    <subjectName>Technopreneurship</subjectName>
                    <units>3</units>
                    <grade>2.00</grade>
                </subject>
            </enrolledSubjects>
            <gpa>1.63</gpa>
        </student>
        <student studentId="23-00002">
            <firstName>Maria</firstName>
            <lastName>Santos</lastName>
            <course>BSCS</course>
            <yearLevel>3</yearLevel>
            <enrolledSubjects>
                <subject subjectId="SUB-005">
                    <subjectName>Data Structures and Algorithms</subjectName>
                    <units>3</units>
                    <grade>1.00</grade>
                </subject>
                <subject subjectId="SUB-006">
                    <subjectName>Operating Systems</subjectName>
                    <units>3</units>
                    <grade>1.25</grade>
                </subject>
                <subject subjectId="SUB-007">
                    <subjectName>Database Management</subjectName>
                    <units>3</units>
                    <grade>1.50</grade>
                </subject>
            </enrolledSubjects>
            <gpa>1.25</gpa>
        </student>
        <student studentId="23-00003">
            <firstName>Jose</firstName>
            <lastName>Reyes</lastName>
            <course>BSIT</course>
            <yearLevel>2</yearLevel>
            <enrolledSubjects>
                <subject subjectId="SUB-008">
                    <subjectName>Object-Oriented Programming</subjectName>
                    <units>3</units>
                    <grade>2.50</grade>
                </subject>
                <subject subjectId="SUB-009">
                    <subjectName>Discrete Mathematics</subjectName>
                    <units>3</units>
                    <grade>2.75</grade>
                </subject>
                <subject subjectId="SUB-010">
                    <subjectName>Web Development</subjectName>
                    <units>3</units>
                    <grade>2.25</grade>
                </subject>
                <subject subjectId="SUB-011">
                    <subjectName>Platform Technologies</subjectName>
                    <units>3</units>
                    <grade>3.00</grade>
                </subject>
            </enrolledSubjects>
            <gpa>2.63</gpa>
        </student>
        <student studentId="23-00004">
            <firstName>Ana</firstName>
            <lastName>Garcia</lastName>
            <course>BSIS</course>
            <yearLevel>1</yearLevel>
            <enrolledSubjects>
                <subject subjectId="SUB-012">
                    <subjectName>Introduction to Computing</subjectName>
                    <units>3</units>
                    <grade>1.75</grade>
                </subject>
                <subject subjectId="SUB-013">
                    <subjectName>Computer Programming 1</subjectName>
                    <units>3</units>
                    <grade>2.00</grade>
                </subject>
                <subject subjectId="SUB-014">
                    <subjectName>Mathematics in the Modern World</subjectName>
                    <units>3</units>
                    <grade>2.25</grade>
                </subject>
            </enrolledSubjects>
            <gpa>2.00</gpa>
        </student>
        <student studentId="23-00005">
            <firstName>Carlos</firstName>
            <lastName>Mendoza</lastName>
            <course>BSCS</course>
            <yearLevel>4</yearLevel>
            <enrolledSubjects>
                <subject subjectId="SUB-015">
                    <subjectName>Artificial Intelligence</subjectName>
                    <units>3</units>
                    <grade>1.50</grade>
                </subject>
                <subject subjectId="SUB-016">
                    <subjectName>Machine Learning</subjectName>
                    <units>3</units>
                    <grade>1.25</grade>
                </subject>
                <subject subjectId="SUB-017">
                    <subjectName>Software Engineering 2</subjectName>
                    <units>3</units>
                    <grade>1.75</grade>
                </subject>
                <subject subjectId="SUB-018">
                    <subjectName>Research Methods</subjectName>
                    <units>3</units>
                    <grade>1.50</grade>
                </subject>
            </enrolledSubjects>
            <gpa>1.50</gpa>
        </student>
    </students>
    <faculty>
        <facultyMember>
            <id>FAC-001</id>
            <name>Dr. Rodrigo Lacson</name>
            <department>College of Arts &amp; Sciences</department>
            <subjects>
                <subject><subjectName>Ethics</subjectName><hours>3</hours></subject>
                <subject><subjectName>Understanding the Self</subjectName><hours>3</hours></subject>
                <subject><subjectName>Art Appreciation</subjectName><hours>3</hours></subject>
                <subject><subjectName>Contemporary World</subjectName><hours>3</hours></subject>
                <subject><subjectName>Readings in Philippine History</subjectName><hours>3</hours></subject>
            </subjects>
            <totalHours>15</totalHours>
        </facultyMember>
        <facultyMember>
            <id>FAC-002</id>
            <name>Sir Lito Pacquiao</name>
            <department>College of Computer Studies</department>
            <subjects>
                <subject><subjectName>Software Engineering</subjectName><hours>3</hours></subject>
                <subject><subjectName>Human Computer Interaction</subjectName><hours>3</hours></subject>
                <subject><subjectName>Object-Oriented Programming</subjectName><hours>3</hours></subject>
                <subject><subjectName>Artificial Intelligence</subjectName><hours>3</hours></subject>
                <subject><subjectName>Web Systems and Technologies</subjectName><hours>3</hours></subject>
                <subject><subjectName>Network Security</subjectName><hours>3</hours></subject>
            </subjects>
            <totalHours>18</totalHours>
        </facultyMember>
        <facultyMember>
            <id>FAC-003</id>
            <name>Sir Manuel Pacquiao</name>
            <department>College of Education</department>
            <subjects>
                <subject><subjectName>Facilitating Learner-Centered Teaching</subjectName><hours>3</hours></subject>
                <subject><subjectName>The Teaching Profession</subjectName><hours>3</hours></subject>
                <subject><subjectName>Technology for Teaching and Learning</subjectName><hours>3</hours></subject>
            </subjects>
            <totalHours>9</totalHours>
        </facultyMember>
        <facultyMember>
            <id>FAC-004</id>
            <name>Dr. Elena Pangilinan</name>
            <department>College of Nursing</department>
            <subjects>
                <subject><subjectName>Nutrition and Dietetics</subjectName><hours>3</hours></subject>
                <subject><subjectName>Microbiology and Parasitology</subjectName><hours>4</hours></subject>
                <subject><subjectName>Medical-Surgical Nursing</subjectName><hours>6</hours></subject>
                <subject><subjectName>Community Health Nursing</subjectName><hours>5</hours></subject>
                <subject><subjectName>Pharmacology</subjectName><hours>3</hours></subject>
                <subject><subjectName>Mental Health Nursing</subjectName><hours>4</hours></subject>
            </subjects>
            <totalHours>25</totalHours>
        </facultyMember>
    </faculty>
    <library>
        <books>
            <book bookId="BK-001"><title>Introduction to Programming</title><author>John D. Doe</author><category>Technology</category><isbn>978-0-13-468599-1</isbn><copies>5</copies></book>
            <book bookId="BK-002"><title>Data Structures and Algorithms</title><author>Mark R. Allen</author><category>Technology</category><isbn>978-0-13-284750-4</isbn><copies>3</copies></book>
            <book bookId="BK-003"><title>Database Management Systems</title><author>Ramez Elmasri</author><category>Technology</category><isbn>978-0-13-235-317-5</isbn><copies>2</copies></book>
            <book bookId="BK-004"><title>Calculus: Early Transcendentals</title><author>James Stewart</author><category>Mathematics</category><isbn>978-1-285-74155-0</isbn><copies>4</copies></book>
            <book bookId="BK-005"><title>Philippine History and Culture</title><author>Maria Santos</author><category>Social Science</category><isbn>978-971-23-5678-1</isbn><copies>6</copies></book>
            <book bookId="BK-006"><title>Fundamentals of Accounting</title><author>Carlos L. Reyes</author><category>Business</category><isbn>978-971-07-3421-9</isbn><copies>4</copies></book>
        </books>
        <borrowingRecords>
            <record recordId="REC-001"><bookId>BK-001</bookId><borrower><borrowerId>STU-001</borrowerId><borrowerName>Ana Marie Cruz</borrowerName><borrowerType>Student</borrowerType><course>BSIT</course><contactNo>09171234567</contactNo></borrower><borrowDate>2025-04-01</borrowDate><dueDate>2025-04-15</dueDate><returnDate>2025-04-14</returnDate><status>Returned</status></record>
            <record recordId="REC-002"><bookId>BK-002</bookId><borrower><borrowerId>STU-002</borrowerId><borrowerName>Ramon Jose Dela Torre</borrowerName><borrowerType>Student</borrowerType><course>BSCS</course><contactNo>09189876543</contactNo></borrower><borrowDate>2025-03-10</borrowDate><dueDate>2025-03-24</dueDate><returnDate></returnDate><status>Overdue</status></record>
            <record recordId="REC-003"><bookId>BK-004</bookId><borrower><borrowerId>STU-003</borrowerId><borrowerName>Liza Mae Santos</borrowerName><borrowerType>Student</borrowerType><course>BSME</course><contactNo>09201122334</contactNo></borrower><borrowDate>2025-04-20</borrowDate><dueDate>2025-05-04</dueDate><returnDate></returnDate><status>Active</status></record>
        </borrowingRecords>
    </library>
    <billing>
        <record><studentId>BIL-001</studentId><name>Sarah Williams</name><tuitionFee>34478</tuitionFee><paymentsMade>18603</paymentsMade><balance>15875</balance></record>
        <record><studentId>BIL-002</studentId><name>Robert Martin</name><tuitionFee>21599</tuitionFee><paymentsMade>6653</paymentsMade><balance>14946</balance></record>
        <record><studentId>BIL-003</studentId><name>Jane Rodriguez</name><tuitionFee>46289</tuitionFee><paymentsMade>42464</paymentsMade><balance>3825</balance></record>
        <record><studentId>BIL-004</studentId><name>Charles Anderson</name><tuitionFee>37978</tuitionFee><paymentsMade>16122</paymentsMade><balance>21856</balance></record>
        <record><studentId>BIL-005</studentId><name>Emily Lopez</name><tuitionFee>42600</tuitionFee><paymentsMade>38093</paymentsMade><balance>4507</balance></record>
        <record><studentId>BIL-006</studentId><name>Amelia Smith</name><tuitionFee>36355</tuitionFee><paymentsMade>12336</paymentsMade><balance>24019</balance></record>
    </billing>
    <events>
        <event eventId="EVT-0001" eventStatus="upcoming"><eventName>AI and Machine Learning Workshop</eventName><eventDate>2026-05-25</eventDate><eventTime>09:00:00</eventTime><venue>Engineering Building Room 301</venue><capacity>100</capacity><registrationCount>45</registrationCount><category>Academic</category><description>A comprehensive workshop on artificial intelligence and machine learning concepts.</description></event>
        <event eventId="EVT-0002" eventStatus="upcoming"><eventName>Philosophy and Critical Thinking Forum</eventName><eventDate>2026-05-26</eventDate><eventTime>10:00:00</eventTime><venue>Humanities Building Room 201</venue><capacity>50</capacity><registrationCount>38</registrationCount><category>Academic</category><description>A forum for discussing philosophical ideas and developing critical thinking skills.</description></event>
        <event eventId="EVT-0003" eventStatus="upcoming"><eventName>Career Development and Resume Workshop</eventName><eventDate>2026-05-27</eventDate><eventTime>14:00:00</eventTime><venue>Career Services Center</venue><capacity>50</capacity><registrationCount>50</registrationCount><category>Professional Development</category><description>A workshop on career planning and resume writing.</description></event>
        <event eventId="EVT-0004" eventStatus="current"><eventName>Data Science Bootcamp</eventName><eventDate>2026-05-12</eventDate><eventTime>09:00:00</eventTime><venue>Computer Lab 1</venue><capacity>100</capacity><registrationCount>85</registrationCount><category>Academic</category><description>A comprehensive workshop on data science fundamentals.</description></event>
        <event eventId="EVT-0005" eventStatus="current"><eventName>Leadership and Communication Seminar</eventName><eventDate>2026-05-12</eventDate><eventTime>10:00:00</eventTime><venue>Function Hall A</venue><capacity>150</capacity><registrationCount>120</registrationCount><category>Professional Development</category><description>A seminar on effective leadership and communication skills.</description></event>
        <event eventId="EVT-0006" eventStatus="closed"><eventName>Cybersecurity Awareness Forum</eventName><eventDate>2026-05-10</eventDate><eventTime>11:00:00</eventTime><venue>IT Building Auditorium</venue><capacity>50</capacity><registrationCount>48</registrationCount><category>Professional Development</category><description>A forum on cybersecurity awareness and best practices.</description></event>
    </events>
</sarms>`;

// ==================== MODAL FUNCTIONS ====================
function toggleModal() {
  const modal = document.getElementById("moduleModal");
  const overlay = document.getElementById("modalOverlay");
  const button = document.querySelector(".menu-button");

  modal.classList.toggle("active");
  overlay.classList.toggle("active");
  button.classList.toggle("active");
}

// ==================== TAB SWITCHING ====================
function switchTab(tabName) {
  // Hide all tabs
  const tabs = document.querySelectorAll(".tab-content");
  tabs.forEach((tab) => tab.classList.remove("active"));

  // Remove active class from all buttons
  const buttons = document.querySelectorAll(".tab-button");
  buttons.forEach((btn) => btn.classList.remove("active"));

  // Show selected tab
  document.getElementById(tabName + "-tab").classList.add("active");

  // Add active class to clicked button
  event.target.closest(".tab-button").classList.add("active");

  // Initialize charts for the selected tab
  initializeCharts(tabName);
}

// ==================== CHART INITIALIZATION ====================
let chartsInitialized = {
  enrollment: false,
  faculty: false,
  library: false,
  billing: false,
  events: false,
};

function initializeCharts(tabName) {
  if (chartsInitialized[tabName]) return;

  if (tabName === "enrollment") {
    updateEnrollmentStats();
    createCourseChart();
    createYearLevelChart();
    createGPAChart();
    chartsInitialized.enrollment = true;
  } else if (tabName === "faculty") {
    updateFacultyStats();
    createDepartmentChart();
    createWorkloadChart();
    chartsInitialized.faculty = true;
  } else if (tabName === "library") {
    updateLibraryStats();
    createCategoryChart();
    createBorrowingStatusChart();
    chartsInitialized.library = true;
  } else if (tabName === "billing") {
    updateBillingStats();
    createPaymentStatusChart();
    createBalanceDistChart();
    chartsInitialized.billing = true;
  } else if (tabName === "events") {
    updateEventsStats();
    createEventStatusChart();
    createEventCategoryChart();
    createRegistrationChart();
    chartsInitialized.events = true;
  }
}

// ==================== LOAD XML DATA ====================
async function loadXMLData() {
  try {
    // Try to load the full integrated XML file with all records
    let xmlText = "";
    try {
      const response = await fetch("sarms-integrated-full.xml");
      if (response.ok) {
        xmlText = await response.text();
        console.log(
          "✅ Loaded sarms-integrated-full.xml (all 100+ records per module)",
        );
      } else {
        throw new Error("File not found");
      }
    } catch (fetchError) {
      // Fallback to embedded sample data if fetch fails (CORS issue)
      console.warn(
        "⚠️  Could not load sarms-integrated-full.xml (CORS restriction)",
      );
      console.log("📝 Using embedded sample data instead");
      console.log("💡 To load full data, use a local web server:");
      console.log('   • VS Code: Install "Live Server" extension');
      console.log("   • Python: python -m http.server 8000");
      console.log("   • Node.js: npx http-server");
      xmlText = EMBEDDED_XML;
    }

    const parser = new DOMParser();
    xmlData = parser.parseFromString(xmlText, "text/xml");

    // Check for parsing errors
    const parserError = xmlData.querySelector("parsererror");
    if (parserError) {
      console.error("XML parsing error:", parserError.textContent);
      return;
    }

    console.log("XML data loaded and parsed successfully");

    // Initialize enrollment tab by default
    initializeCharts("enrollment");
  } catch (error) {
    console.error("Error loading XML:", error);
  }
}

// ==================== ENROLLMENT STATISTICS ====================
function updateEnrollmentStats() {
  if (!xmlData) return;

  const students = xmlData.querySelectorAll("students > student");
  const totalStudents = students.length;

  let highAchievers = 0;
  let totalSubjects = 0;
  let totalGPA = 0;

  students.forEach((student) => {
    const gpa = parseFloat(student.querySelector("gpa").textContent);
    if (gpa < 2.0) highAchievers++;
    totalGPA += gpa;
    totalSubjects += student.querySelectorAll("subject").length;
  });

  const avgGPA = (totalGPA / totalStudents).toFixed(2);

  document.getElementById("total-students").textContent = totalStudents;
  document.getElementById("high-achievers").textContent = highAchievers;
  document.getElementById("total-subjects").textContent = totalSubjects;
  document.getElementById("avg-gpa").textContent = avgGPA;
}

function createCourseChart() {
  const ctx = document.getElementById("courseChart");
  if (!ctx || !xmlData) return;

  const students = xmlData.querySelectorAll("students > student");
  const courses = {};

  students.forEach((student) => {
    const course = student.querySelector("course").textContent;
    courses[course] = (courses[course] || 0) + 1;
  });

  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: Object.keys(courses),
      datasets: [
        {
          data: Object.values(courses),
          backgroundColor: [
            "#008A45",
            "#00C76F",
            "#FFB800",
            "#3B82F6",
            "#F59E0B",
          ],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  });
}

function createYearLevelChart() {
  const ctx = document.getElementById("yearLevelChart");
  if (!ctx || !xmlData) return;

  const students = xmlData.querySelectorAll("students > student");
  const yearLevels = { 1: 0, 2: 0, 3: 0, 4: 0 };

  students.forEach((student) => {
    const year = parseInt(student.querySelector("yearLevel").textContent);
    yearLevels[year]++;
  });

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: ["1st Year", "2nd Year", "3rd Year", "4th Year"],
      datasets: [
        {
          label: "Students",
          data: Object.values(yearLevels),
          backgroundColor: "#008A45",
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  });
}

function createGPAChart() {
  const ctx = document.getElementById("gpaChart");
  if (!ctx || !xmlData) return;

  const students = xmlData.querySelectorAll("students > student");
  const ranges = {
    "Excellent (1.0-1.5)": 0,
    "Very Good (1.6-2.0)": 0,
    "Good (2.1-2.5)": 0,
    "Fair (2.6-3.0)": 0,
    "Passing (3.1-5.0)": 0,
  };

  students.forEach((student) => {
    const gpa = parseFloat(student.querySelector("gpa").textContent);
    if (gpa <= 1.5) ranges["Excellent (1.0-1.5)"]++;
    else if (gpa <= 2.0) ranges["Very Good (1.6-2.0)"]++;
    else if (gpa <= 2.5) ranges["Good (2.1-2.5)"]++;
    else if (gpa <= 3.0) ranges["Fair (2.6-3.0)"]++;
    else ranges["Passing (3.1-5.0)"]++;
  });

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: Object.keys(ranges),
      datasets: [
        {
          label: "Students",
          data: Object.values(ranges),
          backgroundColor: [
            "#10B981",
            "#00C76F",
            "#FFB800",
            "#F59E0B",
            "#EF4444",
          ],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  });
}

// ==================== FACULTY STATISTICS ====================
function updateFacultyStats() {
  if (!xmlData) return;

  const faculty = xmlData.querySelectorAll("faculty > facultyMember");
  const totalFaculty = faculty.length;

  let overloaded = 0;
  let optimal = 0;
  let totalHours = 0;

  faculty.forEach((member) => {
    const hours = parseInt(member.querySelector("totalHours").textContent);
    totalHours += hours;
    if (hours > 24) overloaded++;
    else optimal++;
  });

  const avgHours = (totalHours / totalFaculty).toFixed(1);

  document.getElementById("total-faculty").textContent = totalFaculty;
  document.getElementById("overloaded").textContent = overloaded;
  document.getElementById("optimal-load").textContent = optimal;
  document.getElementById("avg-hours").textContent = avgHours;
}

function createDepartmentChart() {
  const ctx = document.getElementById("departmentChart");
  if (!ctx || !xmlData) return;

  const faculty = xmlData.querySelectorAll("faculty > facultyMember");
  const departments = {};

  faculty.forEach((member) => {
    const dept = member.querySelector("department").textContent;
    departments[dept] = (departments[dept] || 0) + 1;
  });

  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: Object.keys(departments),
      datasets: [
        {
          data: Object.values(departments),
          backgroundColor: [
            "#008A45",
            "#00C76F",
            "#FFB800",
            "#3B82F6",
            "#F59E0B",
          ],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  });
}

function createWorkloadChart() {
  const ctx = document.getElementById("workloadChart");
  if (!ctx || !xmlData) return;

  const faculty = xmlData.querySelectorAll("faculty > facultyMember");
  const names = [];
  const hours = [];

  faculty.forEach((member) => {
    const fullName = member.querySelector("name").textContent;
    const lastName = fullName.split(" ").pop();
    names.push(lastName);
    hours.push(parseInt(member.querySelector("totalHours").textContent));
  });

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: names,
      datasets: [
        {
          label: "Teaching Hours",
          data: hours,
          backgroundColor: hours.map((h) => (h > 24 ? "#F59E0B" : "#008A45")),
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  });
}

// ==================== LIBRARY STATISTICS ====================
function updateLibraryStats() {
  if (!xmlData) return;

  const books = xmlData.querySelectorAll("library > books > book");
  const records = xmlData.querySelectorAll(
    "library > borrowingRecords > record",
  );

  const totalBooks = books.length;
  let totalCopies = 0;

  books.forEach((book) => {
    totalCopies += parseInt(book.querySelector("copies").textContent);
  });

  let activeLoans = 0;
  let overdueBooks = 0;

  records.forEach((record) => {
    const status = record.querySelector("status").textContent;
    if (status === "Active") activeLoans++;
    if (status === "Overdue") overdueBooks++;
  });

  document.getElementById("total-books").textContent = totalBooks;
  document.getElementById("total-copies").textContent = totalCopies;
  document.getElementById("active-loans").textContent = activeLoans;
  document.getElementById("overdue-books").textContent = overdueBooks;
}

function createCategoryChart() {
  const ctx = document.getElementById("categoryChart");
  if (!ctx || !xmlData) return;

  const books = xmlData.querySelectorAll("library > books > book");
  const categories = {};

  books.forEach((book) => {
    const cat = book.querySelector("category").textContent;
    categories[cat] = (categories[cat] || 0) + 1;
  });

  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: Object.keys(categories),
      datasets: [
        {
          data: Object.values(categories),
          backgroundColor: [
            "#008A45",
            "#00C76F",
            "#FFB800",
            "#3B82F6",
            "#F59E0B",
            "#EF4444",
          ],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  });
}

function createBorrowingStatusChart() {
  const ctx = document.getElementById("borrowingStatusChart");
  if (!ctx || !xmlData) return;

  const records = xmlData.querySelectorAll(
    "library > borrowingRecords > record",
  );
  const statuses = {};

  records.forEach((record) => {
    const status = record.querySelector("status").textContent;
    statuses[status] = (statuses[status] || 0) + 1;
  });

  new Chart(ctx, {
    type: "pie",
    data: {
      labels: Object.keys(statuses),
      datasets: [
        {
          data: Object.values(statuses),
          backgroundColor: ["#10B981", "#FFB800", "#EF4444"],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  });
}

// ==================== BILLING STATISTICS ====================
function updateBillingStats() {
  if (!xmlData) return;

  const records = xmlData.querySelectorAll("billing > record");
  const totalRecords = records.length;

  let totalRevenue = 0;
  let totalCollected = 0;
  let totalOutstanding = 0;

  records.forEach((record) => {
    totalRevenue += parseFloat(record.querySelector("tuitionFee").textContent);
    totalCollected += parseFloat(
      record.querySelector("paymentsMade").textContent,
    );
    totalOutstanding += parseFloat(record.querySelector("balance").textContent);
  });

  document.getElementById("total-billing-records").textContent = totalRecords;
  document.getElementById("total-revenue").textContent =
    "₱" + totalRevenue.toLocaleString("en-PH", { minimumFractionDigits: 0 });
  document.getElementById("total-collected").textContent =
    "₱" + totalCollected.toLocaleString("en-PH", { minimumFractionDigits: 0 });
  document.getElementById("total-outstanding").textContent =
    "₱" +
    totalOutstanding.toLocaleString("en-PH", { minimumFractionDigits: 0 });
}

function createPaymentStatusChart() {
  const ctx = document.getElementById("paymentStatusChart");
  if (!ctx || !xmlData) return;

  const records = xmlData.querySelectorAll("billing > record");
  let totalCollected = 0;
  let totalOutstanding = 0;

  records.forEach((record) => {
    totalCollected += parseFloat(
      record.querySelector("paymentsMade").textContent,
    );
    totalOutstanding += parseFloat(record.querySelector("balance").textContent);
  });

  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: ["Collected", "Outstanding"],
      datasets: [
        {
          data: [totalCollected, totalOutstanding],
          backgroundColor: ["#10B981", "#FFB800"],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  });
}

function createBalanceDistChart() {
  const ctx = document.getElementById("balanceDistChart");
  if (!ctx || !xmlData) return;

  const records = xmlData.querySelectorAll("billing > record");
  const dist = {
    "Fully Paid": 0,
    "Low (< ₱10k)": 0,
    "Medium (₱10k-20k)": 0,
    "High (> ₱20k)": 0,
  };

  records.forEach((record) => {
    const balance = parseFloat(record.querySelector("balance").textContent);
    if (balance === 0) dist["Fully Paid"]++;
    else if (balance < 10000) dist["Low (< ₱10k)"]++;
    else if (balance <= 20000) dist["Medium (₱10k-20k)"]++;
    else dist["High (> ₱20k)"]++;
  });

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: Object.keys(dist),
      datasets: [
        {
          label: "Students",
          data: Object.values(dist),
          backgroundColor: ["#10B981", "#3B82F6", "#FFB800", "#EF4444"],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  });
}

// ==================== EVENTS STATISTICS ====================
function updateEventsStats() {
  if (!xmlData) return;

  const events = xmlData.querySelectorAll("events > event");
  const totalEvents = events.length;

  let upcoming = 0;
  let current = 0;
  let totalParticipants = 0;

  events.forEach((event) => {
    const status = event.getAttribute("eventStatus");
    if (status === "upcoming") upcoming++;
    if (status === "current") current++;
    totalParticipants += parseInt(
      event.querySelector("registrationCount").textContent,
    );
  });

  document.getElementById("total-events").textContent = totalEvents;
  document.getElementById("upcoming-events").textContent = upcoming;
  document.getElementById("current-events").textContent = current;
  document.getElementById("total-participants").textContent = totalParticipants;
}

function createEventStatusChart() {
  const ctx = document.getElementById("eventStatusChart");
  if (!ctx || !xmlData) return;

  const events = xmlData.querySelectorAll("events > event");
  const statuses = {};

  events.forEach((event) => {
    const status = event.getAttribute("eventStatus");
    statuses[status] = (statuses[status] || 0) + 1;
  });

  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: Object.keys(statuses).map(
        (s) => s.charAt(0).toUpperCase() + s.slice(1),
      ),
      datasets: [
        {
          data: Object.values(statuses),
          backgroundColor: ["#3B82F6", "#10B981", "#6B7280"],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  });
}

function createEventCategoryChart() {
  const ctx = document.getElementById("eventCategoryChart");
  if (!ctx || !xmlData) return;

  const events = xmlData.querySelectorAll("events > event");
  const categories = {};

  events.forEach((event) => {
    const cat = event.querySelector("category").textContent;
    categories[cat] = (categories[cat] || 0) + 1;
  });

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: Object.keys(categories),
      datasets: [
        {
          label: "Events",
          data: Object.values(categories),
          backgroundColor: "#008A45",
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      indexAxis: "y",
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  });
}

function createRegistrationChart() {
  const ctx = document.getElementById("registrationChart");
  if (!ctx || !xmlData) return;

  const events = xmlData.querySelectorAll("events > event");
  const eventData = [];

  let count = 0;
  events.forEach((event) => {
    if (count++ >= 6) return; // Limit to 6 events for readability
    eventData.push({
      name: event.querySelector("eventName").textContent.substring(0, 20),
      registered: parseInt(
        event.querySelector("registrationCount").textContent,
      ),
      capacity: parseInt(event.querySelector("capacity").textContent),
    });
  });

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: eventData.map((d) => d.name),
      datasets: [
        {
          label: "Registered",
          data: eventData.map((d) => d.registered),
          backgroundColor: "#008A45",
        },
        {
          label: "Capacity",
          data: eventData.map((d) => d.capacity),
          backgroundColor: "#E5E7EB",
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
        },
      },
    },
  });
}

// ==================== INITIALIZE ====================
window.addEventListener("DOMContentLoaded", function () {
  loadXMLData();
});
