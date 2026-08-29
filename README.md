# ⚡ 𝓐𝓬𝓪𝓭𝓮𝓶𝔂 𝓜𝓪𝓷𝓪𝓰𝓮𝓶𝓮𝓷𝓽 𝓢𝔂𝓼𝓽𝓮𝓶

A web-based platform designed to manage educational institution workflows, featuring role-based dashboards, student and instructor tracking, and class activity logging.

---

## 🚀 Key Features

* **Role-Based Authorization:** Custom views and access permissions for administrative personnel and teaching staff.
* **Admin Dashboard:** Overview of academy metrics, active and deactivated student records, and instructor management.
* **Teacher Portal:** Streamlined interface for logging conducted classes, managing schedules, and tracking class histories.
* **Database Management:** Optimized SQL schema design pre-seeded with anonymized test data for rapid local setup.

---

## 💻 Core Application Workflows

### 1. Student Lifecycle & Registration
- Multi-field intake form handling student registration, parent contact channels, course metadata, and custom parent logs.
- Dynamic day-selection arrays (Mon–Sun) stored as serialized string data to track individual weekly schedules.

### 2. Teacher Workload & Reassignment
- Real-time tracking of active student capacity per instructor.
- One-click inline reassignment forms on student rosters to re-route students to active teachers instantly.

### 3. Server-Side Filtering & Search
- Query-string search parameters (`/admin/students?search=...`) executing indexed `LIKE` queries for instant filtering across active rosters and archived records.

### 4. Automated Class Tracking
- When an instructor logs a class session as "Completed," the system automatically increments the student's completed class counter.

### 5. Renewal Tracking & Unpaid Fee Alerts
- Automatically flags students for "Renewal Due" once the total scheduled package classes are completed.
- Highlights students with pending or overdue fee balances directly on the Admin Dashboard overview.

### 6. Soft Deactivation Management
- Safely deactivate student and instructor records without deleting historical data. Admins maintain full visibility over deactivated records with one-click restoration.

---

## 🛠️ Tech Stack

- **Backend:** Python 3, Flask
- **Database:** SQLite3 (relational schema with custom JOIN queries & cascading logic)
- **Templating:** Jinja2 (template inheritance & modular partials)
- **Frontend:** HTML5, Custom Vanilla CSS3 (CSS Variables system, Flexbox/Grid architecture)

---

## 📁 Repository Structure

```text
Academy/
├── static/
│   └── style.css
├── templates/
│   ├── admin_dashboard_summary.html
│   ├── admin_students_deactivated.html
│   ├── admin_students_list.html
│   ├── admin_teachers_deactivated.html
│   ├── admin_teachers_list.html
│   ├── base.html
│   ├── index.html
│   ├── login.html
│   ├── teacher_dashboard_classes.html
│   └── teacher_log_class_form.html
├── .gitignore
├── app.py
├── README.md
├── requirements.txt
├── schema.sql
└── seed.sql
```

## ⚙️ Local Setup Instructions
### 1. Clone the Repository:
- git clone [https://github.com/khushi07tech/academy-management-system.git]
- cd academy-management-system

### 2. Install Dependencies:
- pip install -r requirements.txt

### 3. Initialize Database
- sqlite3 academy.db < schema.sql
- sqlite3 academy.db < seed.sql

### 4. Run Application
- python app.py
- Open your browser and navigate to http://127.0.0.1:5000.

### 5. Use the demo login credentials

*(All demo accounts use default testing password: `password123`)*

| Role | Name | Email | Associated Schedule / Access |
| :--- | :--- | :--- | :--- |
| **Admin** | Admin One | `admin1@academy.com` | Full System Management |
| **Admin** | Admin Two | `admin2@academy.com` | Full System Management |
| **Teacher** | Teacher Alpha | `teacher.alpha@academy.com` | Schedule: Mon, Wed, Fri (16:00) |
| **Teacher** | Teacher Beta | `teacher.beta@academy.com` | Schedule: Tue, Thu, Sat (17:00) |
| **Teacher** | Teacher Gamma | `teacher.gamma@academy.com` | Schedule: Mon, Wed (18:00) |

---

## 🔒 Intellectual Property & Rights

**Copyright © 2026.** All rights reserved.

This repository represents proprietary portfolio software designed to showcase full-stack development, database architecture, and custom UI design capabilities. All rights reserved. Not authorized for commercial distribution, replication, or deployment without explicit permission.