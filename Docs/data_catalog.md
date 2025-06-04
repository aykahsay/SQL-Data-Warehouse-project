# 📘 Gold Layer Data Dictionary

## Overview

The **Gold Layer** is the business-level data representation, structured to support **analytical** and **reporting** use cases. It consists of **dimension tables** and **fact tables** that store cleaned, conformed, and enriched data.

---

## 1. `gold.dim_customers`

**Purpose:**  
Stores customer details enriched with demographic and geographic data.

| Column Name      | Data Type      | Description                                                              |
|------------------|----------------|--------------------------------------------------------------------------|
| `customer_key`   | `INT`          | Surrogate key uniquely identifying each customer record.                 |
| `customer_id`    | `INT`          | Unique numerical identifier assigned to each customer.                   |
| `customer_number`| `NVARCHAR(50)` | Alphanumeric identifier representing the customer, used for tracking.    |
| `first_name`     | `NVARCHAR(50)` | Customer's first name.                                                   |
| `last_name`      | `NVARCHAR(50)` | Customer’s last or family name.                                          |

---

## 2. `gold.dim_products`

**Purpose:**  
Contains enriched product information including cost, category, and lifecycle dates.

| Column Name        | Data Type        | Description                                                              |
|--------------------|------------------|--------------------------------------------------------------------------|
| `product_key`       | `INT`            | Surrogate key for the product dimension.                                 |
| `product_id`        | `INT`            | System-generated product ID.                                             |
| `product_name`      | `NVARCHAR(100)`  | Name of the product.                                                     |
| `category_id`       | `INT`            | ID representing the product's category.                                  |
| `category`          | `NVARCHAR(100)`  | Business category of the product.                                        |
| `subcategory`       | `NVARCHAR(100)`  | Business subcategory of the product.                                     |
| `maintenance_type`  | `NVARCHAR(100)`  | Indicates type of maintenance required (if any).                         |
| `product_cost`      | `DECIMAL(18,2)`  | Cost to produce or acquire the product.                                  |
| `product_line`      | `NVARCHAR(50)`   | Product line grouping for reporting.                                     |
| `start_date`        | `DATE`           | Product activation/start date.                                           |
| `end_date`          | `DATE`           | Product deactivation/end date. Null if still active.                     |

---

## 3. `gold.fact_sales`

**Purpose:**  
Captures transactional sales data for analysis across time, products, and customers.

| Column Name       | Data Type        | Description                                                              |
|-------------------|------------------|--------------------------------------------------------------------------|
| `sales_key`        | `INT`            | Surrogate key uniquely identifying each sales transaction.               |
| `customer_key`     | `INT`            | Foreign key linking to the `dim_customers` table.                        |
| `product_key`      | `INT`            | Foreign key linking to the `dim_products` table.                         |
| `store_id`         | `INT`            | Identifier of the store where the sale occurred.                         |
| `order_number`     | `NVARCHAR(50)`   | External reference for the transaction (e.g., invoice or order number).  |
| `order_date`       | `DATE`           | Date when the order was placed.                                          |
| `quantity`         | `INT`            | Number of units sold.                                                    |
| `unit_price`       | `DECIMAL(18,2)`  | Price per unit at the time of the sale.                                  |
| `total_amount`     | `DECIMAL(18,2)`  | Total sale value (quantity × unit price).                                |

---

## 🔄 Update Frequency

Data in the Gold Layer is refreshed nightly via scheduled ETL processes. Surrogate keys are generated using `ROW_NUMBER()` functions during view materialization or ETL loads.

## 🧠 Usage Notes

- Dimensions support **slowly changing dimension (SCD)** logic for tracking attribute changes over time.
- Fact tables support **star schema** analytics, enabling performance across tools like Power BI, Tableau, or direct SQL analytics.

---

> 📌 For additional metrics, indexes, or lineage, refer to the metadata catalog or contact the data engineering team.
