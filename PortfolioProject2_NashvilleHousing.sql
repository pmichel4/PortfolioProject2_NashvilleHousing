/*

Cleaning Data in SQL Queries

*/


Select *
FROM portfolioProject.dbo.NashvilleHousing


-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date,saledate)
FROM portfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET Saledate = CoNVERT(Date, SALEDATE)


ALTER TABLE nashvillehousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CoNVERT(Date, SALEDATE)



--Populate Property Address Data

Select *
FROM portfolioProject.dbo.NashvilleHousing
--WHERE Propertyaddress is NULL
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
FROM portfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
--WHERE a.PropertyAddress is NULL


Update a
SET propertyaddress = isnull(a.PropertyAddress, b.PropertyAddress)
FROM portfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL



--Breaking Out Address into Individual Columns (Address, City, State)

Select PropertyAddress
FROM portfolioProject.dbo.NashvilleHousing
--WHERE Propertyaddress is NULL
--Order By ParcelID

Select 
Substring(propertyaddress, 1, charindex(',', propertyaddress) -1) as Address
, Substring(propertyaddress, charindex(',', propertyaddress) +1, LEN(propertyaddress)) as City


FROM portfolioProject.dbo.NashvilleHousing



ALTER TABLE nashvillehousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = Substring(propertyaddress, 1, charindex(',', propertyaddress) -1)

ALTER TABLE nashvillehousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = Substring(propertyaddress, charindex(',', propertyaddress) +1, LEN(propertyaddress))


SELECT *
FROM portfolioProject.dbo.NashvilleHousing



SELECT OwnerAddress
FROM portfolioProject.dbo.NashvilleHousing


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM portfolioProject.dbo.NashvilleHousing



ALTER TABLE nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE nashvillehousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE nashvillehousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



SELECT *
FROM portfolioProject.dbo.NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(Soldasvacant)
FROM portfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order by 2



Select SoldAsVacant
, Case When soldasvacant = 'Y' THEN 'YES'
WHEN Soldasvacant = 'N' THEN 'No'
ELSE Soldasvacant
END
FROM portfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = Case When soldasvacant = 'Y' THEN 'YES'
WHEN Soldasvacant = 'N' THEN 'No'
ELSE Soldasvacant
END
FROM portfolioProject.dbo.NashvilleHousing



--RemoveDuplicates

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				ORDER By
				UniqueID) 
				Row_num
FROM portfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
Delete
FROM RowNumCTE
WHERE row_num >1
--Order By PropertyAddress


WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				ORDER By
				UniqueID) 
				Row_num
FROM portfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
Select *
FROM RowNumCTE
--WHERE row_num >1
Order By PropertyAddress



--Delete Unused Columns


Select *
FROM portfolioProject.dbo.NashvilleHousing


Alter Table portfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
