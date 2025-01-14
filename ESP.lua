-- I Made This Open Source For People To Learn Off.
if not getgc or not getupvalue then  -- Checks If The Executor Has The Required Functions For The Script.
	game:GetService("Players").localPlayer:kick("Executor Not Supported"); -- Kicks The Player If Not.
end;
getgenv().DELETEMOB = {RunningESP = false};

local ExecutorName = identifyexecutor and string.lower(identifyexecutor()) or "unkown";
local Script = [[repeat task.wait() until game:GetService("Workspace"):FindFirstChild("Players")]] .. game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Phantom-Forces-Silent-Aim/refs/heads/main/ESP.lua");
local Success, Output = pcall(getfflag, "FFlagDebugRunParallelLuaOnMainThread");
local DetectionBypass = [[

    -- Need To Make.

]];
local ActorCapture = [[
    getgenv().DELETEMOB.Actors = { };
    local Connection;
    Connection = game.DescendantAdded:Connect(function(insance)
        if insance:IsA("Actor") then
            DELETEMOB.Actors[#DELETEMOB.Actors + 1] = insance;
        end;

        if #DELETEMOB.Actors <= 5 then
            Connection:Disconnect();
        end;
    end);
]];

-- // Actor Bypass
if not DELETEMOB.RunningESP then
    if Success and string.lower(tostring(Output)) == "true" then
        loadstring(Script)();

        DELETEMOB.RunningESP = true;
    elseif string.match(ExecutorName, "awp1") then
        for _,Actor in getactors() do
            run_on_actor(Actor, [[
                for _,v in getgc(true) do 
                    if typeof(v) == "table" and rawget(v, "require") and not rawget(v, "rawget") then 
                        ]] .. Script ..[[
                        break;
                    end;
                end;
            ]]);
        end;

        DELETEMOB.RunningESP = true;
    elseif string.match(ExecutorName, "wave") then
        run_on_actor(getdeletedactors()[1], Script)

        DELETEMOB.RunningESP = true;
    elseif string.match(ExecutorName, "nihon") then
        for _, Actor in getactorthreads() do
            run_on_thread(Actor, [[ 
                for _,v in getgc(true) do 
                    if typeof(v) == "table" and rawget(v, "require") and not rawget(v, "rawget") then 
                        ]] .. Script ..[[
                        break;
                    end;
                end;
            ]]);
        end;

        DELETEMOB.RunningESP = true;
    elseif run_on_actor and queue_on_teleport then
        if DELETEMOB and DELETEMOB.Actors and #DELETEMOB.Actors ~= 0 then -- I Don't Trust Peoples getactos.
            for _,Actor in DELETEMOB.Actors do
                run_on_actor(Actor, [[
                    for _,v in getgc(true) do 
                        if typeof(v) == "table" and rawget(v, "require") and not rawget(v, "rawget") then 
                            ]] .. Script ..[[
                            break;
                        end;
                    end;
                ]]);
            end;

        else
            queue_on_teleport(ActorCapture);
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);

        end;

        DELETEMOB.RunningESP = true;
    elseif getfflag and setfflag and queue_on_teleport then
        local Success, Output = pcall(getfflag, "RunParallelLuaOnMainThread");
        if (Success and string.lower(tostring(Output)) == "true") then
            loadstring(Script)();

        else
            if pcall(setfflag, "FFlagDebugRunParallelLuaOnMainThread", "True") then
                queue_on_teleport(DetectionBypass .. "task.wait(5)" .. Script);
                DELETEMOB.RunningESP = true;
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);

            elseif pcall(setfflag, "RunParallelLuaOnMainThread", "True") then -- Some Executors Just Fake It Or Something.
                queue_on_teleport(DetectionBypass .. "task.wait(5)" .. Script);
                DELETEMOB.RunningESP = true;
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);

            elseif pcall(setfflag, "RunParallelLuaOnMainThread", "true") then -- Got Me Tweaking.
                queue_on_teleport(DetectionBypass .. "task.wait(5)" .. Script);
                DELETEMOB.RunningESP = true;
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);

            end;
        end;

    end;

    if not DELETEMOB.RunningESP then -- If This Shit Dosent Then U Got A Nigga Executor. 
        game:GetService("Players").LocalPlayer:Kick("Executor Is Not Supported End.");
    end;
end;

local ESP = { 
	Enabled = false,
	Box = false,
	Tracer = false,
	Health = false,
	Name = false,
	Gun = false,
};

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = game:GetService("Workspace").CurrentCamera;
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Drawings = { };
local ListYSize = 40;

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

end;

if not Modules.ReplicationInterface then
	LocalPlayer:Kick('Check If You Have "FFlagDebugRunParallelLuaOnMainThread" "True"');
end;

--// Functions
local Functions = { };
do

	function Functions:Draw(Type, Properties, IsESP)
		local Drawing = Drawing.new(Type);

		for Prop, Value in Properties do
			Drawing[Prop] = Value;
		end;

		if not IsESP then -- So We Dont Move The ESP.
			Drawings[#Drawings + 1] = Drawing;
		end;

		return Drawing;
	end;

	function Functions:IsMouseOver(Drawing)
		if UserInputService:GetMouseLocation().X >= Drawing.Position.X and UserInputService:GetMouseLocation().Y >= Drawing.Position.Y then
			if UserInputService:GetMouseLocation().X <= Drawing.Position.X + Drawing.Size.X and UserInputService:GetMouseLocation().Y <= Drawing.Position.Y + Drawing.Size.Y then
				return true;
			end;
		end;

		return false;
	end;

end;

--// ESP
do

	function ESP:AddPlayer(Player, Entry)
		local Connection;
		local BoxOutline = Functions:Draw("Square", {Visible = false, Filled = false, Transparency = 1, Color = Color3.fromRGB(0, 0, 0), Thickness = 2}, true);
		local Box = Functions:Draw("Square", {Visible = false, Filled = false, Transparency = 1, Color = Color3.fromRGB(255, 255, 255), Thickness = 1}, true);
		local TracerOutline = Functions:Draw("Line", {Visible = false, Thickness = 2, Transparency = 1, Color = Color3.fromRGB(0, 0, 0)}, true);
		local Tracer = Functions:Draw("Line", {Visible = false, Thickness = 1, Transparency = 1, Color = Color3.fromRGB(255, 255, 255)}, true);
		local HealthBarOutline = Functions:Draw("Square", {Visible = false, Filled = true, Transparency = 1, Color = Color3.fromRGB(0, 0, 0)}, true);
		local HealthBar = Functions:Draw("Square", {Visible = false, Filled = true, Transparency = 1, Color = Color3.fromRGB(0, 255, 0)}, true);
		local Name = Functions:Draw("Text", {Visible = false, Text = Player.Name, Font = 0, Size = 12, Color = Color3.fromRGB(255, 255, 255), Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0), Center = true}, true);
		local Gun = Functions:Draw("Text", {Visible = false, Text = Player.Name, Font = 0, Size = 12, Color = Color3.fromRGB(255, 255, 255), Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0), Center = true}, true);
		
		local function Hide()
			BoxOutline.Visible = false;
			Box.Visible = false;
			TracerOutline.Visible = false;
			Tracer.Visible = false;
			HealthBarOutline.Visible = false;
			HealthBar.Visible = false;
			Name.Visible = false;
			Gun.Visible = false;
		end;

		local function Destroy()
			BoxOutline:Remove();
			Box:Remove();
			TracerOutline:Remove();
			Tracer:Remove();
			HealthBarOutline:Remove();
			HealthBar:Remove();
			Name:Remove();
			Gun:Remove();
			Connection:Disconnect();
		end;

		Connection = RunService.Heartbeat:Connect(function()
			
			if not ESP.Enabled then
				return Hide();
			end;
			
			if not Player or not Entry then
				return Destroy();
			end;

			if Player.Team == LocalPlayer.Team then
				return Hide();
			end;

			if not Entry._alive or not Entry._thirdPersonObject or not Entry._thirdPersonObject._rootPart then
				return Hide();
			end;

			local ScreenPosition, OnScreen = CurrentCamera:WorldToViewportPoint(Entry._thirdPersonObject._rootPart.Position);
			if ScreenPosition.Z <= 0 then 
				return Hide();
			end;

			local FrustumHeight = math.tan(math.rad(CurrentCamera.FieldOfView * 0.5)) * 2 * ScreenPosition.Z; 
			local Size = CurrentCamera.ViewportSize.Y / FrustumHeight * Vector2.new(5,6);
			local Position = Vector2.new(ScreenPosition.X, ScreenPosition.Y) - (Size / 2 - Vector2.new(0, Size.Y) / 20);
			local TopTextY = (ScreenPosition.Y - (Size.Y + Name.TextBounds.Y + 19) / 2);
			local BottomTextY = (ScreenPosition.Y + (Size.Y + Gun.TextBounds.Y + 19) / 2);
			
			BoxOutline.Visible = ESP.Box;
			Box.Visible = ESP.Box;
			if BoxOutline.Visible then
				BoxOutline.Position = Position;
				BoxOutline.Size = Size;
				
				Box.Position = Position;
				Box.Size = Size;
			end;
			
			TracerOutline.Visible = ESP.Tracer;
			Tracer.Visible = ESP.Tracer;
			if TracerOutline.Visible then
				TracerOutline.To = Vector2.new(ScreenPosition.X, ScreenPosition.Y + Size.Y/2);
				TracerOutline.From = Vector2.new(CurrentCamera.ViewportSize.X/2, CurrentCamera.ViewportSize.Y);
				
				Tracer.To = TracerOutline.To;
				Tracer.From = TracerOutline.From;
			end;
			
			HealthBarOutline.Visible = ESP.Health;
			HealthBar.Visible = ESP.Health;
			if HealthBarOutline.Visible then
				HealthBarOutline.Size = Vector2.new(4, Size.Y);
				HealthBarOutline.Position = Vector2.new(ScreenPosition.X - Size.X / 2 - 6, Position.Y);
				HealthBar.Size = Vector2.new(2, -Size.Y * (math.floor(Entry:getHealth()) / 100));
				HealthBar.Position = Vector2.new(HealthBarOutline.Position.X + 1, Position.Y + Size.Y);
			end;
			
			Name.Visible = ESP.Name;
			if Name.Visible then
				Name.Position = Vector2.new(ScreenPosition.X, TopTextY);
			end;
			
			Gun.Visible = ESP.Gun;
			if Gun.Visible then
				Gun.Text = Entry._thirdPersonObject._weaponName;
				Gun.Position = Vector2.new(ScreenPosition.X, BottomTextY);
			end;
			
		end);

	end;
	
	Modules.ReplicationInterface.operateOnAllEntries(function(Player, Entry)
		ESP:AddPlayer(Player, Entry);
	end);
	
	Players.PlayerAdded:Connect(function(NewPlayer) 
		task.wait(2);
		Modules.ReplicationInterface.operateOnAllEntries(function(Player, Entry) -- They Updated getEnty() I Don't Think It Returns Everything. - I Diden't Check.
			if NewPlayer == Player then
				ESP:AddPlayer(Player, Entry);
			end;
		end);
	end);

end;

-- // GUI (I Made It External If The Drawing Libary Is In C++. (I Thought It Would Be Fun.))
do
	
	local Background = Functions:Draw("Square", {Visible = true, Filled = true, Color = Color3.fromRGB(52, 52, 52), Size = Vector2.new(241, 248), Position = CurrentCamera.ViewportSize/2 - Vector2.new(241, 248)/2, Transparency = 1, ZIndex = 10}); -- ZIndex Is At 10 Just Incase You Are Using ESP.
	local Outline = Functions:Draw("Square", {Visible = true, Filled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Size = Background.Size, Position = Background.Position, Transparency = 1, ZIndex = 10});
	local Enable = Functions:Draw("Square", {Visible = true, Filled = true, Color = Color3.fromRGB(52, 52, 52), Size = Vector2.new(122, 24), Position = Background.Position + Vector2.new(Background.Size.X/2 - 61, ListYSize), Transparency = 1, ZIndex = 10}); ListYSize = ListYSize + 29;
	local EnableText = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Enable.Position + Enable.Size/2 - Vector2.new(0, 8.5), Text = "Enable", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false}); 
	local EnableOutline = Functions:Draw("Square", {Visible = true, Filled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Size = Enable.Size, Position = Enable.Position, Transparency = 1, ZIndex = 10});
	local Box = Functions:Draw("Square", {Visible = true, Filled = true, Color = Color3.fromRGB(52, 52, 52), Size = Vector2.new(122, 24), Position = Background.Position + Vector2.new(Background.Size.X/2 - 61, ListYSize), Transparency = 1, ZIndex = 10}); ListYSize = ListYSize + 29;
	local BoxkText = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Box.Position + Box.Size/2 - Vector2.new(0, 8.5), Text = "Box", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false}); 
	local BoxOutline = Functions:Draw("Square", {Visible = true, Filled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Size = Box.Size, Position = Box.Position, Transparency = 1, ZIndex = 10});
	local Tracer = Functions:Draw("Square", {Visible = true, Filled = true, Color = Color3.fromRGB(52, 52, 52), Size = Vector2.new(122, 24), Position = Background.Position + Vector2.new(Background.Size.X/2 - 61, ListYSize), Transparency = 1, ZIndex = 10}); ListYSize = ListYSize + 29;
	local TracerText = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Tracer.Position + Tracer.Size/2 - Vector2.new(0, 8.5), Text = "Tracer", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false});
	local Tracerutline = Functions:Draw("Square", {Visible = true, Filled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Size = Tracer.Size, Position = Tracer.Position, Transparency = 1, ZIndex = 10});
	local Name = Functions:Draw("Square", {Visible = true, Filled = true, Color = Color3.fromRGB(52, 52, 52), Size = Vector2.new(122, 24), Position = Background.Position + Vector2.new(Background.Size.X/2 - 61, ListYSize), Transparency = 1, ZIndex = 10}); ListYSize = ListYSize + 29;
	local NameText = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Name.Position + Name.Size/2 - Vector2.new(0, 8.5), Text = "Name", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false});
	local NameOutline = Functions:Draw("Square", {Visible = true, Filled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Size = Name.Size, Position = Name.Position, Transparency = 1, ZIndex = 10});
	local Health = Functions:Draw("Square", {Visible = true, Filled = true, Color = Color3.fromRGB(52, 52, 52), Size = Vector2.new(122, 24), Position = Background.Position + Vector2.new(Background.Size.X/2 - 61, ListYSize), Transparency = 1, ZIndex = 10}); ListYSize = ListYSize + 29;
	local HealthText = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Health.Position + Health.Size/2 - Vector2.new(0, 8.5), Text = "Health Bar", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false});
	local HealthOutline = Functions:Draw("Square", {Visible = true, Filled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Size = Health.Size, Position = Health.Position, Transparency = 1, ZIndex = 10});
	local Gun = Functions:Draw("Square", {Visible = true, Filled = true, Color = Color3.fromRGB(52, 52, 52), Size = Vector2.new(122, 24), Position = Background.Position + Vector2.new(Background.Size.X/2 - 61, ListYSize), Transparency = 1, ZIndex = 10}); ListYSize = ListYSize + 29;
	local GunText = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Gun.Position + Gun.Size/2 - Vector2.new(0, 8.5), Text = "Gun", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false});
	local GunOutline = Functions:Draw("Square", {Visible = true, Filled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Size = Gun.Size, Position = Gun.Position, Transparency = 1, ZIndex = 10});
	local NameD = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Background.Position + Vector2.new(Background.Size.X/2, 15) - Vector2.new(0, 8.5), Text = "DELETEMOB | PF ESP", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false}); 
	local Discord = Functions:Draw("Text", {Visible = true, Size = 17, Center = true, Position = Background.Position + Vector2.new(Background.Size.X/2, Background.Size.Y - 25.5), Text = "https://discord.gg/FsApQ7YNTq", Color = Color3.fromRGB(255, 255, 255), Font = 0, ZIndex = 10, Outline = false}); 

	-- // GUI Interactions
	local Dragging, StartPos;
	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 and Background.Visible then
			if Functions:IsMouseOver(Background) then 
				Dragging = true;
				StartPos = UserInputService:GetMouseLocation();
			end
			if Functions:IsMouseOver(Enable) then 
                setclipboard(Enable.Color)
				if ESP.Enabled then
					ESP.Enabled = false;
					Enable.Color = Color3.fromRGB(52, 52, 52);
				else
					ESP.Enabled = true;
					Enable.Color = Color3.fromRGB(2, 54, 8);
				end;
			elseif Functions:IsMouseOver(Box) then
				if ESP.Box then
					ESP.Box = false;
					Box.Color = Color3.fromRGB(52, 52, 52);
				else
					ESP.Box = true;
					Box.Color = Color3.fromRGB(2, 54, 8);
				end;
			elseif Functions:IsMouseOver(Tracer) then
				if ESP.Tracer then
					ESP.Tracer = false;
					Tracer.Color = Color3.fromRGB(52, 52, 52);
				else
					ESP.Tracer = true;
					Tracer.Color = Color3.fromRGB(2, 54, 8);
				end;
			elseif Functions:IsMouseOver(Name) then 
				if ESP.Name then
					ESP.Name = false;
					Name.Color = Color3.fromRGB(52, 52, 52);
				else
					ESP.Name = true;
					Name.Color = Color3.fromRGB(2, 54, 8);
				end;
			elseif Functions:IsMouseOver(Health) then
				if ESP.Health then
					ESP.Health = false;
					Health.Color = Color3.fromRGB(52, 52, 52);
				else
					ESP.Health = true;
					Health.Color = Color3.fromRGB(2, 54, 8);
				end;
			elseif Functions:IsMouseOver(Gun) then
				if ESP.Gun then
					ESP.Gun = false;
					Gun.Color = Color3.fromRGB(52, 52, 52);
				else
					ESP.Gun = true;
					Gun.Color = Color3.fromRGB(2, 54, 8);
				end;
			end;
		elseif Input.KeyCode == Enum.KeyCode.RightShift then
			if Background.Visible then
				for i = 1, #Drawings do
					Drawings[i].Visible = false;
				end;
			else
				for i = 1, #Drawings do
					Drawings[i].Visible = true;
				end;
			end;
		end;
	end);

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then -- To Stop Dragging The UI
			Dragging = false;
		end;
	end);

	UserInputService.InputChanged:Connect(function() -- To Drag The UI
		if Dragging and Background.Visible then
			local Distance = StartPos - UserInputService:GetMouseLocation();
			for i = 1, #Drawings do -- Make Sure We Move Everything
				Drawings[i].Position = Drawings[i].Position - Distance;
				StartPos = UserInputService:GetMouseLocation();
			end;
		end;
	end);
	
end;
