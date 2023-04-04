/*

Cleaning  Data in SQL Queries
*/
select*
from [SQL Tutorial].DBO.[Nashville Housing]

-- Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
from [SQL Tutorial].dbo.[Nashville Housing ]

update [Nashville Housing ]
Set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Nashville Housing] 
Add SaleDateConverted Date;

Update [Nashville Housing ]
Set SaleDateConverted =CONVERT (Date,SaleDate)

--Populate Property Adress Data
select *
from [SQL Tutorial].dbo.[Nashville Housing ]
--Where PropertyAddress is Null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress,b.PropertyAddress)
from [SQL Tutorial].dbo.[Nashville Housing ] a
join [SQL Tutorial].dbo.[Nashville Housing ] b

on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress =isnull (a.PropertyAddress,b.PropertyAddress)
from [SQL Tutorial].dbo.[Nashville Housing ] a
join [SQL Tutorial].dbo.[Nashville Housing ] b

on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out  Address into Individual Columns (Address,City,State)

select PropertyAddress
from [SQL Tutorial].dbo.[Nashville Housing ]

select
substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address
, substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress))as Address
from [SQL Tutorial].dbo.[Nashville Housing ]



ALTER TABLE [Nashville Housing] 
Add PropertySplitAddress NVARCHAR(255);

Update [Nashville Housing ]
Set PropertySplitAddress = substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE [Nashville Housing] 
Add PropertySplitCity NVARCHAR(255);

Update [Nashville Housing ]
Set PropertySplitCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress))

select*
from [SQL Tutorial].DBO.[Nashville Housing]





select OwnerAddress
from [SQL Tutorial].DBO.[Nashville Housing]




select
parsename(replace(OwnerAddress, ',','.'),3),

parsename(replace(OwnerAddress, ',','.'),2),

parsename(replace(OwnerAddress, ',','.'),1)

from [SQL Tutorial].DBO.[Nashville Housing]






ALTER TABLE [Nashville Housing] 
Add OwnerSplitAddress NVARCHAR(255);

Update [Nashville Housing ]
Set OwnerSplitAddress = parsename(replace(OwnerAddress, ',','.'),3)



ALTER TABLE [Nashville Housing] 
Add OwnerSplitCity NVARCHAR(255);

Update [Nashville Housing ]
Set OwnerSplitCity = parsename(replace(OwnerAddress, ',','.'),2)



ALTER TABLE [Nashville Housing] 
Add OwnerSplitState NVARCHAR(255);

Update [Nashville Housing ]
Set OwnerSplitState = parsename(replace(OwnerAddress, ',','.'),1)



select*
from [SQL Tutorial].DBO.[Nashville Housing]





-- change Y and N to Yes and No in "Sold as Vacant" field

select distinct (SoldAsVacant), count(SoldAsVacant)
from [SQL Tutorial].DBO.[Nashville Housing]
group by SoldAsVacant
order by 2


select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'No'

 ELSE SoldAsVacant
 END
 from [SQL Tutorial].DBO.[Nashville Housing]


 UPDATE [Nashville Housing ]
 SET SoldAsVacant =CASE when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'No'
	  ELSE SoldAsVacant
 END


 ---Remove Duplicates
 WITH RowNumCTE As(

 Select*,
  ROW_NUMBER() OVER(
  PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
  ORDER BY UniqueID) row_num
 
 from [SQL Tutorial].DBO.[Nashville Housing]
 )

 select *
 from RowNumCTE
 where row_num> 1
 order by propertyAddress


 --Delete Unused Columns rettrrcxxxqxxz
  select *
from [SQL Tutorial].DBO.[Nashville Housing]

ALTER TABLE  [SQL Tutorial].DBO.[Nashville Housing]
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress


ALTER TABLE  [SQL Tutorial].DBO.[Nashville Housing]
DROP COLUMN SaleDate