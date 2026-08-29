-- Disable foreign keys temporarily during drop/recreate
PRAGMA foreign_keys = ON;

-- 1. USERS TABLE (Handles Admin and Teacher authentication/roles)
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT CHECK(role IN ('admin', 'teacher')) NOT NULL DEFAULT 'teacher',
    phone_number TEXT,
    is_active INTEGER DEFAULT 1,
    must_change_password INTEGER DEFAULT 1,
    class_days TEXT,
    class_time TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. PARENTS TABLE (Connects multiple children to one parent contact)
CREATE TABLE IF NOT EXISTS parents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    whatsapp_number TEXT NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. STUDENTS TABLE (Tracks individual profiles, package limits, and progress)
CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    parent_id INTEGER NOT NULL,
    assigned_teacher_id INTEGER NOT NULL,
    course_name TEXT DEFAULT 'General English',
    
    -- Package Configuration
    total_classes INTEGER NOT NULL DEFAULT 12,
    completed_classes INTEGER DEFAULT 0,
    
    -- Fee Tracking
    package_fee REAL NOT NULL,
    amount_paid REAL DEFAULT 0.0,
    payment_status TEXT CHECK(payment_status IN ('Paid', 'Partially Paid', 'Overdue', 'Payment Pending')) DEFAULT 'Payment Pending',
    fee_due_date DATE,
    
    -- Status & Renewal Management
    renewal_status TEXT CHECK(renewal_status IN ('Active', 'Renewal Due', 'Not Renewing')) DEFAULT 'Active',
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_id) REFERENCES parents(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_teacher_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- 4. CLASSES TABLE (Logs each session, attendance, and notes)
CREATE TABLE IF NOT EXISTS classes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    class_date DATE NOT NULL DEFAULT (DATE('now')),
    
    -- Class & Attendance Status
    status TEXT CHECK(status IN ('Completed', 'Student Absent', 'Teacher Absent', 'Cancelled', 'Rescheduled')) NOT NULL,
    class_number_in_package INTEGER,
    notes TEXT,
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- 5. PAYMENTS TABLE (History log of every transaction received)
CREATE TABLE IF NOT EXISTS payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    amount_paid REAL NOT NULL,
    payment_date DATE NOT NULL,
    payment_method TEXT, -- e.g., 'Bank Transfer', 'Cash', 'Easypaisa'
    reference_no TEXT,
    notes TEXT,
    recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

SELECT * FROM parents;
SELECT * FROM users;
SELECT * FROM students;
SELECT * FROM classes;
SELECT * FROM payments;
