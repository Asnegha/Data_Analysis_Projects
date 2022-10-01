use project;
SELECT * FROM project_housing;
-- ------------------------------------------------------------
-- Formatting the SaleDate column
SELECT SaleDate, str_to_date(SaleDate, "%M %d, %Y")
FROM project_housing;

UPDATE project_housing
SET SaleDate = str_to_date(SaleDate, "%M %d, %Y");
-- -------------------------------------------------------------
-- Populating the PropertyAddress

-- Checking null value reference Point
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
FROM project_housing a
JOIN project_housing b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Updating null value
UPDATE project_housing a
JOIN project_housing b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = ifnull(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;
-- -------------------------------------------------------------
-- Extracting city name from address
SELECT substring(PropertyAddress, 1, position(','IN PropertyAddress)-1) as 'Address',
substring(PropertyAddress, position(','IN PropertyAddress)+1, length(PropertyAddress)) as 'Address'
FROM project_housing;

ALTER TABLE  project_housing
ADD Propertyplace Nvarchar(255);

UPDATE project_housing
SET Propertyplace = substring(PropertyAddress, 1, position(','IN PropertyAddress)-1);

ALTER TABLE  project_housing
ADD Propertycity Nvarchar(255);

UPDATE project_housing
SET Propertycity = substring(PropertyAddress, position(','IN PropertyAddress)+1, length(PropertyAddress));
-- -----------------------------------------------------------------
-- Split OwnerAddress
SELECT substring_index(OwnerAddress, ',',1) AS OwnerPlace,
substring_index(substring_index(OwnerAddress, ',',-2),',',1) AS Ownercity,
substring_index(OwnerAddress, ',',-1) AS Ownerstate
FROM project_housing;

ALTER TABLE  project_housing
ADD Ownerplace Nvarchar(255);

UPDATE project_housing
SET Ownerplace = substring_index(OwnerAddress, ',',1);

ALTER TABLE  project_housing
ADD Ownercity Nvarchar(255);

UPDATE project_housing
SET Ownercity = substring_index(substring_index(OwnerAddress, ',',-2),',',1);

ALTER TABLE  project_housing
ADD Ownerstate Nvarchar(255);

UPDATE project_housing
SET Ownerstate = substring_index(OwnerAddress, ',',-1);
-- ---------------------------------------------------------------
-- Changing inconsistent SoldAsVacant column
SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
END AS Corrrected
FROM project_housing;

UPDATE project_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
WHEN SoldAsVacant = 'N' THEN  'No'
ELSE SoldAsVacant
END;
-- --------------------------------------------------------------
-- Removing Duplicate
DELETE h1 FROM project_housing h1
INNER JOIN project_housing h2 
WHERE
    h1.UniqueID > h2.UniqueID AND 
    h1.ParcelID = h2.ParcelID AND
    h1.LegalReference = h2.LegalReference;
-- --------------------------------------------------------------
-- Deleting Unused Columns
ALTER TABLE project_housing
DROP COLUMN OwnerAddress;

ALTER TABLE project_housing
DROP COLUMN PropertyAddress;

ALTER TABLE project_housing
DROP COLUMN TaxDistrict;

ALTER TABLE project_housing
DROP COLUMN SaleDate;
-----------------------------------------------------------





