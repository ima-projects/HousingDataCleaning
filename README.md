# Housing Data Cleaning

## Table of Contents
- [Business Problem](#business-problem)
  * [Objective](#objective)
  * [Goal](#goal)
- [Data Source](#data-source)
- [Methods](#methods)
- [Tech Stack](#tech-stack)
- [SQL Queries Analysis](#sql-queries-analysis)
  * [Query Methods](#query-methods)
- [Quick Analysis of Results](#quick-analysis-of-results)
  * [Key findings](#key-findings)
  * [Limitations and Suggestions for Optimization of the Dashboard](#limitations-and-suggestions-for-optimization-of-the-dashboard)

## Business Problem
Our international property management firm has a client interested in expanding their operations to the Nashville housing market. To support this expansion, the firm needs to gather comprehensive and reliable information about the Nashville housing property market. However, the available data requires cleaning and normalization to ensure its suitability for analysis.

### Objective 
The objective is to clean and normalize the Nashville housing property dataset to enable effective analysis. By performing data cleaning and normalization procedures, the firm aims to remove inconsistencies, handle missing values, standardize formats, and ensure data quality. The objective is to transform the dataset into a structured and reliable form that can be used for accurate analysis and decision-making.

### Goal
My goal is to provide the client with a clean, normalized dataset on the Nashville housing property market. The cleaned dataset should be ready for analysis, enabling the property management firm to generate insights and recommendations for their client's expansion plans. By achieving this goal, the firm aims to equip their client with valuable information about the Nashville housing market, including key trends, property prices, neighborhood characteristics, and any other relevant factors influencing the market such as identifying sold or vacant property. This will ultimately support the client in making informed business decisions related to their expansion strategy in Nashville.

## Data Source
- [Github data source containing Housing Data dataset](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)

## Methods
- SQL querying

## Tech Stack
- Microsoft SQL Server Management Studio

## SQL Queries Analysis
### Query Methods
- Date standardization.
- Populating null values in a column based on a reference point (ParcelID column) by using a self-join on the table data.
- Breaking out a column into individual columns by using SUBSTRINGS, CHARINDEX or PARSENAME.
- Changing binary values in one column to string values by creating a new column.
- Removing duplicates using CTEs (Common Table Expression).
- Deleting unused columns.


