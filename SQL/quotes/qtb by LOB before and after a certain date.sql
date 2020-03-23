--------------------------------------
--------------------------------------
--- Roadshow Metrics: NB ans Quotes---
--------------------------------------
--------------------------------------

--- This query will provide the requested metrics between certain time periods for specified agents
--- You will have to inster the agent codes separated by coma towards the bottom of the query


--- Select the day of the roadshow

Declare @Roadhshow as date = '01/08/2020' 

--- The script will automatically calculate 30 days before/after the date of the Roadshow

Declare @30daysBefore as date =  (dateadd(mm,-1,@Roadhshow ))

Declare @30daysAfter as date =  (dateadd(mm,+1,@Roadhshow ))

------------
---Quotes---
------------

----- quotes before the roadshow

Select @Roadhshow as RoadshowDate, 
coalesce(a.AgencyCode,b.AgencyCode, c.SourceAgentId, d.SourceAgentId) as AgencyCode,
coalesce(a.Subline1,b.Subline1, c.Subline2, d.Subline2) as Subline, 
coalesce(QuotesBefore, 0) as QuotesBefore, 
coalesce(QuotesAfter, 0) as QuotesAfter,
coalesce(NBBefore, 0) as NBBdefore,
coalesce(NBAfter, 0) as NBAfter

FROM

(SELECT @30daysBefore as DaysBefore, @30daysAfter as DaysAfter, AgencyCode, 
case 
when Subline in ('Private','Family','Subdivision','Park') THEN 'MH Other'
when (HVH = 'Y' and SubLine in ('DF3','HO3','DF1')) THEN 'Premier'
WHEN ([SubLine]= 'DF1' AND [Occupancy] = 'Vacant' and [HVH] <> 'Y') THEN 'DF1 - Vacant'
WHEN ([SubLine] = 'DF1' and [HVH] <> 'Y') THEN 'DF1'
WHEN [SubLine]  = 'Umbrellabasic' THEN 'UMB'
WHEN [SubLine] = 'Adult' THEN 'SA'
else Subline end as Subline1,
count(Distinct [ApplicationNumber]) as QuotesBefore

  FROM [ARS].[dbo].[tblQuoteData]
  where 
  AddDt between @30daysBefore and @Roadhshow -- R minus 30 days

  -- original, valid, and unique can be commented out, based on the method of counting that you choose

  and original = 1
  and ValidQuote = 1
  and UniqueQuote = 1

  and ProviderCd like 'AG%'
  and subline <>''
  and subline not like '%takeout%' -- just in case, exclude non-voluntary quotes?

  group by AgencyCode, 
  case 
when Subline in ('Private','Family','Subdivision','Park') THEN 'MH Other'
when (HVH = 'Y' and SubLine in ('DF3','HO3','DF1')) THEN 'Premier'
WHEN ([SubLine]= 'DF1' AND [Occupancy] = 'Vacant' and [HVH] <> 'Y') THEN 'DF1 - Vacant'
WHEN ([SubLine] = 'DF1' and [HVH] <> 'Y') THEN 'DF1'
WHEN [SubLine]  = 'Umbrellabasic' THEN 'UMB'
WHEN [SubLine] = 'Adult' THEN 'SA'
else Subline end) a

  full outer join

  (SELECT @30daysBefore as DaysBefore, @30daysAfter as DaysAfter, AgencyCode, 
  case 
when Subline in ('Private','Family','Subdivision','Park') THEN 'MH Other'
when (HVH = 'Y' and SubLine in ('DF3','HO3','DF1')) THEN 'Premier'
WHEN ([SubLine]= 'DF1' AND [Occupancy] = 'Vacant' and [HVH] <> 'Y') THEN 'DF1 - Vacant'
WHEN ([SubLine] = 'DF1' and [HVH] <> 'Y') THEN 'DF1'
WHEN [SubLine]  = 'Umbrellabasic' THEN 'UMB'
WHEN [SubLine] = 'Adult' THEN 'SA'
else Subline end as Subline1,
count(Distinct [ApplicationNumber]) as QuotesAfter

  FROM [ARS].[dbo].[tblQuoteData]
  where 
  AddDt between @Roadhshow and @30daysAfter -- R plus 30 days

  -- original, valid, and unique can be commented out, based on the method of counting that you choose

  and original = 1
  and ValidQuote = 1
  and UniqueQuote = 1

  and ProviderCd like 'AG%'
  and subline <>''
  and subline not like '%takeout%' -- just in case, exclude non-voluntary quotes?

  group by AgencyCode, 
  case 
when Subline in ('Private','Family','Subdivision','Park') THEN 'MH Other'
when (HVH = 'Y' and SubLine in ('DF3','HO3','DF1')) THEN 'Premier'
WHEN ([SubLine]= 'DF1' AND [Occupancy] = 'Vacant' and [HVH] <> 'Y') THEN 'DF1 - Vacant'
WHEN ([SubLine] = 'DF1' and [HVH] <> 'Y') THEN 'DF1'
WHEN [SubLine]  = 'Umbrellabasic' THEN 'UMB'
WHEN [SubLine] = 'Adult' THEN 'SA'
else Subline end) b

  on a.AgencyCode = b.AgencyCode
  and a.Subline1 = b.Subline1



  ------------------
---New Business---
------------------

  --- nb before the roadshow

full outer join 
  (Select  SourceAgentID, 
  case 
	when (ProductForm = 'df1' and [ProductDescription] = 'vacant dwelling fire - named peril' ) THEN 'DF1 - Vacant'
	when CoverageA_AO >= 750000  THEN 'Premier'
	when ProductForm = 'Golf Cart' THEN 'GOC'
	when ProductForm = 'Umbrella' THEN 'UMB'
	when ProductForm in ('PP','PFP','ASD') THEN 'MH Other'
	else ProductForm end as Subline2, 
 count(distinct(PolicyNumber)) as NBBefore

 FROM  adw.dbo.Facts_Policy_Status a
 join  adw.dbo.Dim1_Policy b on a.DimPolicyId  = b.DimPolicyId
 join  adw.dbo.Dim1_Product d on  a.DimProductId = d.DimProductId
 join  adw.dbo.Dim1_Agency e on a.DimAgencyId = e.DimAgencyId


 WHERE DimTransTypeId = 150 -- NB
and rewrite = 0 -- Exclude Rewrites
and TransDt between @30daysBefore and @Roadhshow 
and BusinessType = 'Voluntary' -- voluntary only

group by  SourceAgentID, case 
	when (ProductForm = 'df1' and [ProductDescription] = 'vacant dwelling fire - named peril' ) THEN 'DF1 - Vacant'
	when CoverageA_AO >= 750000  THEN 'Premier'
	when ProductForm = 'Golf Cart' THEN 'GOC'
	when ProductForm = 'Umbrella' THEN 'UMB'
	when ProductForm in ('PP','PFP','ASD') THEN 'MH Other'
	else ProductForm end) c

on a.AgencyCode = c.SourceAgentID
and a.Subline1 = c.Subline2 
and b.Subline1 = c.Subline2

--- NB after the roadshow

full outer join 

  (Select  SourceAgentID, 
  case 
	when (ProductForm = 'df1' and [ProductDescription] = 'vacant dwelling fire - named peril' ) THEN 'DF1 - Vacant'
	when CoverageA_AO >= 750000  THEN 'Premier'
	when ProductForm = 'Golf Cart' THEN 'GOC'
	when ProductForm = 'Umbrella' THEN 'UMB'
	when ProductForm in ('PP','PFP','ASD') THEN 'MH Other'
	else ProductForm end as Subline2, 
 count(distinct(PolicyNumber)) as NBAfter

 FROM  adw.dbo.Facts_Policy_Status a
 join  adw.dbo.Dim1_Policy b on a.DimPolicyId  = b.DimPolicyId
 join  adw.dbo.Dim1_Product d on  a.DimProductId = d.DimProductId
 join  adw.dbo.Dim1_Agency e on a.DimAgencyId = e.DimAgencyId


 WHERE DimTransTypeId = 150 -- NB
and rewrite = 0 -- Exclude Rewrites
and TransDt between @Roadhshow  and @30daysAfter
and BusinessType = 'Voluntary' -- voluntary only

group by  SourceAgentID, 
case 
	when (ProductForm = 'df1' and [ProductDescription] = 'vacant dwelling fire - named peril' ) THEN 'DF1 - Vacant'
	when CoverageA_AO >= 750000  THEN 'Premier'
	when ProductForm = 'Golf Cart' THEN 'GOC'
	when ProductForm = 'Umbrella' THEN 'UMB'
	when ProductForm in ('PP','PFP','ASD') THEN 'MH Other'
	else ProductForm end) d

on a.AgencyCode = d.SourceAgentID
and a.Subline1 = d.Subline2
and b.Subline1 = d.Subline2

-----------------------------------------------
-- Insert your Agents here, separated by coma--
-----------------------------------------------



  where coalesce(a.AgencyCode,b.AgencyCode, c.SourceAgentId, d.SourceAgentId) in ('AG1777A10')
  order by 1,2,3
