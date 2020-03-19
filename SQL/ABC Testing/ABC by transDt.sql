SELECT TransDt,PolicyNumber
  FROM [ARS].[dbo].[ABC_Production]
  where year(transDt) = 2020
  and month(transDt) = 3
  order by 1 
