repeat task.wait() until game:IsLoaded() and game.GameId ~= 0;

if not setfflag or not getfflag or not hookfunction or not newcclosure then
    game:GetService("Players").LocalPlayer:Kick("Executor Is Not Suported!");
end;

if string.lower(getfflag("DebugRunParallelLuaOnMainThread")) ~= "true" then
    setfflag("DebugRunParallelLuaOnMainThread", "True");
    queue_on_teleport(loadstring(game:HpptGet("https://raw.githubusercontent.com/Mick-gordon/Phantom-Forces-Silent-Aim/refs/heads/main/Main.lua", true))());
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);
end;

-- // Variables
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = game:GetService("Workspace").CurrentCamera;
local UserInputService = game:GetService("UserInputService");

-- // Tables
local SilentAim = {
    Enabled = true,
    Fov = 600,
    HitScan = "Head"
};

-- // Modules 
local Modules = { };
do
    
    for i,v in next, getgc(true) do
        if typeof(v) == "table" then
            if rawget(v, "send") and rawget(v, "getPing") then
                Modules.NetworkClient = v;
            elseif rawget(v, "new") and rawget(v, "setColor") and rawget(v, "step") then
                Modules.BulletObject = v;
            elseif rawget(v, "removeEntry") and rawget(v, "operateOnAllEntries") and rawget(v, "getEntry") then
                Modules.ReplicationInterface = v;
            end;
        end;
    end;
    
end;

-- // Functions
local Functions = { };
do
    
    function Functions:GetClosestToMouse()
		local Closest, HitPart = SilentAim.Fov, nil;

		for _,Player in pairs(Players:GetChildren()) do
			if Player ~= LocalPlayer and Modules.ReplicationInterface.getEntry(Player) then
				local Entry = Modules.ReplicationInterface.getEntry(Player);
				if Entry._alive and Player.Team ~= LocalPlayer.Team and Entry._thirdPersonObject and Entry._thirdPersonObject._characterHash then
					local HitBox = Entry._thirdPersonObject._characterHash[SilentAim.HitScan];
					if HitBox then
						local ScreenPosition, OnScreen = CurrentCamera:WorldToScreenPoint(HitBox.Position);
						local Magnitude = (UserInputService:GetMouseLocation() - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude;
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
    -- BulletObject.new
    local OldBulletObject_new; OldBulletObject_new = hookfunction(Modules.BulletObject.new, newcclosure(function(...)
        local Args = {...};
        local HitPart = Functions:GetClosestToMouse();
        
        if HitPart and Args[1]["extra"] and SilentAim.Enabled then
            Args[1]["velocity"] = (HitPart.Position - Args[1]["position"]).unit * Args[1]["extra"]["firearmObject"]:getWeaponStat("bulletspeed");
        end;
        
        return OldBulletObject_new(table.unpack(Args));
    end));
    
    -- NetworkClient.send
    local OldNetwork_send;OldNetwork_send = hookfunction(Modules.NetworkClient.send, newcclosure(function(Idk, Name, ...)
		local Args = {...};

		if Name == "newbullets" and SilentAim.Enabled then
			local UniqueId, BulletData, Time = ...;

			for i,v in next, BulletData["bullets"] do
				local HitPart = Functions:GetClosestToMouse();
				if HitPart then
					v[1] = (HitPart.Position - BulletData["firepos"]).unit;
				end;
			end;

			return OldNetwork_send(Idk, Name, UniqueId, BulletData, Time);
		end;

		return OldNetwork_send(Idk, Name, ...);
    end));

end;
