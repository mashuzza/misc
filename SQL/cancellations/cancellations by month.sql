-- The query shows cancelled policies with insured info

Declare @StartDt as date
Declare @EndDt as date

--Set @StartDt = '08/15/2018'
--Set @EndDt = '08/15/2019'


Select DISTINCT SourceAgentID,
 --year(transdt) as Year, month(TransDt) as Month, 
 PolicyNumber, ProductForm, [InsuredFirstName], InsuredLastName, 
 cast(transDt as date) as TransDt,
 cast(effDt as date) as EffectiveDate,

[ReasonCd]

 --cast(EffDt as date) as EfftDt, f.DimTransTypeId, cast(TransDt as date) as TransDt

 FROM  adw.dbo.Facts_Policy_Status a
 join  adw.dbo.Dim1_Policy b on a.DimPolicyId  = b.DimPolicyId
 join  adw.dbo.Dim1_Insured c on a.DimInsuredId = c.DimInsuredId
 join  adw.dbo.Dim1_Product d on  a.DimProductId = d.DimProductId
 join  adw.dbo.Dim1_Agency e on a.DimAgencyId = e.DimAgencyId
 join  adw.dbo.Dim1_TransType f on a.DimTransTypeId = f.DimTransTypeId
 join  adw.dbo.Dim1_TransTypeSub h on a.DimTransTypeSubId = h.DimTransTypeSubId
 join  adw.dbo.Dim2_Address k on a.DimPropAddressId = k.DimAddressId

 WHERE f.DimTransTypeId = 153 -- cancellation
 --AND  cast(TransDt as date) >= @StartDt
 --and cast(TransDt as date)<= @EndDt
--and SourceAgentID like 'AG2159%'
and year(transdt) = 2020
and month(transdt) = 2


	order by TransDt
