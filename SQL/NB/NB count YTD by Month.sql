 -- NB count YTD by month
 
 Select year(TransDt) as Year, count( distinct PolicyNumber) as NB

 FROM  adw.dbo.Facts_Policy_Status a
 join  adw.dbo.Dim1_Policy b on a.DimPolicyId  = b.DimPolicyId
 join  adw.dbo.Dim1_TransType f on a.DimTransTypeId = f.DimTransTypeId
 join  adw.dbo.Dim1_Product c on a.DimProductId = c.DimProductId
 join  adw.dbo.Dim1_Agency d on a.DimAgencyId = d.DimAgencyId


 WHERE f.DimTransTypeId = 150
 and Rewrite = 0
 and BusinessType = 'Voluntary'
 --AND  cast(TransDt as date) <= '2019-03-03' 
 and year(TransDt)>= 2017
 group  by year(TransDt)
 order  by  year(TransDt)
