-- Up Migration

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(10) NOT NULL
);

CREATE TABLE warehouses (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE warehouse_receipts (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    receipt_number VARCHAR(255) NOT NULL UNIQUE,
    date DATE NOT NULL,
    debit_account VARCHAR(255),
    credit_account VARCHAR(255),
    supplier_name VARCHAR(255) NOT NULL,
    document_ref VARCHAR(255),
    document_date DATE,
    warehouse_id INTEGER REFERENCES warehouses (id) ON DELETE SET NULL,
    total_amount NUMERIC(12, 2) NOT NULL CHECK (total_amount >= 0),
    total_amount_text VARCHAR(255),
    created_by_id INTEGER REFERENCES employees (id) ON DELETE SET NULL,
    delivered_by_id INTEGER REFERENCES employees (id) ON DELETE SET NULL,
    warehouseman_id INTEGER REFERENCES employees (id) ON DELETE SET NULL,
    accountant_id INTEGER REFERENCES employees (id) ON DELETE SET NULL
);

CREATE TABLE receipt_items (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    receipt_id INTEGER NOT NULL REFERENCES warehouse_receipts (id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    unit VARCHAR(255) NOT NULL,
    quantity_doc NUMERIC(10, 2) NOT NULL CHECK (quantity_doc >= 0),
    quantity_actual NUMERIC(10, 2) NOT NULL CHECK (quantity_actual >= 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    total_price NUMERIC(12, 2) NOT NULL CHECK (total_price >= 0)
);

CREATE INDEX idx_receipt_items_receipt_id ON receipt_items (receipt_id);

CREATE INDEX idx_receipt_items_product_id ON receipt_items (product_id);

CREATE INDEX idx_warehouse_receipts_warehouse_id ON warehouse_receipts (warehouse_id);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_employees_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trigger_update_warehouses_updated_at
BEFORE UPDATE ON warehouses
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trigger_update_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trigger_update_warehouse_receipts_updated_at
BEFORE UPDATE ON warehouse_receipts
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trigger_update_receipt_items_updated_at
BEFORE UPDATE ON receipt_items
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- Down Migration
DROP INDEX IF EXISTS idx_receipt_items_receipt_id;

DROP INDEX IF EXISTS idx_receipt_items_product_id;

DROP INDEX IF EXISTS idx_warehouse_receipts_warehouse_id;

DROP TRIGGER IF EXISTS trigger_update_receipt_items_updated_at ON receipt_items;

DROP TRIGGER IF EXISTS trigger_update_warehouse_receipts_updated_at ON warehouse_receipts;

DROP TRIGGER IF EXISTS trigger_update_products_updated_at ON products;

DROP TRIGGER IF EXISTS trigger_update_warehouses_updated_at ON warehouses;

DROP TRIGGER IF EXISTS trigger_update_employees_updated_at ON employees;

DROP FUNCTION IF EXISTS set_updated_at ();

DROP TABLE IF EXISTS receipt_items;

DROP TABLE IF EXISTS warehouse_receipts;

DROP TABLE IF EXISTS products;

DROP TABLE IF EXISTS warehouses;

DROP TABLE IF EXISTS employees;