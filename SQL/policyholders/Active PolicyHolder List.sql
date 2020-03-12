-- Active Policyholder list

Select DISTINCT InsuredFirstName, InsuredLastName, InsuredEmail,SourceAgentID, AgencyName, AgencyPhone1

 FROM  adw.dbo.Agg_Policy a
 join  adw.dbo.Dim1_Policy b on a.DimPolicyId  = b.DimPolicyId
 join  adw.dbo.Dim1_Insured c on a.DimInsuredId = c.DimInsuredId
 --join  adw.dbo.Dim1_Product d on  a.DimProductId = d.DimProductId
 join  adw.dbo.Dim2_Address j on a.DimLocationId = j.DimAddressId
 join  adw.dbo.Dim1_Agency f on a.DimAgencyId = f.DimAgencyId
 where InforceStatusAO <>0 -- select active policies only
 and ReportDt = '02/29/2020' -- current report dt
 and source = 'ISCS'
 and f.active = 1
 and InsuredEmail <>''
 order by InsuredFirstName

