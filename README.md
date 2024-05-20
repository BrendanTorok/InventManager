# InventManager
SQL Relational Database for inventory management.
This database was initially created as a final project for Boston University CS 669.

# Use Cases: 

Internal Account Sign-in/Account Creation
1.	Internal user navigates to InventManager application and is prompted to log in
2.	If the user has an account, the database checks existing accounts and allows them in if credentials are correct 
3.	If the user does not have an account, directed to system administrator who creates account
4.	Account email, name, password, and user level of administrator, inventory manager, or sales account is stored.
5.	User logs in for the first time and is prompted to change their password, password in the database is updated to new password. 


New product is added to inventory
1.	Inventory manager adds a new product to the inventory
2.	The new product_id, product_name, dimensions, description, usage, product_cost, vendor, vendor location (international or domestic), lead_time, and inventory must be updated 
3.	If the product does not have any current inventory, the product must be ordered 

A product is sold
1.	Inventory must be updated
2.	Daily, weekly, monthly, quarterly, and yearly sales must be updated
3.	ABC code is updated if sales reach threshold
4.	ABC codes include Code A, Code B, Code C, and Code D

Customer orders a product with no inventory
1.	Inventory reaches 0 for a product
2.	Customer orders product
3.	Customer_id is checked to determine if customer tier is priority paid, paid, or free customer which determines the pricing for a product
4.	Vendor location is checked to see if it is an international or domestic vendor which impacts pricing and lead time
5.	Customer is given an expected order delivery_date must be added as well as the order_size and order_date. An order_id is also given for the order
6.	The customer location must also be checked to see if it is domestic, international, or both to determine shipping costs and expected delivery date

A product is no longer being created but exists in inventory
1.	The option to order the product is disabled by setting obsolete_flag to true
2.	Customers and managers can no longer order products 
3.	Existing inventory can still be sold
4.	When all existing inventory is sold, location_id must be cleared for use by new products
5.	Locations may be on a pallet, the ground, in shelving, in drawers, or none of these

Lead time update
1.	A manufacturer changes time to build, or shipment time changes for a product
2.	Database must be updated to reflect new lead time
3.	All future orders are given the new lead time when orders are placed

A product with a high priority ABC code reaches safety stock threshold
1.	A product is sold and the order size causes the current inventory to dip below safety stock threshold
2.	Internal order must be placed
3.	Expected delivery date and open order quantity is added to inventory

Manager sales history inquiries
1.	A manager inquires whether a large product sells enough to justify its space
2.	Product is searched in the database
3.	The sales history is returned for the day, week, month, quarter, and year
4.	Volume of sales is also returned for the product as well as time in inventory

Customer database inquires
1.	Customer inquires whether a product is sold from warehouse
2.	The database must be searched for the product description and uses based on customer information
3.	If the product exists, the customer is given the product_cost based on their customer_tier and inventory
4.	If the product exists and there is no inventory, customer is given an expected delivery date if it is already ordered or the option to order the product
5.	If product does not exist in database, customer is told the product is not distributed by the warehouse


# Database Rules

1.	Each account must be a sales account, inventory manager, or administrator.
2.	Each product must be supplied by one or more vendors; each vendor supplies one or many products.
3.	Each product occupied warehouse inventory; warehouse inventory may be occupied by many products.
4.	Vendors must be either international or domestic.
5.	Each product has an associated ABC code threshold; each ABC code threshold may have multiple associated products.
6.	Each customer must be associated with one customer tier; each customer tier may be associated with zero to many customers.
7.	A customer tier is priority paid, paid, or free.
8.	Each order is associated with a customer; each customer may be associated with many orders.
9.	Each order must have at least one product and may be associated with many products; each product may be associated with many orders.
10.	Each internal sales account may be associated with many customers; each customer may be associated with 1 to many internal sales accounts.
11.	Customer location must be specified and can be international, domestic, or both.
12.	Each product may have a location; each location may have a product.
13.	Product inventory locations can be on a pallet, the ground, in shelving, in drawers, or none of these.
14.	Each international customer and vendor has a country; each country may be associated with many international customers or vendors.
15.	Each international and domestic customer and vendor has a state; each state may be associated with many international and domestic customers and vendors.
16.	Each paid priority and paid customer has a discount; each discount may be associated with many paid customers

