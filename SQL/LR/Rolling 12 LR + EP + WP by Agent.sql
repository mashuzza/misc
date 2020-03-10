SELECT 
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

			WHERE   reportDt >= '03/31/2015'
					and reportDt <= '02/28/2020'
			and P.BusinessType = 'Voluntary' 
			and CL.Cause not like '%HRB%' 
			and C.HartfordSteamBoiler <> 'Yes'
			and sourceAgentId like 'AG1777A16'
			group by cat

----------EP

 Select  sum(earnedPremiumChg) as EP
  from dbo.Agg_Policy a
  join dbo.Dim1_Agency b on a.DimAgencyId = b.DimAgencyId
  join Dim1_Product e on e.DimProductId = a.DimProductId
  join dbo.Dim1_Policy c on a.DimPolicyId = c.DimPolicyId

where  e.BusinessType = 'Voluntary' 
		and reportDt >= '03/31/2015'
		and reportDt <= '02/28/2020'
  and sourceAgentId like 'AG1777A16'


/*
----------WP

 Select  [AgencyMarketingRep], sum(WrittenPremiumChg) as WP
  from dbo.Agg_Policy a
  join dbo.Dim1_Agency b on a.DimAgencyId = b.DimAgencyId
  join Dim1_Product e on e.DimProductId = a.DimProductId
  join dbo.Dim1_Policy c on a.DimPolicyId = c.DimPolicyId

where  e.BusinessType = 'Voluntary' 
and reportDt <= '09/30/2018'
and reportDt >= '10/31/2017'
and AgencyMarketingRep like 'L%'

group by [AgencyMarketingRep]
