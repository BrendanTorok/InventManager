--TABLES
CREATE TABLE product(
	product_id DECIMAL(12) PRIMARY KEY NOT NULL,
	inventory_id DECIMAL(12),
	abc_code_id DECIMAL(12),
	product_name VARCHAR(255) NOT NULL,
	product_usage VARCHAR(255) NULL,
	product_description VARCHAR(1024) NULL,
	product_price DECIMAL(10,2) NOT NULL,
	product_width DECIMAL(3) NOT NULL,
	product_depth DECIMAL(3) NOT NULL,
	product_height DECIMAL(3) NOT NULL,
	product_weight DECIMAL(10,2) NOT NULL,
	days_in_inventory DECIMAL(5) NULL,
	sales_volume DECIMAL(7) NOT NULL,
	sales_percentile DECIMAL(3) NOT NULL,
	obsolete_flag BOOLEAN NOT NULL
);

CREATE TABLE warehouse_inventory(
	inventory_id DECIMAL(12) PRIMARY KEY NOT NULL,
	product_id DECIMAL(12),
	location_id DECIMAL(12) NOT NULL,
	num_inventory DECIMAL(12) NOT NULL,
	open_order_quant DECIMAL(12) NULL,
	reserve_stock DECIMAL(7) NULL,
	FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE location_table(
	location_id DECIMAL(12) PRIMARY KEY NOT NULL,
	inventory_id DECIMAL(12) NULL,
	max_width DECIMAL(3) NOT NULL,
	max_depth DECIMAL(3) NOT NULL,
	max_height DECIMAL(3) NOT NULL,
	total_size_capacity DECIMAL(12) NOT NULL,
	max_weight DECIMAL(12) NOT NULL,
	location_type CHAR(1) NOT NULL,
	FOREIGN KEY (inventory_id) REFERENCES warehouse_inventory(inventory_id)
);

CREATE TABLE pallet(
	location_id DECIMAL(12) PRIMARY KEY NOT NULL,
	pallet_aisle DECIMAL(3) NOT NULL,
	FOREIGN KEY (location_id) REFERENCES location_table(location_id)
);

CREATE TABLE shelf(
	location_id DECIMAL(12) PRIMARY KEY NOT NULL,
	shelf_aisle DECIMAL(3) NOT NULL,
	FOREIGN KEY (location_id) REFERENCES location_table(location_id)
);

CREATE TABLE ground(
	location_id DECIMAL(12) PRIMARY KEY NOT NULL,
	ground_aisle DECIMAL(3) NOT NULL,
	FOREIGN KEY (location_id) REFERENCES location_table(location_id)
);

CREATE TABLE drawer(
	location_id DECIMAL(12) PRIMARY KEY NOT NULL,
	drawer_aisle DECIMAL(3) NOT NULL,
	FOREIGN KEY (location_id) REFERENCES location_table(location_id)
);

CREATE TABLE abc_threshold(
	threshold_id DECIMAL(1) PRIMARY KEY NOT NULL,
	threshold DECIMAL(2) NOT NULL
);

CREATE TABLE abc_code(
	abc_code_id DECIMAL(12) PRIMARY KEY NOT NULL,
	product_id DECIMAL(12) NOT NULL,
	threshold_id DECIMAL(1) NOT NULL,
	FOREIGN KEY (product_id) REFERENCES product(product_id),
	FOREIGN KEY (threshold_id) REFERENCES abc_threshold(threshold_id)
);

CREATE TABLE country(
	country_id DECIMAL(12) PRIMARY KEY NOT NULL,
	country_name VARCHAR(64) NOT NULL
);

CREATE TABLE state(
	state_id DECIMAL(12) PRIMARY KEY NOT NULL,
	state_name VARCHAR(64)
);
	
CREATE TABLE vendor(
	vendor_id DECIMAL(12) PRIMARY KEY NOT NULL,
	vendor_name VARCHAR(64) NOT NULL,
	vendor_location_type CHAR(1)
);

CREATE TABLE international_vendor(
	vendor_id DECIMAL(12) PRIMARY KEY NOT NULL,
	country_id DECIMAL(12),
	street1 VARCHAR(64) NOT NULL,
	street2 VARCHAR(64) NULL,
	city VARCHAR(255) NOT NULL,
	mail_code VARCHAR(64) NOT NULL,
	FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id),
	FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE domestic_vendor(
	vendor_id DECIMAL(12) PRIMARY KEY NOT NULL,
	street1 VARCHAR(64) NOT NULL,
	street2 VARCHAR(64) NULL,
	city VARCHAR(255) NOT NULL,
	state_id DECIMAL(12) NULL,
	mail_code VARCHAR(64) NOT NULL,
	FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id),
	FOREIGN KEY (state_id) REFERENCES state(state_id)
);

CREATE TABLE vendor_supply_link(
	vendor_supply_id DECIMAL(12) PRIMARY KEY NOT NULL,
	vendor_id DECIMAL(12) NOT NULL,
	product_id DECIMAL(12) NOT NULL,
	lead_time_days DECIMAL(4) NOT NULL,
	supply_price DECIMAL(10,2) NOT NULL,
	shipping_cost DECIMAL(6,2) NOT NULL,
	FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE discount(
	discount_id DECIMAL(12) PRIMARY KEY NOT NULL,
	discount DECIMAL(2) NOT NULL
);

CREATE TABLE customer(
	customer_id DECIMAL(12) PRIMARY KEY NOT NULL,
	tier_id DECIMAL (12) NOT NULL,
	customer_name VARCHAR(255) NOT NULL,
	customer_location_type CHAR(1) NOT NULL,
	customer_email VARCHAR(255) NOT NULL,
	customer_phone DECIMAL(11) NOT NULL,
	sales_value DECIMAL(12,2) NOT NULL
);

CREATE TABLE internal_account(
	internal_account_id DECIMAL(12) PRIMARY KEY NOT NULL,
	username VARCHAR(64) NOT NULL,
	encrypted_password VARCHAR(255) NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	created_on DATE NOT NULL,
	account_type CHAR(1) NOT NULL
);

CREATE TABLE administrator(
	internal_account_id DECIMAL(12) PRIMARY KEY NOT NULL,
	FOREIGN KEY (internal_account_id) REFERENCES internal_account(internal_account_id)
);

CREATE TABLE sales_account(
	internal_account_id DECIMAL(12) PRIMARY KEY NOT NULL,
	FOREIGN KEY (internal_account_id) REFERENCES internal_account(internal_account_id)
);

CREATE TABLE inventory_manager(
	internal_account_id DECIMAL(12) PRIMARY KEY NOT NULL,
	FOREIGN KEY (internal_account_id) REFERENCES internal_account(internal_account_id)
);

CREATE TABLE account_manager_link(
	account_manager_link_id DECIMAL(12) PRIMARY KEY NOT NULL,
	internal_account_id DECIMAL(12) NOT NULL,
	customer_id DECIMAL(12) NOT NULL,
	FOREIGN KEY (internal_account_id) REFERENCES internal_account(internal_account_id),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE international_customer_location(
	customer_id DECIMAL(12) PRIMARY KEY NOT NULL,
	country_id DECIMAL(12),
	street1 VARCHAR(64) NOT NULL,
	street2 VARCHAR(64) NULL,
	city VARCHAR(255) NOT NULL,
	mail_code VARCHAR(64) NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE domestic_customer_location(
	customer_id DECIMAL(12) PRIMARY KEY NOT NULL,
	street1 VARCHAR(64) NOT NULL,
	street2 VARCHAR(64) NULL,
	city VARCHAR(255) NOT NULL,
	state_id DECIMAL(12) NULL,
	mail_code VARCHAR(64) NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY (state_id) REFERENCES state(state_id)
);

CREATE TABLE customer_tier(
	tier_id DECIMAL(12) PRIMARY KEY NOT NULL,
	customer_id DECIMAL(12) NOT NULL,
	tier_type CHAR(1),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE paid_priority_customers(
	tier_id DECIMAL(12) PRIMARY KEY NOT NULL,
	discount_id DECIMAL(12) NOT NULL,
	renewal_date DATE NOT NULL,
	priority_product_id DECIMAL(12) NULL,
	FOREIGN KEY (tier_id) REFERENCES customer_tier(tier_id),
	FOREIGN KEY (discount_id) REFERENCES discount(discount_id),
	FOREIGN KEY (priority_product_id) REFERENCES product(product_id)
);

CREATE TABLE paid_customers(
	tier_id DECIMAL(12) PRIMARY KEY NOT NULL,
	discount_id DECIMAL(12) NOT NULL,
	renewal_date DATE NOT NULL,
	FOREIGN KEY (tier_id) REFERENCES customer_tier(tier_id),
	FOREIGN KEY (discount_id) REFERENCES discount(discount_id)
);

CREATE TABLE free_customers(
	tier_id DECIMAL(12) PRIMARY KEY NOT NULL,
	markup DECIMAL(2) NOT NULL,
	FOREIGN KEY (tier_id) REFERENCES customer_tier(tier_id)
);

CREATE TABLE order_table(
	order_id DECIMAL(12) PRIMARY KEY NOT NULL,
	customer_id DECIMAL(12) NOT NULL,
	shipping_cost DECIMAL(7,2) NOT NULL,
	order_price_total DECIMAL(12,2) NOT NULL,
	delivery_date DATE NOT NULL,
	order_date DATE NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE product_price_link(
	product_price_link_id DECIMAL(12) PRIMARY KEY NOT NULL,
	product_id DECIMAL(12) NOT NULL,
	tier_id DECIMAL(12) NOT NULL,
	order_id DECIMAL(12) NOT NULL,
	purchase_price DECIMAL(12) NOT NULL,
	order_quantity DECIMAL(12) NOT NULL,
	FOREIGN KEY (product_id) REFERENCES product(product_id),
	FOREIGN KEY (tier_id) REFERENCES customer_tier(tier_id),
	FOREIGN KEY (order_id) REFERENCES order_table(order_id)
);

CREATE TABLE product_price_change(
	product_price_change_id DECIMAL(12) NOT NULL PRIMARY KEY,
	old_product_price DECIMAL(10,2) NOT NULL,
	new_product_price DECIMAL(10,2) NOT NULL,
	product_id DECIMAL(12) NOT NULL,
	product_price_change_date DATE,
	FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE inventory_change(
	num_inventory_change_id DECIMAL(12) NOT NULL PRIMARY KEY,
	old_num_inventory DECIMAL(12) NOT NULL,
	new_num_inventory DECIMAL(12) NOT NULL,
	inventory_id DECIMAL(12) NOT NULL,
	num_inventory_change_date DATE,
	FOREIGN KEY (inventory_id) REFERENCES warehouse_inventory(inventory_id)
);

CREATE TABLE open_order_quant_change(
	open_order_quant_change_id DECIMAL(12) NOT NULL PRIMARY KEY,
	old_open_order_quant DECIMAL(12) NOT NULL,
	new_open_order_quant DECIMAL(12) NOT NULL,
	inventory_id DECIMAL(12) NOT NULL,
	open_order_quant_change_date DATE,
	FOREIGN KEY (inventory_id) REFERENCES warehouse_inventory(inventory_id)
);

ALTER TABLE product
ADD CONSTRAINT inventory_id_fk
FOREIGN KEY (inventory_id)
REFERENCES warehouse_inventory(inventory_id);

ALTER TABLE product
ADD CONSTRAINT abc_code_id_fk
FOREIGN KEY (abc_code_id)
REFERENCES abc_code(abc_code_id);

ALTER TABLE warehouse_inventory
ADD CONSTRAINT location_id_fk
FOREIGN KEY (location_id)
REFERENCES location_table(location_id);

ALTER TABLE customer
ADD CONSTRAINT tier_id_fk
FOREIGN KEY (tier_id) 
REFERENCES customer_tier(tier_id);

--SEQUENCES
CREATE SEQUENCE product_id_seq START WITH 1;
CREATE SEQUENCE inventory_id_seq START WITH 1;
CREATE SEQUENCE location_id_seq START WITH 1;
CREATE SEQUENCE abc_code_id_seq START WITH 1;
CREATE SEQUENCE country_id_seq START WITH 1;
CREATE SEQUENCE state_id_seq START WITH 1;
CREATE SEQUENCE vendor_id_seq START WITH 1;
CREATE SEQUENCE vendor_supply_id_seq START WITH 1;
CREATE SEQUENCE discount_id_seq START WITH 1;
CREATE SEQUENCE customer_id_seq START WITH 1;
CREATE SEQUENCE internal_account_id_seq START WITH 1;
CREATE SEQUENCE account_manager_link_id_seq START WITH 1;
CREATE SEQUENCE tier_id_seq START WITH 1;
CREATE SEQUENCE order_id_seq START WITH 1;
CREATE SEQUENCE product_price_link_id_seq START WITH 1;
CREATE SEQUENCE product_price_change_seq START WITH 1;
CREATE SEQUENCE num_inventory_change_seq START WITH 1;
CREATE SEQUENCE open_order_quant_change_seq START WITH 1;

--INDEXES
CREATE INDEX product_price_idx
ON product(product_price);

CREATE INDEX product_sales_volume_idx
ON product(sales_volume);

CREATE INDEX inventory_num_idx
ON warehouse_inventory(num_inventory);

--STORED PROCEDURES
CREATE OR REPLACE PROCEDURE add_inventory(--add inventory for a product
	product_id_arg IN VARCHAR, -- the product id 
	num_inventory_arg IN DECIMAL, -- the amount of product inventory 
	open_order_quant_arg IN DECIMAL, -- the amount of product currently out on order
	reserve_stock_arg IN DECIMAL) -- the amount of product on reserve stock
	LANGUAGE plpgsql
	
AS $reusableproc$
	DECLARE v_product_id DECIMAL;
BEGIN
	-- Exception block
	BEGIN
		SELECT product_id INTO v_product_id
		FROM product
		WHERE product_name = product_id_arg;

		INSERT INTO warehouse_inventory(inventory_id, product_id_arg, location_id, num_inventory, open_order_quant, reserve_stock)
		VALUES(nextval('inventory_id_seq'), v_product_id, NULL, num_inventory_arg, open_order_quant_arg, reserve_stock_arg);
	END;
	EXCEPTION
		WHEN others THEN
			-- Rollback any changes made if an exception occurs
			RAISE NOTICE 'Error %', SQLERRM;
			ROLLBACK;
END;
$reusableproc$;

CREATE OR REPLACE PROCEDURE add_domestic_vendor(--add domestic vendor
	vendor_id_arg IN DECIMAL, -- the vendor id
	state_arg in VARCHAR, -- the state of the domestic vendor
	street1_arg IN VARCHAR, -- the street1 address 
	street2_arg IN VARCHAR, -- the street2 address
	city_arg IN VARCHAR, -- the city the domestic vendor is in
	mail_code in VARCHAR) -- the mailcode for the domestic vendor
	LANGUAGE plpgsql
	
AS $reusableproc$
DECLARE v_state_id DECIMAL;
BEGIN
	-- Exception block
	BEGIN
		-- check if state exists in state table, if not, insert it
		SELECT state_id INTO v_state_id
		FROM state
		WHERE state_name = state_arg;
		IF NOT FOUND THEN
			INSERT INTO state(state_id, state_id)
			VALUES(nextval('state_id_seq'), state_arg)
			RETURNING state_id INTO v_state_id;
		END IF;

		-- Insert into domestic vendor
		INSERT INTO domestic_vendor(vendor_id, v_state_id, street1, street2, city, mail_code)
		VALUES(vendor_id_arg, v_state_id, street1_arg, street2_arg, city_arg, mail_code_arg);
	END;
	EXCEPTION
		WHEN others THEN
			-- Rollback any changes made if an exception occurs
			RAISE NOTICE 'Error %', SQLERRM;
			ROLLBACK;
END;
$reusableproc$;


CREATE OR REPLACE PROCEDURE add_international_vendor(--add international vendor
	vendor_id_arg IN DECIMAL, -- the vendor id
	vendor_name_arg IN VARCHAR, -- the name of the vendor
	vendor_location_type IN CHAR, -- the location type of the vendor
	country_arg in VARCHAR, -- the country of the international vendor
	street1_arg IN VARCHAR, -- the street1 address 
	street2_arg IN VARCHAR, -- the street2 address
	city_arg IN VARCHAR, -- the city the international vendor is in
	mail_code in VARCHAR) -- the mailcode for the international vendor
	LANGUAGE plpgsql
	
AS $reusableproc$
DECLARE v_country_id DECIMAL;
BEGIN
	-- Exception block
	BEGIN
		-- Check if country exists in country table, if not, insert it
		SELECT country_id INTO v_country_id
		FROM country
		WHERE country_name = country_arg;
		IF NOT FOUND THEN
			INSERT INTO country(country_id, country_id)
			VALUES(nextval('country_id_seq'), country_arg)
			RETURNING country_id INTO v_country_id;
		END IF;

		-- Insert into international vendor
		INSERT INTO vendor(vendor_id, vendor_name, vendor_location_type)
		VALUES(nextval('vendor_id_seq'), vendor_name_arg, vendor_location_type_arg);
		INSERT INTO international_vendor(vendor_id, v_country_id, street1, street2, city, mail_code)
		VALUES(currval('vendor_id_seq'), v_country_id, street1_arg, street2_arg, city_arg, mail_code_arg);
	END;
	EXCEPTION
		WHEN others THEN
			-- Rollback any changes made if an exception occurs
			RAISE NOTICE 'Error %', SQLERRM;
			ROLLBACK;
END;
$reusableproc$;


CREATE OR REPLACE PROCEDURE add_vendor_supply_link(--add vendor_supply link
	vendor_supply_id_arg IN DECIMAL, -- the vendor supply link id
	vendor_id_arg IN VARCHAR, -- the name of the vendor
	product_id_arg IN VARCHAR, -- the name of the product
	lead_time_days_arg in DECIMAL, -- the lead time for the product
	supply_price_arg IN DECIMAL, -- the cost of the product from the vendor
	shipping_cost_arg IN DECIMAL) -- cost of shipping the product from the vendor
	
	LANGUAGE plpgsql
	
AS $reusableproc$
DECLARE v_vendor_id DECIMAL;
DECLARE v_product_id DECIMAL;
BEGIN
	-- Exception block
	BEGIN
		-- get the vendor id value and insert it into the vendor id variable
		SELECT vendor_id INTO v_vendor_id
		FROM vendor
		WHERE vendor_name = vendor_id_arg;

		-- get the product id value and insert it into the product id variable
		SELECT product_id INTO v_product_id
		FROM product
		WHERE product_name = product_id_arg;
	
		-- Insert the values into vendor supply link
		INSERT INTO vendor_supply_link(vendor_supply_id, vendor_id_arg, product_id_arg, lead_time_days, supply_price,
		shipping_cost)
		VALUES(nextval('vendor_supply_link_id_seq'), v_vendor_id, v_product_id, lead_time_days_arg, 
		supply_price_arg, shipping_cost_arg);
	EXCEPTION
		WHEN others THEN
			-- Rollback any changes made if an exception occurs
			RAISE NOTICE 'Error %', SQLERRM;
			ROLLBACK;
	END;
END;
$reusableproc$;


CREATE OR REPLACE PROCEDURE add_internal_account(--add internal account
	username_arg IN VARCHAR, -- the username of the account
	encrypted_password_arg IN VARCHAR, -- the encrypted password associated with the internal account
	first_name_arg in DECIMAL, -- the first name associated with the internal account
	last_name_arg IN DECIMAL, -- the last name associated with the internal account
	email_arg IN DECIMAL, -- the email address associated with the internal account
	account_type_arg IN CHAR) -- the type of account created
	LANGUAGE plpgsql
	
AS $reusableproc$
BEGIN
	-- Exception block
	BEGIN
		-- Insert into the internal account table
		INSERT INTO internal_account(internal_account_id, username, encrypted_password, first_name, last_name, email, 
		created_on, account_type)
		VALUES(nextval('internal_account_id_seq'), username_arg, encrypted_password_arg, first_name_arg, last_name_arg,
		email_arg, CURRENT_DATE, account_type_arg);
		CASE 
			WHEN account_type_arg = 1 THEN
				INSERT INTO administrator(internal_account_id)
				VALUES (currval('internal_account_id_seq'));
			WHEN account_type_arg = 2 THEN
				INSERT INTO sales_account(internal_account_id)
				VALUES (currval('internal_account_id_seq'));
			ELSE
				INSERT INTO inventory_manager(internal_account_id)
				VALUES (currval('internal_account_id_seq'));
		END CASE;
	EXCEPTION
		WHEN others THEN
			-- Rollback any changes made if an exception occurs
			RAISE NOTICE 'Error %', SQLERRM;
			ROLLBACK;
	END;
END;
$reusableproc$;


CREATE OR REPLACE PROCEDURE add_product_with_inventory(
    product_name_arg IN VARCHAR, -- name of product
    product_usage_arg IN VARCHAR, -- usage of product
    product_description_arg IN VARCHAR, -- description of product
    product_price_arg IN DECIMAL, -- price of product in inches
    product_width_arg IN DECIMAL, -- width of product in inches
    product_depth_arg IN DECIMAL, -- depth of product in inches
    product_height_arg IN DECIMAL, -- height of product in inches
    product_weight_arg IN DECIMAL,  -- weight of product in lbs
    days_in_inventory_arg IN DECIMAL, -- amount of days product has been in inventory
    sales_volume_arg IN DECIMAL, -- sales volume for month
    sales_percentile_arg IN DECIMAL, -- sales percentile
    obsolete_flag IN BOOLEAN, -- product obsolete or not
    num_inventory_arg IN DECIMAL, -- number of product in inventory
    open_order_quant_arg IN DECIMAL, -- number of product currently on order
    reserve_stock_arg IN DECIMAL, -- minimum stock for product
    threshold_id_arg IN DECIMAL, -- threshold id
    max_width_arg IN DECIMAL, -- max width in location it is stored
    max_depth_arg IN DECIMAL, -- max depth in location it is stored
    max_height_arg IN DECIMAL, -- max height in location it is stored
    total_size_capacity_arg IN DECIMAL, -- max total size in location  it is stored
    max_weight_arg IN DECIMAL, -- max weight in location it is stored
    location_type IN CHAR) -- the type of location product is stored in
LANGUAGE plpgsql
AS $reusableproc$
DECLARE 
    v_product_id DECIMAL;
	v_inventory_id DECIMAL;
    v_location_id DECIMAL;
    v_abc_code_id DECIMAL;
BEGIN
	-- Error handling block
	BEGIN
    	-- Insert into location table
    	INSERT INTO location_table(location_id, max_width, max_depth, max_height, total_size_capacity, max_weight, location_type)
    	VALUES(nextval('location_id_seq'), max_width_arg, max_depth_arg, max_height_arg, total_size_capacity_arg, max_weight_arg,
    	location_type)
    	SELECT currval('location_id_seq') INTO v_location_id;

    	-- Insert into product table
    	INSERT INTO product(product_id, inventory_id, abc_code_id, product_name, product_usage, product_description, product_price, 
        product_width, product_depth, product_height, product_weight, days_in_inventory, sales_volume, sales_percentile,
        obsolete_flag)
    	VALUES(
        nextval('product_id_seq'), NULL, NULL, product_name_arg, product_usage_arg, product_description_arg, product_price_arg, 
        product_width_arg, product_depth_arg, product_height_arg, product_weight_arg, days_in_inventory_arg, sales_volume_arg, 
        sales_percentile_arg, obsolete_flag)
    
    	SELECT currval('product_id_seq') INTO v_product_id;

    	-- Insert into warehouse_inventory table
    	INSERT INTO warehouse_inventory(inventory_id, product_id, location_id, num_inventory, open_order_quant, 
        reserve_stock)
    	VALUES(nextval('inventory_id_seq'), v_product_id, v_location_id, num_inventory_arg, open_order_quant_arg, 
        reserve_stock_arg)
		SELECT currval('inventory_id_seq') INTO v_inventory_id;

    	-- Insert into abc_code table
    	INSERT INTO abc_code(abc_code_id, product_id, threshold_id)
    	VALUES(nextval('abc_code_id_seq'), v_product_id, threshold_id_arg)
    	SELECT currval('abc_code_id_seq') INTO v_abc_code_id;

    	-- Update product table with abc_code_id
   		UPDATE product
    	SET abc_code_id = v_abc_code_id,
	    inventory_id = v_inventory_id
    	WHERE product_id = v_product_id;
	EXCEPTION
		WHEN others THEN
			-- Rollback any changes made if an exception occurs
			RAISE NOTICE 'Error %', SQLERRM;
			ROLLBACK;
	END;
END;
$reusableproc$;

CREATE OR REPLACE PROCEDURE add_product(--add a new product to the product table
	product_name_arg IN VARCHAR, -- the product name
	product_usage_arg IN VARCHAR, -- the usage of the product
	product_description_arg IN VARCHAR, -- description of the product
	product_price_arg IN DECIMAL, -- the price of the produce
	product_width_arg IN DECIMAL, -- the width of the product
	product_depth_arg IN DECIMAL, -- the depth of the product
	product_height_arg IN DECIMAL, -- the depth of the product
	days_in_inventory_arg IN DECIMAL, -- the amount of days the product has been in the inventory
	sales_volume_arg IN DECIMAL, -- how many sales the product has
	sales_percentile_arg IN DECIMAL, -- the sales percentile the product falls in
	obsolete_flag IN BOOLEAN) -- if the product is obsolete or not
	LANGUAGE plpgsql

AS $reusableproc$
BEGIN
	INSERT INTO product(product_id, inventory_id, abc_code_id, product_name, product_usage, product_description,
	product_price, product_width, product_depth, product_height, days_in_inventory, sales_volume, sales_percentile,
	obsolete_flag)
	VALUES(nextval('product_id_seq'), NULL, NULL, product_name_arg, product_usage_arg, product_description_arg, 
	product_price_arg, product_width_arg, product_depth_arg, product_height_arg, days_in_inventory_arg, sales_volume_arg, 
	sales_percentile_arg, obsolete_flag);

END;
$reusableproc$;

--TRIGGERS
CREATE OR REPLACE FUNCTION product_price_change_history_func()
RETURNS TRIGGER LANGUAGE plpgsql
AS $trigfunc$
BEGIN
	IF OLD.product_price <> NEW.product_price THEN
		INSERT INTO product_price_change(product_price_change_id, old_product_price, 
		new_product_price, product_id, product_price_change_date)
		VALUES(nextval('product_price_change_seq'), OLD.product_price, NEW.product_price, 
		NEW.product_id, CURRENT_DATE);
	END IF;
	RETURN NEW;
END;
$trigfunc$;
CREATE TRIGGER product_price_change_history_trg
BEFORE UPDATE on product
FOR EACH ROW
EXECUTE PROCEDURE product_price_change_history_func();

CREATE OR REPLACE FUNCTION num_inventory_change_history_func()
RETURNS TRIGGER LANGUAGE plpgsql
AS $trigfunc$
BEGIN
	IF OLD.num_inventory <> NEW.num_inventory THEN
		INSERT INTO inventory_change(num_inventory_change_id, old_num_inventory, 
		new_num_inventory, inventory_id, num_inventory_change_date)
		VALUES(nextval('num_inventory_change_seq'), OLD.num_inventory, NEW.num_inventory, 
		NEW.inventory_id, CURRENT_DATE);
	END IF;
	RETURN NEW;
END;
$trigfunc$;
CREATE TRIGGER num_inventory_change_history_trg
BEFORE UPDATE on warehouse_inventory
FOR EACH ROW
EXECUTE PROCEDURE num_inventory_change_history_func();

CREATE OR REPLACE FUNCTION open_order_quant_change_history_func()
RETURNS TRIGGER LANGUAGE plpgsql
AS $trigfunc$
BEGIN
	IF OLD.open_order_quant <> NEW.open_order_quant THEN
		INSERT INTO open_order_quant_change(open_order_quant_change_id, old_open_order_quant, 
		new_open_order_quant, inventory_id, open_order_quant_change_date)
		VALUES(nextval('open_order_quant_change_seq'), OLD.open_order_quant, NEW.open_order_quant, 
		NEW.inventory_id, CURRENT_DATE);
	END IF;
	RETURN NEW;
END;
$trigfunc$;
CREATE TRIGGER open_order_quant_change_history_trg
BEFORE UPDATE on warehouse_inventory
FOR EACH ROW
EXECUTE PROCEDURE open_order_quant_change_history_func();

--QUERIES
SELECT product_name, product_description, num_inventory
FROM product
JOIN warehouse_inventory ON product.product_id = warehouse_inventory.product_id
JOIN location_table ON warehouse_inventory.location_id = location_table.location_id
JOIN abc_code ON product.product_id = abc_code.product_id
JOIN drawer ON location_table.location_id = drawer.location_id
WHERE abc_code.threshold_id = 1
ORDER BY warehouse_inventory.num_inventory DESC;


SELECT product_name, product_price, days_in_inventory, sales_volume, location_type, open_order_quant
FROM product
JOIN warehouse_inventory ON product.product_id = warehouse_inventory.product_id
JOIN location_table ON warehouse_inventory.location_id = location_table.location_id
LEFT JOIN abc_code ON product.product_id = abc_code.product_id
WHERE abc_code.threshold_id = 3 AND warehouse_inventory.open_order_quant > 25;

CREATE OR REPLACE VIEW low_inventory_high_volume_view AS
SELECT product_name, product_description, product_price, sales_volume, num_inventory
FROM product
JOIN warehouse_inventory ON product.product_id = warehouse_inventory.product_id
WHERE warehouse_inventory.num_inventory < 100 AND product.sales_volume > 50
ORDER BY product_name;
SELECT * FROM low_inventory_high_volume_view;


SELECT 
    price_range,
    COUNT(products_above_20.product_id) AS count_products_above_20_sales
FROM (
    SELECT 
        CASE 
            WHEN product_price BETWEEN 0 AND 20 THEN '$0-$20'
            WHEN product_price BETWEEN 20 AND 100 THEN '$20-$100'
            WHEN product_price BETWEEN 100 AND 500 THEN '$100-$500'
            WHEN product_price BETWEEN 500 AND 1000 THEN '$500-$1000'
            WHEN product_price BETWEEN 1000 AND 5000 THEN '$1000-$5000'
            WHEN product_price > 5000 THEN '$5000'
        END AS price_range,
        product.product_id
    FROM product
) 
AS products_above_20
LEFT JOIN product ON products_above_20.product_id = product.product_id AND product.sales_volume > 20
GROUP BY 
    price_range;


SELECT 
    CASE 
        WHEN warehouse_inventory.reserve_stock = 0 THEN '0'
        WHEN warehouse_inventory.reserve_stock = 1 THEN '1'
        WHEN warehouse_inventory.reserve_stock = 2 THEN '2'
		WHEN warehouse_inventory.reserve_stock = 3 THEN '3'
		WHEN warehouse_inventory.reserve_stock = 4 THEN '4'
        ELSE '5+'
    END AS reserve_stock_range, COUNT(*) AS count_products
FROM product
JOIN warehouse_inventory ON product.inventory_id = warehouse_inventory.inventory_id
WHERE product.sales_volume = 0
GROUP BY reserve_stock_range;