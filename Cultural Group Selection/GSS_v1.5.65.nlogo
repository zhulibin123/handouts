globals [        ; -----------------------------------------------
;environmental variables
  ;r              ; intrinsic rate of growth
  K              ; per patch resource carrying capacity
  MSY            ; CALCULATED - maximum sustainable yield; floor ( ( K * r ) / 4 )
  refuge-level   ; level below which resources cannot be extinguished (optional)
  regen_rate     ; rate at which patches will restart growing when below refuge-level
  
;trait value lists - these are lists of the states that these behavioral traits may take
  productionNorms
  markerTraits
  harvestTraits
  propertyNorms
  
;imitation of traits 
  ;Production ;- set as a switch
  ;Property ;- set as a switch

;initialization - cultural traits
  ;mutationRate      ; rate
  ;group-markers     ; binary - set as a switch
  mutateMarker      ; binary - only responds to group treatment
  imitateMarker?    ; binary - only responds to group treatment
  ;imitateProb       ; rate
  imitateBias       ; payoff bias - vary for robustness
  imitateTreatment  ; binary (anyone, group) - only anyone used
  ;imitateRadius     ; value - set at 2
  
;initialization - demographics
  organization          ; initial group organization scheme
  init_n_groups         ; 
  init_group_size       ; 
  costOfBaby            ; CALCULATED: floor ( 2 * ( highHarvest - costOfLiving ))
  costOfLiving          ; CALCULATED: floor ( costOfLivingMSYRatio * MSY )
  ;migrateProb           ; rate - currently 0
  ;marginal_defense_cost ; the cost of defending your patch from one neighbor
  
;initialization - economic factors
  ;givePerc                ; fraction of turtles raw resources that it will give in the public goods game
  ;publicGoodsTheta        ; growth rate of public goods investment
  ;HoldingCap              ; value - resource holding capacity of agents FOR BOTH raw AND processed resources.
  ;HarvestGap              ; proportion of MSY by which high harvesting amount exceeds low harvest amount
  ;costOfLivingMSYRatio    ; cost of living as a proportion of MSY
  highHarvest             ; CALCULATED - amount of resource that high harvesters take
  lowHarvest              ; CALCULATED - amount of resource that low harvesters take
     
;DATA COLLECTION ##############################
;data collection - environmental 
  resource       ; CALCULATED - sum [patchresource] of patches / (K * count patches)
  groups     ; number of groups
  
;data collection - trait frequencies 
  freq_low            ; sustainable harvesting behavior
  freq_coop_group     ; cooperate with group only
  freq_coop_any       ; cooperate with all
  freq_coop_noone
  freq_prop_group     ; defend property against all but my group
  freq_prop_private   ; defend property against all
  freq_prop_open
    
;data collection - trait-combination variables. These are abbreviations for trait types
  hl_cg_po      ; hl, hh - represent harvesting high and low
  hl_cg_pg      ; cn, cg, ca - represent Cooperation (Sharing) ["noone" "group" "anyone"]
  hl_cg_pp      ; pp, pg, po - represent Property (Defense) ["private" "group" "open"]
  
  hl_cn_po
  hl_cn_pg
  hl_cn_pp
  
  hl_ca_po
  hl_ca_pg
  hl_ca_pp
  
  hh_cn_po
  hh_cn_pg
  hh_cn_pp
  
  hh_cg_po
  hh_cg_pg
  hh_cg_pp
  
  hh_ca_po
  hh_ca_pg
  hh_ca_pp

;data collection - between-group trait-fitness covariances
  gs_harv_l         ; harvest
  
  gs_prop_p         ; property
  gs_prop_g         ; property
  gs_prop_o         ; property
  
  gs_coop_a         ; production
  gs_coop_g         ; production
  gs_coop_n         ; production
  
;data collection - mean within-group trait-fitness covariances
  is_harv_l         ; harvest
  
  is_prop_p         ; property
  is_prop_g         ; property
  is_prop_o         ; property
  
  is_coop_a         ; production
  is_coop_g         ; production
  is_coop_n         ; production
  ]  



turtles-own [       ; -----------------------------------------------
;key behavioral traits
  share  ;; the sharing trait of an agent (anyone, noone, group)
  harvestPref  ;; the harvesting preference (low, high)
  propertyNorm  ;; the agent's norm for whom to allow on the patch it occupies ("private" "group" "open")
  
;demographic variables
  age  ;; number of time steps agent has survived
  agentRawResource  ;; the amount of unprocessed resource an agent has accumulated
  agentProcessedResource ;; the amount of processed resource an agent has accumulated
  rs  ;; reproductive success
  
;**REMOVE** could be localized, SHOULD be localized if that made things more efficient  
  copy-target         ;; the agent that has been chosen to be imitated
  harvestAmt          ;; the amount of resource associated with your harvesting preferemce
  myHarvest           ;; keeps track of the amount of resource an agent has harvested during the time step
  myCommons           ;; the patches in an agent's commons (Moore neighborhood)
  commonsResources    ;; the sum of the resources on all of the patches in an agent's Moore neighborhood
  total-defense-cost  ;; cost of defending patch from those who are not in your property rights norm
  ]



patches-own [       ; -----------------------------------------------
  patchResource        ;; the amount of resource on a patch
  owner-property-norm  ;; the propertyNorm of the turtle sitting on that patch
  owner-group          ;; the group marker of the turtle here
  ]




;###################################################################################################
;################################ SET UP WORLD AND VARIABLES #######################################
;###################################################################################################

to setup ;[ group-config ]
  ca
  ;random-seed 1234567890  ;; must be commented off during Batch runs
  setup-treatment
  setup-globals 
  setup-patches 
  setup-agents initial-organization
  update-agent-look  
  reset-ticks
end

;---------------------------------------------------------


to setup-treatment 
; This procedure initializes globals based on three treatment variables: (1) group-markers (2) Property and (3) Production
  
  ifelse Property 
  [  set propertyNorms ["private" "group" "open"] ]    ; ["private" "group" "open"]
  [  set propertyNorms ["open" "open" "open"] ]   
  
  ifelse Production 
  [  set productionNorms   ["noone" "group" "anyone"] ]    ; ["noone" "group" "anyone"]
  [  set productionNorms   ["noone" "noone" "noone"] ]   
  
  
; Harvesting traits are always allowed to be imitated
  set harvestTraits ["low" "high"]  
  

  ifelse group-markers = true        ;--------------------------------- MARKERS ------------------------------------------
  [  
    set markerTraits [ yellow red blue gray pink violet lime cyan orange ]   ; [ yellow red blue gray pink violet lime cyan orange ]
    set imitateMarker? true
    set mutateMarker true
  ]
  [
    set markerTraits [ yellow yellow yellow yellow yellow yellow yellow yellow yellow ]   ; [ yellow red blue gray pink violet lime cyan orange ]
    set imitateMarker? false
    set mutateMarker false
  ]
        
end
;---------------------------------------------------------

to setbenchmark
  set r 0.5
  set K 200
  set refuge-level 3
  set init_n_groups 12 ; length (markerTraits) ;12
  set init_group_size 12
  
  set imitateProb 5
  set mutationRate 0.3
  set imitateRadius 2
  set migrateProb 0
  set imitateTreatment "anyone"
  set imitateBias "payoff"
  
  set HarvestGap 1              ;; Hh – Hl = HarvestGap*MSY, the proportion of MSY by which high harvesting amount exceeds low harvest amount
  set HoldingCap 1000000
  set givePerc 0.5
  set publicGoodsTheta 1.5
  set marginal_defense_cost 1
  set costOfLivingMSYRatio .2   ;; to ensure that lowHarvest > costOfLiving, THIS MUST BE LESS THAN (1 - (HarvestGap / 2))
end


to setup-globals  ;; sets up all of the REMAINING globals (mostly those that don't change between treatments)
  set K 200
  set refuge-level 3
  set init_n_groups length (markerTraits)
  set init_group_size 12

  set imitateTreatment "anyone"
  set imitateBias "payoff"
    
  set MSY floor ( ( K * r ) / 4 )  ;; set maximum sustainable yield = half of carrying capacity
  set highHarvest floor (( 1 + ( HarvestGap / 2)) * MSY) ;; currently this amounts to 1.5*MSY
  set lowHarvest  floor (( 1 - ( HarvestGap / 2 )) * MSY) ;; and .5*MSY
  set costOfLiving floor ( costOfLivingMSYRatio * MSY )
  set costOfBaby floor ( 2 * ( highHarvest - costOfLiving )) ;; Explanation: 2 = timesteps to Reproduce for high harvesters IF no cooperation.
end
;---------------------------------------------------------




to setup-patches  
  ask patches [ set patchResource random K ]
  ;ask patches [ set patch-r precision (random-float r) 2 ]
  ask patches [ set pcolor white ]
  ask patches [ set owner-property-norm "open" ] 
  ask patches [ set owner-group "nil" ]
  update-patch-color
end
;---------------------------------------------------------




to setup-agents [ organization2 ]  
; initialize group structure, options include:
; (currently low harvesting is fixed at 100%)
;  "trait-combo-groups" ; --> homogneous groups, one for each trait combination
;  "random-groups"      ; --> homogenous groups, of random trait combinations
;  "random-individuals" ; --> mixed groups, with random individual trait cominations in each
;  "random-prop-indivs" ; --> mixed groups, with random individual trait cominations in each, with the global proportion of each trait type matching "trait-combo-groups"

 if organization2 = "trait-combo-groups" [      ; --> make one group for each trait combination
   let grps (length (productionNorms) * length (propertyNorms) )
   
   foreach productionNorms
     [ let s ?
       foreach propertyNorms
         [ let p ?
           
           ask one-of patches [ sprout 1   ; sprout group-starters, set their types
             [ set share s 
               set propertyNorm p 
               set color item who markerTraits
             ]
           ]          
         ]
     ]
   
   ask turtles [                                  ; ask each SEED turtle to
     hatch (init_group_size - 1) [                ; and hatch the rest of their groups (copying their characteristics)
       move-to min-one-of patches with [not any? turtles-here] [distance myself] ]   ; and have them cluster in space
   ]   
 ]
 
 
 if organization2 = "random-groups" [
   ask n-of init_n_groups patches [ sprout 1 ]  ; sprout a few turtles as group-starters, the will have the numbers 0 to init_n_groups
   
   ask turtles [                            ; ask each SEED turtle to
     ;set harvestPref one-of harvestTraits
     set share one-of productionNorms       ; randomize traits 
     set propertyNorm one-of propertyNorms 
     
     set color item who markerTraits        ; set their colors to a color from the markerTraits list
     hatch (init_group_size - 1) [                ; and hatch the rest of their groups  
       move-to min-one-of patches with [not any? turtles-here] [distance myself] ]   ; and have them cluster in space
   ]  
 ]
 
  
 
 if organization2 = "random-individuals" [
   ask n-of init_n_groups patches [ sprout 1 ]  ; sprout a few turtles as group-starters, they will have the numbers 0 to init_n_groups
   
   ask turtles [                            ; ask each SEED turtle to:
     set color item who markerTraits        ; 1 - set their colors to a color from the markerTraits list,
     hatch (init_group_size - 1) [          ; 1 - hatch the rest of their groups,  
       move-to min-one-of patches with [not any? turtles-here] [distance myself] ]   ; and have them cluster in space.
   ]
   
   ask turtles [                            ; ask ALL turtles to randomize their traits (except their markers)
     ;set harvestPref one-of harvestTraits   
     set share one-of productionNorms       ; randomize traits 
     set propertyNorm one-of propertyNorms 
   ]  
 ]
 
 
  
  if organization2 = "random-prop-indivs" [      ; --> make one group for each trait combination
   let grps (length (productionNorms) * length (propertyNorms) )
   
   foreach productionNorms
     [ let s ?
       foreach propertyNorms
         [ let p ?
           
           ask one-of patches [ sprout 1   ; sprout group-starters, set their types
             [ set share s 
               set propertyNorm p 
               set color item who markerTraits
             ]
           ]          
         ]
     ]
   
   ask turtles [                                  ; ask each SEED turtle to
     hatch (init_group_size - 1) [                ; and hatch the rest of their groups (copying their characteristics)
       move-to min-one-of patches with [not any? turtles-here] [distance myself] ]   ; and have them cluster in space
   ]
   
   ; mix individuals between groups
   ask turtles [
     let my-partner one-of turtles with [color != [color] of myself]  ; pick a partner in another group
     ;create-link-with my-partner ;(for diagnostic purposes)
     let newx [xcor] of my-partner                                    ; record partners home address
     let newy [ycor] of my-partner
     let newc [color] of my-partner                                   ; record partners group color
     ask my-partner [setxy [xcor] of myself [ycor] of myself]         ; have partner come over
     ask my-partner [set color [color] of myself]                     ; have partner copy my color
     setxy newx newy                                                  ; move to partners location
     set color newc                                                   ; copy partners color
      
     ;wait .01 
     ;ask my-links [die]
     ;set shape "circle"
   ]
      
 ]
  
  
;; set other all-turtle variables

  ask turtles [ set harvestPref "low" ]                                 ; set all to harvest low 
  ask turtles [ set agentProcessedResource random (costOfBaby + 1) ]    ; initialize agent wealth to be a random number between 0 and cost of reproduction
  
end  ; setup-agents 
;---------------------------------------------------------



to update-agent-look  ;; sets up the way the agents look on the interface
  ask turtles [  
    if harvestPref = "low" [set shape "circle"] ; face happy"]
    if harvestPref = "high" [set shape "square" ] ; face sad"]
  ]  
end  ;---------------------------------------------------------


to update-patch-color
  ifelse show-resources? [ask patches [set pcolor scale-color green patchResource (K + 20) 0]] [ask patches [ set pcolor black]]
end
;---------------------------------------------------------


;to clear-patch-property-variables ; observer procedure
;  ask patches [ set owner-property-norm "open" set owner-group "nil" ]
;end
;---------------------------------------------------------




;###################################################################################################
;########################################### GO/ACTIONS ############################################
;###################################################################################################

to go
  if not any? turtles [stop]
  
  defend-property
  harvest
  
  ask turtles [ cooperate-produce ]
  ask turtles [ pay-cost-of-living ]
  ask turtles [ expire ]
  ask turtles [ reproduce ]
  ask turtles [ migrate ]
  ask turtles [ imitate ]
  ask patches [ regrow ]
  ask turtles [ set age ( age + 1 ) ]
  ask turtles [ cap-resources ]
  
;update  
  update-patch-color
  update-agent-look
  
;data collection
  data-collection
  tick
end
;---------------------------------------------------------



to cap-resources ; turtle procedure
  if agentRawResource > HoldingCap [ set agentRawResource HoldingCap ]  ;; should this be moved before paying cost of living and reproduction???
  if agentProcessedResource > HoldingCap [ set agentProcessedResource HoldingCap ]
end
;---------------------------------------------------------



to harvest
  ;; agents harvest their preferred amount from any (or all) of the patches in their Moore neighborhood
  ask turtles [
    
    set myHarvest 0
    
    if harvestPref = "low" [set harvestAmt lowHarvest]
    if harvestPref = "high" [set harvestAmt highHarvest]
      
      ; define the patches withing the local Moore neighborhood on which the current agent may harvest.
      set myCommons (patch-set neighbors patch-here) ;; set list of patches to harvest from to include all neighboring patches
      set myCommons myCommons with [(owner-property-norm = "group" and owner-group = [color] of myself) or owner-property-norm = "open"] ;; remove the patches with owner-property-norm = group when owner-group != my group
      set myCommons (patch-set myCommons patch-here) ;; add back my own patch
      
      if not member? patch-here myCommons [print (list agentRawResource agentProcessedResource" no" )]
      
      ; this procedure should always have at least patch-here remaining in myCommons after removing the others.
      
      set commonsResources sum ([patchResource] of myCommons)  ;; sums all of the resources in my commons
      let commonsList sort-on [patchResource] myCommons  ;; sort the list by the amount of resource on the patch
      set commonsList reverse commonsList  ;; reverse the sort list so it is largest to smallest
    
      ifelse commonsResources < harvestAmt  ;; if the total commons are less than what the agent wants to harvest
      [ set agentRawResource floor ( agentRawResource + commonsResources )
        ask myCommons [ set patchResource 0 ]  ;; take everything from the commons 
      ]
    
      [ 
        while [myHarvest < harvestAmt][  ;; while you are still in need
        ;; harvest some resource from the neighborhood
          foreach commonsList [
            ifelse [patchResource] of ? <= (harvestAmt - myHarvest) 
              [set myHarvest (myHarvest + [patchResource] of ?)
               ask ? [set patchResource 0]
              ]
            
              [ask ? [
                set patchResource (patchResource - ([harvestAmt] of myself - [myHarvest] of myself))
              ]
                set myHarvest harvestAmt
              ]
          ]  ;; end foreach
        ]  ;; end while
        set agentRawResource floor (agentRawResource + harvestAmt)
      ] ;; end second part of ifelse commonsResources
  ]
end
;---------------------------------------------------------



to cooperate-produce ; turtle procedure
  ;Two improvements could be made here: 
  ; (1) They should not choose a random neighbor, but choose a partner that matches their criteria, amongst their neighbors (makes production stronger), and 
  ; (2) Both agents should only contribute the amount that the poorer agent can afford. (makes production less generous to poor, less strong of a force).
  
    if any? (turtles-on neighbors) [  ;; if there is anyone in your neighborhood
      ask one-of ( turtles-on neighbors ) [  ;; ask someone in your neighborhood
        let myGive 0  ;; initialize a local variable that will hold the amount of resource you give to the dyadic public goods game
        let yourGive 0  ;; initialize a local variable that will hold the amount of resource your partner will give to the dyadic public goods game
            
        let sameGroup? false  ;; initialize a local variable to mark whether or not you and your partner have the same visible group marker
        if color = [color] of myself [ set sameGroup? true ]  ;; if the other agent has the same visible marker as me set the sameGroup? variable to true
        
        let myshare_boolean false  ;; initialize a local variable to keep track of whether or not I am going to give some amount to the public goods game
        ;; set the myshare_boolean to be true if my share trait is group and me and my partner are in the same group OR if my share trait is anyone
        set myshare_boolean (([share] of myself = "group" and sameGroup? = true) or [share] of myself = "anyone")   
        
        let yourshare_boolean false  ;; initialize a local variable to keep track of whether or not my partner is going to give some amount to the public goods game
        ;; set the yourshare_boolean to be true if my partner's share trait is group and me and my partner are in the same group OR if my partner's share trait is anyone
        set yourshare_boolean ((share = "group" and sameGroup? = true) or share = "anyone")
        
        if myshare_boolean [
          if ([agentProcessedResource] of myself + [agentRawResource] of myself) >= costOfLiving [  ;; if I have more than enough to pay cost of living
            ;; if I have enough to give the full ratio of raw goods to the pot
            ifelse ([agentProcessedResource] of myself) + (( 1 - givePerc ) * [agentRawResource] of myself) >= costOfLiving  
              [ set myGive floor (givePerc * [agentRawResource] of myself) ]  ;;give the full amount to the pot
               ;; otherwise, give as much to the pot as I can while still being able to afford the cost of living
              [ set myGive floor ([agentProcessedResource] of myself + [agentRawResource] of myself - costOfLiving) ] 
          ]
        ]
        
        if yourshare_boolean [
          if (agentProcessedResource + agentRawResource) >= costOfLiving [  ;; if my partner has more than enough to pay cost of living
            ;; if I have enough to give the full ratio of raw goods to the pot
            ifelse (agentProcessedResource + (( 1 - givePerc) * agentRawResource)) >= costOfLiving
              [ set yourGive floor (( givePerc * agentRawResource )) ] ;; give the full amount to the pot
                ;; otherwise, give as much to the pot as I can while still being able to afford the cost of living
              [ set yourGive floor ( agentProcessedResource + agentRawResource - costOfLiving ) ]
          ]
      ]
        
        let publicGoodsPayoff 0  ;; initialize a local variable to hold the value of the payoff received from the public goods game
        
        ;; the total amount of value produced from cooperation = the sum of the two players' contribution multiplied by the publicGoodsTheta (set at 1.5)
        ;; this means that the individual benefit from the public goods game is the total / 2
        set publicGoodsPayoff floor ( ( publicGoodsTheta * ( myGive + yourGive ) ) / 2 )
        
        ;; recalculate your partner's resource amounts
        set agentRawResource ( agentRawResource - yourGive )  ;; subtract your partner's contribution amount from their raw resources
        set agentProcessedResource ( agentProcessedResource + publicGoodsPayoff )  ;; add your partner's payoff from the public goods game to their processed resources
        
        ask myself [ 
          set agentRawResource floor ( agentRawResource - myGive )  ;; subtract your contribution amount from their raw resources
          set agentProcessedResource ( agentProcessedResource + publicGoodsPayoff )  ;; add your payoff from the public goods games to your processed resources
          ] 
      ]
    ]
end
;---------------------------------------------------------


to pay-cost-of-living ; turtle procedure
    ifelse agentProcessedResource >= costOfLiving ;; if you have more than enough resource just from your processed resource bucket
    [ set agentProcessedResource ( agentProcessedResource - costOfLiving ) ]  ;; pay cost of living from your processed resources only
    
    [ set agentRawResource (agentRawResource - (costOfLiving - agentProcessedResource))
      set agentProcessedResource 0
    ]
end
;---------------------------------------------------------



to expire
  if (agentRawResource + agentProcessedResource) < 0 [die]
  if random-float 1.0 <  (1 / (1 + e ^ (10 - (age / 8))) ) [die]
end
;---------------------------------------------------------


to regrow-new  ;patch procedure

;#### COLONIZATION - if patches are at zero, how to they rebound?
  if patchResource <= 1 [
    ; type 1 - forest has a permanent refuge level
;    set patchResource refuge-level  
    
    ; type 2 - probabilistic recolonization
;    let colonization-probability (count neighbors with patchResource > resource-refuge-level ) / 8
;    if random 100 <= colonization-probability [set patchResource refuge-level  ] 
    
    ; type 3 - biomass-based probabilistic recolonization
;    let colonizing-biomass sum [patchResource] of neighbors
;    let colonization-probability min list 1 colonizing-biomass / ( 8 * K / 4 )  ; 100% chance of colonication at one quarter maximum biomass
;    if random 100 <= colonization-probability [set patchResource refuge-level  ] 
    
    ; type 4 - older growth dynamics
    if regen_rate * random 1000 <= 1 [set patchResource refuge-level  ]
  ]

;##### REGROWTH - Patches grow following the logistic growth function, once colonization is done.
  if patchResource > 0 [  set patchResource  ceiling (patchResource + ((r * patchResource) * (1 - (patchResource / K))))  ]
end
;---------------------------------------------------------


to regrow  ;patch procedure
  ;allows resources on the patches to regrow according to a logistic growth function
    ifelse patchResource > 0 [
      set patchResource  ceiling (patchResource + ((r * patchResource) * (1 - (patchResource / K)))) 
    ]

      [
        ;; allows a small chance of regrowth on empty patches (could change this to happen only if there are neighboring patches with resource to simulate seeding)
        if random 1000 <= 1 [set patchResource 3]
  ]
end
;---------------------------------------------------------



to migrate ; turtles
    if random 100 < migrateProb [
      if any? neighbors with [not any? turtles-here] [
        let emptyNeighbors patch-set neighbors with [not any? turtles-here]
        move-to max-one-of emptyNeighbors [patchResource]
      ]
    ]
end

; a comparison with own patch resources should be made first!

;---------------------------------------------------------




to imitate  ; turtle procedure
    set copy-target -1
    if random 100 < imitateProb [
      if imitateTreatment = "anyone" [
        let turtlesInRadius turtles in-radius imitateRadius
        if turtlesInRadius != [] [
          if imitateBias = "payoff" [ set copy-target [who] of (max-one-of turtlesInRadius [agentRawResource + agentProcessedResource]) ] ;; payoff biased imitation
          if imitateBias = "green" [ if any? turtlesInRadius with [harvestPref = "low"] [
              set copy-target [who] of one-of turtlesInRadius with [harvestPref = "low"] ]
          ] ;; conspicuous conservation imitation
          if imitateBias = "random" [ set copy-target [who] of one-of turtlesInRadius ] ;; random imitation
        ]
      ]  ;; end imitateTreatment = anyone
        
      if imitateTreatment = "group" [
        let turtlesInRadius turtles in-radius imitateRadius with [color = [color] of myself]
        if turtlesInRadius != [] [
          if imitateBias = "payoff" [ set copy-target [who] of (max-one-of turtlesInRadius [agentRawResource + agentProcessedResource]) ] ;; payoff biased imitation
          if imitateBias = "green" [ set copy-target [who] of one-of turtlesInRadius with [harvestPref = "low"] ] ;; conspicuous conservation imitation
          if imitateBias = "random" [ set copy-target [who] of one-of turtlesInRadius ] ;; random imitation
          ]
        ]  ;; end imitateTreatment = group
    
      if copy-target != -1 [
          set harvestPref [harvestPref] of turtle copy-target
      
        if Production [
          set share [share] of turtle copy-target
          ]
        
        if Property [
          set propertyNorm [propertyNorm] of turtle copy-target
          ]
        
        if imitateMarker? [
          set color [color] of turtle copy-target
          ]
      ]
    ]  ;; end imitateProb
end
;---------------------------------------------------------




to reproduce   ; turtles
  ;; birth turtles to agents who have greater than the reproduction threshold
    if (agentRawResource + agentProcessedResource) >= costOfBaby [
      if any? neighbors with [not any? turtles-here] [
        
        hatch 1 [ move-to one-of neighbors with [not any? turtles-here]
          set agentRawResource 0
          set agentProcessedResource 0
          set age 0
          if random 100 < mutationRate [
            set share one-of productionNorms
          ]  
          if random 100 < mutationRate [
            set harvestPref one-of harvestTraits
          ]
          if random 100 < mutationRate [
            set propertyNorm one-of propertyNorms
          ]
          if random 100 < mutationRate [
            if mutateMarker [
            set color one-of markerTraits
            ]
          ]
          
        ]
        ifelse agentProcessedResource >= costOfBaby 
          [ set agentProcessedResource ( agentProcessedResource - costOfBaby ) ]  ;; pay for the baby using only processed resources if you have enough
          [ set agentRawResource ( agentRawResource - ( costOfBaby - agentProcessedResource ) )  ;; otherwise, use up your processed resources and then dig into your raw resources
            set agentProcessedResource 0 ]
        
        set rs rs + 1
      ] 
    ]  
end
;---------------------------------------------------------




to defend-property                     ; observer procedure
  let NeighborsToExclude 0
  
  ; (step 1) clear last rounds property rights
  ask patches [ 
    set owner-property-norm "open"  ;; I like open instead of nil
    set owner-group "nil" ]  
  
  ; (step 2) have calculate the number of neighbors who the focal turtle will forbid access to their patch, 
  ; and the cost to exluding them.
  ask turtles [
    if propertyNorm = "anyone" [ set NeighborsToExclude 0] ; I will allow anyone on my patch to harvest because there is no cost to defense
    
    if propertyNorm = "private" [ set NeighborsToExclude count turtles-on neighbors ] ;; I want exclusive harvesting rights to my patch
    
    if propertyNorm = "group" [                              ;; I want to allow group members to have harvesting rights on my patch
      set NeighborsToExclude count (turtles-on neighbors) with [color != [color] of myself] 
      ]
    
      set total-defense-cost marginal_defense_cost * NeighborsToExclude
  ]
  
  ; (step 3) Have turtles pay the cost of defense to meet their property norm
  ; If they cannot pay to defend their property, their property is not marked.  If they can pay,
  ; then they mark their property accordingly.
  
  ask turtles [
    if propertyNorm != "open" [ ;; pay to defend only if so desired. 
      if total-defense-cost < patchResource  [ ;; turtles should not invest more to defend their patch then the patch has resources for harvest
        
        if total-defense-cost <= (agentProcessedResource + agentRawResource) [  ;; if you have enough to pay, then
          ifelse agentProcessedResource >= total-defense-cost ;; if you have enough to pay just from your processed resource bucket, then
          [ set agentProcessedResource ( agentProcessedResource - total-defense-cost ) ]  ;; pay for defense from your processed resources only
          [ set agentRawResource (agentRawResource - (total-defense-cost - agentProcessedResource))  ;; otherwise empty processed resource and pay remainder with raw resources
            set agentProcessedResource 0
          ]
          
          ; and finally mark the territory according to the group norm
          set owner-property-norm propertyNorm set owner-group color
        ]
      ]
    ]
  ]
end
;---------------------------------------------------------
  
  
  
  
  
  
  

;###################################################################################################
;####################################### DATA COLLECTION ###########################################
;###################################################################################################
  
  
to data-collection  ; observer  -  calculate trait frequencies 
;  freq_low            ; sustainable harvesting behavior
;  freq_coop_group    ; cooperate with group only
;  freq_coop_any      ; cooperate with all
;  freq_prop_group     ; defend property against all but my group
;  freq_prop_private   ; defend property against all
;  freq_prop_open
;  freq_coop_noone
  
  carefully [set freq_low count turtles with [harvestPref = "low"] / count turtles] [set freq_low 0]
  
  carefully [set freq_coop_group count turtles with [share = "group"] / count turtles] [set freq_coop_group 0]
  carefully [set freq_coop_any count turtles with [share = "anyone"] / count turtles] [set freq_coop_any 0]  
  set freq_coop_noone 1 - freq_coop_group - freq_coop_any
  
  carefully [set freq_prop_group count turtles with [propertyNorm = "group"] / count turtles] [set freq_prop_group 0]
  carefully [set freq_prop_private count turtles with [propertyNorm = "private"] / count turtles] [set freq_prop_private 0]  
  set freq_prop_open 1 - freq_prop_group - freq_prop_private
  
; trait combination variables are abbreviations for trait types
  ; hl, hh represent harvestPref (low, high)
  ; cn, cg, ca represent share (Sharing) ["noone" "group" "anyone"]
  ; pp, pg, po represent propertyNorm (Defense) ["private" "group" "open"]

  set hl_cg_po count turtles with [harvestPref = "low" and share = "group" and propertyNorm = "open"] 
  set hl_cg_pg count turtles with [harvestPref = "low" and share = "group" and propertyNorm = "group"] 
  set hl_cg_pp count turtles with [harvestPref = "low" and share = "group" and propertyNorm = "private"] 
  
  set hl_cn_po count turtles with [harvestPref = "low" and share = "noone" and propertyNorm = "open"] 
  set hl_cn_pg count turtles with [harvestPref = "low" and share = "noone" and propertyNorm = "group"] 
  set hl_cn_pp count turtles with [harvestPref = "low" and share = "noone" and propertyNorm = "private"] 
  
  set hl_ca_po count turtles with [harvestPref = "low" and share = "anyone" and propertyNorm = "open"] 
  set hl_ca_pg count turtles with [harvestPref = "low" and share = "anyone" and propertyNorm = "group"] 
  set hl_ca_pp count turtles with [harvestPref = "low" and share = "anyone" and propertyNorm = "private"] 
  
  
  set hh_cg_po count turtles with [harvestPref = "high" and share = "group" and propertyNorm = "open"] 
  set hh_cg_pg count turtles with [harvestPref = "high" and share = "group" and propertyNorm = "group"] 
  set hh_cg_pp count turtles with [harvestPref = "high" and share = "group" and propertyNorm = "private"] 
  
  set hh_cn_po count turtles with [harvestPref = "high" and share = "noone" and propertyNorm = "open"] 
  set hh_cn_pg count turtles with [harvestPref = "high" and share = "noone" and propertyNorm = "group"] 
  set hh_cn_pp count turtles with [harvestPref = "high" and share = "noone" and propertyNorm = "private"] 
  
  set hh_ca_po count turtles with [harvestPref = "high" and share = "anyone" and propertyNorm = "open"] 
  set hh_ca_pg count turtles with [harvestPref = "high" and share = "anyone" and propertyNorm = "group"] 
  set hh_ca_pp count turtles with [harvestPref = "high" and share = "anyone" and propertyNorm = "private"] 
  
  

; record strength of group selection on traits
  set gs_harv_l price-btw-harv  "low" / 1024       ; harvest
  
  set gs_prop_p price-btw-prop  "private" / 1024    ; property
  set gs_prop_g price-btw-prop  "group" / 1024      ; property
  set gs_prop_o price-btw-prop  "open" / 1024       ; property
  
  set gs_coop_a price-btw-coop  "anyone" / 1024       ; production
  set gs_coop_g price-btw-coop  "group" / 1024        ; production
  set gs_coop_n price-btw-coop  "noone" / 1024        ; production
  
  set groups count-marked-groups 
  
  
; record strength of individual selection on traits
  set is_harv_l price-win-harvest  "low"     ; harvest
  
  set is_prop_p price-win-prop  "private"    ; property
  set is_prop_g price-win-prop  "group"      ; property
  set is_prop_o price-win-prop  "open"       ; property
  
  set is_coop_a price-win-coop  "anyone"       ; production
  set is_coop_g price-win-coop  "group"        ; production
  set is_coop_n price-win-coop  "noone"        ; production
  
  
; record total world resources
  set resource sum [patchresource] of patches / (K * count patches)
  
end  
;---------------------------------------------------------


  
  

;###################################################################################################
;########################################### UTILITIES #############################################
;###################################################################################################
  
to-report count-marked-groups
 let x [color] of turtles
 set x remove-duplicates x
 report length x
end
;---------------------------------------------------------


to-report compute-pop-variance [values]
  let average mean values
  let n length values
  let pos 0
  let varstep1 0
  repeat n
  [
    set varstep1 varstep1 + (item pos values - average) ^ 2
    set pos pos + 1
  ]
  report varstep1 / n ;change to (n - 1) for sample var.
end
;---------------------------------------------------------


to-report compute-pop-covariance [values-x values-y]
  let average-x mean values-x
  let average-y mean values-y
  let n length values-x
  let pos 0
  let covarstep1 0
  repeat n
  [ set covarstep1 covarstep1 + (item pos values-x - average-x) * (item pos
      values-y - average-y)
    set pos pos + 1 ]
  report covarstep1 / n
end
;---------------------------------------------------------


to-report correlation [values-x values-y]
  carefully [if variance values-x = 0 or variance values-y = 0
    [report 1.1]] [report 1.1]
  report (compute-pop-covariance values-x values-y) / (sqrt (variance
    values-x) * sqrt (variance values-y))
end
;---------------------------------------------------------







to-report price-btw-harv [ TRAIT ]  ;  any one of ["private" "group" "open"] (just doing property first, to test)...    
; calculate between group covariance
; calculate mean frequency (of TRAIT) by group
  let gfreqs (list)
  foreach markerTraits 
    [ 
      let groupfreq 0
      carefully 
      [ set groupfreq count turtles with [color = ? and harvestPref = TRAIT] / count turtles with [color = ?] ] 
      [ set groupfreq 0 ] 
      set gfreqs lput groupfreq gfreqs 
    ]
  
; calculate total group fitness
  let gfits (list)
  foreach markerTraits 
    [ 
      let groupfit 0
      carefully
      [ set groupfit sum [rs] of turtles with [color = ?] ] 
      [ set groupfit 0 ] 
      set gfits lput groupfit gfits
    ]
  

; calculate covariance of mean group fitness and group frequencies (between-group selection) 
; using two lists in the same order (the order of markerTraits)
  let cov_wglg_temp compute-pop-covariance gfits gfreqs
  report cov_wglg_temp
end
;---------------------------------------------------------








to-report price-btw-prop [ TRAIT ]  ;  any one of ["private" "group" "open"] (just doing property first, to test)...    
; calculate between group covariance
; calculate mean frequency (of TRAIT) by group
  let gfreqs (list)
  foreach markerTraits 
    [ 
      let groupfreq 0
      carefully 
      [ set groupfreq count turtles with [color = ? and propertyNorm = TRAIT] / count turtles with [color = ?] ] 
      [ set groupfreq 0 ] 
      set gfreqs lput groupfreq gfreqs 
    ]
  
; calculate total group fitness
  let gfits (list)
  foreach markerTraits 
    [ 
      let groupfit 0
      carefully
      [ set groupfit sum [rs] of turtles with [color = ?] ] 
      [ set groupfit 0 ] 
      set gfits lput groupfit gfits
    ]
  
; calculate covariance of mean group fitness and group frequencies (between-group selection) 
; using two lists in the same order (the order of markerTraits)
  let cov_wglg_temp compute-pop-covariance gfits gfreqs
  report cov_wglg_temp
end
;---------------------------------------------------------




to-report price-btw-coop [ TRAIT ]  ;  any one of ["private" "group" "open"]    
; collect a list of frequency (of TRAIT) by group
  let gfreqs (list)
  foreach markerTraits 
    [ 
      let groupfreq 0
      carefully 
      [ set groupfreq count turtles with [color = ? and share = TRAIT] / count turtles with [color = ?] ] 
      [ set groupfreq 0 ] 
      set gfreqs lput groupfreq gfreqs 
    ]
  
; collect a list of mean fitness by group
  let gfits (list)
  foreach markerTraits 
    [ 
      let groupfit 0
      carefully
      [ set groupfit sum [rs] of turtles with [color = ?] ] 
      [ set groupfit 0 ] 
      set gfits lput groupfit gfits
    ]
  
; calculate covariance of mean group fitness and group frequencies (between-group selection) 
; using two lists in the same order (the order of markerTraits)
  let cov_wglg_temp compute-pop-covariance gfits gfreqs
  report cov_wglg_temp
end
;---------------------------------------------------------





  
to-report price-win-prop [ TRAIT ] ; observer
; COMPUTE: (average) within group covariances
  let cov_wiglig (list)
  foreach markerTraits 
    [ 
      let cwl_g 0
      if any? turtles with [color = ?]
      [
        let current_group_list sort-on [who] turtles with [color = ?] ; ordered list of agents.. so the two lists are in the same order for cov. calc.
        
; collect individual traits (itraits) within current_group
        let itraits (list)
        foreach current_group_list  [ set itraits lput [propertyNorm] of ? itraits ]
        let binarize task [ ifelse-value (? = TRAIT) [1][0] ] 
        set itraits map binarize itraits                                      
        
; collect individual current cumulative fitnesses within current_group
        let ifits (list)
        foreach current_group_list  [ set ifits lput [rs] of ? ifits ]
        
; calculate covariance of individual fitness and trait for current group (within-group selection) with two lists in the same order (who) 
        ;print (list "ifits: " ifits)     
        ;print (list "ifreqs: " ifreqs)
        set cwl_g compute-pop-covariance ifits itraits
      ]
        set cov_wiglig lput cwl_g cov_wiglig 
    ]

; calculate covariance of individual fitness and trait for current group (within-group selection)
  let e_cov_wiglig mean cov_wiglig 
  report e_cov_wiglig
end
;---------------------------------------------------------
  
  
  


  
to-report price-win-coop [ TRAIT ] ; observer
; COMPUTE: (average) within group covariances
  let cov_wiglig (list)
  foreach markerTraits 
    [ 
      let cwl_g 0
      if any? turtles with [color = ?]
      [
        let current_group_list sort-on [who] turtles with [color = ?] ; ordered list of agents.. so the two lists are in the same order for cov. calc.
        
; collect individual traits (itraits) within current_group
        let itraits (list)
        foreach current_group_list  [ set itraits lput [share] of ? itraits ]
        let binarize task [ ifelse-value (? = TRAIT) [1][0] ] 
        set itraits map binarize itraits                                      
        
; collect individual current cumulative fitnesses within current_group
        let ifits (list)
        foreach current_group_list  [ set ifits lput [rs] of ? ifits ]
        
; calculate covariance of individual fitness and trait for current group (within-group selection) with two lists in the same order (who) 
        ;print (list "ifits: " ifits)     
        ;print (list "ifreqs: " ifreqs)
        set cwl_g compute-pop-covariance ifits itraits
      ]
        set cov_wiglig lput cwl_g cov_wiglig 
    ]

; calculate covariance of individual fitness and trait for current group (within-group selection)
  let e_cov_wiglig mean cov_wiglig 
  report e_cov_wiglig
end
;---------------------------------------------------------
  
  
  


to-report price-win-harvest [ TRAIT ] ; observer
; COMPUTE: (average) within group covariances
  let cov_wiglig (list)
  foreach markerTraits 
    [ 
      let cwl_g 0
      if any? turtles with [color = ?]
      [
        let current_group_list sort-on [who] turtles with [color = ?] ; ordered list of agents.. so the two lists are in the same order for cov. calc.
        
; collect individual traits (itraits) within current_group
        let itraits (list)
        foreach current_group_list  [ set itraits lput [HarvestPref] of ? itraits ]
        let binarize task [ ifelse-value (? = TRAIT ) [1][0] ] 
        set itraits map binarize itraits                                      
        
; collect individual current cumulative fitnesses within current_group
        let ifits (list)
        foreach current_group_list  [ set ifits lput [rs] of ? ifits ]
        
; calculate covariance of individual fitness and trait for current group (within-group selection) with two lists in the same order (who) 
        ;print (list "ifits: " ifits)     
        ;print (list "ifreqs: " ifreqs)
        set cwl_g compute-pop-covariance ifits itraits
      ]
        set cov_wiglig lput cwl_g cov_wiglig 
    ]

; calculate covariance of individual fitness and trait for current group (within-group selection)
  let e_cov_wiglig mean cov_wiglig 
  report e_cov_wiglig
end
;---------------------------------------------------------
@#$#@#$#@
GRAPHICS-WINDOW
211
40
686
536
-1
-1
14.5313
1
10
1
1
1
0
1
1
1
-16
15
-16
15
1
1
1
ticks
24.0

BUTTON
55
276
149
309
Step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
55
308
149
341
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
15
10
524
35
Group Selection in Social-Ecological Systems
20
0.0
1

SWITCH
28
357
180
390
show-resources?
show-resources?
1
1
-1000

PLOT
690
10
1236
160
Population, Resources, Groups
NIL
NIL
0.0
200.0
0.0
1.0
true
true
"" ""
PENS
"groups/init" 1.0 0 -16777216 true "" "plot count-marked-groups / init_n_groups"
"resources" 1.0 0 -10899396 true "" "plot sum [patchresource] of patches / (K * count patches)"
"population" 1.0 0 -4539718 true "" "plot count turtles / count patches"
"low-harvest" 1.0 0 -13345367 true "" "carefully [ plot count turtles with [harvestPref = \"low\"] / count turtles ] [plot 0]"

PLOT
690
313
1237
463
Frequency of Cooperative Production Norms
NIL
NIL
0.0
200.0
0.0
1.0
true
true
"" ""
PENS
"group" 1.0 0 -13345367 true "" "carefully [ plot count turtles with [share = \"group\"] / count turtles ] [plot 0]"
"no one" 1.0 0 -7500403 true "" "carefully [ plot count turtles with [share = \"noone\"] / count turtles ] [plot 0]"

PLOT
690
162
1237
312
Frequency of Property Rights Norms
NIL
NIL
0.0
200.0
0.0
1.0
true
true
"" ""
PENS
"group" 1.0 0 -13345367 true "" "carefully [ plot count turtles with [propertyNorm = \"group\"] / count turtles ] [plot 0]"
"private" 1.0 0 -7500403 true "" "carefully [ plot count turtles with [propertyNorm = \"private\"] / count turtles ] [plot 0]"

PLOT
193
540
684
690
Property-Fitness Covariance
NIL
NIL
0.0
200.0
0.0
1.0
true
true
"" ""
PENS
"group-btw" 1.0 0 -13840069 true "" "plot gs_prop_g"
"private-btw" 1.0 0 -2674135 true "" "plot gs_prop_p"
"zero" 1.0 0 -7500403 true "" "plot 0"
"group-win" 1.0 0 -15575016 true "" "plot is_prop_g"
"private-win" 1.0 0 -10873583 true "" "plot is_prop_p"

PLOT
193
692
684
842
Production-Fitness Covariance
NIL
NIL
0.0
200.0
0.0
1.0
true
true
"" ""
PENS
"zero" 1.0 0 -9276814 true "" "plot 0"
"group" 1.0 0 -8630108 true "" "plot gs_coop_g"
"individual" 1.0 0 -955883 true "" "plot is_coop_g"

SWITCH
18
143
187
176
group-markers
group-markers
0
1
-1000

SWITCH
18
77
187
110
Property
Property
0
1
-1000

SWITCH
18
110
187
143
Production
Production
0
1
-1000

TEXTBOX
21
57
171
75
Treatment Variables
13
15.0
1

PLOT
691
465
1237
615
Selection for sustainable harvesting
NIL
NIL
0.0
200.0
0.0
1.0
true
true
"" ""
PENS
"zero" 1.0 0 -5987164 true "" "plot 0"
"within" 1.0 0 -2674135 true "" "plot is_harv_l"
"between" 1.0 0 -13791810 true "" "plot gs_harv_l"

SLIDER
694
624
866
657
r
r
0
1
0.5
.1
1
NIL
HORIZONTAL

SLIDER
694
657
866
690
HarvestGap
HarvestGap
0
2
1
0.1
1
NIL
HORIZONTAL

SLIDER
695
691
866
724
costOfLivingMSYRatio
costOfLivingMSYRatio
0
1
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
696
823
868
856
publicGoodsTheta
publicGoodsTheta
1
3
1.5
0.1
1
NIL
HORIZONTAL

SLIDER
696
724
868
757
HoldingCap
HoldingCap
0
1000000
1000000
1000
1
NIL
HORIZONTAL

SLIDER
696
757
868
790
givePerc
givePerc
0
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
695
790
869
823
marginal_defense_cost
marginal_defense_cost
0
10
1
1
1
NIL
HORIZONTAL

SLIDER
696
955
868
988
migrateProb
migrateProb
0
100
0
0.1
1
NIL
HORIZONTAL

SLIDER
696
856
868
889
imitateProb
imitateProb
0
100
5
1
1
NIL
HORIZONTAL

SLIDER
696
889
868
922
imitateRadius
imitateRadius
1
20
2
1
1
NIL
HORIZONTAL

SLIDER
696
922
868
955
mutationRate
mutationRate
0
100
0.3
0.1
1
NIL
HORIZONTAL

BUTTON
888
622
1082
655
Set Benchmark Parameters
setbenchmark
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
18
180
196
225
initial-organization
initial-organization
"trait-combo-groups" "random-groups" "random-individuals" "random-prop-indivs"
0

BUTTON
55
244
149
277
Set Up
setup ;initial-organization
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
# Group Selection and Sustainability v1.5.65

## Documentation
This model simulates a simple society in which individuals survive and reproduce by harvesting and consuming renewable natural resources.  Individuals face fixed costs of living, CL, (every round) and cost of reproduction, CR.  Individuals cannot store an unlimited amount of harvested resources, and have a harvested resource limit, RRL. Individuals have two behavioral traits (harvesting norm, production norm).  Harvesting norms specify the individual rate of harvest, and may be either high, HH or low, HL.  Individuals may also have the opportunity to engage in a cooperative production activity that converts harvested resources into processed resources.  The production process creates a surplus so that more processed resources result than harvested resources were supplied.  However, the process of production is a cooperative activity requiring two participants, specifically a public goods mechanism in which both contributions are summed, multiplied by a factor of production, Θ > 2, and divided evenly among the two neighbors.  To meet the costs of living and reproduction, individuals use processed resources first and, if necessary, harvested resources.  Harvested resources are consumed directly without conversion, or growth because they have not undergone the cooperative processing.  

Individuals also have a group marker that signifies if they belong to a social group.  An individuals production norm interacts with their group marker to determine the types of others with whom they will join in cooperative production.  Production norms may be either no one, every one, or group.

Individuals also have a property rights norm that determines which types of neighbors they will allow to harvest on the patch that they occupy.  There are three different property rights norms; allow anyone, allow only group members, allow no one.  Each round individuals pay a cost of defense equal to the number of neighbors who do not meet the criteria to allow them access the focal individual’s resource patch.

**--> See ODD Protocol Document**

## Recent Changes (newest on top)
- (TMW Oct 26) Cleaned up code.  Removed legacy setup-agents-old procedure, and associated globals.  Fixed trait frequencies calculations. Added structure and comments throughout.  Organized GO procedure (observer scoped). Made most GO-subordinate procedures agent scoped (harvest and defend-property still remaining). Flagged turtle variables for demotion to procedure variables (if that makes things more efficient).
- (TMW May 22) remade treatment and group initialization procedure for much better batch runs, new BehaviorSpace runs set up.
- (TMW May 22) removed needless GUI
- (TMW Feb 20) fixed a bug in the REGROW procedure that allowed resources to grow forever.  Now they have a real carrying capacity, and growth really does slow down as it gets to K
- (TMW Feb 19) implemented within and between group covariance estimates
- (SHG) Change kill-agents so that when there are no more resources left in an agent's neighborhood they die.  This addresses the accumulated wealth issue because agents can't amass wealth and live off of it after they've crashed resources locally.
- (SHG) Fixed sharing so that agents don't share unless the evenly distributed resource will be greater than the costOfLiving
- (SHG) Changed code so that there are high and low harvesters with the same color at initialization.
- (TMW) Altered Pay CostOfLiving to set agentWealth no greater than 100 * CostOfLiving.  This might not be ideal, perhaps better to have them not harvest if they are already "too rich"
- (SHG) commented random-seed for BehaviorSpace implementation.
- (SHG) Fixed the share procedure so that the share_boolean variable is calculated based upon which agent is the sharing agent.
- (SHG) Added harvestCommons switch to allow switching back and forth between a commons dilemma and individual property rights.
- (TMW) added a random-seed during setup for replay ability.
- (SHG) sorted the list of commons patches so that they are sorted from highest resource to lowest (this was in the calibrate model, but hadn't made its way over to this one).  I could probably also find a way to randomize, but for now, an agent harvests from the most plentiful patch first and then works its way down the list. 

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
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="8-Treatments" repetitions="1000" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <metric>freq_coop_group</metric>
    <metric>freq_coop_any</metric>
    <metric>freq_coop_noone</metric>
    <metric>freq_prop_group</metric>
    <metric>freq_prop_private</metric>
    <metric>freq_prop_open</metric>
    <metric>hl_cg_po</metric>
    <metric>hl_cg_pg</metric>
    <metric>hl_cg_pp</metric>
    <metric>hl_cn_po</metric>
    <metric>hl_cn_pg</metric>
    <metric>hl_cn_pp</metric>
    <metric>hl_ca_po</metric>
    <metric>hl_ca_pg</metric>
    <metric>hl_ca_pp</metric>
    <metric>hh_cn_po</metric>
    <metric>hh_cn_pg</metric>
    <metric>hh_cn_pp</metric>
    <metric>hh_cg_po</metric>
    <metric>hh_cg_pg</metric>
    <metric>hh_cg_pp</metric>
    <metric>hh_ca_po</metric>
    <metric>hh_ca_pg</metric>
    <metric>hh_ca_pp</metric>
    <metric>gs_harv_l</metric>
    <metric>gs_prop_p</metric>
    <metric>gs_prop_g</metric>
    <metric>gs_prop_o</metric>
    <metric>gs_coop_a</metric>
    <metric>gs_coop_g</metric>
    <metric>gs_coop_n</metric>
    <metric>groups</metric>
    <metric>is_harv_l</metric>
    <metric>is_prop_p</metric>
    <metric>is_prop_g</metric>
    <metric>is_prop_o</metric>
    <metric>is_coop_a</metric>
    <metric>is_coop_g</metric>
    <metric>is_coop_n</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-theta" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <steppedValueSet variable="publicGoodsTheta" first="1" step="0.1" last="3"/>
  </experiment>
  <experiment name="SA-mutation" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <steppedValueSet variable="mutationRate" first="0" step="0.01" last="0.1"/>
  </experiment>
  <experiment name="SA-regen" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <steppedValueSet variable="regen_rate" first="0" step="0.05" last="0.5"/>
  </experiment>
  <experiment name="SA-costofliving" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <steppedValueSet variable="costOfLivingMSYRatio" first="0" step="0.1" last="1"/>
  </experiment>
  <experiment name="SA-givePerc" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="r">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateProb">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateRadius">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migrateProb">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HarvestGap">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HoldingCap">
      <value value="1000000"/>
    </enumeratedValueSet>
    <steppedValueSet variable="givePerc" first="0" step="0.1" last="1"/>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="marginal_defense_cost">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-imitate_radius" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="r">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateProb">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="imitateRadius" first="0" step="2" last="24"/>
    <enumeratedValueSet variable="migrateProb">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HarvestGap">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HoldingCap">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="givePerc">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="marginal_defense_cost">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RA-init-organization" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="initial-organization">
      <value value="&quot;trait-combo-groups&quot;"/>
      <value value="&quot;random-prop-indivs&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-storage" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="r">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateProb">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.0030"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateRadius">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migrateProb">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HarvestGap">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HoldingCap">
      <value value="100"/>
      <value value="500"/>
      <value value="1000"/>
      <value value="5000"/>
      <value value="10000"/>
      <value value="50000"/>
      <value value="100000"/>
      <value value="500000"/>
      <value value="1000000"/>
      <value value="5000000"/>
      <value value="10000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="givePerc">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="marginal_defense_cost">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-migration" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="r">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateProb">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.0030"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateRadius">
      <value value="2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="migrateProb" first="0" step="0.1" last="1"/>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HarvestGap">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HoldingCap">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="givePerc">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="marginal_defense_cost">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-defense" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="r">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateProb">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.0030"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateRadius">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migrateProb">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HarvestGap">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HoldingCap">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="givePerc">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="marginal_defense_cost" first="0" step="1" last="10"/>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-imit-rate" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="r">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <steppedValueSet variable="imitateProb" first="0" step="1" last="10"/>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.0030"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateRadius">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migrateProb">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HarvestGap">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HoldingCap">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="givePerc">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="marginal_defense_cost">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-gap" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="r">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateProb">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.0030"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateRadius">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migrateProb">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="HarvestGap" first="0" step="0.2" last="2"/>
    <enumeratedValueSet variable="HoldingCap">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="givePerc">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="marginal_defense_cost">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SA-r" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>setbenchmark</final>
    <timeLimit steps="1000"/>
    <exitCondition>count turtles = 0</exitCondition>
    <metric>count turtles</metric>
    <metric>resource</metric>
    <metric>freq_low</metric>
    <enumeratedValueSet variable="group-markers">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Property">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Production">
      <value value="true"/>
    </enumeratedValueSet>
    <steppedValueSet variable="r" first="0" step="0.1" last="1"/>
    <enumeratedValueSet variable="K">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="refuge-level">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_n_groups">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init_group_size">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateProb">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutationRate">
      <value value="0.0030"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateRadius">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migrateProb">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateTreatment">
      <value value="&quot;anyone&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="imitateBias">
      <value value="&quot;payoff&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HarvestGap">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HoldingCap">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="givePerc">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="publicGoodsTheta">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="marginal_defense_cost">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="costOfLivingMSYRatio">
      <value value="0.2"/>
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
