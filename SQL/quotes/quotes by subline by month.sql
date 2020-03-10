-- Quotes by subline by month

SELECT year(UpdateDt) as UpdateYear, month(UpdateDt) as UpdateMonth, 
case 
when Subline in ('Private','Family','Subdivision','Park') THEN 'MH Other'
when (HVH = 'Y' and SubLine in ('DF3','HO3','DF1')) THEN 'Premier'
WHEN ([SubLine]= 'DF1' AND [Occupancy] = 'Vacant' and [HVH] <> 'Y') THEN 'DF1 - Vacant'
WHEN ([SubLine] = 'DF1' and [HVH] <> 'Y') THEN 'DF1'
WHEN [SubLine]  = 'Umbrellabasic' THEN 'UMB'
WHEN [SubLine] = 'Adult' THEN 'SA'
else Subline end as Subline1,
count(Distinct [ApplicationNumber]) as Quotes

  FROM [ARS].[dbo].[tblQuoteData]
  where 
  original = 1
  and ValidQuote = 1
  and UniqueQuote = 1
  and UpdateDt <='09/30/2019'
  and ProviderCd like 'AG%'
  and TerritoryMgrFirstName is not NULL
  and subline <>''
  and subline not like '%takeout%'


  group by year(UpdateDt), month(UpdateDt), case 
when Subline in ('Private','Family','Subdivision','Park') THEN 'MH Other'
when (HVH = 'Y' and SubLine in ('DF3','HO3','DF1')) THEN 'Premier'
WHEN ([SubLine]= 'DF1' AND [Occupancy] = 'Vacant' and [HVH] <> 'Y') THEN 'DF1 - Vacant'
WHEN ([SubLine] = 'DF1' and [HVH] <> 'Y') THEN 'DF1'
WHEN [SubLine]  = 'Umbrellabasic' THEN 'UMB'
WHEN [SubLine] = 'Adult' THEN 'SA'
else Subline end
  Order by year(UpdateDt), month(UpdateDt), Subline1


 
