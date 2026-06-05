# Healthcare Analytics & Hospital Performance Optimization

## 🏥 Project Overview
This repository contains an end-to-end relational database solution designed to track, manage, and extract clinical and operational insights for a multi-branch healthcare provider. The project focuses on assessing patient demographics, hospital resource utilization, historical patient tracking, and facility revenue benchmarking.

## 📂 Repository Contents
- **`SQL queries.sql`**: Complete database build scripts, structured sample data inserts, and advanced analytical queries.
- **`Assignment 2.pdf`**: The formal project blueprint detailing the case study constraints and operational query objectives.

## 🛠️ Data Engineering & Analytical Concepts Used
- **Schema Architecture:** Engineered a relational model creating explicitly defined tables linked with optimized primary keys and foreign key constraints.
- **Relational Operations:** Handled multi-table data staging using descriptive `LEFT JOIN` and `UNION` parameters to seamlessly stitch across fragmented operational layers.
- **Performance Objects:** Built a permanent virtual database mapping view (`HospitalPerformance`) to dynamically capture complex key performance indicators (KPIs).
- **Advanced Statistical Window Functions:** Implemented localized ranking pipelines using `RANK()` and `DENSE_RANK()` functions to grade high-frequency treatments and evaluate relative branch revenue outputs without structural aggregation loss.

## 📊 Core Business Problems Solved
1. **Demographic Analysis:** Calculated granular age distributions and aggregate volume counts broken down uniformly by gender metrics.
2. **Resource & Capacity Tracking:** Isolated high-volume facility pipelines by aggregating dynamic admission volumes against standard hospital capacities.
3. **Length of Stay Tracking:** Standardized datetime metrics utilizing conditional `DATEDIFF` functions to compute average length of stay benchmarks across specific clinical conditions.
4. **Treatment Valuation Pricing:** Designed complex evaluation subqueries to automatically filter and flag peak procedure frequencies and surface top-performing average revenue generators.
