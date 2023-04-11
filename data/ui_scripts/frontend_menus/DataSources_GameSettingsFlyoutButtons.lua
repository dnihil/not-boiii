DataSources.GameSettingsFlyoutButtonsCustom = DataSourceHelpers.ListSetup( "GameSettingsFlyoutButtonsCustom", function ( f7_arg0 )
	local f7_local0 = {
		{
			optionDisplay = "MPUI_CHANGE_MAP_CAPS",
			customId = "btnChangeMap",
			action = OpenChangeMap
		},
		-- {
			-- optionDisplay = "MPUI_CHANGE_GAME_MODE_CAPS",
			-- customId = "btnChangeGameMode",
			-- action = OpenChangeGameMode
		-- },
		{
			optionDisplay = "MENU_SETUP_BOTS_CAPS",
			customId = "btnSetupBots",
			action = OpenBotSettings
		},
		{
			optionDisplay = "MPUI_EDIT_GAME_RULES_CAPS",
			customId = "btnEditGameRules",
			action = OpenEditGameRules
		}
	}
	-- if CoD.isPC and IsServerBrowserEnabled() then
		-- table.insert( f7_local0, {
			-- optionDisplay = "PLATFORM_SERVER_SETTINGS_CAPS",
			-- customID = "btnServerSettings",
			-- action = OpenServerSettings
		-- } )
	-- end
	local f7_local1 = {}
	for f7_local5, f7_local6 in ipairs( f7_local0 ) do
		table.insert( f7_local1, {
			models = {
				displayText = Engine.Localize( f7_local6.optionDisplay ),
				customId = f7_local6.customId,
				disabled = f7_local6.disabled
			},
			properties = {
				title = f7_local6.optionDisplay,
				desc = f7_local6.desc,
				action = f7_local6.action,
				actionParam = f7_local6.actionParam
			}
		} )
	end
	return f7_local1
end, nil, nil, nil )

LUI.createMenu.GameSettingsFlyoutMPCustom = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "GameSettingsFlyoutMPCustom" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self.soundSet = "default"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "GameSettingsFlyoutMP.buttonPrompts" )
	self.anyChildUsesUpdateState = true
	
	local Options = LUI.UIList.new( self, controller, -2, 0, nil, false, false, 0, 0, false, false )
	Options:makeFocusable()
	Options:setLeftRight( true, false, 243.43, 523.43 )
	Options:setTopBottom( true, false, 177.56, 329.56 )
	Options:setYRot( 25 )
	Options:setWidgetType( CoD.FE_List1ButtonLarge_PH )
	Options:setVerticalCount( 5 )
	Options:setSpacing( -2 )
	Options:setDataSource( "GameSettingsFlyoutButtonsCustom" )
	Options:registerEventHandler( "gain_focus", function ( element, event )
		local f9_local0 = nil
		if element.gainFocus then
			f9_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f9_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f9_local0
	end )
	Options:registerEventHandler( "lose_focus", function ( element, event )
		local f10_local0 = nil
		if element.loseFocus then
			f10_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f10_local0 = element.super:loseFocus( event )
		end
		return f10_local0
	end )
	self:AddButtonCallbackFunction( Options, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( element, menu, controller, model )
		ProcessListAction( self, element, controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( Options )
	self.Options = Options
	
	self:mergeStateConditions( {
		{
			stateName = "Local",
			condition = function ( menu, element, event )
				return IsLobbyNetworkModeLAN()
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNetworkMode" ), function ( model )
		local f14_local0 = self
		local f14_local1 = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNetworkMode"
		}
		CoD.Menu.UpdateButtonShownState( f14_local0, self, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "lobbyRoot.lobbyNav" ), function ( model )
		local f15_local0 = self
		local f15_local1 = {
			controller = controller,
			name = "model_validation",
			modelValue = Engine.GetModelValue( model ),
			modelName = "lobbyRoot.lobbyNav"
		}
		CoD.Menu.UpdateButtonShownState( f15_local0, self, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE )
	end )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( element, menu, controller, model )
		GoBack( self, controller )
		ClearMenuSavedState( menu )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "" )
		return false
	end, false )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_START, "M", function ( element, menu, controller, model )
		GoBackAndOpenOverlayOnParent( self, "StartMenu_Main", controller )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_START, "MENU_MENU" )
		return true
	end, false )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "S", function ( element, menu, controller, model )
		if not IsLAN() and not IsPlayerAGuest( controller ) and IsPlayerAllowedToPlayOnline( controller ) then
			GoBackAndOpenOverlayOnParent( self, "Social_Main", controller )
			return true
		else
			
		end
	end, function ( element, menu, controller )
		if not IsLAN() and not IsPlayerAGuest( controller ) and IsPlayerAllowedToPlayOnline( controller ) then
			CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "" )
			return false
		else
			return false
		end
	end, false )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_LB, nil, function ( element, menu, controller, model )
		SendButtonPressToOccludedMenu( menu, controller, model, Enum.LUIButton.LUI_KEY_LB )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_LB, "" )
		return false
	end, false )
	self:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_RB, nil, function ( element, menu, controller, model )
		SendButtonPressToOccludedMenu( menu, controller, model, Enum.LUIButton.LUI_KEY_RB )
		return true
	end, function ( element, menu, controller )
		CoD.Menu.SetButtonLabel( menu, Enum.LUIButton.LUI_KEY_RB, "" )
		return false
	end, false )
	Options.id = "Options"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = self
	} )
	if not self:restoreState() then
		self.Options:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Options:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "GameSettingsFlyoutMP.buttonPrompts" ) )
	end )
	return self
end

