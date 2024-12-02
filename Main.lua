repeat task.wait() until game:IsLoaded() and game.GameId ~= 0; -- Makes Sure The Game Is Loaded.

if not setfflag or not getfflag or not hookfunction or not newcclosure and not queue_on_teleport then -- Check If The Executor Is Supported
    game:GetService("Players").LocalPlayer:Kick("Executor Is Not Suported!");
end;

if getfflag("DebugRunParallelLuaOnMainThread") ~= true then -- Check If They Have This Fflag
    setfflag("DebugRunParallelLuaOnMainThread", "True"); -- Phantom Forces Basicaly Runs The Game On A Actor And Using "DebugRunParallelLuaOnMainThread" Will Bypass That And I Will Not Need To Use run_on_actor or run_on_thread.
    queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Phantom-Forces-Silent-Aim/refs/heads/main/Main.lua", true)); -- When The Player TP It Will Load The Script Again.
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId); -- Rejoin The Game 
   
    wait(4)
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
    pcall(function()
        -- BulletObject.new
        local OldBulletObject_new; OldBulletObject_new = hookfunction(Modules.BulletObject.new, newcclosure(function(...) -- Hooks The Function. No Way.
            local Args = {...}; -- No Need For This As It Is A Table Already.
            local HitPart = Functions:GetClosestToMouse(); -- Gets The Closest To The Mouse.
            
            if HitPart and Args[1]["extra"] and SilentAim.Enabled then -- Check If We Have A Target, If Silent Aim Is Enabled And It Is The Local Player Sending The Bullet.
                Args[1]["velocity"] = (HitPart.Position - Args[1]["position"]).unit * Args[1]["extra"]["firearmObject"]:getWeaponStat("bulletspeed"); -- LookVector * MuzzleVelocity (This Dose Not Account For Bullet Drop!).
            end;
            
            return OldBulletObject_new(table.unpack(Args)); -- Send The Table Back 
        end));
        
        -- NetworkClient.send
        local OldNetwork_send;OldNetwork_send = hookfunction(Modules.NetworkClient.send, newcclosure(function(Idk, Name, ...) -- Wait No Way It Hooks The Function Like hookfunction From The Functions In The Executor From hookfunction. 
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
        end));
    end);

end;


-- If You Have Any Questions Ask Dm Me On Discord "m1ckgordon" My User Also Join My Discord Where I Will Update DeleteMob (Sometime When I Feel Like It) "https://discord.gg/vgXSSeKAb6".

-- You Have Made It To The End !!! Hope You Have Enjoyed Reading This Like 1 Out Of 1000 People Will See This. 
