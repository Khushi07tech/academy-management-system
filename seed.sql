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
(1, 'Admin One', 'admin1@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+15550000001', NULL, NULL),
(2, 'Admin Two', 'admin2@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+15550000002', NULL, NULL),
(3, 'Admin Three', 'admin3@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+15550000003', NULL, NULL),
(4, 'Admin Four', 'admin4@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+15550000004', NULL, NULL),
(5, 'Admin Five', 'admin5@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+15550000005', NULL, NULL),

-- Teachers
(6, 'Teacher Alpha', 'teacher.alpha@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+15551110001', 'Mon,Wed,Fri', '16:00'),
(7, 'Teacher Beta', 'teacher.beta@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+15551110002', 'Tue,Thu,Sat', '17:00'),
(8, 'Teacher Gamma', 'teacher.gamma@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+15551110003', 'Mon,Wed', '18:00');

-- 2. PARENTS (Household contacts)
INSERT INTO parents (id, full_name, whatsapp_number, notes) VALUES
(1, 'Parent One', '+15552220001', 'Prefers WhatsApp updates on weekends.'),
(2, 'Parent Two', '+15552220002', 'Wants focus on pronunciation and vocabulary.'),
(3, 'Parent Three', '+15552220003', 'Parent of Student D and Student E.'),
(4, 'Parent Four', '+15552220004', 'Parent of Student F.'),
(5, 'Parent Five', '+15552220005', 'Parent of Student G and Student H.');

-- 3. STUDENTS (Linking siblings, varied payment & renewal statuses)
INSERT INTO students 
(id, full_name, parent_id, assigned_teacher_id, course_name, total_classes, completed_classes, package_fee, amount_paid, payment_status, fee_due_date, renewal_status) 
VALUES
-- Household 1: Siblings sharing Parent ID 1
(1, 'Student A', 1, 6, 'English Basics', 12, 5, 150.00, 150.00, 'Paid', '2026-09-01', 'Active'),
(2, 'Student B', 1, 6, 'Spoken English', 12, 12, 150.00, 150.00, 'Paid', '2026-08-15', 'Renewal Due'),

-- Single Child: Parent ID 2
(3, 'Student C', 2, 7, 'Kids English', 8, 3, 100.00, 100.00, 'Paid', '2026-09-05', 'Active'),

-- Household 2: Siblings sharing Parent ID 3
(4, 'Student D', 3, 8, 'Creative Writing', 12, 8, 160.00, 0.00, 'Payment Pending', '2026-08-20', 'Active'),
(5, 'Student E', 3, 8, 'Grammar Focus', 12, 2, 160.00, 80.00, 'Partially Paid', '2026-09-01', 'Active'),

-- Single Child: Parent ID 4
(6, 'Student F', 4, 7, 'Phonics', 12, 6, 140.00, 140.00, 'Paid', '2026-09-10', 'Active'),

-- Household 3: Siblings sharing Parent ID 5
(7, 'Student G', 5, 6, 'General English', 8, 7, 110.00, 0.00, 'Overdue', '2026-08-10', 'Renewal Due'),
(8, 'Student H', 5, 6, 'Beginner English', 8, 8, 110.00, 110.00, 'Paid', '2026-08-18', 'Not Renewing');

-- 4. CLASSES (Logged sessions)
INSERT INTO classes (student_id, teacher_id, class_date, status, class_number_in_package, notes) VALUES
(2, 6, '2026-08-10', 'Completed', 11, 'Practiced narrative tenses.'),
(2, 6, '2026-08-12', 'Completed', 12, 'Final class completed. Great improvement!'),
(1, 6, '2026-08-11', 'Completed', 4, 'Covered sentence structures.'),
(1, 6, '2026-08-13', 'Student Absent', 5, 'Parent notified class will be rescheduled.'),
(3, 7, '2026-08-14', 'Completed', 3, 'Phonics sound exercise.'),
(7, 6, '2026-08-15', 'Completed', 7, 'Grammar exercise review.');

-- 5. PAYMENTS (Transaction history)
INSERT INTO payments (student_id, amount_paid, payment_date, payment_method, reference_no, notes) VALUES
(1, 150.00, '2026-08-01', 'Bank Transfer', 'TXN100201', 'Full fee for Student A.'),
(2, 150.00, '2026-07-25', 'Online Transfer', 'EP992011', 'Full fee for Student B.'),
(3, 100.00, '2026-08-03', 'Cash', 'CSH005', 'Paid at enrollment.'),
(5, 80.00,  '2026-08-05', 'Bank Transfer', 'TXN100405', 'First installment for Student E.'),
(6, 140.00, '2026-08-08', 'Online Transfer', 'EP883012', 'Full payment for Student F.'),
(8, 110.00, '2026-07-30', 'Cash', 'CSH009', 'Full payment for Student H.');