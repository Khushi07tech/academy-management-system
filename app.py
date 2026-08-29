import sqlite3
from functools import wraps
from werkzeug.security import generate_password_hash, check_password_hash
from flask import Flask, render_template, request, redirect, url_for, flash, session
from datetime import datetime

app = Flask(__name__)
app.secret_key = "dev_key"

def db_execute(query, params=()):
    conn = sqlite3.connect("academy.db")
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute(query, params)

    if query.strip().upper().startswith("SELECT"):
        results = cursor.fetchall()
    else:
        results = None
        conn.commit()

    conn.close()
    return results

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user_id" not in session:
            flash("Please log in first.", "danger")
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated_function

def role_required(required_role):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if session.get("role") != required_role:
                flash("Unauthorized access.", "danger")
                return redirect(url_for("login"))
            return f(*args, **kwargs)
        return decorated_function
    return decorator

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        # TODO: Extract email and password from form
        email = request.form.get("email")
        password = request.form.get("password")

        # TODO: SELECT user from users table where email = ?
        user = db_execute("SELECT * FROM users WHERE email = ?", (email,))
        # TODO: Verify password using check_password_hash()
        if user:
            stored_hash = user[0]['password_hash']
            is_valid = check_password_hash(stored_hash, password)

            if is_valid:
                session['user_id'] = user[0]['id']
                session['role'] = user[0]['role']

                if session['role'] == 'admin':
                    return redirect(url_for('admin_dashboard_summary'))
                else:
                    return redirect(url_for('teacher_dashboard_classes'))
                
            else:
                flash("Invalid password", "danger")
        else:
            flash("Email not found", "danger")
        
    # TODO: Render login.html template
    return render_template("login.html")

@app.route("/logout")
def logout():
    # TODO: Clear session data (session.clear())
    session.clear()
    # TODO: Flash logout message
    flash("You logged out succesfully")
    # TODO: Redirect to login page
    return redirect(url_for("login"))

@app.route("/admin/dashboard")
@login_required
@role_required("admin")
def admin_dashboard_summary():
    # TODO: Query database for total active students, today's classes, and renewals due
    total_active_students = db_execute("SELECT COUNT(*) AS count FROM students WHERE is_active = 1")[0]['count']
    today_classes = db_execute("SELECT COUNT(*) AS count FROM classes WHERE class_date = DATE('now')")[0]['count']
    renewal_dues = db_execute("SELECT students.full_name AS student_name, parents.full_name AS parent_name, parents.whatsapp_number FROM students JOIN parents ON students.parent_id = parents.id WHERE renewal_status = 'Renewal Due'")
    # TODO: Query automated alerts (overdue fees, pending payment)
    due_fees = db_execute("SELECT students.full_name AS student_name, parents.full_name AS parent_name, parents.whatsapp_number, payment_status FROM students JOIN parents ON students.parent_id = parents.id WHERE payment_status = 'Payment Pending'")
    # TODO: Pass query results into template
    return render_template("admin_dashboard_summary.html", total_active_students=total_active_students, today_classes=today_classes, renewal_dues=renewal_dues, due_fees=due_fees)

@app.route("/admin/students", methods=["GET"])
@login_required
@role_required("admin")
def admin_students_list():
    # TODO: SELECT all students JOINed with parents and teachers
    teachers = db_execute("SELECT id, full_name FROM users WHERE role = 'teacher' AND is_active = 1")

    search_query = request.args.get("search", "").strip()

    base_sql = "SELECT students.*, students.id AS student_id, parents.full_name AS parent_name, users.full_name AS teacher_name, parents.whatsapp_number, parents.notes AS parent_notes, users.phone_number AS teacher_contact FROM students JOIN parents ON students.parent_id = parents.id JOIN users ON students.assigned_teacher_id = users.id WHERE students.is_active = 1"
    

    if search_query:
        sql = base_sql + " AND students.full_name LIKE ? OR parents.full_name LIKE ?"
        param = f"%{search_query}%"
        rows = db_execute(sql, (param, param))
    else:
        rows = db_execute(base_sql)
        
    return render_template("admin_students_list.html", teachers=teachers, rows=rows)

@app.route("/admin/students/create", methods=["POST"])
@login_required
@role_required("admin")
def admin_students_create():
    student_name = request.form.get("student_name")
    parent_name = request.form.get("parent_name")
    parent_whatsapp = request.form.get("parent_whatsapp")
    parent_notes = request.form.get("parent_notes")
    course_name = request.form.get("course_name")
    assigned_teacher_id = request.form.get("assigned_teacher_id")
    package_fee = request.form.get("package_fee")
    total_classes = request.form.get("total_classes")
    selected_days = request.form.getlist("class_day")
    class_day = ",".join(selected_days)
    class_time = request.form.get("class_time")

    # TODO: Execute INSERT into students table
    db_execute("INSERT INTO parents (full_name, whatsapp_number, notes) VALUES (?, ?, ?)", (parent_name, parent_whatsapp, parent_notes))

    parent_id = db_execute("SELECT id FROM parents WHERE full_name = ? AND whatsapp_number = ?", (parent_name, parent_whatsapp))[0]['id']

    db_execute("INSERT INTO students (full_name, parent_id, assigned_teacher_id, course_name, total_classes, package_fee, class_date, class_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", (student_name, parent_id, assigned_teacher_id, course_name, total_classes, package_fee, class_day, class_time))

    return redirect(url_for("admin_students_list"))
    
@app.route("/admin/students/deactivate/<int:id>", methods=["POST"])
@login_required
@role_required("admin")
def admin_students_deactivate(id):
    db_execute("UPDATE students SET is_active = 0 WHERE id = ?", (id,))
    flash("Student deactivated", "success")
    return redirect(url_for("admin_students_list"))

@app.route("/admin/students/reassign/<int:id>", methods=["POST"])
@login_required
@role_required("admin")
def admin_students_reassign(id):
    reassigned_teacher_id = request.form.get("reassigned_teacher_id")

    db_execute("UPDATE students SET assigned_teacher_id = ? WHERE id = ?", (reassigned_teacher_id, id))

    flash("Teacher reassigned succesfully", "success")

    return redirect(url_for("admin_students_list"))

@app.route("/admin/students/deactivated", methods=["GET"])
@login_required
@role_required("admin")
def admin_students_deactivated():
    students = db_execute("SELECT students.full_name AS student_name, students.id AS student_id, parents.full_name AS parent_name, users.full_name AS teacher_name FROM students JOIN parents ON students.parent_id = parents.id JOIN users ON students.assigned_teacher_id = users.id WHERE students.is_active = 0")

    return render_template("admin_students_deactivated.html", students=students)

@app.route("/admin/students/activate/<int:id>", methods=["POST"])
@login_required
@role_required("admin")
def admin_students_activated(id):
    db_execute("UPDATE students SET is_active = 1 WHERE students.id = ?", (id,))
    flash("Student activated successfully!", "success")
    return redirect(url_for("admin_students_deactivated"))

@app.route("/admin/teachers")
@login_required
@role_required("admin")
def admin_teachers_list():

    search_query = request.args.get("search", "").strip()

    sql = """
        SELECT 
            users.id AS teacher_id, 
            users.full_name AS teacher_name, 
            users.phone_number, 
            users.role, 
            COUNT(DISTINCT students.id) AS student_count 
        FROM users 
        LEFT JOIN students 
            ON users.id = students.assigned_teacher_id 
            AND students.is_active = 1
        WHERE users.role = 'teacher' AND users.is_active = 1
    """
    params = []

    # Inject search BEFORE the GROUP BY clause
    if search_query:
        sql += " AND users.full_name LIKE ?"
        params.append(f"%{search_query}%")

    # GROUP BY must ALWAYS be at the very end
    sql += " GROUP BY users.id"

    rows = db_execute(sql, tuple(params))

    return render_template("admin_teachers_list.html", rows=rows)

@app.route("/admin/teachers/deactivate/<int:id>", methods=["POST"])
@login_required
@role_required("admin")
def admin_teachers_deactivate(id):
    db_execute("UPDATE users SET is_active = 0 WHERE id = ?", (id,))
    flash("Teacher deactivated", "success")
    return redirect(url_for("admin_teachers_list"))

@app.route("/admin/teachers/deactivated", methods=["GET"])
@login_required
@role_required("admin")
def admin_teachers_deactivated():
    teachers = db_execute("SELECT users.full_name AS teacher_name, users.id AS teacher_id FROM users WHERE users.is_active = 0")

    return render_template("admin_teachers_deactivated.html", teachers=teachers)

@app.route("/admin/teachers/activate/<int:id>", methods=["POST"])
@login_required
@role_required("admin")
def admin_teachers_activated(id):
    db_execute("UPDATE users SET is_active = 1 WHERE users.id = ?", (id,))
    flash("Teacher activated successfully!", "success")
    return redirect(url_for("admin_teachers_deactivated"))

@app.route("/admin/teachers/create", methods=["POST"])
@login_required
@role_required("admin")
def admin_create_teacher():
    name = request.form.get("name")
    email = request.form.get("email")
    password = request.form.get("password")
    phone_number = request.form.get("phone_number")

    user = db_execute("SELECT * FROM users WHERE email = ?", (email,))

    if user:
        flash("user already exist", "danger")
        return redirect(url_for('admin_teachers_list'))
    else:
        hashed_password = generate_password_hash(password)
        db_execute("INSERT INTO users (full_name, email, password_hash, phone_number, role) VALUES(?, ?, ?, ?, ?)", (name, email, hashed_password, phone_number, 'teacher'))
        return redirect(url_for('admin_teachers_list'))
    
@app.route("/teacher/dashboard")
@login_required
@role_required("teacher")
def teacher_dashboard_classes():
    today_code = datetime.now().strftime("%a")
    today_classes = db_execute("SELECT students.full_name as student_name, completed_classes, total_classes,class_time FROM students JOIN users ON  students.assigned_teacher_id = users.id WHERE assigned_teacher_id = ? AND class_days LIKE ? ORDER BY students.class_time ASC", (session.get('user_id'), f"%{today_code}%"))

    # TODO: Fetch assigned students and recent class logs for logged-in teacher
    assigned_students = db_execute("SELECT * FROM students WHERE assigned_teacher_id = ?", (session.get('user_id'),))

    completed_classes = db_execute("SELECT classes.*, students.full_name FROM students JOIN classes ON students.id = classes.student_id WHERE classes.teacher_id = ? AND classes.status = 'Completed'", (session.get('user_id'),))
    
    return render_template("teacher_dashboard_classes.html", assigned_students=assigned_students, completed_classes=completed_classes, today_classes=today_classes)

@app.route("/teacher/log-class", methods=["GET", "POST"])
@login_required
@role_required("teacher")
def teacher_log_class_form():
    current_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if request.method == "POST":
        # TODO: Extract student_id, status, notes from form
        student_id = request.form.get("student_id")
        status = request.form.get("status")
        notes = request.form.get("notes")

        # TODO: If status == 'Completed', increment student's completed_classes count
        if status == "Completed":
            db_execute("UPDATE students SET completed_classes = completed_classes + 1 WHERE students.id = ?", (student_id,))

        student_data = db_execute("SELECT completed_classes, total_classes FROM students WHERE students.id = ?", (student_id,))

        completed_classes = student_data[0]['completed_classes']
        total_classes = student_data[0]['total_classes']

        # TODO: If completed_classes >= total_classes, set renewal_status = 'Renewal Due'
        if completed_classes >= total_classes:
            db_execute("UPDATE students SET renewal_status = 'Renewal Due' WHERE students.id = ?", (student_id,))

        # TODO: INSERT into classes table and UPDATE students table
        db_execute("INSERT INTO classes (student_id, teacher_id, status, class_number_in_package, notes, class_date) VALUES (?, ?, ?, ?, ?, ?)", (student_id, session.get('user_id'), status, completed_classes, notes, current_date))
        return redirect(url_for("teacher_dashboard_classes"))

    # TODO: Fetch assigned students list for dropdown
    student_ids = db_execute("SELECT students.id, students.full_name AS student_name FROM students JOIN users ON students.assigned_teacher_id = users.id WHERE assigned_teacher_id = ?", (session.get('user_id'),))
    return render_template("teacher_log_class_form.html", student_ids=student_ids)

if __name__ == "__main__":
    app.run(debug=True)