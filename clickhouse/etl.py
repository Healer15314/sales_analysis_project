import mysql.connector
from clickhouse_connect import get_client

def migrate_data():
  
    mysql_conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='кщще', 
        database='sales_db'
    )
    mysql_cursor = mysql_conn.cursor(dictionary=True)

  
    ch_client = get_client(
        host='localhost',
        port=8123,
        username='default',
        password='password123' 
    )

   
    ch_client.command('CREATE DATABASE IF NOT EXISTS sales_db')

    ch_client.command('''
        CREATE TABLE IF NOT EXISTS sales_db.sales (
            transaction_id UInt64,
            transaction_datetime DateTime,
            product_id UInt64,
            quantity UInt32,
            unit_price Float32
        ) ENGINE = MergeTree()
        ORDER BY transaction_id
    ''')


    mysql_cursor.execute("SELECT transaction_id, transaction_datetime, product_id, quantity, unit_price FROM sales")
    rows = mysql_cursor.fetchall()

  
    data = []
    for row in rows:
        data.append((
            row['transaction_id'],
            row['transaction_datetime'],
            row['product_id'],
            row['quantity'],
            float(row['unit_price']) if row['unit_price'] is not None else 0.0
        ))

    ch_client.insert(
        table='sales_db.sales',
        data=data,
        column_names=['transaction_id', 'transaction_datetime', 'product_id', 'quantity', 'unit_price']
    )

    print(f"Миграция завершена. Перенесено записей: {len(data)}")

    mysql_cursor.close()
    mysql_conn.close()

if __name__ == '__main__':
    migrate_data()
