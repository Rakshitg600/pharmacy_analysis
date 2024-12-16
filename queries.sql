-- SQL script to clean the messy pharmacy sales data

-- Step 1: Create a table for the messy data
CREATE TABLE messy_pharmacy_sales (
    Date DATE,
    Product_Name VARCHAR(255),
    Category VARCHAR(255),
    Quantity_Sold VARCHAR(255),
    Price_per_Unit FLOAT,
    Total_Revenue FLOAT,
    Cost_Price_per_Unit FLOAT
);

-- Step 2: Load the messy data into the table
-- (Assume you load the CSV file using a tool or script)

-- Step 3: Clean the data

-- Remove duplicates
DELETE FROM messy_pharmacy_sales
WHERE ROWID NOT IN (
    SELECT MIN(ROWID)
    FROM messy_pharmacy_sales
    GROUP BY Date, Product_Name, Category, Quantity_Sold, Price_per_Unit, Total_Revenue, Cost_Price_per_Unit
);

-- Handle missing values
UPDATE messy_pharmacy_sales
SET Category = 'Unknown'
WHERE Category IS NULL;

UPDATE messy_pharmacy_sales
SET Price_per_Unit = 0
WHERE Price_per_Unit IS NULL;

-- Correct misaligned data
UPDATE messy_pharmacy_sales
SET Quantity_Sold = '10'
WHERE Quantity_Sold = 'ten';

-- Ensure Quantity_Sold is numeric
ALTER TABLE messy_pharmacy_sales
ADD COLUMN Quantity_Sold_Clean INT;

UPDATE messy_pharmacy_sales
SET Quantity_Sold_Clean = CASE
    WHEN Quantity_Sold GLOB '[0-9]+' THEN CAST(Quantity_Sold AS INT)
    ELSE NULL
END;

-- Drop the old Quantity_Sold column and rename the clean column
ALTER TABLE messy_pharmacy_sales DROP COLUMN Quantity_Sold;
ALTER TABLE messy_pharmacy_sales RENAME COLUMN Quantity_Sold_Clean TO Quantity_Sold;

-- Step 4: Export the cleaned data
-- (Use a database export tool to save the cleaned data back to a CSV file)
