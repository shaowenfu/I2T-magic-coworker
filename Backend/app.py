from flask import Flask, jsonify, request
import psycopg2
from config import DATABASE_CONFIG
app = Flask(__name__)

# 数据库连接函数
def get_db_connection():
    conn = psycopg2.connect(**DATABASE_CONFIG)
    return conn

@app.route('/api/data', methods=['GET'])
def get_data():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM my_table;")  # 替换为实际表名
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rows)

@app.route('/api/data', methods=['POST'])
def post_data():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO my_table (column1, column2) VALUES (%s, %s);",
                   (data['column1'], data['column2']))  # 替换为实际列名
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Data inserted successfully"})

if __name__ == '__main__':
    app.run(debug=True)
