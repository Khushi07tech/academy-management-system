import sqlite3
from werkzeug.security import generate_password_hash

conn = sqlite3.connect("academy.db")
cursor = conn.cursor()

# 1. Run schema
with open("schema.sql", "r") as f:
    cursor.executescript(f.read())

# 2. Run seed SQL
with open("seed.sql", "r") as f:
    cursor.executescript(f.read())

# 3. Update all user passwords to a valid 'password123' hash
valid_hash = generate_password_hash("password123")
cursor.execute("UPDATE users SET password_hash = ?", (valid_hash,))

conn.commit()
conn.close()

print(valid_hash)
print("Database seeded! All admin and teacher accounts are set to password: password123")