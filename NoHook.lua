-- To Make This Work Open Blox Trap. Go In "Engine Settings" Scroll To The Bottom And Click On "Fast Flag Editor". 
-- Click On "+ Add new" Then For The Name Put "FFlagDebugRunParallelLuaOnMainThread" Then For Value Do "True".

repeat task.wait() until game:IsLoaded() and game.GameId ~= 0; -- Makes Sure The Game Is Loaded.

if not hookfunction or not newcclosure and not queue_on_teleport then -- Check If The Executor Is Supported
    game:GetService("Players").LocalPlayer:Kick("Executor Is Not Suported!");
end;

-- // Variables
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = game:GetService("Workspace").CurrentCamera;
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");

-- // Tables
local SilentAim = { -- I Haven't Added WallCheck On This One So The Skids Will Have To Figure It Out.
    Enabled = false,
    Fov = 600,
    ShowFov = false,
    HitScan = "Head"
};

-- // Modules 
local Modules = { };
do
    
    for i,v in next, getgc(true) do -- It Is Shitty Way Of Getting Them (I Hope, Fuck You Nigga Skids).
        if typeof(v) == "table" then
            if rawget(v, "send") and rawget(v, "getPing") then -- Checks If The Table Contains getPing and send Function.
                Modules.NetworkClient = v; -- Network Is Where The Game Communicates To The Server.
            elseif rawget(v, "new") and rawget(v, "setColor") and rawget(v, "step") then -- I Have Used BulletObject As Basicaly Everyone Hooks This.
                Modules.BulletObject = v; -- Where The Bullets Are Created For Local Computer.
            elseif rawget(v, "removeEntry") and rawget(v, "operateOnAllEntries") and rawget(v, "getEntry") then
                Modules.ReplicationInterface = v; -- Where The Player Characters Are Held.
            end;
        end;
    end;
    
end;

-- // Functions
local Functions = { };
do
    
    function Functions:GetClosestToMouse() -- Quick Little Get Closest To Mouse Function Nothing Special.
		local Closest, HitPart = SilentAim.Fov, nil;

		for _,Player in pairs(Players:GetChildren()) do
			if Player ~= LocalPlayer and Modules.ReplicationInterface.getEntry(Player) then
				local Entry = Modules.ReplicationInterface.getEntry(Player); -- Gets The Entry Where It Contains All Of The Player Information
				if Entry._alive and Player.Team ~= LocalPlayer.Team and Entry._thirdPersonObject and Entry._thirdPersonObject._characterHash then -- Check If They Are Alive And Have A Character
					local HitBox = Entry._thirdPersonObject._characterHash[SilentAim.HitScan];
					if HitBox then
						local ScreenPosition, OnScreen = CurrentCamera:WorldToScreenPoint(HitBox.Position); -- 3D To 2D
						local Magnitude = (UserInputService:GetMouseLocation() - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude; -- The Distance Between Mouse And Player 2D Position.
						if OnScreen and Magnitude < Closest then
							Closest = Magnitude;
							HitPart = HitBox;
						end;
					end;
				end;
			end;
		end;

		return HitPart;
	end;
    
end;


-- // Hooks
do
    xpcall(function()
        -- BulletObject.new
        local OldBulletObject_new = Modules.BulletObject.new; Modules.BulletObject.new = newcclosure(function(...) -- Hooks The Function. No Way.
            local Args = {...}; -- No Need For This As It Is A Table Already.
            local HitPart = Functions:GetClosestToMouse(); -- Gets The Closest To The Mouse.
            
            if HitPart and Args[1]["extra"] and SilentAim.Enabled then -- Check If We Have A Target, If Silent Aim Is Enabled And It Is The Local Player Sending The Bullet.
                Args[1]["velocity"] = (HitPart.Position - Args[1]["position"]).unit * Args[1]["extra"]["firearmObject"]:getWeaponStat("bulletspeed"); -- LookVector * MuzzleVelocity (This Dose Not Account For Bullet Drop!).
            end;
            
            return OldBulletObject_new(table.unpack(Args)); -- Send The Table Back 
        end);
        
        -- NetworkClient.send
        local OldNetwork_send = Modules.NetworkClient.send; Modules.NetworkClient.send = newcclosure(function(Idk, Name, ...) -- Wait No Way It Hooks The Function Like hookfunction From The Functions In The Executor From hookfunction. 
    		local Args = {...};
    
    		if Name == "newbullets" and SilentAim.Enabled then -- Checks If It Sending newbullets
    			local UniqueId, BulletData, Time = ...; -- Unpacked The Args To Make More Sense (From R6).
    
    			for i,v in next, BulletData["bullets"] do -- For Each Bullet Change
    				local HitPart = Functions:GetClosestToMouse();
    				if HitPart then
    					v[1] = (HitPart.Position - BulletData["firepos"]).unit;-- LookVector (This Dose Not Account For Bullet Drop!). Args[1] Is The LookVector.
    				end;
    			end;
    
    			return OldNetwork_send(Idk, Name, UniqueId, BulletData, Time); -- Return The Modified Args.
    		end;
    
    		return OldNetwork_send(Idk, Name, ...); -- Return The Non Modified Args From The Other Shitty Things.
        end);
    end,function()
        LocalPlayer:Kick('Check If You Have "FFlagDebugRunParallelLuaOnMainThread" "True" Or Was Not Able To Find Modules Or Silent Aim Has A Error.')
    end);

end;


-- If You Have Any Questions Ask Dm Me On Discord "m1ckgordon" My User Also Join My Discord Where I Will Update DeleteMob (Sometime When I Feel Like It) "https://discord.gg/vgXSSeKAb6".

-- You Have Made It To The End !!! Hope You Have Enjoyed Reading This Like 1 Out Of 1000 People Will See This. 


-- // GUI (No Need To Look Down Here It Is Just My Shitty GUI)
local GUIHolder = Instance.new("ScreenGui", game.CoreGui); GUIHolder.ResetOnSpawn = false;
local Frame = Instance.new("Frame", GUIHolder); Frame.Visible = true; Frame.Draggable = true; Frame.Active = true; Frame.BackgroundColor3 = Color3.fromRGB(52, 52, 52); Frame.Size = UDim2.fromOffset(241, 248); Frame.BorderColor3 = Color3.fromRGB(255, 255, 255);
local Frame2 = Instance.new("Frame", Frame); Frame2.BackgroundTransparency = 1; Frame2.Position = UDim2.new(0.288, 0,0.155, 0); Frame2.Size = UDim2.new(0, 100,0, 164);
local UiListLayout = Instance.new("UIListLayout", Frame2); UiListLayout.FillDirection = "Vertical"; UiListLayout.SortOrder = "LayoutOrder"; UiListLayout.Padding = UDim.new(0,5);
local EnableButton = Instance.new("TextButton", Frame2); EnableButton.Text = "Enable"; EnableButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52); EnableButton.BorderColor3 = Color3.fromRGB(255, 255, 255); EnableButton.Font = "Roboto"; EnableButton.TextSize = 17; EnableButton.TextColor3 = Color3.fromRGB(255, 255, 255); EnableButton.TextXAlignment = "Center"; EnableButton.Size = UDim2.new(0, 122,0, 24);
local ShowFovButton = Instance.new("TextButton", Frame2); ShowFovButton.Text = "Show Fov"; ShowFovButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52); ShowFovButton.BorderColor3 = Color3.fromRGB(255, 255, 255); ShowFovButton.Font = "Roboto"; ShowFovButton.TextSize = 17; ShowFovButton.TextColor3 = Color3.fromRGB(255, 255, 255); ShowFovButton.TextXAlignment = "Center"; ShowFovButton.Size = UDim2.new(0, 122,0, 24);
local TextLabel = Instance.new("TextLabel", Frame2); TextLabel.Text = "Fov Size"; TextLabel.BackgroundTransparency = 1; TextLabel.TextXAlignment = "Center"; TextLabel.TextSize = 17; TextLabel.Font = "Roboto"; TextLabel.TextColor3 = Color3.fromRGB(17, 223, 255); TextLabel.Size = UDim2.new(0, 100,0, 17);
local FovSizeText = Instance.new("TextBox", Frame2); FovSizeText.Text = "600"; FovSizeText.BackgroundColor3 = Color3.fromRGB(52, 52, 52); FovSizeText.BorderColor3 = Color3.fromRGB(255, 255, 255); FovSizeText.Font = "Roboto"; FovSizeText.TextSize = 17; FovSizeText.TextColor3 = Color3.fromRGB(255, 255, 255); FovSizeText.TextXAlignment = "Center"; FovSizeText.Size = UDim2.new(0, 122,0, 24); FovSizeText.ClearTextOnFocus = false;
local HitScanButton = Instance.new("TextButton", Frame2); HitScanButton.Text = "HEAD, torso"; HitScanButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52); HitScanButton.BorderColor3 = Color3.fromRGB(255, 255, 255); HitScanButton.Font = "Roboto"; HitScanButton.TextSize = 17; HitScanButton.TextColor3 = Color3.fromRGB(255, 255, 255); HitScanButton.TextXAlignment = "Center"; HitScanButton.Size = UDim2.new(0, 122,0, 24);
local Name = Instance.new("TextLabel", Frame); Name.Text = "DeleteMob | PF Silent Aim"; Name.BackgroundTransparency = 1; Name.TextXAlignment = "Center"; Name.TextSize = 19; Name.Font = "Roboto"; Name.TextColor3 = Color3.fromRGB(17, 223, 255); Name.Size = UDim2.new(0, 200,0, 50); Name.Position = UDim2.new(0.083, 0,-0.056, 0);
local Discord = Instance.new("TextBox", Frame); Discord.Text = "https://discord.gg/FsApQ7YNTq - ClickMe"; Discord.BackgroundTransparency = 1; Discord.BorderColor3 = Color3.fromRGB(255, 255, 255); Discord.Font = "Roboto"; Discord.TextSize = 14; Discord.TextColor3 = Color3.fromRGB(255, 255, 255); Discord.TextXAlignment = "Center"; Discord.Size = UDim2.new(0, 200,0, 23); Discord.Position = UDim2.new(0.083, 0,0.873, 0); Discord.ClearTextOnFocus = false; Discord.TextEditable = false;
EnableButton.MouseButton1Down:Connect(function()
	if SilentAim.Enabled then 
		SilentAim.Enabled = false 
		EnableButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52);
	else
		SilentAim.Enabled = true 
		EnableButton.BackgroundColor3 = Color3.fromRGB(2, 54, 8);
	end;
end);
ShowFovButton.MouseButton1Down:Connect(function()
	if SilentAim.ShowFov then 
		SilentAim.ShowFov = false 
		ShowFovButton.BackgroundColor3 = Color3.fromRGB(52, 52, 52);
	else
		SilentAim.ShowFov = true 
		ShowFovButton.BackgroundColor3 = Color3.fromRGB(2, 54, 8);
	end;
end);
HitScanButton.MouseButton1Down:Connect(function()
	if SilentAim.HitScan == "Head" then 
		SilentAim.HitScan = "Torso";
		HitScanButton.Text = "head, TORSO"
	else
		SilentAim.HitScan = "Head";
		HitScanButton.Text = "HEAD, torso"
	end;
end);

-- // FOV
local Fov   = Drawing.new("Circle"); -- Simple Fov;
Fov.Fill    = false;
Fov.Corners = 1000;
Fov.Color   = Color3.fromRGB(255, 255 ,255);
Fov.Thickness = 1;
RunService.Heartbeat:Connect(function() -- Loop To Change The Mouse Position And Size.

	if not (FovSizeText.Text == "") then
		SilentAim.Fov = tonumber(FovSizeText.Text);
	end;

	Fov.Visible = SilentAim.Enabled and SilentAim.ShowFov;

	Fov.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y);
	Fov.Radius   = SilentAim.Fov;
end);
