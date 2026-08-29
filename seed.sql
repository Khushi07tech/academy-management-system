-- Clear out existing data to allow fresh seeds
DELETE FROM payments;
DELETE FROM classes;
DELETE FROM students;
DELETE FROM parents;
DELETE FROM users;

-- Reset autoincrement sequence primary keys
DELETE FROM sqlite_sequence WHERE name IN ('users', 'parents', 'students', 'classes', 'payments');

-- 1. USERS (5 Admins + 3 Teachers)
-- Password hashes use standard testing placeholder string
INSERT INTO users (id, full_name, email, password_hash, role, phone_number, class_days, class_time) VALUES
-- Admins
(1, 'Quratulain', 'quratulain@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+923001111111', NULL, NULL),
(2, 'Saeed', 'saeed@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+923002222222', NULL, NULL),
(3, 'Bushra', 'bushra@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+923003333333', NULL, NULL),
(4, 'Aneela', 'aneela@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+923004444444', NULL, NULL),
(5, 'Amna', 'amna@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+923005555555', NULL, NULL),

-- Teachers
(6, 'Miss Zainab', 'zainab@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+923111234567', 'Mon,Wed,Fri', '16:00'),
(7, 'Sir Hamza', 'hamza@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+923129876543', 'Tue,Thu,Sat', '17:00'),
(8, 'Miss Sana', 'sana@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+923135554433', 'Mon,Wed', '18:00');

-- 2. PARENTS (Household contacts)
INSERT INTO parents (id, full_name, whatsapp_number, notes) VALUES
(1, 'Abu Wajd & Samu', '+966500000001', 'Prefers WhatsApp updates on weekends.'),
(2, 'Umm Jouri', '+966500000002', 'Wants focus on pronunciation and vocabulary.'),
(3, 'Tariq Al-Mansoor', '+966500000003', 'Father of Ghada and Dana.'),
(4, 'Khaled Al-Ghamdi', '+966500000004', 'Father of Ruda.'),
(5, 'Fahad Al-Harbi', '+966500000005', 'Father of Lama and Faisal.');

-- 3. STUDENTS (Linking siblings, varied payment & renewal statuses)
INSERT INTO students 
(id, full_name, parent_id, assigned_teacher_id, course_name, total_classes, completed_classes, package_fee, amount_paid, payment_status, fee_due_date, renewal_status) 
VALUES
-- Household 1: Samu & Wajd (Siblings sharing Parent ID 1)
(1, 'Samu', 1, 6, 'English Basics', 12, 5, 150.00, 150.00, 'Paid', '2026-09-01', 'Active'),
(2, 'Wajd', 1, 6, 'Spoken English', 12, 12, 150.00, 150.00, 'Paid', '2026-08-15', 'Renewal Due'),

-- Single Child: Jouri
(3, 'Jouri', 2, 7, 'Kids English', 8, 3, 100.00, 100.00, 'Paid', '2026-09-05', 'Active'),

-- Household 2: Ghada & Dana (Siblings sharing Parent ID 3)
(4, 'Ghada', 3, 8, 'Creative Writing', 12, 8, 160.00, 0.00, 'Payment Pending', '2026-08-20', 'Active'),
(5, 'Dana', 3, 8, 'Grammar Focus', 12, 2, 160.00, 80.00, 'Partially Paid', '2026-09-01', 'Active'),

-- Single Child: Ruda
(6, 'Ruda', 4, 7, 'Phonics', 12, 6, 140.00, 140.00, 'Paid', '2026-09-10', 'Active'),

-- Household 3: Lama & Faisal (Siblings sharing Parent ID 5)
(7, 'Lama', 5, 6, 'General English', 8, 7, 110.00, 0.00, 'Overdue', '2026-08-10', 'Renewal Due'),
(8, 'Faisal', 5, 6, 'Beginner English', 8, 8, 110.00, 110.00, 'Paid', '2026-08-18', 'Not Renewing');

-- 4. CLASSES (Logged sessions)
INSERT INTO classes (student_id, teacher_id, class_date, status, class_number_in_package, notes) VALUES
-- Wajd completed sessions
(2, 6, '2026-08-10', 'Completed', 11, 'Practiced narrative tenses.'),
(2, 6, '2026-08-12', 'Completed', 12, 'Final class completed. Great improvement!'),

-- Samu active sessions
(1, 6, '2026-08-11', 'Completed', 4, 'Covered sentence structures.'),
(1, 6, '2026-08-13', 'Student Absent', 5, 'Parent notified class will be rescheduled.'),

-- Jouri session
(3, 7, '2026-08-14', 'Completed', 3, 'Phonics sound exercise.'),

-- Lama session
(7, 6, '2026-08-15', 'Completed', 7, 'Grammar exercise review.');

-- 5. PAYMENTS (Transaction history)
INSERT INTO payments (student_id, amount_paid, payment_date, payment_method, reference_no, notes) VALUES
(1, 150.00, '2026-08-01', 'Bank Transfer', 'TXN100201', 'Full fee for Samu.'),
(2, 150.00, '2026-07-25', 'Easypaisa', 'EP992011', 'Full fee for Wajd.'),
(3, 100.00, '2026-08-03', 'Cash', 'CSH005', 'Paid at enrollment.'),
(5, 80.00,  '2026-08-05', 'Bank Transfer', 'TXN100405', 'First installment for Dana.'),
(6, 140.00, '2026-08-08', 'Easypaisa', 'EP883012', 'Full payment for Ruda.'),
(8, 110.00, '2026-07-30', 'Cash', 'CSH009', 'Full payment for Faisal.');


-- Clear out existing data to allow fresh seeds
SELECT * FROM users;
SELECT * FROM students;
SELECT * FROM parents;
SELECT * FROM classes;
SELECT * FROM payments;


