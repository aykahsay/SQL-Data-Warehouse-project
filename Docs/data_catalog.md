📘 Data Dictionary for Gold Layer
Overview

The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.
1. gold.dim_customers

    Purpose:
    Stores customer details enriched with demographic and geographic data.

Column Name	Data Type	Description
customer_key	INT	Surrogate key uniquely identifying each customer record in the dimension table.
customer_id	INT	Unique numerical identifier assigned to each customer.
customer_number	NVARCHAR(50)	Alphanumeric identifier representing the customer, used for tracking.
first_name	NVARCHAR(50)	Customer's first name as recorded in the system.
last_name	NVARCHAR(50)	Customer’s last name or family name.
2. gold.dim_products

    Purpose:
    Contains enriched product information including cost, category, and lifecycle dates.

Column Name	Data Type	Description
product_key	INT	Surrogate key for the product dimension.
product_id	INT	System-generated product ID.
product_name	NVARCHAR(100)	Name of the product.
category_id	INT	ID representing the product's category.
category	NVARCHAR(100)	Business category of the product.
subcategory	NVARCHAR(100)	Business subcategory of the product.
maintenance_type	NVARCHAR(100)	Indicates type of maintenance required (if any).
product_cost	DECIMAL(18,2)	Cost to produce or acquire the product.
product_line	NVARCHAR(50)	Product line grouping for reporting.
start_date	DATE	Product activation/start date.
end_date	DATE	Product deactivation/end date. Null if still active.
3. gold.fact_sales

    Purpose:
    Stores detailed sales transactions, joined with customer and product dimensions.

Column Name	Data Type	Description
sls_ord_num	INT	Sales order number.
product_key	INT	FK to dim_products.
customer_key	INT	FK to dim_customers.
sls_prd_key	INT	System product key from source system.
sls_cust_id	INT	System customer ID from source system.
sls_order_dt	DATE	Date the order was placed.
sls_ship_dt	DATE	Date the order was shipped.
sls_due_dt	DATE	Date the order was due.
sls_sales	DECIMAL(18,2)	Total value of the sale.
sls_quantity	INT	Number of units sold.
sls_price	DECIMAL(18,2)	Unit price at which the product was sold.
