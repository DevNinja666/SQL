CREATE DATABASE electronics_store;
USE electronics_store;

-- =========================
-- 1. Brands
-- =========================
CREATE TABLE brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    country VARCHAR(100)
);

-- =========================
-- 2. Categories (hierarchy)
-- =========================
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

-- =========================
-- 3. Products
-- =========================
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    brand_id INT,
    category_id INT,
    base_price DECIMAL(10,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- =========================
-- 4. Attributes (filters)
-- =========================
CREATE TABLE attributes (
    attribute_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    data_type ENUM('number','text','boolean','select')
);

-- =========================
-- 5. Category Attributes
-- =========================
CREATE TABLE category_attributes (
    category_id INT,
    attribute_id INT,
    PRIMARY KEY (category_id, attribute_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (attribute_id) REFERENCES attributes(attribute_id)
);

-- =========================
-- 6. Product Attribute Values
-- =========================
CREATE TABLE product_attribute_values (
    product_id INT,
    attribute_id INT,
    value VARCHAR(255),
    PRIMARY KEY (product_id, attribute_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (attribute_id) REFERENCES attributes(attribute_id)
);

-- =========================
-- 7. Warehouses
-- =========================
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    location VARCHAR(200)
);

-- =========================
-- 8. Inventory (stock)
-- =========================
CREATE TABLE inventory (
    warehouse_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- 9. Price history
-- =========================
CREATE TABLE prices (
    price_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    price DECIMAL(10,2),
    start_date DATETIME,
    end_date DATETIME,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- 10. Orders
-- =========================
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(200),
    phone VARCHAR(50),
    status ENUM('new','paid','shipped','delivered','cancelled'),
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- 11. Order Items
-- =========================
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- 12. Reviews
-- =========================
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- 13. Product Images
-- =========================
CREATE TABLE product_images (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    image_url VARCHAR(300),
    is_main BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
