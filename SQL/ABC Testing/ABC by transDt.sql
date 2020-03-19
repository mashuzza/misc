SELECT TransDt, count([PolicyNumber]) as NewABC
  FROM [ARS].[dbo].[ABC_Production]
  where year(transDt) = 2020
  and month(transDt) = 3
  group by transdt
  order by trans
