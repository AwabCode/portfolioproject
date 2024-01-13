select *
from PortfolioProject..NashvileHousing


--Standardize Date format
select saleDateConverted, CONVERT(Date,saleDate)
from PortfolioProject..NashvileHousing

UPDATE NashvileHousing
SET saleDate = CONVERT(Date,saleDate)

ALTER TABLE  NashvileHousing
add saleDateConverted Date;

UPDATE NashvileHousing
SET saleDateConverted = CONVERT(Date, SaleDate)

--Populate property address data
select *
from PortfolioProject..NashvileHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvileHousing a
join PortfolioProject..NashvileHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null

 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject..NashvileHousing a
join PortfolioProject..NashvileHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ] 
where a.PropertyAddress is null

--Breaking Down into Address into individual columns (Adress, city ,state)

select propertyAddress
from PortfolioProject..NashvileHousing

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address

from PortfolioProject..NashvileHousing

ALTER TABLE NashvileHousing
Add PropertysplitAddress Nvarchar(255);

UPDATE NashvileHousing 
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvileHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvileHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress)+1 , LEN(PropertyAddress))

select *
from PortfolioProject..NashvileHousing



--change Y and N to yes and NO in "Sold as vacan" field

select Distinct(SoldASVacant), Count (soldASVacant)
from PortfolioProject..NashvileHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'NO'
	  else SoldAsVacant
	  END 
From PortfolioProject..NashvileHousing

update NashvileHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'NO'
else SoldAsVacant
	  END 

 --REMOVE Duolicates
 WITH RowNumCTE AS(
 select *,
     ROW_NUMBER() OVER (
     PARTITION BY parcelID, 
               propertyAddress,
			   SalePrice,
			   saleDate,
			   legalReference
			   order BY 
			   UniqueID
			   ) row_num

from  PortfolioProject..NashvileHousing 
)
delete 
from RowNumCTE
where row_num > 1

 --DELETE UNSED COLUMS
 select *
 from PortfolioProject..NashvileHousing
 ALTER TABLE PortfolioProject..NashvileHousing
 DROP COLUMN ownerAddress, TaxDistrict, PropertyAddress

 ALTER TABLE PortfolioProject..NashvileHousing
 DROP COLUMN SaleDate

