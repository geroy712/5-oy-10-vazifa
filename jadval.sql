import psycopg2



def create_tables():
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS brands (
        id SERIAL PRIMARY KEY,
        brand_name VARCHAR(100) NOT NULL
    )''')
    
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS models (
        id SERIAL PRIMARY KEY,
        model_name VARCHAR(100) NOT NULL,
        brand_id INT,
        color VARCHAR(50) NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY(brand_id) REFERENCES brands(id)
    )''')
    
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS employees (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        country VARCHAR(100) NOT NULL
    )''')
    
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS customers (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        country VARCHAR(100) NOT NULL
    )''')
    
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS orders (
        id SERIAL PRIMARY KEY,
        customer_id INT,
        employee_id INT,
        model_id INT,
        FOREIGN KEY(customer_id) REFERENCES customers(id),
        FOREIGN KEY(employee_id) REFERENCES employees(id),
        FOREIGN KEY(model_id) REFERENCES models(id)
    )''')
    conn.commit()

def add_brand():
    brand_name = input("Brand nomini kiriting: ")
    cursor.execute("INSERT INTO brands (brand_name) VALUES (%s)", (brand_name,))
    conn.commit()

def add_model():
    model_name = input("Model nomini kiriting: ")
    brand_id = int(input("Brand ID ni kiriting: "))
    color = input("Rangini kiriting: ")
    price = float(input("Narxini kiriting: "))
    cursor.execute("INSERT INTO models (model_name, brand_id, color, price) VALUES (%s, %s, %s, %s)", (model_name, brand_id, color, price))
    conn.commit()

def add_employee():
    name = input("Xodim nomini kiriting: ")
    email = input("Xodimning emailini kiriting: ")
    country = input("Xodimning davlatini kiriting: ")
    cursor.execute("INSERT INTO employees (name, email, country) VALUES (%s, %s, %s)", (name, email, country))
    conn.commit()

def add_customer():
    name = input("Buyurtmachining nomini kiriting: ")
    email = input("Buyurtmachining emailini kiriting: ")
    country = input("Buyurtmachining davlatini kiriting: ")
    cursor.execute("INSERT INTO customers (name, email, country) VALUES (%s, %s, %s)", (name, email, country))
    conn.commit()

def add_order():
    customer_id = int(input("Buyurtmachi ID sini kiriting: "))
    employee_id = int(input("Xodim ID sini kiriting: "))
    model_id = int(input("Model ID sini kiriting: "))
    cursor.execute("INSERT INTO orders (customer_id, employee_id, model_id) VALUES (%s, %s, %s)", (customer_id, employee_id, model_id))
    conn.commit()

def display_all_models():
    cursor.execute('''
    SELECT models.model_name, brands.brand_name, models.color
    FROM models
    JOIN brands ON models.brand_id = brands.id
    ''')
    rows = cursor.fetchall()
    for row in rows:
        print(f"Model: {row[0]}, Brand: {row[1]}, Color: {row[2]}")

def display_emails():
    cursor.execute("SELECT email FROM employees UNION SELECT email FROM customers")
    rows = cursor.fetchall()
    for row in rows:
        print(row[0])

def count_customers_by_country():
    cursor.execute("SELECT country, COUNT(*) FROM customers GROUP BY country ORDER BY COUNT(*) DESC")
    rows = cursor.fetchall()
    for row in rows:
        print(f"Country: {row[0]}, Customers: {row[1]}")

def count_employees_by_country():
    cursor.execute("SELECT country, COUNT(*) FROM employees GROUP BY country ORDER BY COUNT(*) DESC")
    rows = cursor.fetchall()
    for row in rows:
        print(f"Country: {row[0]}, Employees: {row[1]}")

def count_models_by_brand():
    cursor.execute('''
    SELECT brands.brand_name, COUNT(models.id)
    FROM models
    JOIN brands ON models.brand_id = brands.id
    GROUP BY brands.brand_name
    ''')
    rows = cursor.fetchall()
    for row in rows:
        print(f"Brand: {row[0]}, Models: {row[1]}")

def brands_with_more_than_five_models():
    cursor.execute('''
    SELECT brands.brand_name, COUNT(models.id)
    FROM models
    JOIN brands ON models.brand_id = brands.id
    GROUP BY brands.brand_name
    HAVING COUNT(models.id) > 5
    ''')
    rows = cursor.fetchall()
    for row in rows:
        print(f"Brand: {row[0]}, Models: {row[1]}")

def join_orders_with_details():
    cursor.execute('''
    SELECT orders.id, customers.name, employees.name, models.model_name
    FROM orders
    JOIN customers ON orders.customer_id = customers.id
    JOIN employees ON orders.employee_id = employees.id
    JOIN models ON orders.model_id = models.id
    ''')
    rows = cursor.fetchall()
    for row in rows:
        print(f"Order ID: {row[0]}, Customer: {row[1]}, Employee: {row[2]}, Model: {row[3]}")

def total_price_of_models():
    cursor.execute("SELECT SUM(price) FROM models")
    total_price = cursor.fetchone()[0]
    print(f"Jami avtomobillar narxi: {total_price}")

def count_brands():
    cursor.execute("SELECT COUNT(*) FROM brands")
    count = cursor.fetchone()[0]
    print(f"Jami brandlar soni: {count}")

def main():
    create_tables()
    while True:
        print("\n1. Brand qo'shish")
        print("2. Model qo'shish")
        print("3. Xodim qo'shish")
        print("4. Buyurtmachi qo'shish")
        print("5. Buyurtma qo'shish")
        print("6. Barcha modellarni chiqarish")
        print("7. Xodimlar va buyurtmachilarning emaillarini chiqarish")
        print("8. Har bir davlatdagi buyurtmachilar sonini chiqarish")
        print("9. Har bir davlatdagi xodimlar sonini chiqarish")
        print("10. Har bir branddagi modellar sonini chiqarish")
        print("11. 5 tadan ko'p modelga ega brandlarni chiqarish")
        print("12. Buyurtmalarni chiqarish (Customers, Employees, Models bilan birlashtirish)")
        print("13. Barcha modellarning umumiy narxini chiqarish")
        print("14. Jami brandlar sonini chiqarish")
        print("15. Chiqish")

        choice = int(input("Tanlovni kiriting: "))
        
        if choice == 1:
            add_brand()
        elif choice == 2:
            add_model()
        elif choice == 3:
            add_employee()
        elif choice == 4:
            add_customer()
        elif choice == 5:
            add_order()
        elif choice == 6:
            display_all_models()
        elif choice == 7:
            display_emails()
        elif choice == 8:
            count_customers_by_country()
        elif choice == 9:
            count_employees_by_country()
        elif choice == 10:
            count_models_by_brand()
        elif choice == 11:
            brands_with_more_than_five_models()
        elif choice == 12:
            join_orders_with_details()
        elif choice == 13:
            total_price_of_models()
        elif choice == 14:
            count_brands()
        elif choice == 15:
            break

if __name__ == "__main__":
    main()
