globals
[
  Num_Old_Customers ;; Customers with old vehicles enter into the market
  Num_New_Customers ;; New customers enter into the market
  ;; Cumulative number of vehicles up to time t.

  Beta_Fuel_Charge_Costs_List
  Beta_Purchase_Prices_List
  Beta_Driving_Mileages_List
  Beta_Refuel_Charge_Times_List
  Beta_Fuel_Charge_Stations_List
  Beta_CO2_Emissions_List

  Num_Gasoline
  Num_Diesel
  Num_NGV
  Num_HEV
  Num_PHEV
  Num_BEV
  Num_HFCV
  Vehicles_Total
  ;; Cumulative % of each type of vehicle
  ;;Gasoline and Diesel is a fuel made from cude oil .... considerd as a conventional fuels
  %Gasoline
  %Diesel
  ;; natural gas (liquefied petroleum gas, LPG, or compressed natural gas, CNG) vehicles (NGVs)
  %NGV
  ;;hybrid electric vehicles (HEVs)
  %HEV
  ;;Plug-in hybrid electric vehicles (PHEVs)
  %PHEV
  ;; Fully battery electric vehicles (BEVs)
  %BEV
  ;;, Hydrogen (fuel cell electric) vehicles (FCEVs)--->HFCV,
  %HFCV

  %CVs ;; %Gasoline + %Diesel + %NGV
  %EVs ;; %HEV + %PHEV + %BEV + %HFCV

  Vehicle_Lifetime

  Fuel_Charge_Cost_G
  Fuel_Charge_Cost_D
  Fuel_Charge_Cost_N
  Fuel_Charge_Cost_H
  Fuel_Charge_Cost_P
  Fuel_Charge_Cost_B
  Fuel_Charge_Cost_HF
  Purchase_Price_G
  Purchase_Price_D
  Purchase_Price_N
  Purchase_Price_H
  Purchase_Price_P
  Purchase_Price_B
  Purchase_Price_HF
  Driving_Mileage_G
  Driving_Mileage_D
  Driving_Mileage_N
  Driving_Mileage_H
  Driving_Mileage_P
  Driving_Mileage_B
  Driving_Mileage_HF
  Refuel_Charge_Time_G
  Refuel_Charge_Time_D
  Refuel_Charge_Time_N
  Refuel_Charge_Time_H
  Refuel_Charge_Time_P
  Refuel_Charge_Time_B
  Refuel_Charge_Time_HF
  Fuel_Charge_Station_G
  Fuel_Charge_Station_D
  Fuel_Charge_Station_N
  Fuel_Charge_Station_H
  Fuel_Charge_Station_P
  Fuel_Charge_Station_B
  Fuel_Charge_Station_HF
  CO2_Emission_G
  CO2_Emission_D
  CO2_Emission_N
  CO2_Emission_H
  CO2_Emission_P
  CO2_Emission_B
  CO2_Emission_HF
  Vehicle_Type ;; Gasoline=1, Diesel=2, NGV=3, HEV=4, PHEV=4, BEV=6, HFCV=7
]
breed[Vehicles Vehicle]
Vehicles-own
[

  Vehicle_Age

  Fuel_Charge_Costs_List
  Purchase_Prices_List
  Driving_Mileages_List
  Refuel_Charge_Times_List
  Fuel_Charge_Stations_List
  CO2_Emissions_List

  Norm_Fuel_Charge_Costs_List
  Norm_Purchase_Prices_List
  Norm_Driving_Mileages_List
  Norm_Refuel_Charge_Times_List
  Norm_Fuel_Charge_Stations_List
  Norm_CO2_Emissions_List

  Utility_List ;; (list Utility_Gasoline Utility_Diesel Utility_NGV Utility_HEV Utility_PHEV Utility_BEV Utility_HFCV)
  Exp_Utility_List
  Utility_Based_Prob_List

]

to Setup
  ;random-seed 40
  clear-all
  ask patches
  [
    set pcolor white
  ]
  set Vehicle_Lifetime floor ((random-normal (7 * 4) (1.5 * 4))) ;;; assuming 1 tick represents 3 months
  ;;; Specified parameter values in the utility function in the ABM (The CIE, 2019; Table D2, page 84):  EVs vs ICEVs (Ref. category)
  set Beta_Fuel_Charge_Costs_List       (list -1  -1  -1  -1.1020  -1.1020  -1.1020  -1.1020)         ;;; -0.1020 vs 0
  set Beta_Purchase_Prices_List         (list -1  -1  -1  -1.0815  -1.0815  -1.0815  -1.0815)         ;;; -0.0815 vs 0
  set Beta_Driving_Mileages_List        (list  1   1   1   1.0005   1.0005   1.0005   1.0005)         ;;;  0.0005 vs 0
  set Beta_Refuel_Charge_Times_List     (list -1  -1  -1  -1.0226  -1.0226  -1.0226  -1.0226)         ;;; -0.0226 vs 0
  set Beta_Fuel_Charge_Stations_List    (list  1   1   1   1.0029   1.0029   1.0029   1.0029)         ;;;  0.0029 vs 0
  set Beta_CO2_Emissions_List           (list -1  -1  -1  -1.0008  -1.0008   0.0000   0.0000)         ;;; -0.0008 vs 0
  ask Vehicles
  [
    set Fuel_Charge_Costs_List (list )
    set Purchase_Prices_List (list )
    set Driving_Mileages_List (list )
    set Refuel_Charge_Times_List (list )
    set Fuel_Charge_Stations_List (list )
    set CO2_Emissions_List (list )

    set Norm_Fuel_Charge_Costs_List (list )
    set Norm_Purchase_Prices_List (list )
    set Norm_Driving_Mileages_List (list )
    set Norm_Refuel_Charge_Times_List (list )
    set Norm_Fuel_Charge_Stations_List (list )
    set Norm_CO2_Emissions_List (list )
    set Utility_List (list )
    set Utility_Based_Prob_List (list )
  ]
  Generate_Initial_Vehicles
  reset-ticks
end
to Generate_Initial_Vehicles
  Create-Vehicles Initial_Num_Vehicles
  [
    setxy random-xcor random-ycor
    set shape "car"
    ;set size 1.5
    let a random-float 1                                        ;; Based on Wonjae Choi et al. (2020) https://doi.org/10.1016/j.apenergy.2020.114754
    (ifelse                                                     ;; Type       Number       %       Cum %
      a <= 0.56903                 [Be_Gasoline_Vehicle]        ;; Gasoline  10613540	  0.56903	  0.56903
      a > 0.56903 and a <= 0.87825 [Be_Diesel_Vehicle]          ;; Diesel	    5767379	  0.30921	  0.87825
      a > 0.87825 and a <= 0.97622 [Be_NGV_Vehicle]             ;; NGV	      1827462	  0.09798	  0.97622
      a > 0.97622 and a <= 0.99686 [Be_HEV_Vehicle]             ;; HEVs	       385010	  0.02064	  0.99686
      a > 0.99686 and a <= 0.99698 [Be_PHEV_Vehicle]            ;; PHEVs	       2167	  0.00012	  0.99698
      a > 0.99698 and a <= 0.99995 [Be_BEV_Vehicle]             ;; BEVs	        55417	  0.00297	  0.99995
      a > 0.99995                  [Be_HFCV_Vehicle]            ;; FCEVs	        891	  0.00005	  1.00000
                                   [show "Error! in the Initial Vehicle." stop]
    )
  ]
  set Vehicles_Total     Num_Gasoline + Num_Diesel + Num_NGV + Num_HEV + Num_PHEV + Num_BEV + Num_HFCV
end
to Be_Gasoline_Vehicle
  set color red
  set Vehicle_Type 1
  set Num_Gasoline  Num_Gasoline + 1
  set Vehicle_Age random-float Vehicle_Lifetime
end
to Be_Diesel_Vehicle
  set color brown
  set Vehicle_Type 2
  set Num_Diesel  Num_Diesel + 1
  set Vehicle_Age random-float Vehicle_Lifetime
end
to Be_NGV_Vehicle
  set color gray
  set Vehicle_Type 3
  set Num_NGV  Num_NGV + 1
  set Vehicle_Age random-float Vehicle_Lifetime
end
to Be_HEV_Vehicle
  set color cyan
  set Vehicle_Type 4
  set Num_HEV  Num_HEV + 1
  set Vehicle_Age random-float Vehicle_Lifetime
end
to Be_PHEV_Vehicle
  set color blue
  set Vehicle_Type 5
  set Num_PHEV  Num_PHEV + 1
  set Vehicle_Age random-float Vehicle_Lifetime
end
to Be_BEV_Vehicle
  set color green
  set Vehicle_Type 6
  set Num_BEV  Num_BEV + 1
  set Vehicle_Age random-float Vehicle_Lifetime
end
to Be_HFCV_Vehicle
  set color violet
  set Vehicle_Type 7
  set Num_HFCV  Num_HFCV + 1
  set Vehicle_Age random-float Vehicle_Lifetime
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;
to Go
  if ticks = 10 * 4  [stop]
  Generate_Current_Purchased_Vehicles ;; Old and new customers entered the market
  Summarize_Simulated_Vehicles
  Plot_Simulated_Market_Shares_Each_Vehicle_Type
  Plot_Simulated_Market_Shares_CVs_vs_EVs
  tick
end

;;; new customers enter the market
to Generate_Current_Purchased_Vehicles
  ask Vehicles
  [
    set Vehicle_Age Vehicle_Age + 3
    set Num_Old_Customers count Vehicles with [Vehicle_Age >= Vehicle_Lifetime]
    set Num_New_Customers random-poisson Mean_Num_New_Customers_per_Month
  ]
  ask Vehicles with [Vehicle_Age >= Vehicle_Lifetime]
  [
    (ifelse
      Vehicle_Type = 1 [set Num_Gasoline  Num_Gasoline - 1]
      Vehicle_Type = 2 [set Num_Diesel  Num_Diesel - 1]
      Vehicle_Type = 3 [set Num_NGV  Num_NGV - 1]
      Vehicle_Type = 4 [set Num_HEV  Num_HEV - 1]
      Vehicle_Type = 5 [set Num_PHEV  Num_PHEV - 1]
      Vehicle_Type = 6 [set Num_BEV  Num_BEV - 1]
      Vehicle_Type = 7 [set Num_HFCV  Num_HFCV - 1]
                       [print "No old vehicle to be replaced."]
    )
    die
  ]
  Create-Vehicles (Num_Old_Customers + Num_New_Customers)
  [
    set shape "car"
    ;set size 1.5
    setxy random-xcor random-ycor
  ]
  ask Vehicles
  [
    Setup_Vehicles_Data
    Compute_Utilities ;; Utility calculation for each of the 7 vehicle types
    Select_Vehicle_Type ;; Select the type of vehicle and decide to replace the old vehicle
    ;let Output Vehicles_Data_Output
  ]
end

to Setup_Vehicles_Data
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Parameters for sensitivity analysis
  let %Purchase_Tax_Increment     Purchase_Tax_CVs / 100            ;; % of Purchase Tax on CVs
  let %Fuel_Cost_Increment        Fuel_Cost_Increment / 100         ;; % of Fuel Cost increment
  let %Purchase_Subsidy           Subsidy_For_EVs / 100             ;; % of Purchase price of EVs covered by Subsidy
  let %Driving_Mileage_Increment  Driving_Mileage_Increment / 100   ;; % of Dirving Mileage improvement per full charge
  let %Charge_Time_Decrement      Charging_Time_Decrement / 100     ;; % of battery Charging Time decrement for EVs
  let %Charge_Station_Increment   Charging_Station_Increment / 100  ;; % of Charging Stations increment r.t current status

  let FCG      Fuel_Cost_Gasoline - 2 + random (2 * 2 + 1)
  let FCD      Fuel_Cost_Diesel - 2 + random (2 * 2 + 1)
  let FCN      Fuel_Cost_NGV - 2 + random (2 * 2 + 1)
  let FCH      Fuel_Cost_HEV - 2 + random (2 * 2 + 1)
  let FCP      Fuel_Cost_PHEV - 2 + random (2 * 2 + 1)
  let FCB      Charging_Cost_BEV - 2 + random (2 * 2 + 1)
  let FCHF     Charging_Cost_HFCV - 2 + random (2 * 2 + 1)


  set Fuel_Charge_Cost_G      FCG + FCG * %Fuel_Cost_Increment
  set Fuel_Charge_Cost_D      FCD + FCD * %Fuel_Cost_Increment
  set Fuel_Charge_Cost_N      FCN + FCN * %Fuel_Cost_Increment
  set Fuel_Charge_Cost_H      FCH + FCH * %Fuel_Cost_Increment
  set Fuel_Charge_Cost_P      FCP + FCP * %Fuel_Cost_Increment
  set Fuel_Charge_Cost_B      FCB
  set Fuel_Charge_Cost_HF     FCHF
  set Fuel_Charge_Costs_List (list Fuel_Charge_Cost_G Fuel_Charge_Cost_D Fuel_Charge_Cost_N Fuel_Charge_Cost_H Fuel_Charge_Cost_P Fuel_Charge_Cost_B Fuel_Charge_Cost_HF)

  let PPG        Purchase_Price_Gasoline - 2000 + random (2 * 2000 + 1)
  let PPD        Purchase_Price_Diesel - 2000 + random (2 * 2000 + 1)
  let PPN        Purchase_Price_NGV - 2000 + random (2 * 2000 + 1)
  let PPH        Purchase_Price_HEV - 2000 + random (2 * 2000 + 1)
  let PPP        Purchase_Price_PHEV - 2000 + random (2 * 2000 + 1)
  let PPB        Purchase_Price_BEV - 2000 + random (2 * 2000 + 1)
  let PPHF       Purchase_Price_HFCV - 2000 + random (2 * 2000 + 1)

  set Purchase_Price_G        PPG + PPG * %Purchase_Tax_Increment
  set Purchase_Price_D        PPD + PPD * %Purchase_Tax_Increment
  set Purchase_Price_N        PPN + PPN * %Purchase_Tax_Increment
  set Purchase_Price_H        PPH - PPH * %Purchase_Subsidy
  set Purchase_Price_P        PPP - PPP * %Purchase_Subsidy
  set Purchase_Price_B        PPB - PPB * %Purchase_Subsidy
  set Purchase_Price_HF       PPHF - PPHF * %Purchase_Subsidy
  set Purchase_Prices_List (list Purchase_Price_G Purchase_Price_D Purchase_Price_N Purchase_Price_H Purchase_Price_P Purchase_Price_B Purchase_Price_HF)

  let DMG       Driving_Mileage_Gasoline - 150 + random (2 * 150 + 1)
  let DMD       Driving_Mileage_Diesel - 150 + random (2 * 150 + 1)
  let DMN       Driving_Mileage_NGV - 150 + random (2 * 150 + 1)
  let DMH       Driving_Mileage_HEV - 150 + random (2 * 150 + 1)
  let DMP       Driving_Mileage_PHEV - 150 + random (2 * 150 + 1)
  let DMB       Driving_Mileage_BEV - 150 + random (2 * 150 + 1)
  let DMHF      Driving_Mileage_HFCV - 150 + random (2 * 150 + 1)

  set Driving_Mileage_G       DMG
  set Driving_Mileage_D       DMD
  set Driving_Mileage_N       DMN
  set Driving_Mileage_H       DMH
  set Driving_Mileage_P       DMP
  set Driving_Mileage_B       DMB + DMB * %Driving_Mileage_Increment
  set Driving_Mileage_HF      DMHF + DMHF * %Driving_Mileage_Increment
  set Driving_Mileages_List (list Driving_Mileage_G Driving_Mileage_D Driving_Mileage_N Driving_Mileage_H Driving_Mileage_P Driving_Mileage_B Driving_Mileage_HF)

  let RCG    Refuel_Time_Gasoline - 1 + random (2 * 1 + 1)
  let RCD    Refuel_Time_Diesel  - 1 + random (2 * 1 + 1)
  let RCN    Refuel_Time_NGV  - 1 + random (2 * 1 + 1)
  let RCH    Refuel_Time_HEV  - 1 + random (2 * 1 + 1)
  let RCP    Charging_Time_PHEV - 100 + random (2 * 100 + 1)
  let RCB    Charging_Time_BEV - 100 + random (2 * 100 + 1)
  let RCHF   Charging_Time_HFCV - 1 + random (2 * 1 + 1)

  set Refuel_Charge_Time_G    RCG
  set Refuel_Charge_Time_D    RCD
  set Refuel_Charge_Time_N    RCN
  set Refuel_Charge_Time_H    RCH
  set Refuel_Charge_Time_P    RCP
  set Refuel_Charge_Time_B    RCB - RCB * %Charge_Time_Decrement
  set Refuel_Charge_Time_HF   RCHF
  set Refuel_Charge_Times_List (list Refuel_Charge_Time_G Refuel_Charge_Time_D Refuel_Charge_Time_N Refuel_Charge_Time_H Refuel_Charge_Time_P Refuel_Charge_Time_B Refuel_Charge_Time_HF)

  let FCSG    Fuel_Station_Gasoline
  let FCSD    Fuel_Station_Diesel
  let FCSN    Fuel_Station_NGV
  let FCSH    Fuel_Station_HEV - 10 + random (2 * 10 + 1)
  let FCSP    Fuel_Station_PHEV - 10 + random (2 * 10 + 1)
  let FCSB    Charging_Station_BEV - 10 + random (2 * 10 + 1)
  let FCSHF   Charging_Station_HFCV + random (2 * 10 + 1)

  set Fuel_Charge_Station_G    FCSG
  set Fuel_Charge_Station_D    FCSD
  set Fuel_Charge_Station_N    FCSN
  set Fuel_Charge_Station_H    FCSH
  set Fuel_Charge_Station_P    FCSP + FCSP * %Charge_Station_Increment
  set Fuel_Charge_Station_B    FCSB + FCSB * %Charge_Station_Increment
  set Fuel_Charge_Station_HF   FCSHF + FCSHF * %Charge_Station_Increment
  set Fuel_Charge_Stations_List (list Fuel_Charge_Station_G Fuel_Charge_Station_D Fuel_Charge_Station_N Fuel_Charge_Station_H Fuel_Charge_Station_P Fuel_Charge_Station_B Fuel_Charge_Station_HF)

  let CO2G    CO2_Emission_Gasoline
  let CO2D    CO2_Emission_Diesel
  let CO2N    CO2_Emission_NGV
  let CO2H    CO2_Emission_HEV - 10 + random (2 * 10 + 1)
  let CO2P    CO2_Emission_PHEV - 10 + random (2 * 10 + 1)
  let CO2B    CO2_Emission_BEV
  let CO2HF   CO2_Emission_HFCV

  set CO2_Emission_G    CO2G
  set CO2_Emission_D    CO2D
  set CO2_Emission_N    CO2N
  set CO2_Emission_H    CO2H
  set CO2_Emission_P    CO2P
  set CO2_Emission_B    CO2B
  set CO2_Emission_HF   CO2HF

  set CO2_Emissions_List (list CO2_Emission_G CO2_Emission_D CO2_Emission_N CO2_Emission_H CO2_Emission_P CO2_Emission_B CO2_Emission_HF)
end

to Compute_Utilities
  set Norm_Fuel_Charge_Costs_List (map [[Cost] -> (Cost - min (Fuel_Charge_Costs_List)) / (max (Fuel_Charge_Costs_List) - min (Fuel_Charge_Costs_List))] Fuel_Charge_Costs_List)
  set Norm_Purchase_Prices_List (map [[Price] -> (Price - min (Purchase_Prices_List)) / (max (Purchase_Prices_List) - min (Purchase_Prices_List))] Purchase_Prices_List)
  set Norm_Driving_Mileages_List (map [[Mileage] -> (Mileage - min (Driving_Mileages_List)) / (max (Driving_Mileages_List) - min (Driving_Mileages_List))] Driving_Mileages_List)
  set Norm_Refuel_Charge_Times_List (map [[Time] -> (Time - min (Refuel_Charge_Times_List)) / (max (Refuel_Charge_Times_List) - min (Refuel_Charge_Times_List))] Refuel_Charge_Times_List)
  set Norm_Fuel_Charge_Stations_List (map [[Station] -> (Station - min (Fuel_Charge_Stations_List)) / (max (Fuel_Charge_Stations_List) - min (Fuel_Charge_Stations_List))] Fuel_Charge_Stations_List)
  set Norm_CO2_Emissions_List (map [[Emission] -> (Emission - min (CO2_Emissions_List)) / (max (CO2_Emissions_List) - min (CO2_Emissions_List))] CO2_Emissions_List)

  let Random_Error_List (list (random-normal 0 1) (random-normal 0 1) (random-normal 0 1) (random-normal 0 1) (random-normal 0 1) (random-normal 0 1) (random-normal 0 1))

  set Utility_List (map[[Beta_Fuel_Charge_Cost      Beta_Purchase_Price     Beta_Driving_Mileage     Beta_Refuel_Charge_Time    Beta_Fuel_Charge_Station    Beta_CO2_Emission
                         Norm_Fuel_Charge_Cost      Norm_Purchase_Price     Norm_Driving_Mileage     Norm_Refuel_Charge_Time    Norm_Fuel_Charge_Station    Norm_CO2_Emission Random_Term]
                      -> Beta_Fuel_Charge_Cost * Norm_Fuel_Charge_Cost + Beta_Purchase_Price * Norm_Purchase_Price + Beta_Driving_Mileage * Norm_Driving_Mileage
                       + Beta_Refuel_Charge_Time * Norm_Refuel_Charge_Time + Beta_Fuel_Charge_Station * Norm_Fuel_Charge_Station + Beta_CO2_Emission * Norm_CO2_Emission + Random_Term]
                          Beta_Fuel_Charge_Costs_List Beta_Purchase_Prices_List Beta_Driving_Mileages_List Beta_Refuel_Charge_Times_List Beta_Fuel_Charge_Stations_List Beta_CO2_Emissions_List
                          Norm_Purchase_Prices_List Norm_Fuel_Charge_Costs_List Norm_Driving_Mileages_List Norm_Refuel_Charge_Times_List Norm_Fuel_Charge_Stations_List Norm_CO2_Emissions_List Random_Error_List)
end

to Select_Vehicle_Type
  ;; Calculate_Utility_Based_Probabilities - Multinomial probability of choice based on utility
  let Utility_Prob_Gasoline       exp(item 0 Utility_List)/ sum((map[[Utility] -> exp(Utility)] Utility_List))
  let Utility_Prob_Diesel         exp(item 1 Utility_List)/ sum((map[[Utility] -> exp(Utility)] Utility_List))
  let Utility_Prob_NGV            exp(item 2 Utility_List)/ sum((map[[Utility] -> exp(Utility)] Utility_List))
  let Utility_Prob_HEV            exp(item 3 Utility_List)/ sum((map[[Utility] -> exp(Utility)] Utility_List))
  let Utility_Prob_PHEV           exp(item 4 Utility_List)/ sum((map[[Utility] -> exp(Utility)] Utility_List))
  let Utility_Prob_BEV            exp(item 5 Utility_List)/ sum((map[[Utility] -> exp(Utility)] Utility_List))
  let Utility_Prob_HFCV           exp(item 6 Utility_List)/ sum((map[[Utility] -> exp(Utility)] Utility_List))

  set Utility_Based_Prob_List (list Utility_Prob_Gasoline Utility_Prob_Diesel Utility_Prob_NGV Utility_Prob_HEV Utility_Prob_PHEV Utility_Prob_BEV Utility_Prob_HFCV)

  let p_1         Utility_Prob_Gasoline
  let p_2   p_1 + Utility_Prob_Diesel
  let p_3   p_2 + Utility_Prob_NGV
  let p_4   p_3 + Utility_Prob_HEV
  let p_5   p_4 + Utility_Prob_PHEV
  let p_6   p_5 + Utility_Prob_BEV
  let p_7   p_6 + Utility_Prob_HFCV

  let p_i random-float 1.0
  (ifelse
    p_i < p_1                [Become_Gasoline_Owner]
    p_i > p_1 and p_i <= p_2 [Become_Diesel_Owner]
    p_i > p_2 and p_i <= p_3 [Become_NGV_Owner]
    p_i > p_3 and p_i <= p_4 [Become_HEV_Owner]
    p_i > p_4 and p_i <= p_5 [Become_PHEV_Owner]
    p_i > p_5 and p_i <= p_6 [Become_BEV_Owner]
    p_i > p_6 and p_i <= p_7 [Become_HFCV_Owner]
  )
end

to Become_Gasoline_Owner
  set shape "car"
  set color gray
  set Vehicle_Type 1
  set Num_Gasoline  Num_Gasoline + 1
  set Vehicle_Age 0
end
to Become_Diesel_Owner
  set shape "car"
  set color brown
  set Vehicle_Type 2
  set Num_Diesel  Num_Diesel + 1
  set Vehicle_Age 0
end
to Become_NGV_Owner
  set shape "car"
  set color brown
  set Vehicle_Type 3
  set Num_NGV  Num_NGV + 1
  set Vehicle_Age 0
end
to Become_HEV_Owner
  set shape "car"
  set color cyan
  set Vehicle_Type 4
  set Num_HEV  Num_HEV + 1
  set Vehicle_Age 0
end
to Become_PHEV_Owner
  set color blue
  set shape "car"
  set Vehicle_Type 5
  set Num_PHEV  Num_PHEV + 1
  set Vehicle_Age 0
end
to Become_BEV_Owner
  set shape "car"
  set color green
  set Vehicle_Type 6
  set Num_BEV  Num_BEV + 1
  set Vehicle_Age 0
end
to Become_HFCV_Owner
  set shape "car"
  set color violet
  set Vehicle_Type 7
  set Num_HFCV  Num_HFCV + 1
  set Vehicle_Age 0
end

to Summarize_Simulated_Vehicles
  set Vehicles_Total     Num_Gasoline + Num_Diesel + Num_NGV + Num_HEV + Num_PHEV + Num_BEV + Num_HFCV
  set %Gasoline    Num_Gasoline / Vehicles_Total * 100
  set %Diesel      Num_Diesel / Vehicles_Total * 100
  set %NGV         Num_NGV / Vehicles_Total * 100
  set %HEV         Num_HEV / Vehicles_Total * 100
  set %PHEV        Num_PHEV / Vehicles_Total * 100
  set %BEV         Num_BEV / Vehicles_Total * 100
  set %HFCV        Num_HFCV / Vehicles_Total * 100
  set %CVs        (Num_Gasoline + Num_Diesel + Num_NGV) / Vehicles_Total * 100
  set %EVs        (Num_HEV + Num_PHEV + Num_BEV + Num_HFCV) / Vehicles_Total * 100
end

to Plot_Simulated_Market_Shares_Each_Vehicle_Type
  set-current-plot "Market Shares of Each Type of Vehicle"
  set-current-plot-pen "Gasoline"
  plot (%Gasoline)
  set-current-plot-pen "Diesel"
  plot (%Diesel)
  set-current-plot-pen "NGV"
  plot (%NGV)
  set-current-plot-pen "HEV"
  plot (%HEV)
  set-current-plot-pen "PHEV"
  plot (%PHEV)
  set-current-plot-pen "BEV"
  plot (%BEV)
  set-current-plot-pen "HFCV"
  plot (%HFCV)
end
to Plot_Simulated_Market_Shares_CVs_vs_EVs
  set-current-plot "Market Shares of Conventional vs Electric Vehicles"
  set-current-plot-pen "CVs"
  plot (%CVs)
  set-current-plot-pen "EVs"
  plot (%EVs)
end
@#$#@#$#@
GRAPHICS-WINDOW
84
10
437
364
-1
-1
10.455
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
20
38
84
71
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
13
494
245
527
Driving_Mileage_Increment
Driving_Mileage_Increment
0
100
0.0
1
1
%
HORIZONTAL

SLIDER
13
530
245
563
Charging_Time_Decrement
Charging_Time_Decrement
0
50
25.0
1
1
%
HORIZONTAL

SLIDER
13
424
245
457
Purchase_Tax_CVs
Purchase_Tax_CVs
0
20
10.0
1
1
%
HORIZONTAL

BUTTON
19
113
82
146
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
75
83
109
NIL
Go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
443
300
503
345
Gasoline
Num_Gasoline
17
1
11

MONITOR
686
300
744
345
PHEV
Num_PHEV
17
1
11

MONITOR
625
300
683
345
HEV
Num_HEV
17
1
11

MONITOR
748
300
806
345
BEV
Num_BEV
17
1
11

PLOT
440
10
870
298
Market Shares of Each Type of Vehicle
Simulation Time
Percentage of Vehicles
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"Gasoline" 1.0 0 -2674135 true "" ""
"Diesel" 1.0 0 -6459832 true "" ""
"NGV" 1.0 0 -7500403 true "" ""
"HEV" 1.0 0 -11221820 true "" ""
"PHEV" 1.0 0 -13345367 true "" ""
"BEV" 1.0 0 -10899396 true "" ""
"HFCV" 1.0 0 -8630108 true "" ""

PLOT
872
10
1252
298
Market Shares of Conventional vs Electric Vehicles
Simulation Time
Percentage of Vehicles
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"CVs" 1.0 0 -2674135 true "" ""
"EVs" 1.0 0 -14835848 true "" ""

SLIDER
12
388
244
421
Subsidy_For_EVs
Subsidy_For_EVs
0
20
20.0
1
1
%
HORIZONTAL

MONITOR
867
299
926
344
Total
Vehicles_Total
17
1
11

SLIDER
13
566
245
599
Charging_Station_Increment
Charging_Station_Increment
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
13
460
245
493
Fuel_Cost_Increment
Fuel_Cost_Increment
0
30
0.0
1
1
%
HORIZONTAL

INPUTBOX
1258
12
1398
72
Purchase_Price_Gasoline
24128.24
1
0
Number

INPUTBOX
1267
260
1410
320
Purchase_Price_PHEV
33425.36
1
0
Number

INPUTBOX
1265
197
1409
257
Purchase_Price_HEV
29551.56
1
0
Number

INPUTBOX
1267
322
1413
382
Purchase_Price_BEV
40730.24
1
0
Number

INPUTBOX
1402
11
1543
71
Driving_Mileage_Gasoline
1000.0
1
0
Number

INPUTBOX
1411
261
1553
321
Driving_Mileage_PHEV
750.0
1
0
Number

INPUTBOX
1409
197
1552
257
Driving_Mileage_HEV
1000.0
1
0
Number

INPUTBOX
1412
322
1554
382
Driving_Mileage_BEV
175.0
1
0
Number

INPUTBOX
1547
10
1663
70
Fuel_Cost_Gasoline
9.9612
1
0
Number

INPUTBOX
1555
195
1669
255
Fuel_Cost_HEV
8.301
1
0
Number

INPUTBOX
1560
320
1674
380
Charging_Cost_BEV
9.9612
1
0
Number

INPUTBOX
1123
451
1249
511
Refuel_Time_Gasoline
5.0
1
0
Number

INPUTBOX
1127
697
1255
757
Refuel_Time_PHEV
5.0
1
0
Number

INPUTBOX
1127
637
1253
697
Refuel_Time_HEV
5.0
1
0
Number

INPUTBOX
1260
760
1384
820
Charging_Time_BEV
480.0
1
0
Number

INPUTBOX
1537
452
1672
512
CO2_Emission_Gasoline
100.0
1
0
Number

INPUTBOX
1542
699
1680
759
CO2_Emission_PHEV
31.0
1
0
Number

INPUTBOX
1540
636
1677
696
CO2_Emission_HEV
77.0
1
0
Number

INPUTBOX
1388
453
1533
513
Fuel_Station_Gasoline
100.0
1
0
Number

INPUTBOX
1392
698
1539
758
Fuel_Station_PHEV
43.3
1
0
Number

INPUTBOX
1390
637
1538
697
Fuel_Station_HEV
100.0
1
0
Number

INPUTBOX
1392
758
1541
818
Charging_Station_BEV
14.1
1
0
Number

INPUTBOX
1267
385
1414
445
Purchase_Price_HFCV
37409.84
1
0
Number

INPUTBOX
1417
383
1557
443
Driving_Mileage_HFCV
750.0
1
0
Number

INPUTBOX
1561
383
1674
443
Charging_Cost_HFCV
8.301
1
0
Number

INPUTBOX
1260
821
1385
881
Charging_Time_HFCV
5.0
1
0
Number

INPUTBOX
1391
819
1541
879
Charging_Station_HFCV
0.2
1
0
Number

MONITOR
808
300
865
345
HFCV
Num_HFCV
17
1
11

TEXTBOX
72
369
209
387
Model Parameters
12
0.0
1

INPUTBOX
1555
258
1672
318
Fuel_Cost_PHEV
6.0874
1
0
Number

INPUTBOX
1259
698
1385
758
Charging_Time_PHEV
240.0
1
0
Number

SLIDER
440
432
722
465
Mean_Num_New_Customers_per_Month
Mean_Num_New_Customers_per_Month
0
500
100.0
1
1
NIL
HORIZONTAL

INPUTBOX
1543
760
1683
820
CO2_Emission_BEV
0.0
1
0
Number

INPUTBOX
1545
820
1685
880
CO2_Emission_HFCV
0.0
1
0
Number

INPUTBOX
1259
73
1401
133
Purchase_Price_Diesel
24128.24
1
0
Number

INPUTBOX
1404
72
1546
132
Driving_Mileage_Diesel
1000.0
1
0
Number

INPUTBOX
1548
71
1665
131
Fuel_Cost_Diesel
9.9612
1
0
Number

INPUTBOX
1123
512
1251
572
Refuel_Time_Diesel
5.0
1
0
Number

INPUTBOX
1388
513
1533
573
Fuel_Station_Diesel
100.0
1
0
Number

INPUTBOX
1537
511
1672
571
CO2_Emission_Diesel
100.0
1
0
Number

MONITOR
507
300
564
345
Diesel
Num_Diesel
17
1
11

SLIDER
440
395
723
428
Initial_Num_Vehicles
Initial_Num_Vehicles
0
1000
500.0
1
1
NIL
HORIZONTAL

MONITOR
566
300
624
345
NGV
Num_NGV
17
1
11

INPUTBOX
1263
134
1407
194
Purchase_Price_NGV
26452.52
1
0
Number

INPUTBOX
1409
134
1550
194
Driving_Mileage_NGV
1000.0
1
0
Number

INPUTBOX
1553
132
1668
192
Fuel_Cost_NGV
7.1942
1
0
Number

INPUTBOX
1124
574
1253
634
Refuel_Time_NGV
5.0
1
0
Number

INPUTBOX
1388
575
1535
635
Fuel_Station_NGV
50.9
1
0
Number

INPUTBOX
1539
573
1674
633
CO2_Emission_NGV
84.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="EV_Experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>Fuel_Charge_Cost_G</metric>
    <metric>Fuel_Charge_Cost_D</metric>
    <metric>Fuel_Charge_Cost_N</metric>
    <metric>Fuel_Charge_Cost_H</metric>
    <metric>Fuel_Charge_Cost_P</metric>
    <metric>Fuel_Charge_Cost_B</metric>
    <metric>Fuel_Charge_Cost_HF</metric>
    <metric>Purchase_Price_G</metric>
    <metric>Purchase_Price_D</metric>
    <metric>Purchase_Price_N</metric>
    <metric>Purchase_Price_H</metric>
    <metric>Purchase_Price_P</metric>
    <metric>Purchase_Price_B</metric>
    <metric>Purchase_Price_HF</metric>
    <metric>Driving_Mileage_G</metric>
    <metric>Driving_Mileage_D</metric>
    <metric>Driving_Mileage_N</metric>
    <metric>Driving_Mileage_H</metric>
    <metric>Driving_Mileage_P</metric>
    <metric>Driving_Mileage_B</metric>
    <metric>Driving_Mileage_HF</metric>
    <metric>Refuel_Charge_Time_G</metric>
    <metric>Refuel_Charge_Time_D</metric>
    <metric>Refuel_Charge_Time_N</metric>
    <metric>Refuel_Charge_Time_H</metric>
    <metric>Refuel_Charge_Time_P</metric>
    <metric>Refuel_Charge_Time_B</metric>
    <metric>Refuel_Charge_Time_HF</metric>
    <metric>Fuel_Charge_Station_G</metric>
    <metric>Fuel_Charge_Station_D</metric>
    <metric>Fuel_Charge_Station_N</metric>
    <metric>Fuel_Charge_Station_H</metric>
    <metric>Fuel_Charge_Station_P</metric>
    <metric>Fuel_Charge_Station_B</metric>
    <metric>Fuel_Charge_Station_HF</metric>
    <metric>CO2_Emission_G</metric>
    <metric>CO2_Emission_D</metric>
    <metric>CO2_Emission_N</metric>
    <metric>CO2_Emission_H</metric>
    <metric>CO2_Emission_P</metric>
    <metric>CO2_Emission_B</metric>
    <metric>CO2_Emission_HF</metric>
    <metric>Vehicle_Type</metric>
    <steppedValueSet variable="Charging_Station_Increment" first="0" step="50" last="100"/>
    <steppedValueSet variable="Charging_Time_Decrement" first="0" step="25" last="50"/>
    <steppedValueSet variable="Driving_Mileage_Increment" first="0" step="50" last="100"/>
    <steppedValueSet variable="Subsidy_For_EVs" first="0" step="10" last="20"/>
    <steppedValueSet variable="Fuel_Cost_Increment" first="0" step="15" last="30"/>
    <enumeratedValueSet variable="Purchase_Tax_CVs">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
