%
% Processes Hue Bridge data produced by the HueDashboard app
% Initiate from requisite directory containing HueData extracts
%

clc

dirStart = pwd;

fprintf('\nAccessing data from startup directory: %s',dirStart);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of data retrieved by HueDashboard.mlapp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath(dirStart));

% Sensors
fprintf('\n\n>>> SENSORS:\n');
fName = 'allSensorsData.mat';
load(fName);
whos("-file",fName);
tableSensors = struct2table(allSensors);
noSensors = size(tableSensors);
fieldX = fieldnames(allSensors(1,1));

% Create a standard format table of Sensors
sz = [noSensors(1,2) 8];
varTypes = ["string", "string", "string", "string", "string", "double", "double","string"];
varNames = ["sensorID", "modelID", "sensorname", "productname", "type", "battery", "temp","uniqueid"];
tSensors = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
tSensors.sensorID = fieldX;
lowBattery = 0;

for i = 1:noSensors(1,2)
    try
        battery = tableSensors.(fieldX{i,1}).config.battery;
        tSensors.battery(i) = tableSensors.(fieldX{i,1}).config.battery;
        productName = tableSensors.(fieldX{i,1}).productname;
        tSensors.productname(i) = tableSensors.(fieldX{i,1}).productname;
        tSensors.modelID(i) = tableSensors.(fieldX{i,1}).modelid;
        tSensors.uniqueid(i) =  tableSensors.(fieldX{i,1}).uniqueid;
    catch
    end

    name = tableSensors.(fieldX{i,1}).name;
    tSensors.sensorname(i) = tableSensors.(fieldX{i,1}).name;
    tSensors.type(i) = tableSensors.(fieldX{i,1}).type;

    try
        temp = tableSensors.(fieldX{i,1}).state.temperature/100;
        fprintf('Sensor ID: %s - Name: %s - Product Name: %s - Battery: %d - Temp: %2.2fC\n', fieldX{i,1}, ...
            name, productName, battery, temp);
        tSensors.temp(i) = tableSensors.(fieldX{i,1}).state.temperature/100;
    catch
    end

end

% Lights
fprintf('\n\n>>> LIGHTS:\n');
fName = 'allLightsData.mat';
load(fName);
whos("-file",fName);
tableLights = struct2table(allLights);
tableLightssSwitch = rows2vars(tableLights);
noLights = size(tableLights);
fieldX = fieldnames(allLights(1,1));

% Create a standard format table of Lights
sz = [noLights(1,2) 8];
varTypes = ["string", "string", "string", "string","string","logical","logical","string"];
varNames = ["lightID", "lightname", "productname", "model", "type","reachable","on","uniqueid"];
tLights = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
tLights.lightID = fieldX;
lightsReachable = 0;
lightsOn = 0;

for i = 1:noLights(1,2)
    modelID = tableLights.(fieldX{i,1}).modelid;
    tLights.model(i) = tableLights.(fieldX{i,1}).modelid;
    productName = tableLights.(fieldX{i,1}).productname;
    tLights.productname(i) = tableLights.(fieldX{i,1}).productname;
    name = tableLights.(fieldX{i,1}).name;
    tLights.lightname(i) = tableLights.(fieldX{i,1}).name;
    tLights.type(i) = tableLights.(fieldX{i,1}).type;
    tLights.reachable(i) = tableLights.(fieldX{i,1}).state.reachable;
    tLights.uniqueid(i) = tableLights.(fieldX{i,1}).uniqueid;
    if tLights.reachable(i)
        lightsReachable = lightsReachable + 1;
    end
    tLights.on(i) = tableLights.(fieldX{i,1}).state.on;
    if tLights.on(i)
        lightsOn = lightsOn + 1;
    end
    fprintf('Light ID: %s - Name: %s - Product Name: %s - Model: %s\n', fieldX{i,1}, ...
        name, productName, modelID);
end

% Schedules
fprintf('\n\n>>> SCHEDULES:\n');
fName = 'allSchedulesData.mat';
load(fName);
whos("-file",fName);
tableSchedules = struct2table(allSchedules);
noSchedules = size(tableSchedules);
fieldX = fieldnames(allSchedules(1,1));

% Create a standard format table of Schedules
sz = [noSchedules(1,2) 6];
varTypes = ["string", "string", "string","string","datetime","datetime"];
varNames = ["scheduleID", "schedulename", "desc", "status","created","starttime"];
tSchedules = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
tSchedules.scheduleID = fieldX;
for i = 1:noSchedules(1,2)
    desc = tableSchedules.(fieldX{i,1}).description;
    tSchedules.desc(i) = tableSchedules.(fieldX{i,1}).description;
    status = tableSchedules.(fieldX{i,1}).status;
    tSchedules.status(i) = tableSchedules.(fieldX{i,1}).status;
    name = tableSchedules.(fieldX{i,1}).name;
    tSchedules.schedulename(i) = tableSchedules.(fieldX{i,1}).name;
    tSchedules.created(i) = tableSchedules.(fieldX{i,1}).created;
    try
        tSchedules.starttime(i) = tableSchedules.(fieldX{i,1}).starttime;
    catch
    end
    fprintf('Schedule ID: %s - Name: %s - Desc: %s - Status: %s\n', fieldX{i,1}, ...
        name, desc, status);
end

% Rules
fprintf('\n\n>>> RULES:\n');
fName = 'allRulesData.mat';
load(fName);
whos("-file",fName);
tableRules = struct2table(allRules);
cellsRules = struct2cell(allRules);
noRules = size(tableRules);

fieldX = fieldnames(allRules(1,1));

% Create a standard format table of Rules
sz = [noRules(1,2) 8];
varTypes = ["string", "string", "datetime", "datetime", "double", "string","string", "string"];
varNames = ["ruleID", "rulename", "created", "lasttriggered", "timestriggered", "status", "action","groupno"];
tRules = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
tRules.ruleID = fieldX;
rulesEnabled = 0;

for i = 1:noRules(1,2)
    created = tableRules.(fieldX{i,1}).created;
    tRules.created(i) = tableRules.(fieldX{i,1}).created;
    lastTriggered = tableRules.(fieldX{i,1}).lasttriggered;
    if tableRules.(fieldX{i,1}).lasttriggered ~= "none"
        tRules.lasttriggered(i) = tableRules.(fieldX{i,1}).lasttriggered;
    end
    timesTriggered = tableRules.(fieldX{i,1}).timestriggered;
    tRules.timestriggered(i) = tableRules.(fieldX{i,1}).timestriggered;
    status = tableRules.(fieldX{i,1}).status;
    if status == "enabled"
        rulesEnabled = rulesEnabled + 1;
    end
    tRules.status(i) = tableRules.(fieldX{i,1}).status;
    tRules.action(i) = tableRules.(fieldX{i,1}).actions.address;

    tRules.rulename(i) = tableRules.(fieldX{i,1}).name;

    name = tableRules.(fieldX{i,1}).name;

    try
        tRules.groupno(i)  = extractBetween(tRules.action(i),"groups/","/action");
    catch
    end

    fprintf('Rule ID: %s - Name: %s - Created: %s - Last Triggered: %s - Times Triggered: %d - Status: %s\n', fieldX{i,1}, ...
        name, created, lastTriggered, timesTriggered, status);
end

tRsorted = sortrows(tRules,"timestriggered","descend");

% Groups
fprintf('\n\n>>> GROUPS:\n');
fName = 'allGroupsData.mat';
load(fName);
whos("-file",fName);
tableGroups = struct2table(allGroups);
noGroups = size(tableGroups);
fieldX = fieldnames(allGroups(1,1));

% Create a standard format table of Groups
sz = [noGroups(1,2) 8];
varTypes = ["string", "string", "string", "double", "string","string","logical","logical"];
varNames = ["groupID", "groupname", "type", "nolights","lights","class","allon","anyon"];
tGroups = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
tGroups.groupID = fieldX;
noGroupLights = 0;
for i = 1:noGroups(1,2)
    sensors = tableGroups.(fieldX{i,1}).sensors;
    try
        lights = strjoin(tableGroups.(fieldX{i,1}).lights, ', ');
        tGroups.lights(i) = strjoin(tableGroups.(fieldX{i,1}).lights, ', ');
        x = size(tableGroups.(fieldX{i,1}).lights);
        tGroups.nolights(i) = x(1,1);
        noGroupLights = noGroupLights + x(1,1);
    catch
        lights = "none";
        tGroups.lights(i) = "none";
    end
    type = tableGroups.(fieldX{i,1}).type;
    tGroups.type(i) = tableGroups.(fieldX{i,1}).type;
    name = tableGroups.(fieldX{i,1}).name;
    tGroups.groupname(i) = tableGroups.(fieldX{i,1}).name;
    tGroups.class(i) = tableGroups.(fieldX{i,1}).class;
    tGroups.allon(i) = tableGroups.(fieldX{i,1}).state.all_on;
    tGroups.anyon(i) = tableGroups.(fieldX{i,1}).state.any_on;
    fprintf('Group ID: %s - Name: %s - Type: %s - Lights: %s\n', fieldX{i,1}, ...
        name, type, lights);
end

% Create an intersection table of Groups and Lights
sz = [noGroupLights 3];
varTypes = ["string", "string","string"];
varNames = ["groupID", "groupname" "lightID"];
itGroupslights = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
l = 0;
for i = 1:noGroups(1,2)
    if tGroups.nolights(i,1) > 0
        for j = 1:tGroups.nolights(i)
            l = l + 1;
            itGroupslights.groupID(l) = tGroups.groupID(i,1);
            itGroupslights.groupname(l) = tGroups.groupname(i,1);
            itGroupslights.lightID(l) =  ['x' tableGroups.(fieldX{i,1}).lights{j,1}];
        end
    end
end

tGroupsLights = join(itGroupslights, tLights);

% ResourceLinks
fprintf('\n\n>>> RESOURCE LINKS:\n');
fName = 'allResourceLinksData.mat';
load(fName);
whos("-file",fName);
tableResourceLinks = struct2table(allResourceLinks);
noRLs = size(tableResourceLinks);
fieldX = fieldnames(allResourceLinks(1,1));

% Create a standard format table of Resource Links
sz = [noRLs(1,2) 4];
varTypes = ["string", "string", "string", "string"];
varNames = ["rlId", "rlname", "desc", "links"];
tRlinks = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
tRlinks.rlId = fieldX;

for i = 1:noRLs(1,2)
    name = tableResourceLinks.(fieldX{i,1}).name;
    tRlinks.rlname(i) = tableResourceLinks.(fieldX{i,1}).name;
    desc = tableResourceLinks.(fieldX{i,1}).description;
    tRlinks.desc(i) = tableResourceLinks.(fieldX{i,1}).description;
    links = strjoin(tableResourceLinks.(fieldX{i,1}).links, ', ');
    tRlinks.links(i) = strjoin(tableResourceLinks.(fieldX{i,1}).links, ', ');
    fprintf('Resource Link: %s - Name: %s - Desc: %s - Links: %s\n', fieldX{i,1}, ...
        name, desc, links)

end

% Scenes
fprintf('\n\n>>> SCENES:\n');
fName = 'allScenesData.mat';
load(fName);
whos("-file",fName);
tableScenes = struct2table(allScenes);
noScenes = size(tableScenes);
fieldX = fieldnames(allScenes(1,1));

% Create a standard format table of Scenes
sz = [noScenes(1,2) 6];
varTypes = ["string", "string", "string", "datetime", "string","string"];
varNames = ["sceneID", "scenename", "type", "lastupdate", "group", "lights"];
tScenes = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
tScenes.sceneID = fieldX;

for i = 1:noScenes(1,2)
    name = tableScenes.(fieldX{i,1}).name;
    tScenes.scenename(i) = tableScenes.(fieldX{i,1}).name;
    type = tableScenes.(fieldX{i,1}).type;
    tScenes.type(i) = tableScenes.(fieldX{i,1}).type;
    lastUpdate = tableScenes.(fieldX{i,1}).lastupdated;
    tScenes.lastupdate(i) = tableScenes.(fieldX{i,1}).lastupdated;
    try
        group = tableScenes.(fieldX{i,1}).group;
        tScenes.group(i) = tableScenes.(fieldX{i,1}).group;
    catch
        group = 'n/a';
        tScenes.group(i) = 'n/a';
    end
    try
        lights = strjoin(tableScenes.(fieldX{i,1}).lights, ', ');
        tScenes.lights(i) = strjoin(tableScenes.(fieldX{i,1}).lights, ', ');
    catch
        lights = "none";
        tScenes.lights(i) = 'none';
    end

    fprintf('Scene: %s - Name: %s - Type: %s - Last Updated: %s - Group: %s - Lights: %s\n', fieldX{i,1}, ...
        name, type, lastUpdate ,group, lights);
end
srtScenes = sortrows (tScenes,"sceneID","ascend");

% Config
fprintf('\n\n>>> CONFIG:\n');
fName = 'config.mat';
load(fName);
whos("-file",fName);
fprintf('Config: Bridge name: %s\n',  ...
    config.name);
fprintf('Config: Zigbee Channel: %d\n',  ...
    config.zigbeechannel);
fprintf('Config: IP Address: %s\n',  ...
    config.ipaddress);
fprintf('Config: MAC: %s\n',  ...
    config.mac);
fprintf('Config: API Version: %s\n',  ...
    config.apiversion);
tableWhitelist = struct2table(config.whitelist);
noWhitelist = size(tableWhitelist);

fieldX = fieldnames(config.whitelist(1,1));

for i = 1:noWhitelist(1,2)
    wlName = tableWhitelist.(fieldX{i,1}).name;
    wlID = fieldX{i,1};
    wlCreated = tableWhitelist.(fieldX{i,1}).createDate;
    wlLastUsed = tableWhitelist.(fieldX{i,1}).lastUseDate;
    fprintf('Config: Whitelist ID: %s - Name: %s - Created: %s - Last Used: %s\n',  ...
        wlID, wlName, wlCreated, wlLastUsed);
end

% Capabilities - aka used vs avaible resources
fprintf('\n\n>>> CAPABILITIES (resource usage):\n');
fName = 'allCapabilitiesData.mat';
load(fName);
whos("-file",fName);
lightsAvailable = allCapabilities.lights.available;
lightsTotal = allCapabilities.lights.total;
lightsPct = (lightsTotal - lightsAvailable) * 100 / lightsTotal;
sensorsAvailable = allCapabilities.sensors.available;
sensorsTotal = allCapabilities.sensors.total;
sensorPct = (sensorsTotal - sensorsAvailable) * 100 / sensorsTotal;
groupsAvailable = allCapabilities.groups.available;
groupsTotal = allCapabilities.groups.total;
groupsPct = (groupsTotal - groupsAvailable) * 100 / groupsTotal;
scenesAvailable = allCapabilities.scenes.available;
scenesTotal = allCapabilities.scenes.total;
scenesPct = (scenesTotal - scenesAvailable) * 100 / scenesTotal;
schedulesAvailable = allCapabilities.schedules.available;
schedulesTotal = allCapabilities.schedules.total;
schedulesPct = (schedulesTotal - schedulesAvailable) * 100 / schedulesTotal;
rulesAvailable = allCapabilities.rules.available;
rulesTotal = allCapabilities.rules.total;
rulesPct = (rulesTotal - rulesAvailable) * 100 / rulesTotal;
resourcelinksAvailable = allCapabilities.resourcelinks.available;
resourcelinksTotal = allCapabilities.resourcelinks.total;
resourceLinksPct = (resourcelinksTotal - resourcelinksAvailable) * 100 / resourcelinksTotal;

fprintf('Resources: Lights - Available: %d - of Total: %d (%4.2f%% used)\n',  ...
    lightsAvailable, lightsTotal, lightsPct);
fprintf('Resources: Sensors - Available: %d - of Total: %d (%4.2f%% used)\n',  ...
    sensorsAvailable, sensorsTotal, sensorPct);
fprintf('Resources: Groups - Available: %d - of Total: %d (%4.2f%% used)\n',  ...
    groupsAvailable, groupsTotal, groupsPct);
fprintf('Resources: Scenes - Available: %d - of Total: %d (%4.2f%% used)\n',  ...
    scenesAvailable, scenesTotal, scenesPct);
fprintf('Resources: Schedules - Available: %d - of Total: %d (%4.2f%% used)\n',  ...
    schedulesAvailable, schedulesTotal, schedulesPct);
fprintf('Resources: Rules - Available: %d - of Total: %d (%4.2f%% used)\n',  ...
    rulesAvailable, rulesTotal, rulesPct);
fprintf('Resources: Resource Links - Available: %d - of Total: %d (%4.2f%% used)\n',  ...
    resourcelinksAvailable, resourcelinksTotal, resourceLinksPct);

