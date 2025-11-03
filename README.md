# 📊 SQL Data Warehouse & Analytics Project

A complete end-to-end project to design, build, and utilize a modern **data warehouse** using **SQL Server**. This project integrates **ETL processes**, **data modeling**, and **SQL-based analytics** to support data-driven decision-making.

---

## 🧠 Project Overview
This project builds 
- **Data Architecture  Designing**: Designging a modern datahouse and analytics using medalion Architecture Bronze,Silver, and Gold layers.
- **ETL pipeline** : Extracting, Transforming, and Loading data from source systems (ERP and CRM) in to the warehouse.
- **Data Modelling**: Developing fact and dimension tables optimized for analytical queries, and enables meaningful analytics using **SQL queries and visualizations**.

---

## 🎯 Objectives
- Build a data warehouse using **SQL Server**
- Cleanse and transform raw data using **ETL pipelines**
- Model the data to support fast, user-friendly querying
- Deliver business insights using SQL and reporting tools

---

## 🧰 Tools & Technologies
- **SQL Server**
- **SSMS** (SQL Server Management Studio)
- **Draw.io / dbdiagram.io** (for ERD and architecture)
- **Excel / CSV** (input data)
- **Power BI / Tableau (optional)** for visualizations
- **Notion** for project management and organization.

---

## 🗂️ Data Sources
- **ERP System**: Orders, Products, Customers
- **CRM System**: Leads, Opportunities, Customer Interactions
- Format: CSV files

---
## Data Architecture
This project fellows Medalion Architecture **Bronze,Silver,and Gold** layer.
1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.

2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.

3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.
---
## ⚙️ ETL Process
- **Extract**: Load data from source CSV files.
- **Transform**:
  - Clean nulls & inconsistencies
  - Standardize date formats and currency
  - Join ERP & CRM data on `CustomerID`
- **Load**:
  - Load data into **staging tables**
  - Insert into **fact and dimension tables**
<img width="1256" height="752" alt="image" src="https://github.com/user-attachments/assets/b931be1b-4e02-4300-a2d0-8f218194134c" />

---

## 🧱 Data Modeling
- **Star Schema** with:
  - `FactSales`
  - `DimCustomer`
  - `DimProduct`
  - `DimDate`
- Relationships defined by foreign keys
<img width="1252" height="775" alt="image" src="https://github.com/user-attachments/assets/f49be9ff-b1c5-4f3a-9363-9ea695070ca8" />

---

## ✅ Data Quality Checks
- Null value detection and handling
- Duplicate record elimination
- Data type validations
- Referencing integrity checks (e.g. orphan records)

---

## 📊 SQL Analytics
Example analytics performed:
- Top 10 selling products by region
- Monthly sales trends by product category
- Customer churn and retention rates
- Conversion rates from leads to opportunities

---

## 📈 Business Insights
This project enables stakeholders to:
- Understand **customer behavior**
- Track **product performance**
- Analyze **sales trends**
- Improve **marketing and operational** strategies

---

---

## 🚀 Future Improvements
- Automate ETL using Python or SSIS
- Add historization for slowly changing dimensions (SCD Type 2)
- Integrate with Power BI for dashboards
- Set up data refresh scheduling

---

## 📄 License

This project is licensed under the **MIT License**.

You are free to:
- Use, copy, modify, merge, publish, and distribute the code for personal or commercial purposes.
---

## 📬 Contact
I’m passionate about Data Science, analytics, and using technology to solve real-world problems. 
For questions, suggestions, or collaboration opportunities, feel free to reach out:
Let’s connect!
- **🌐 LinkedIn**: [linkedin.com/in/ambachow-y-kahsay-863b7b291](https://www.linkedin.com/in/ambachow-y-kahsay-863b7b291)  
