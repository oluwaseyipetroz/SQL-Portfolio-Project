SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[SaleDateconveerted]
      ,[SaleDateconverted]
  FROM [PortfolioProject].[dbo].[NashvileHousing]

  -- DATA CLEANING IN SQL QUERIES:

  SELECT *
  FROM PortfolioProject..NashvileHousing

  -- STANDARDIZE DATEOFRMAT

  SELECT SaleDate, CONVERT(DATE,SaleDate) Date
  FROM PortfolioProject..NashvileHousing

  UPDATE PortfolioProject..NashvileHousing
  SET SaleDate = CONVERT(DATE,SaleDate)

  -- POPULATE PROPERTY ADDRESS


  ALTER TABLE PortfolioProject..NashvileHousing
  ADD NewDate DATE

  UPDATE PortfolioProject..NashvileHousing
  SET NewDate = CONVERT(DATE,SaleDate)

  ALTER TABLE PortfolioProject..NashvileHousing
  DROP COLUMN SaleDateconverted

   ALTER TABLE PortfolioProject..NashvileHousing
  ADD PricePerRoom Numeric 

  UPDATE PortfolioProject..NashvileHousing
  SET PricePerRoom = SalePrice - Lan

  SELECT *
  FROM PortfolioProject..NashvileHousing
  WHERE PropertyAddress IS NOT NULL

  SELECT a.[UniqueID ], a.PropertyAddress, b.[UniqueID ], b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
  FROM PortfolioProject..NashvileHousing a
  JOIN PortfolioProject..NashvileHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ] 
  WHERE a.PropertyAddress IS NOT NULL

  UPDATE a
  SET a.PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
  FROM PortfolioProject..NashvileHousing a
  JOIN PortfolioProject..NashvileHousing b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ] 
  WHERE a.PropertyAddress IS NOT NULL

  --BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMN (ADDRESS, CITY,STATE)

  SELECT PropertyAddress
  FROM PortfolioProject..NashvileHousing
  WHERE PropertyAddress IS NOT NULL

  --SELECT
  --SUBSTRING (PropertyAddress, 1, 3), SUBSTRING (PropertyAddress, 5, 8)
  --FROM PortfolioProject..NashvileHousing

  --SELECT
  ----SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)),
  --CHARINDEX(',',PropertyAddress)
  --FROM PortfolioProject..NashvileHousing

  -- SELECT
  --SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)
  ----CHARINDEX(',',PropertyAddress)
  --FROM PortfolioProject..NashvileHousing

  SELECT
  SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address
  , SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
  FROM PortfolioProject..NashvileHousing

  ALTER TABLE PortfolioProject..NashvileHousing
  ADD PropertySplitAddress NVARCHAR(225)

  UPDATE PortfolioProject..NashvileHousing
  SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

  ALTER TABLE PortfolioProject..NashvileHousing
  ADD PropertySplitCity NVARCHAR(225)

  UPDATE PortfolioProject..NashvileHousing
  SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

  ALTER TABLE PortfolioProject..NashvileHousing
  DROP COLUMN City, Address, PropertyAddressCity, PropertyAddressCitys
 
  
  SELECT OwnerAddress
  FROM PortfolioProject..NashvileHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)
  FROM PortfolioProject..NashvileHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
  FROM PortfolioProject..NashvileHousing

  SELECT 
  PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
  FROM PortfolioProject..NashvileHousing

  ALTER TABLE PortfolioProject..NashvileHousing
  ADD OwnerSplitAddress NVARCHAR(225) , OwnerSplitCity NVARCHAR(225) , OwnerSplitState NVARCHAR(225)

  UPDATE PortfolioProject..NashvileHousing
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)

  UPDATE PortfolioProject..NashvileHousing
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)

  UPDATE PortfolioProject..NashvileHousing
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)

  SELECT *
  FROM PortfolioProject..NashvileHousing

  --CHANGE Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD

  SELECT Soldasvacant
  FROM  PortfolioProject..NashvileHousing

  SELECT DISTINCT(SoldasvacantNEW), COUNT(SoldasvacantNEW)
  FROM PortfolioProject..NashvileHousing
  GROUP BY SoldAsVacantNEW
  ORDER BY 2

  SELECT SoldAsVacant
 , CASE  WHEN SoldAsVacant = 'N' THEN 'NO'
		 WHEN SoldAsVacant = 'y' THEN 'Yes'
		 ELSE SoldAsVacant
		 END AS SoldAsVacantNew
FROM PortfolioProject..NashvileHousing

 ALTER TABLE PortfolioProject..NashvileHousing
  ADD SoldAsVacantNew VARCHAR(5)

UPDATE PortfolioProject..NashvileHousing
SET SoldAsVacantNew =  CASE  WHEN SoldAsVacant = 'N' THEN 'NO'
		 WHEN SoldAsVacant = 'y' THEN 'Yes'
		 ELSE SoldAsVacant
		 END 
FROM PortfolioProject..NashvileHousing

SELECT *
  FROM PortfolioProject..NashvileHousing

  ALTER TABLE PortfolioProject..NashvileHousing
DROP COLUMN Soldasvacant

-- REMOVE DUPLICATE

WITH RowNumCTE AS (
SELECT *, ROW_NUMBER () OVER( 
					PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY 
					UniqueID) ROW_NUM

FROM PortfolioProject..NashvileHousing
--ORDER BY ParcelID
)
SELECT * FROM RowNumCTE
WHERE ROW_NUM > 1

WITH RowNumCTE AS (
SELECT *, ROW_NUMBER () OVER( 
					PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY 
					UniqueID) ROW_NUM

FROM PortfolioProject..NashvileHousing
--ORDER BY ParcelID
)
DELETE FROM RowNumCTE
WHERE ROW_NUM > 1
--ORDER BY PropertyAddress

-- DELETE UNWANTED COLUMN

SELECT * 
FROM PortfolioProject..NashvileHousing

ALTER TABLE PortfolioProject..NashvileHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate

