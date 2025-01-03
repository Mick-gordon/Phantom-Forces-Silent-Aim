-- To Make This Work Open Blox Trap. Go In "Engine Settings" Scroll To The Bottom And Click On "Fast Flag Editor". 
-- Click On "+ Add new" Then For The Name Put "FFlagDebugRunParallelLuaOnMainThread" Then For Value Do "True".

if not debug.getupvalues or not debug.setstack or not debug.getstack or not getgc then -- Check If The Executor Is Supported 
    game:GetService("Players").LocalPlayer:Kick("Executor Is Not Suported!");
end;

-- // Variables
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = game:GetService("Workspace").CurrentCamera;
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");

-- // Tables
local SilentAim = { 
    Enabled = false,
    Fov = 600,
    ShowFov = false,
    HitScan = "Head",
};

-- // Modules 
local Modules = { };
do

    local Shared;
    for _,v in getgc(true) do 
        if typeof(v) == "table" and rawget(v, "require") and not rawget(v, "rawget") then -- My Executors getinfo is broken :broken_heart: 
            Shared = v; -- Gets The Shared table (Most Free Executors Don't Have getrenv().shared)
        end;
    end;

    local Cache;
    xpcall(function()
        Cache = debug.getupvalue(Shared.require, 1)._cache;
    end, function()
        LocalPlayer:Kick('Make Sure The Game Is Loaded Or Check If You Have "FFlagDebugRunParallelLuaOnMainThread" "True".');
    end)

    local function Require(Module)
        return Cache[Module].module;
    end; 

    Modules.ReplicationInterface = Require("ReplicationInterface");
    Modules.BulletInterface = Require("BulletInterface");
    Modules.PublicSettings = Require("PublicSettings");

end;

if not Modules.ReplicationInterface or not Modules.BulletInterface or not Modules.PublicSettings then
    LocalPlayer:Kick('Failed To Get One Of The Modules. Try Rejoining.');
end;

-- // Functions
local Functions = { };
do
    
    function Functions:GetClosestToMouse() -- Quick Little Get Closest To Mouse Function Nothing Special.
		local Closest, HitPart = SilentAim.Fov, nil;
        
		Modules.ReplicationInterface.operateOnAllEntries(function(Player, Entry)
            if Player ~= LocalPlayer then
				if Entry._alive and Player.Team ~= LocalPlayer.Team and Entry._thirdPersonObject and Entry._thirdPersonObject._characterModelHash then -- Check If They Are Alive And Have A Character
					
					local HitBox = Entry._thirdPersonObject._characterModelHash[SilentAim.HitScan];
					if HitBox then
						local ScreenPosition, OnScreen = CurrentCamera:WorldToViewportPoint(HitBox.Position); -- 3D To 2D
						local Magnitude = (UserInputService:GetMouseLocation() - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude; -- The Distance Between Mouse And Player 2D Position.
						if OnScreen and Magnitude < Closest then
							Closest = Magnitude;
							HitPart = HitBox;
						end;
					end;
				end;
			end;
		end);

		return HitPart;
    end;

    function Functions:CalCulateBulletDrop(To, From, MuzzleVelovity) -- I Have Added This As I Am Very Lazy On DELETEMOB V3(Sorry).
        local Distance = (To - From).Magnitude;
        local Time = Distance / MuzzleVelovity;
        local Vertical = 0.5 * Modules.PublicSettings.bulletAcceleration * Time^2; -- kinematic Equation.
        
        return Vertical; -- How Much Need To Be Compinsated For Bullet Drop.
    end;
    
end;


-- // Hooks
do
    -- Thanks mickeydev For Showing Me How To Use SetStack.
    local OldBulletInterface = Modules.BulletInterface.newBullet; Modules.BulletInterface.newBullet = function(BulletData) -- Hooks The New Bullets I Am Not Using hookfunction As It Can Cry About To Many Upvalues.

        if BulletData.extra and SilentAim.Enabled then -- If LocalPlyer Is Sending It.
            local HitPart = Functions:GetClosestToMouse();

            if HitPart then
                local BulletSpeed = BulletData.extra.firearmObject:getWeaponStat("bulletspeed");
                local VerticalDrop = Functions:CalCulateBulletDrop(HitPart.Position, BulletData.position, BulletSpeed);
                local LookVector = (HitPart.Position - VerticalDrop - BulletData.position).unit;

                for i, v in debug.getstack(2) do -- https://www.lua.org/pil/24.2.html
                    if typeof(v) == "Vector3" and (BulletData.velocity.Unit - v).Magnitude < 0.1 then -- The Index Can Change.
                        debug.setstack(2, i, LookVector); -- Changes A Local Variale, LookVector Inside The FirearmObject.
                        break;
                    end;
                end;

                BulletData.velocity = LookVector * BulletSpeed; -- Creates The Velocity.
            end;
        end;

        return OldBulletInterface(BulletData); -- Return It To The Old Function With Our Changed Arguments.
    end;

end;


-- // GUI (No Need To Look Down Here It Is Just My Shitty GUI)
do

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
    do

        local Fov   = Drawing.new("Circle"); -- Simple Fov;
        Fov.Filled    = false;
        Fov.NumSides = 1000;
        Fov.Color   = Color3.fromRGB(255, 255 ,255);
        Fov.Thickness = 1;
        Fov.Transparency = 1;
        RunService.Heartbeat:Connect(function() -- Loop To Change The Mouse Position And Size.

            if not FovSizeText.Text == "" and tonumber(FovSizeText.Text) ~= nil then
                SilentAim.Fov = tonumber(FovSizeText.Text);
            end;

            Fov.Visible = SilentAim.Enabled and SilentAim.ShowFov;

            Fov.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y);
            Fov.Radius   = SilentAim.Fov;
        end);

    end;

end;
