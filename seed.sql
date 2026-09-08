-- Insert 1 Admin & 3 Teachers
INSERT INTO users (id, full_name, email, password_hash, role, phone_number, class_days) VALUES 
(1, 'System Admin', 'admin@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'admin', '+923001112233', NULL),
(2, 'Sara Ahmed', 'sara@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+923004445566', 'Mon,Wed,Fri'),
(3, 'Usman Khan', 'usman@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+923007778899', 'Tue,Thu,Sat'),
(4, 'Ayesha Malik', 'ayesha@academy.com', 'scrypt:32768:8:1$0XX0UoCQd8dXiFWt$addab4032f3130c818cf15925411d15d5df96f758c4ad750b32e1de085d1ce37c8750fb12eac70151df85536f830f33968cbb814295314835b540656ec006414', 'teacher', '+923009990011', 'Mon,Tue,Wed,Thu,Fri');

-- Insert 3 Parents
INSERT INTO parents (id, full_name, whatsapp_number, notes) VALUES 
(1, 'Tariq Mahmood', '+923129876543', 'Prefers afternoon updates on WhatsApp.'),
(2, 'Fatima Zahra', '+923335551122', 'Requested monthly progress sheets.'),
(3, 'Bilal Raza', '+923214443322', 'Fee payment via Bank Transfer.');

-- Insert 4 Students
INSERT INTO students (id, full_name, parent_id, assigned_teacher_id, course_name, total_classes, completed_classes, class_time, class_days, class_date, package_fee, amount_paid, payment_status, fee_due_date, renewal_status) VALUES 
(1, 'Hamza Tariq', 1, 2, 'Spoken English', 12, 4, '04:00 PM', 'Mon,Wed,Fri', '2026-09-01', 15000.0, 15000.0, 'Paid', '2026-09-30', 'Active'),
(2, 'Zainab Tariq', 1, 2, 'Grammar Essentials', 12, 2, '05:00 PM', 'Mon,Wed,Fri', '2026-09-01', 15000.0, 7500.0, 'Partially Paid', '2026-09-15', 'Active'),
(3, 'Ali Bilal', 3, 3, 'General English', 12, 10, '03:30 PM', 'Tue,Thu,Sat', '2026-08-15', 12000.0, 12000.0, 'Paid', '2026-09-10', 'Renewal Due'),
(4, 'Omar Hussain', 2, 4, 'Kids Phonics & Fluency', 16, 0, '06:00 PM', 'Mon,Tue,Wed,Thu', '2026-09-05', 20000.0, 0.0, 'Payment Pending', '2026-09-12', 'Active');

-- Insert Sample Class Logs
INSERT INTO classes (student_id, teacher_id, class_date, status, class_number_in_package, notes) VALUES 
(1, 2, '2026-09-02', 'Completed', 1, 'Great participation in discussion.'),
(1, 2, '2026-09-04', 'Completed', 2, 'Reviewed vocabulary exercises.'),
(3, 3, '2026-09-03', 'Completed', 10, 'Completed final chapter reading.');

-- Insert Sample Payment History
INSERT INTO payments (student_id, amount_paid, payment_date, payment_method, reference_no, notes) VALUES 
(1, 15000.0, '2026-09-01', 'Easypaisa', 'EP-8849201', 'Full fee cleared.'),
(2, 7500.0, '2026-09-01', 'Bank Transfer', 'IBAN-9920112', 'First installment paid.');