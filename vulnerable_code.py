import sqlite3
import subprocess
import pickle
import os
from flask import Flask, request, render_template_string

app = Flask(__name__)
DATABASE = 'example.db'

# Vulnerability 1: SQL Injection
def sql_injection_vulnerable(query):
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = '" + query + "';")
    return cursor.fetchall()

# Vulnerability 2: Command Injection
def command_injection_vulnerable(cmd):
    subprocess.run(cmd, shell=True)

# Vulnerability 3: Cross-Site Scripting (XSS)
@app.route('/xss', methods=['GET'])
def xss_vulnerable():
    name = request.args.get('name', '')
    return render_template_string('<h1>Hello, {}!</h1>'.format(name))

# Vulnerability 4: Insecure Deserialization
def insecure_deserialization_vulnerable(serialized_data):
    return pickle.loads(serialized_data)

# Vulnerability 5: Unrestricted File Upload
@app.route('/upload', methods=['POST'])
def file_upload_vulnerable():
    file = request.files['file']
    file.save(os.path.join('/uploads', file.filename))
    return 'File uploaded successfully'

# Vulnerability 6: Path Traversal
@app.route('/read_file', methods=['GET'])
def path_traversal_vulnerable():
    filename = request.args.get('filename')
    with open(os.path.join('/uploads', filename), 'r') as file:
        return file.read()

# Vulnerability 7: Insecure Cryptographic Storage
def insecure_storage_vulnerable(password):
    with open('passwords.txt', 'a') as file:
        file.write(password + '\n')

@app.route('/test', methods=['GET'])
def test_vulnerabilities():
    # SQL Injection Test
    username = request.args.get('username')
    sql_injection_vulnerable(username)

    # Command Injection Test
    command = request.args.get('command')
    command_injection_vulnerable(command)

    # Insecure Deserialization Test
    serialized_data = request.args.get('data')
    insecure_deserialization_vulnerable(serialized_data)

    # Unrestricted File Upload Test
    # This would typically be tested via a file upload form

    # Path Traversal Test
    filename = request.args.get('filename')
    path_traversal_vulnerable()

    # Insecure Storage Test
    password = request.args.get('password')
    insecure_storage_vulnerable(password)

    return "Vulnerabilities tested"

if __name__ == '__main__':
    app.run(debug=True)
