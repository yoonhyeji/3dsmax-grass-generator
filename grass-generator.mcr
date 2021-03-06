-- Grass Generator 1.5 - 29/05/14
-- Dev by Midge Sinnaeve
-- www.themantissa.net
-- Additional optimization by barigazy
-- www.scriptspot.com/users/barigazy
-- Free for all use and / or modification.
-- If you modify the script please mention our names, cheers. :)

macroScript GrassGenerator
	category:"DAZE"
	toolTip:"Grass Generator"
	buttonText:"GrassGen"
	(
		try(destroyDialog ::GrassGenerator)catch()
		rollout GrassGenerator "Grass Generator v1.5"
		(
			-- UI --
			
			button btn_version "Grass Generator v1.5" pos:[145,5] width:106 height:15 border:false


			GroupBox grp_grassblade "Grass Blade Settings" pos:[5,20] width:245 height:195
			
				label lbl_bamount "Amount of Unique Blades:" pos:[15,42] width:155 height:15
				spinner spn_bamount "" pos:[180,42] width:60 height:16 range:[1,20,5] type:#integer
			
				label lbl_bladesegs "Blade Segments:" pos:[15,68] width:90 height:15
				checkbutton ckb_bladesegs_auto "Auto" pos:[110,65] width:60 height:20 checked:true
				spinner spn_bladesegs_amount "" pos:[180,68] width:60 height:16 range:[2,100,5] type:#integer enabled:false
					
				label lbl_gdim_min "Min:" pos:[62,90] width:30 height:15
				label lbl_gdim_max "Max:" pos:[182,90] width:30 height:15
						
				label lbl_glength "Length:" pos:[15,110] width:45 height:15
				spinner spn_glength_min "" pos:[60,110] width:60 height:16 range:[0.001,10000,7.5] type:#worldUnits
				checkbutton ckb_glength_lock "Lock" pos:[130,108] width:40 height:20 checked:false
				spinner spn_glength_max "" pos:[180,110] width:60 height:16 range:[0.001,10000,15] type:#worldUnits
						
				label lbl_gwidth "Width:" pos:[15,135] width:45 height:15
				spinner spn_gwidth_min "" pos:[60,135] width:60 height:16 range:[0.001,10000,0.25] type:#worldUnits
				checkbutton ckb_gwidth_lock "Lock" pos:[130,133] width:40 height:20
				spinner spn_gwidth_max "" pos:[180,135] width:60 height:16 range:[0.001,10000,0.5] type:#worldUnits
						
				label lbl_gbend "Bend:" pos:[15,160] width:45 height:15
				spinner spn_gbend_min "" pos:[60,160] width:60 height:16 range:[0,180,60] type:#float
				checkbutton ckb_gbend_lock "Lock" pos:[130,158] width:40 height:20
				spinner spn_gbend_max "" pos:[180,160] width:60 height:16 range:[0,180,120] type:#float
						
				checkbox chk_gcut "Cut Grass?" pos:[14,188] width:80 height:15 checked:false
				spinner spn_gcut_length "Cut Length: " pos:[149,189] width:91 height:16 enabled:false range:[0.1,10000,14.9] type:#worldUnits
	

			GroupBox grp_grasspatch "Grass Patch Scatter Settings" pos:[5,220] width:245 height:295
			
			dropdownlist ddl_patchtype "Patch Type: " items:#("NONE      (No patch will be created)", "QUICK     (Version 1.0 scattering)", "SHAPE     (Pick a scene object to scatter on)") width:223 pos:[15,240]
			
				-- Quick --
				
				label lbl_qk_prad "Grass Patch Scatter Radius:" pos:[15,290] width:160 height:15
				spinner spn_qk_prad "" pos:[180,290] width:60 height:16 range:[10,50,25] type:#worldUnits
				radioButtons rdo_qk_bcount "Grass Patch Density:" pos:[15,315] width:209 height:30 labels:#("Sparse        ", "Medium         ", "Dense") columns:3
				
				-- Shape --
				
				fn geoFilter obj = superclassof obj == GeometryClass
				
				
				pickButton pkb_cp_scatter "Select Custom Scatter Shape (Mesh)" pos:[10,290] width:235 height:30 filter:geoFilter
				label lbl_cp_bladecount "Grass Patch Blade Count:" pos:[15,330] width:165 height:15
				spinner spn_cp_bladecount "" pos:[180,330] width:60 height:16 range:[0,100000,1000] type:#integer
				
				label lbl_map_density "Grass Density from Grayscale Values?" pos:[15,510] width:210 height:15
				checkbox chk_map_density "" pos:[227,510] width:12 height:12 enabled:true checked:false
				
				
				-- General --
				
				
				label lbl_brot "Blade Random Rotation (Degrees):" pos:[15,355] width:225 height:15
				label lbl_brot_x "X:" pos:[15,380] width:12 height:15
				spinner spn_brot_x "" pos:[30,380] width:50 height:16 range:[0,90,10] type:#float
				label lbl_brot_y "Y:" pos:[95,380] width:12 height:15
				spinner spn_brot_y "" pos:[110,380] width:50 height:16 range:[0,90,10] type:#float
				label lbl_brot_z "Z:" pos:[175,380] width:12 height:15
				spinner spn_brot_z "" pos:[190,380] width:50 height:16 range:[0,360,360] type:#float
					
				label lbl_bscale "Blade Random Scale (Added Percentage):" pos:[15,410] width:225 height:15
				label lbl_bscale_x "X:" pos:[15,435] width:12 height:15
				spinner spn_bscale_x "" pos:[30,435] width:50 height:16 range:[0,100,10] type:#float
				label lbl_bscale_y "Y:" pos:[95,435] width:12 height:15
				spinner spn_bscale_y "" pos:[110,435] width:50 height:16 range:[0,100,10] type:#float
				label lbl_bscale_z "Z:" pos:[175,435] width:12 height:15
				spinner spn_bscale_z "" pos:[190,435] width:50 height:16 range:[0,100,10] type:#float
				
				label lbl_matid_count "Random Material ID's (1-100)" pos:[15,465] width:175 height:15
				spinner spn_matid_count "" pos:[190,465] width:50 height:16 range:[1,100,3] type:#integer
				
				label lbl_mltsub_create "Automatically Create Multi/Sub Material?" pos:[15,490] width:210 height:15
				checkbox chk_mltsub_enable "" pos:[227,490] width:12 height:12 enabled:true checked:false

			button btn_go "GENERATE" pos:[5,520] width:245 height:40
			
			-- UI States --
			
				-- Blade Segments Auto --
				
				on ckb_bladesegs_auto changed state do spn_bladesegs_amount.enabled = not state
			
				-- Spinners Min/Max --
				
					-- Length Grass Spinners --
					
					on spn_glength_min changed val do
					(
						if spn_glength_max.value <= val do spn_glength_max.value = (val + 0.1)
						spn_gcut_length.value = if ckb_glength_lock.checked then (val - 0.1) else (spn_glength_max.value - 0.1)
					)
					on ckb_glength_lock changed state do
					(
						spn_glength_max.enabled = not state
						spn_gcut_length.value = if ckb_glength_lock.checked then (spn_glength_min.value - 0.1) else (spn_glength_max.value - 0.1)
					)
					on spn_glength_max changed val do
					(
						if spn_glength_min.value >= val do spn_glength_min.value = (val - 0.1)
						spn_gcut_length.value = if ckb_glength_lock.checked then (spn_glength_min.value - 0.1) else (val - 0.1)
					)
		
					-- Width Grass Spinners --
					
					on spn_gwidth_min changed val do (if spn_gwidth_max.value <= val do spn_gwidth_max.value = (val + 0.1))
					on ckb_gwidth_lock changed state do (spn_gwidth_max.enabled = not state)
					on spn_gwidth_max changed val do (if spn_gwidth_min.value >= val do spn_gwidth_min.value = (spn_gwidth_max.value - 0.1))
						
					-- Bend Grass Spinners --
					
					on spn_gbend_min changed val do (if spn_gbend_max.value <= val do spn_gbend_max.value = (val + 0.1))
					on ckb_gbend_lock changed state do (spn_gbend_max.enabled = not state)
					on spn_gbend_max changed val do (if spn_gbend_min.value >= val do spn_gbend_min.value = (spn_gbend_max.value - 0.1))
						
					-- Cut Length Spinner --
						
					on chk_gcut changed state do (spn_gcut_length.enabled = state)
				
					-- Grass Scatter UI ON / OFF --
					
						
					fn patchUI =
					(
						if ddl_patchtype.selection == 1 then -- NONE
						(
							btn_go.pos = [5,300]
							GrassGenerator.height = 345
							grp_grasspatch.height = 75
							(for i = 26 to 49 collect GrassGenerator.controls[i]).visible = false
							(for i = 26 to 49 collect GrassGenerator.controls[i]).enabled = false
						)
						else if ddl_patchtype.selection == 2 then -- QUICK
						(
							btn_go.pos = [5,520]
							GrassGenerator.height = 565
							grp_grasspatch.height = 295
							(for i = 26 to 28 collect GrassGenerator.controls[i]).visible = true
							(for i = 26 to 28 collect GrassGenerator.controls[i]).enabled = true
							(for i = 29 to 33 collect GrassGenerator.controls[i]).visible = false
							(for i = 29 to 33 collect GrassGenerator.controls[i]).enabled = false
							(for i = 34 to 49 collect GrassGenerator.controls[i]).visible = true
							(for i = 34 to 49 collect GrassGenerator.controls[i]).enabled = true
						)
						else if ddl_patchtype.selection == 3 then -- SHAPE
						(
							btn_go.pos = [5,540]
							GrassGenerator.height = 585
							grp_grasspatch.height = 315
							(for i = 26 to 28 collect GrassGenerator.controls[i]).visible = false
							(for i = 26 to 28 collect GrassGenerator.controls[i]).enabled = false
							(for i = 29 to 49 collect GrassGenerator.controls[i]).visible = true
							(for i = 29 to 49 collect GrassGenerator.controls[i]).enabled = true
						)
					)
					on ddl_patchtype selected sel do
					(
						patchUI()
					)

						
			-- GRASS BLADE CREATION FUNCTIONS --
						
				-- SINGLE BLADE CREATION --
							
				fn createGrassBlade offset:2 =
				(
					with undo off with redraw off
					(
						global grassBlades = #()
						
						for i = 1 to spn_bamount.value do 
						(
							-- Declare Randomizers
							
							local gb_length = if ckb_glength_lock.state then spn_glength_min.value else (random spn_glength_min.value spn_glength_max.value)
							local gb_width = if ckb_gwidth_lock.state then spn_gwidth_min.value else (random spn_gwidth_min.value spn_gwidth_max.value)
							local gb_bend = if ckb_gbend_lock.state then spn_gbend_min.value else (random spn_gbend_min.value spn_gbend_max.value)
							local gb_root = ((gb_length / 100) * 5)
							
							-- Declare Plane Segments
							
							if ckb_bladesegs_auto.checked then
							(
								local bsegs = case of
								(
									(spn_glength_min.value < 10): 5
									(spn_glength_min.value < 25): 8
									(spn_glength_min.value < 100): 16
								)
							)
							else
							(
								bsegs = (ceil (spn_bladesegs_amount.value / 2)) as Integer
							)
							
							-- Declare Modifiers
							
							local mods = #(
								Taper primaryaxis:1 amount:-1.5, \
								Bend BendAxis:1 BendDir:-90 BendAngle:gb_bend center:[0,-((gb_length / 2) - (gb_root / 2)),0], \
								MeshSmooth subdivMethod:1 smoothness:1, \
								Relax Relax_Value:1 iterations:1 Keep_Boundary_Pts_Fixed:1
							)
							
							-- Run Creation
							
							grassBlade = Plane pos:[0,0,0] length:(gb_length + gb_root) width:gb_width lengthsegs:bsegs widthsegs:1 name:(uniquename "GrassBlade_")
							rotate grassBlade (eulerangles 90 0 0)
							grassBlade.pos = point3 0 0 ((gb_length / 2) - (gb_root / 2))
							grassBlade.pivot = [0,0,0] ; WorldAlignPivot grassBlade
							for m in mods do addModifier grassBlade m
							ResetXForm grassBlade ; convertToMesh grassBlade
							grassBlade.wirecolor = (color 6 135 6)
							
							-- Cut Grass
							
							if chk_gcut.checked == true do 
							(
								meshop.slice grassBlade grassBlade.faces [0,0,-1] -spn_gcut_length.value delete:true
							)
							-- Add to Blade Array
							
							grassBlade.pos.x += ((i * 2) - 2)
							grassBlades[i] = grassBlade
						)
						
					)
					
					if ddl_patchtype.selection == 1 then redrawViews()
					
					grassBlades
				)
			
				-- FAST COLLAPSE FUNCTION --

				fn fastCollapse nodes name: pivotAt:#bottom moveAtZero:on = if nodes.count > 0 do
				(
					local meshAttach = meshop.attach
					with undo off with redraw off
					(	
						local newMesh = nodes[1]
						for m = nodes.count to 2 by -1 do (meshAttach newMesh nodes[m] attachMat:#IDToMat condenseMat:on)
						newMesh.pivot = case pivotAt of (
							(#center): newMesh.center
							(#bottom): [newMesh.center.x, newMesh.center.y, 0]
						)
						if name != unsupplied do newMesh.name = uniquename name
						if moveAtZero do newMesh.pos = [0,0,0] ; newMesh
					)
				)			
				
				-- MATERIAL CREATION FUNCTION --
			
				fn grassMat name: id: = (mat = multimaterial name:name materialList:(for i = 1 to id collect Standard name:(name+"_id"+i as string) Diffuse:(clr = random black white ; clr.s = 255 ; clr)))

				-- QUICK SCATTER FUNCTION --
					
				fn scatterBlades blades = if blades.count > 0 do
				(				
					local xrot = spn_brot_x.value
					local yrot = spn_brot_y.value
					local zrot = (spn_brot_z.value / 2)
					
					local xscalemin = ((100 - spn_bscale_x.value) / 100)
					local yscalemin = ((100 - spn_bscale_y.value) / 100)
					local zscalemin = ((100 - spn_bscale_z.value) / 100)
					
					local xscalemax = ((100 + spn_bscale_x.value) / 100)
					local yscalemax = ((100 + spn_bscale_y.value) / 100)
					local zscalemax = ((100 + spn_bscale_z.value) / 100)
										
					local prad = spn_qk_prad.value, brad = (prad / 3)
					
					local GrassPatch = with undo off with redraw off for obj in blades collect
					(
						bladeGroup = for i = 0 to ((50 / spn_bamount.value) as integer) collect
						(
							blade = snapshot obj
							blade.rotation = eulerangles (random -xrot xrot) (random -yrot yrot) (random 0.0 zrot)
							WorldAlignPivot blade
							blade.pos = [(random -brad brad),(random -brad brad),0]
							blade.scale = [(random xscalemin xscalemax),(random yscalemin yscalemax),(random zscalemin zscalemax)]
							blade
						)
						turf = fastCollapse (join bladeGroup #(obj))
						bladeGroup = for i = 0 to (brad * rdo_qk_bcount.state) collect
						(
							blade = snapshot turf
							blade.rotation = eulerangles 0 0 (random 0.0 zrot)
							blade.pos = [(random (-prad + brad) (prad - brad)),(random (-prad + brad) (prad - brad)),0]
							blade
						)					
						turf = fastCollapse (join bladeGroup #(turf))
					)
					GrassPatch = fastCollapse GrassPatch name:"GrassPatch_"
					addModifier GrassPatch (MaterialByElement method:0 Material_ID_Count:spn_matid_count.value)
					if chk_mltsub_enable.checked == true do GrassPatch.mat = grassMat name:GrassPatch.name id:spn_matid_count.value
					
					convertToMesh GrassPatch
					GrassPatch.wirecolor = (color 6 135 6)
				)
				
				-- SHAPE SCATTER FUNCTION --
				
				fn spawnParticleSystem = 
				(
					
					with undo off with redraw off
					(
						local scatter_obj =  #(pkb_cp_scatter.object)
						
						local scatter_flow = PF_Source name:(uniquename "PFS_Grass_") X_Coord:20 Y_Coord:0 isSelected:off Logo_Size:25 Emitter_Length:25 Emitter_Width:25 Emitter_Height:0.01 Quantity_Viewport:100 Particle_Amount_Limit:spn_cp_bladecount.value  pos:[0,0,0]
						
						for i=2 to grassBlades.count do
						(
							grassBlades[i].parent = grassBlades[1]
						)
						
						local dbm = if chk_map_density.checked == true then on else off
						
						particleFlow.BeginEdit()
						
						op1_main = RenderParticles()
						op2_main = DisplayParticles type:6 visible:100 Show_Numbering:off color:(color 40 100 10) Selected_Type:6
						
						op1_ev1 = Birth type:0 Emit_Start:0 Emit_Stop:0 amount:spn_cp_bladecount.value
						op2_ev1 = Position_Object Emitter_Objects:scatter_obj Density_By_Emitter_Material:dbm
						op3_ev1 = Shape_Instance Shape_Object:grassBlades[1] Group_Members:off Object_And_Children:on Object_Elements:off
						
						s1 = stringstream ""
						format "on ChannelsUsed pCont do\n" to:s1
						format "(\n" to:s1
						format "\tpCont.useOrientation = true\n" to:s1
						format "\tpCont.useScale = true\n" to:s1
						format ")\n" to:s1
						format "on Init pCont do ()\n" to:s1
						format "on Proceed pCont do\n" to:s1
						format "(\n" to:s1
						format "\tcount = pcont.numparticles()\n" to:s1
						format "\tfor i in 1 to count do\n" to:s1
						format "\t(\n" to:s1
						format "\t\tpCont.particleIndex = i\n" to:s1
						format "\t\txrot = pCont.rand55()\n" to:s1
						format "\t\tyrot = pCont.rand55()\n" to:s1
						format "\t\tzrot = pCont.rand11()\n" to:s1
						format "\t\txscale = pCont.rand01()\n" to:s1
						format "\t\tyscale = pCont.rand01()\n" to:s1
						format "\t\tzscale = pCont.rand01()\n" to:s1
						format "\t\tpCont.particleOrientation.x = xrot * " to:s1
						format (spn_brot_x.value as String) to:s1
						format "\n" to:s1
						format "\t\tpCont.particleOrientation.y = yrot * " to:s1
						format (spn_brot_y.value as String) to:s1
						format "\n" to:s1
						format "\t\tpCont.particleOrientation.z = zrot * " to:s1
						format (spn_brot_z.value as String) to:s1
						format " \n" to:s1
						format "\t\tpCont.particleScaleXYZ.x += (xscale * " to:s1
						format (spn_bscale_x.value as String) to:s1
						format "50 / 100)\n" to: s1
						format "\t\tpCont.particleScaleXYZ.y += (xscale * " to:s1
						format (spn_bscale_y.value as String) to:s1
						format "50 / 100)\n" to: s1
						format "\t\tpCont.particleScaleXYZ.z += (xscale * " to:s1
						format (spn_bscale_z.value as String) to:s1
						format "50 / 100)\n" to: s1
						format "\t)\n" to:s1
						format ")\n" to:s1
						format "on Release pCont do ()" to:s1
						
						s1 = s1 as string
						
						op4_ev1 = Script_Operator name:(uniquename "ScatterScript_") Proceed_Script:s1
						ev1 = Event name:(uniquename "Grass_Blade_Distrib_")
						
						ev1.SetPViewLocation (scatter_flow.X_Coord) (scatter_flow.Y_Coord+100)
						
						scatter_flow.AppendAction op1_main
						scatter_flow.AppendAction op2_main
						
						ev1.AppendAction op1_ev1
						ev1.AppendAction op2_ev1
						ev1.AppendAction op3_ev1
						ev1.AppendAction op4_ev1
						
						scatter_flow.AppendInitialActionList ev1
						
						particleFlow.EndEdit()
						
						local grassMesh = Mesher name:(uniquename "grassPatch_") pos:[0,0,0] pick:scatter_flow isSelected:off
						addModifier grassMesh (MaterialByElement method:0 Material_ID_Count:spn_matid_count.value)
						if chk_mltsub_enable.checked == true do grassMesh.mat = grassMat name:grassMesh.name id:spn_matid_count.value
						
						CenterPivot grassMesh ; WorldAlignPivot grassMesh ; convertToMesh grassMesh
						local xpos = grassMesh.pos.x ; local ypos = grassMesh.pos.y ; grassMesh.pivot = [xpos, ypos, 0] ; grassMesh.wirecolor = (color 6 135 6)
						
						delete grassBlades ; delete scatter_flow ; particleFlow.BeginEdit() ; delete ev1 ; particleFlow.EndEdit()
					)			
				)
					
				-- BUTTON PRESSES --
				
				on pkb_cp_scatter picked obj do
				(
					if obj != undefined do
					(
						pkb_cp_scatter.text = obj.name
					)
				)
-- 				
				on btn_go pressed do
				(
					if getCommandPanelTaskMode() != #create do setCommandPanelTaskMode mode:#create
					
					if ddl_patchtype.selection == 1 do createGrassBlade()
					
					if ddl_patchtype.selection == 2 do
						(
							local bladeRunner = createGrassBlade()
							scatterBlades bladeRunner
						)
						
					if ddl_patchtype.selection == 3 do
					(
						if pkb_cp_scatter.object != undefined then
						(
							local bladeRunner = createGrassBlade()
							spawnParticleSystem()
						)
						else
						(
							messageBox "Please select a Custom Scatter Shape."
						)
					)
				)
				
				on btn_version pressed do messageBox "Grass Generator 1.5 - 29/05/14 \n\nDev by Midge Sinnaeve \nwww.themantissa.net \nmidge@daze.tv \nAdditional Optimization by barigazy \nwww.scriptspot.com/users/barigazy \nFree for all use and / or modification. \nIf you modify the script, please mention our names, cheers. :)" title:"About Grass Generator" beep:false
			)
	
		createDialog GrassGenerator 255 320 50 150 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
		GrassGenerator.patchUI()
	)
