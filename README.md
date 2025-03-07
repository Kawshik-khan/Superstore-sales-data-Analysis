## Superstore-sales-data-Analysis

# Superstore Data Analysis

## Project Overview
This project focuses on analyzing a Superstore dataset by performing various data processing tasks, including bulk insertion, data cleaning, error handling, and customer segmentation using RFM analysis. The project was implemented using MySQL and MySQL Workbench.

## Table of Contents
- [Dataset](#dataset)
- [Technologies Used](#technologies-used)
- [Analysis step by step](#Analysis-step-by-step)
- [Implementation Details](#implementation-details)
- [Results](#results)
- [Conclusion](#conclusion)

## Dataset
I have uploaded the dataset called ****Superstore Sales Data.csv****

## Technologies Used
- MySQL
- MySQL Workbench
- Excel (for initial data inspection)

## Analysis step by step  
1. **Bulk Insertion**
   - Insert data from a CSV or Excel file into MySQL database tables.
   [- All Data](https://github.com/Kawshik-khan/Superstore-sales-data-Analysis/blob/main/Images/Screenshot_12.png)
   
2. **Checking Data Errors**
   - Identify missing values, duplicate records, and inconsistent data.
   
3. **Data Cleaning and Fixing**
   - Handle null values by imputing or removing records.
   - Standardize category names and format text fields.
   - Remove duplicate entries.
   
4. **Date Format Standardization**
   - Convert date fields to proper `DATE` format.
   - Ensure consistent date formats across the dataset.

5. **Creating Views and CTEs**
   - Create MySQL Views for easier querying.
   - Use Common Table Expressions (CTEs) for complex queries and aggregations.

6. **Customer Segmentation using RFM Analysis**
   - **Recency (R):** Days since last purchase.
   - **Frequency (F):** Number of purchases made.
   - **Monetary Value (M):** Total amount spent.
   - Assign scores to each customer and segment them (e.g., Loyal Customers, At Risk, Lost Customers).

## Implementation Details
- MySQL was used to store and process the dataset efficiently.
- MySQL Workbench was utilized for executing queries, visualizing data, and managing database operations.
- Data transformation and cleaning tasks were performed to ensure accuracy and consistency.
- Views and CTEs were implemented to streamline data analysis and enhance query performance.
- RFM segmentation helped categorize customers based on their purchasing behavior.

## Results
- Successfully inserted data without errors.
- Standardized date formats and fixed inconsistencies.
- Created meaningful views and CTEs for analysis.
- Segmented customers into different categories based on RFM scores.

## Conclusion
This project provided insights into customer purchasing behavior, allowing businesses to identify key customer segments and strategize marketing efforts accordingly. Using MySQL and MySQL Workbench ensured efficient data processing and analysis.

