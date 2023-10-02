--Cleaning Data in SQL 
--Skills used : CREATE, UPDATE, SELECT, CTE, JOINS, OREDR BY, GROUP BY
Source: 

Select * 
From dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--Convert Sale Date (drop time format to only date sold)

Select SaleDate, Convert(Date,SaleDate) 
From dbo.NashvilleHousing

--Code above did update properly

Alter Table NashvilleHousing
Add DateSold Date;

Update Nashvillehousing
Set DateSold = Convert(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------

--Identify Null Property Addresses 
  
Select PropertyAddress
From dob.NashvilleHousing
Where PropertyAddress is Null

--Updating Null Property Address Data
 
Select a.parcelId, a.propertyaddress, b.parcelId, b.propertyaddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
	On a.parcelId = b.parcelId
	And a.UniqueId <> b.UniqueId
Where a.propertyaddress is null
  
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
	On a.parcelId = b.parcelId
	And a.UniqueId <> b.UniqueId
Where a.propertyaddress is null

--------------------------------------------------------------------------------------------------------------------------

--Seprating Property Address into Indvidual Address and City Colums Using Substring

Select 
SUBSTRING(propertyAddress, 1, Charindex(',', propertyAddress) -1) As Address
, SUBSTRING(propertyAddress, Charindex(',', propertyAddress) -1, Len(propertyAddress)) As City
From NashvilleHousing

  
Alter Table NashvilleHousing
Add Address Nvarchar(255);

Update Nashvillehousing
Set Address = SUBSTRING(propertyAddress, 1, Charindex(',', propertyAddress) -1)

  
Alter Table NashvilleHousing
Add City Nvarchar(255);

Update Nashvillehousing
Set City = SUBSTRING(propertyAddress, Charindex(',', propertyAddress) -1, Len(propertyAddress)) 

--------------------------------------------------------------------------------------------------------------------------

--Seprating Owner Address into Indvidual Address, City, and State Colums Using ParseName

Select
PARSENAME(Replace(ownerAddress, ',','.'), 3)
,PARSENAME(Replace(ownerAddress, ',','.'), 2)
,PARSENAME(Replace(ownerAddress, ',','.'), 1)
From NashvilleHousing

  
Alter Table NashvilleHousing
Add OwnersAddress Nvarchar(255);

Update Nashvillehousing
Set OwnersAddress = PARSENAME(Replace(ownerAddress, ',','.'), 3)


Alter Table NashvilleHousing
Add OwnersCity Nvarchar(255);

Update Nashvillehousing
Set OwnersCity = PARSENAME(Replace(ownerAddress, ',','.'), 2)


Alter Table NashvilleHousing
Add OwnersState Nvarchar(255);

Update Nashvillehousing
Set OwnersState = PARSENAME(Replace(ownerAddress, ',','.'), 1)

--------------------------------------------------------------------------------------------------------------------------

--Update Y/N in Sold As Vacant to Yes/ No

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
						            When SoldAsVacant = 'N' Then 'No'
						            Else SoldAsVacant
					            	End

--------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

With RowNumCTE As(
Select *,
	Row_Number() Over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 Saledate,
				 LegalReference
				 Order by 
					ParcelID
				 )RowNumber
From NashvilleHousing
)
  
Delete
From RowNumCTE
Where RowNumber > 1

--------------------------------------------------------------------------------------------------------------------------

--Delete unused coloums 

Alter Table dbo.NashvilleHousing
Drop Column TaxDistrict












