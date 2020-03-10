-- Rolling 12 EP and LR by County

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
			join adw.dbo.Dim2_Address f on ac.DimPropAddressId = f.DimAddressId

			WHERE   reportDt >= '02/28/2019'
					and reportDt <= '01/31/2020'
			and P.BusinessType = 'Voluntary' 
			and CL.Cause not like '%HRB%' 
			and C.HartfordSteamBoiler <> 'Yes'
			and county like 'Marion%'
			group by cat


	Select  sum(earnedPremiumChg) as EP
  from dbo.Agg_Policy a
  join dbo.Dim1_Agency b on a.DimAgencyId = b.DimAgencyId
  join Dim1_Product e on e.DimProductId = a.DimProductId
  join dbo.Dim1_Policy c on a.DimPolicyId = c.DimPolicyId
  join adw.dbo.Dim2_Address f on a.DimPropAddressId = f.DimAddressId

where  e.BusinessType = 'Voluntary' 
  and reportDt >= '02/28/2019'
  and reportDt <= '01/31/2020'
  and county like 'Marion%'
