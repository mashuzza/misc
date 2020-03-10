-- NB count by subline by month

Select year(transDt) as TransYear, month(TransDt) as TransMonth, 
case 
	when (ProductForm = 'df1' and [ProductDescription] = 'vacant dwelling fire - named peril' ) THEN 'DF1 - Vacant'
	when CoverageA_AO >= 750000  THEN 'Premier'
	when ProductForm = 'Golf Cart' THEN 'GOC'
	when ProductForm = 'Umbrella' THEN 'UMB'
	when ProductForm in ('PP','PFP','ASD') THEN 'MH Other'
	else ProductForm end as Subline, 

 count(distinct(PolicyNumber)) as NB

 FROM  adw.dbo.Facts_Policy_Status a
 join  adw.dbo.Dim1_Policy b on a.DimPolicyId  = b.DimPolicyId
 join  adw.dbo.Dim1_Insured c on a.DimInsuredId = c.DimInsuredId
 join  adw.dbo.Dim1_Product d on  a.DimProductId = d.DimProductId
 join  adw.dbo.Dim1_Agency e on a.DimAgencyId = e.DimAgencyId
 join  adw.dbo.Dim1_TransType f on a.DimTransTypeId = f.DimTransTypeId
 join  adw.dbo.Dim2_Address k on a.DimPropAddressId = k.DimAddressId

 WHERE 

 f.DimTransTypeId = 150
 and rewrite = 0
AND  year(TransDt) >= 2018
and cast(TransDt as date)<= '09/30/2019'
and BusinessType = 'Voluntary'
and AgencyMarketingRep not like 'Justin%'

group by  year(transDt), month(TransDt),
case 
	when (ProductForm = 'df1' and [ProductDescription] = 'vacant dwelling fire - named peril' ) THEN 'DF1 - Vacant'
	when CoverageA_AO >= 750000  THEN 'Premier'
	when ProductForm = 'Golf Cart' THEN 'GOC'
	when ProductForm = 'Umbrella' THEN 'UMB'
	when ProductForm in ('PP','PFP','ASD') THEN 'MH Other'
	else ProductForm end

	order by year(transDt), month(TransDt)
