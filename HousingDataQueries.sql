/*

Cleaning Data in SQL Queries

*/



SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT SaleDate, CONVERT(date,SaleDate)
FROM [dbo].[Nashville Housing Data for Data Cleaning]


UPDATE [Nashville Housing Data for Data Cleaning]
SET SaleDate = CONVERT(date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) -- here the nulls in a.PropertyAddress column will be populated by the values in b.PropertyAddress column
FROM [dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [dbo].[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID -- uniqueIDs will always be different
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [dbo].[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [dbo].[Nashville Housing Data for Data Cleaning]
--WHERE PropertyAddress is null
--ORDER BY ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM [dbo].[Nashville Housing Data for Data Cleaning]


ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD PropertySplitAddress nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD PropertySplitCity nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]





-- Changing OwnerAddress

SELECT OwnerAddress
FROM [dbo].[Nashville Housing Data for Data Cleaning]


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [dbo].[Nashville Housing Data for Data Cleaning]


ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitAddress nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitCity nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitState nvarchar(255);

UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]





--------------------------------------------------------------------------------------------------------------------------

-- Changing the (binary) 1 and 0 to (varchar) Yes and No in "SoldAsVacant" field


SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM [dbo].[Nashville Housing Data for Data Cleaning]
GROUP BY SoldAsVacant
ORDER BY 2

-- Working...
SELECT SoldAsVacant  -- as SoldAsVacantUpdate
	, CASE WHEN SoldAsVacant = 1 THEN 'Yes'
		   WHEN SoldAsVacant = 0 THEN 'No'
		   --ELSE SoldAsVacant
		END AS Vacant_Status
	FROM [dbo].[Nashville Housing Data for Data Cleaning]
-- WHERE SoldAsVacant = 1;


-- Solution

SELECT SoldAsVacant
	, CASE WHEN SoldAsVacant = 1 THEN 'Yes'
		   WHEN SoldAsVacant = 0 THEN 'No'
		   END AS Vacant_Status
	FROM [dbo].[Nashville Housing Data for Data Cleaning]


-- Creating new column (SoldAsVacant_temp) to store new string values 

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
ADD SoldAsVacant_temp varchar(10);


-- Updating the new column with the new values from the binary values

UPDATE [dbo].[Nashville Housing Data for Data Cleaning]
SET SoldAsVacant_temp = 
	  CASE WHEN SoldAsVacant = 1 THEN 'Yes'
		   WHEN SoldAsVacant = 0 THEN 'No'
	  END;


-- Dropping the original SoldAsVacant column

ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN SoldAsVacant;


-- Changing the newly updated SoldAsVacant_temp column to SoldAsVacant
EXEC sp_rename '[dbo].[Nashville Housing Data for Data Cleaning].SoldAsVacant_temp', 'SoldAsVacant', 'COLUMN';



SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num
FROM [dbo].[Nashville Housing Data for Data Cleaning]
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
where row_num > 1




WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num
FROM [dbo].[Nashville Housing Data for Data Cleaning]
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
where row_num > 1
ORDER BY PropertyAddress



SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



SELECT *
FROM [dbo].[Nashville Housing Data for Data Cleaning]


ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE [dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN SaleDate
