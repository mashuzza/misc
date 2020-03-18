select cast (ReportDt as date) as ReportDt, ProductForm, InForceStatusAO,
count(*) as PIF
FROM dbo.Agg_Policy a
join dbo.Dim1_Policy b on a.DimPolicyId = b.DimPolicyId
join dbo.Dim1_Product d on a.DimProductId = d.DimProductId
join dbo.Dim1_Agency e on a.DimAgencyId = e.DimAgencyId
join dbo.Dim1_Risk f on a.DimRiskId = f.DimRiskId
where year(ReportDt) = 2018
and month(reportDt) = 12
and NumberOfStories is not NULL
group by cast (ReportDt as date), ProductForm, InForceStatusAO
order by 1, 2, 3
