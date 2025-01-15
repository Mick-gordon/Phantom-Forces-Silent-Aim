-- I Made This Open Source For People To Learn Off.
repeat task.wait() until game:IsLoaded()

local ExecutorName = identifyexecutor and string.lower(identifyexecutor()) or "unkown";
local Script = [[repeat task.wait() until game:IsLoaded(); task.wait(5);]] .. game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Phantom-Forces-Silent-Aim/refs/heads/main/ESP.lua");
local Success, Output = pcall(getfflag, "FFlagDebugRunParallelLuaOnMainThread");
local DetectionBypass = [[

    -- Need To Make.

]];
local ActorCapture = [[
    local Connection;
    Connection = game.DescendantAdded:Connect(function(insance)
        if insance:IsA("Actor") then
            CapturedActors[#CapturedActors + 1] = insance;
        end;

        if #CapturedActors >= 5 then
            Connection:Disconnect();
        end;
    end);
]];

-- // Actor Bypass
if not DELETEMOBESP then
    
    if Success and string.lower(tostring(Output)) == "true" then
        loadstring(Script)();
        getgenv().DELETEMOBESP = true;

    elseif string.match(ExecutorName, "awp") then
        for _,Actor in getactors() do
            run_on_actor(Actor, [[
                for _,v in getgc(true) do 
                    if type(func) == "function" and islclosure(func) and debug.getinfo(func).name == "require" and string.match(debug.getinfo(func).source, "ClientLoader") then
                        ]] .. Script ..[[
                        break;
                    end;
                end;
            ]]);
        end;
        getgenv().DELETEMOBESP = true;
        
    elseif string.match(ExecutorName, "wave") then
        run_on_actor(getdeletedactors()[1], Script)
        getgenv().DELETEMOBESP = true;

    elseif string.match(ExecutorName, "nihon") then
        for _, Actor in getactorthreads() do
            run_on_thread(Actor, [[ 
                for _,v in getgc(true) do 
                    if type(func) == "function" and islclosure(func) and debug.getinfo(func).name == "require" and string.match(debug.getinfo(func).source, "ClientLoader") then
                        ]] .. Script ..[[
                        break;
                    end;
                end;
            ]]);
        end;  
        getgenv().DELETEMOBESP = true;

    elseif run_on_actor and queue_on_teleport then
        if CapturedActors then -- I Don't Trust Peoples getactos.
            repeat task.wait() until #CapturedActors >= 5;
            
            for _,Actor in CapturedActors do
                run_on_actor(Actor, [[
                    for _,v in getgc(true) do 
                        if type(func) == "function" and islclosure(func) and debug.getinfo(func).name == "require" and string.match(debug.getinfo(func).source, "ClientLoader") then
                            ]] .. Script ..[[
                            break;
                        end;
                    end;
                ]]);
            end;
            getgenv().DELETEMOBESP = true;

        else
            queue_on_teleport([[getgenv().CapturedActors = {};]] .. ActorCapture .. game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Phantom-Forces-Silent-Aim/refs/heads/main/ESPloader.lua"));
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);
            getgenv().DELETEMOBESP = false;

        end;

    elseif getfflag then
        local Success, Output = pcall(getfflag, "RunParallelLuaOnMainThread");
        if Success and string.lower(tostring(Output)) == "true" then
            loadstring(Script)();
            getgenv().DELETEMOBESP = true;

        elseif queue_on_teleport and setfflag then
            if pcall(setfflag, "FFlagDebugRunParallelLuaOnMainThread", "True") then
                queue_on_teleport(DetectionBypass .. "task.wait(5)" .. Script);
                getgenv().DELETEMOBESP = true;
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);

            elseif pcall(setfflag, "RunParallelLuaOnMainThread", "True") then -- Some Executors Just Fake It Or Something.
                queue_on_teleport(DetectionBypass .. "task.wait(5)" .. Script);
                getgenv().DELETEMOBESP = true;
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);

            elseif pcall(setfflag, "RunParallelLuaOnMainThread", "true") then -- Got Me Tweaking.
                queue_on_teleport(DetectionBypass .. "task.wait(5)" .. Script);
                getgenv().DELETEMOBESP = true;
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);
                
            end;
        end;

    end;

end;

