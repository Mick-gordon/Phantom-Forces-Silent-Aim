-- I Made This Open Source For People To Learn Off.
if not getgc or not getupvalue then  -- Checks If The Executor Has The Required Functions For The Script.
	game:GetService("Players").localPlayer:kick("Executor Not Supported"); -- Kicks The Player If Not.
end;
getgenv().DELETEMOB = {RunningESP = false};

local ExecutorName = identifyexecutor and string.lower(identifyexecutor()) or "unkown";
local Script = [[repeat task.wait() until game:IsLoaded()]] .. game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Phantom-Forces-Silent-Aim/refs/heads/main/ESP.lua");
local Success, Output = pcall(getfflag, "FFlagDebugRunParallelLuaOnMainThread");
local DetectionBypass = [[

    -- Need To Make.

]];
local ActorCapture = [[
    getgenv().DELETEMOB = {Actors = { }};
    local Connection;
    Connection = game.DescendantAdded:Connect(function(insance)
        if insance:IsA("Actor") then
            DELETEMOB.Actors[#DELETEMOB.Actors + 1] = insance;
        end;

        if #DELETEMOB.Actors >= 5 then
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
        repeat task.wait() until game:IsLoaded()

        if DELETEMOB and DELETEMOB.Actors then -- I Don't Trust Peoples getactos.

            repeat task.wait() until #DELETEMOB.Actors >= 5;
            warn("Loaded")
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
            queue_on_teleport(ActorCapture .. [[repeat task.wait() until game:IsLoaded()]] .. game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Phantom-Forces-Silent-Aim/refs/heads/main/ESPloader.lua"));
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

