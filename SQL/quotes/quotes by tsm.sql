SELECT [ProviderCd], AgencyCode, AgencyName, count([ApplicationNumber]) as Quotes, count(PolicyNumber) as Binds
  FROM [ARS].[dbo].[tblQuoteData]
  where month(updateDt) = 3
  and year(updateDt) = 2020
  and TerritoryMgrLastName like 'Mah%'
  and Subline = 'HO3'
  and ValidQuote = 1
  and Original = 1
  and UniqueQuote = 1
  and HVH <> 'Y'
  group by [ProviderCd], AgencyCode, AgencyName
  order by Quotes desc


  SELECT TerritoryMgrFirstName,  ProductDesc, LocationCounty, count(*) as Quotes
  FROM [ARS].[dbo].[tblQuoteData]
  where month(updateDt) = 3
  and year(updateDt) = 2020
  and TerritoryMgrLastName like 'Mah%'
  and Subline = 'HO3'
  and ValidQuote = 1
  and Original = 1
  and UniqueQuote = 1
  and HVH <> 'Y'
 -- and AgencyCode = 'AG7466A1'
 and ProductDesc like 'ABC%'
  group by TerritoryMgrFirstName, ProductDesc, LocationCounty
  order by 3 desc
 
