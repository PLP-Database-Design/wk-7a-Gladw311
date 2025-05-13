-- answers.sql

-- Question 1: Achieving 1NF (First Normal Form)
-- We need to transform the ProductDetail table so that each row represents a single product for an order.

-- Creating a new table to store the normalized data
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Inserting data into the new table by splitting the Products column
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) numbers ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1;

-- Question 2: Achieving 2NF (Second Normal Form)
-- We need to remove partial dependencies from the OrderDetails table.

-- Creating a new table to store the normalized data
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT
);

-- Inserting data into the new table
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Creating a separate table for customer information to eliminate partial dependency
CREATE TABLE CustomerDetails (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Inserting customer data into the new table
INSERT INTO CustomerDetails (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Now, the OrderDetails_2NF table contains only OrderID, Product, and Quantity,
-- while CustomerDetails contains OrderID and CustomerName, ensuring that all non-key columns
-- fully depend on the entire primary key.
