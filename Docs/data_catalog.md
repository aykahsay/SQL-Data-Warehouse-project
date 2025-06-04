# 📘 Gold Layer Data Dictionary

## Overview

The **Gold Layer** represents the business-level view of the data warehouse, structured for analytics and reporting. It contains curated **dimension** and **fact** tables used across business intelligence tools.

---

## 1. `gold.dim_customers`

**Purpose:**  
Stores customer details enriched with demographic, geographic, and CRM data.

| Column Name       | Data Type      | Description                                                                 |
|-------------------|----------------|-----------------------------------------------------------------------------|
| `customer_key`    | `INT`          | Surrogate key generated using `ROW_NUMBER()` to uniquely identify each record. |
| `customer_id`     | `INT`          | Raw customer ID from CRM system.                                            |
| `customer_number` | `NVARCHAR`     | Unique customer code/key from CRM.                                          |
| `first_name`      | `NVARCHAR(50)` | Customer’s first name from CRM.                                             |
| `last_name`       | `NVARCHAR(50)` | Customer’s last name from CRM.                                              |
| `country`         | `NVARCHAR`     | Country from the ERP location mapping.                                      |
| `marital_status`  | `NVARCHAR`     | Marital status as recorded in CRM.                                          |
| `gender`          | `NVARCHAR`     | Gender field prioritized from CRM; fallback to ERP if not available.        |
| `birthdate`       | `DATE`         | Customer’s birth date from ERP source.                                      |
| `create_date`     | `DATE`         | Date when the customer was created in the CRM system.                       |

---

## 2. `gold.dim_products`

**Purpose:**  
Contains enriched product information including cost, category, and lifecycle dates.

| Column Name        | Data Type        | Description                                                              |
|--------------------|------------------|--------------------------------------------------------------------------|
| `product_key`      | `INT`            | Surrogate key for the product dimension.                                 |
| `product_id`       | `INT`            | System-generated product ID.                                             |
| `product_name`     | `NVARCHAR(100)`  | Name of the product.                                                     |
| `category_id`      | `INT`            | ID representing the product's category.                                  |
| `category`         | `NVARCHAR(100)`  | Business category of the product.                                        |
| `subcategory`      | `NVARCHAR(100)`  | Business subcategory of the product.                                     |
| `maintenance_type` | `NVARCHAR(100)`  | Indicates type of maintenance required (if any).                         |
| `product_cost`     | `DECIMAL(18,2)`  | Cost to produce or acquire the product.                                  |
| `product_line`     | `NVARCHAR(50)`   | Product line grouping for reporting.                                     |
| `start_date`       | `DATE`           | Product activation/start date.                                           |
| `end_date`         | `DATE`           | Product deactivation/end date. Null if still active.                     |

---

## 3. `gold.fact_sales`

**Purpose:**  
Stores detailed sales transactions, linked to customer and product dimensions for reporting.

| Column Name     | Data Type       | Description                                                           |
|------------------|------------------|-----------------------------------------------------------------------|
| `sls_ord_num`    | `INT`            | Sales order number.                                                   |
| `product_key`    | `INT`            | Foreign key to `dim_products`.                                        |
| `customer_key`   | `INT`            | Foreign key to `dim_customers`.                                       |
| `sls_prd_key`    | `INT`            | Product key from source system.                                       |
| `sls_cust_id`    | `INT`            | Customer ID from source system.                                       |
| `sls_order_dt`   | `DATE`           | Date the order was placed.                                            |
| `sls_ship_dt`    | `DATE`           | Date the order was shipped.                                           |
| `sls_due_dt`     | `DATE`           | Date the order was due.                                               |
| `sls_sales`      | `DECIMAL(18,2)`  | Total value of the sale.                                              |
| `sls_quantity`   | `INT`            | Number of units sold.                                                 |
| `sls_price`      | `DECIMAL(18,2)`  | Unit price at which the product was sold.                             |

---

## Notes

- All tables follow **surrogate key** design for consistency across joins.
- Gold layer is intended for **reporting, dashboards, and business KPIs**.
- Source systems: `CRM`, `ERP`, and intermediate `Silver` layer.

---
