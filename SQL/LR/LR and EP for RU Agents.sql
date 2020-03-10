-- 36 Rolling Loss and EP for RU Agents

Select 
				case 
					when Cat = 1 then  'Loss_Cat'
					else 'Loss_Non_Cat'
					end as LossType
				,sum(AC.Paid_Loss_Chg)+sum(AC.Paid_DCC_Chg)+sum(ac.Reserve_Loss_Chg)+sum(AC.Reserve_AOE_Chg)
				+sum(AC.Reserve_DCC_Chg)+sum(AC.Salvage_Rcvd_Chg)+sum(AC.Subro_Rcvd_Chg)+sum(AC.Paid_AOE_Chg) as [Amount]
			from adw.dbo.Dim1_Agency A 
			JOIN adw.dbo.Agg_Claims AC on A.DimAgencyId = AC.DimAgencyId
			JOIN adw.dbo.Dim1_Product P on P.DimProductId = AC.DimProductId
			JOIN adw.dbo.Dim2_CauseOfLoss CL on CL.DimCauseOfLossId = AC.DimCauseofLossSubId
			JOIN adw.dbo.Dim1_Claim C on C.DimClaimId = AC.DimClaimId
			join adw.dbo.Dim1_Policy e on ac.DimPolicyId = e.DimPolicyId

			WHERE   reportDt <='07/31/2019'
				and reportDt >= '08/31/2016'
			and P.BusinessType = 'Voluntary' 
			and CL.Cause not like '%HRB%' 
			and C.HartfordSteamBoiler <> 'Yes'
			and substring(SourceAgentID, 1, 6) in (
			SELECT 
      [Sourceagentid]
  FROM [Diamond_Reporting].[dbo].[Agency]
  where RU_2 = 'RU56')
			group by cat

----------EP

 Select sum(earnedPremiumChg) as EP
  from dbo.Agg_Policy a
  join dbo.Dim1_Agency b on a.DimAgencyId = b.DimAgencyId
  join Dim1_Product e on e.DimProductId = a.DimProductId
  join dbo.Dim1_Policy c on a.DimPolicyId = c.DimPolicyId

where  e.BusinessType = 'Voluntary' 
and substring(SourceAgentID, 1, 6) in (
			SELECT 
      [Sourceagentid]
  FROM [Diamond_Reporting].[dbo].[Agency]
  where RU_2 = 'RU56')
  and reportDt <='07/31/2019'
  and reportDt >= '08/31/2016'
