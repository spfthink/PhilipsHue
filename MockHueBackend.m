classdef MockHueBackend < handle
    % Mock backend for Hue API v2, safe for App Designer use.

    properties
        Registry   % struct of resource arrays
    end

    methods
        function obj = MockHueBackend()
            % Initialise registry with all v2 resource types
            obj.Registry = struct( ...
                "light", [], ...
                "room", [], ...
                "zone", [], ...
                "device", [], ...
                "scene", [], ...
                "grouped_light", [], ...
                "motion", [], ...
                "temperature", [], ...
                "contact", [], ...
                "button", [], ...
                "device_power", [], ...
                "bridge_home", [], ...
                "behavior_script", [], ...
                "behavior_instance", [] );

            % Seed example light
            obj.Registry.light = [obj.Registry.light; struct( ...
                "id","light-1", ...
                "type","light", ...
                "metadata",struct("name","Mock Light 1"), ...
                "on",struct("on",false), ...
                "dimming",struct("brightness",50))];

            % Seed example room
            obj.Registry.room = [obj.Registry.room; struct( ...
                "id","room-1", ...
                "type","room", ...
                "metadata",struct("name","Living Room"), ...
                "children",{{struct("rid","light-1","rtype","light")}})];
        end

        % --------------------------------------------------------------
        % GET collection
        % --------------------------------------------------------------
        function out = getResources(obj, type)
            if isfield(obj.Registry, type)
                out = obj.Registry.(type);
            else
                out = [];
            end
        end

        % --------------------------------------------------------------
        % GET single
        % --------------------------------------------------------------
        function out = getResource(obj, type, id)
            arr = obj.getResources(type);
            idx = find(string({arr.id}) == id, 1);
            if isempty(idx)
                out = [];
            else
                out = arr(idx);
            end
        end

        % --------------------------------------------------------------
        % UPDATE
        % --------------------------------------------------------------
        function out = updateResource(obj, type, id, payload)
            arr = obj.getResources(type);
            idx = find(string({arr.id}) == id, 1);
            if isempty(idx)
                error("MockHueBackend:NotFound","Resource not found");
            end
            f = fieldnames(payload);
            for k = 1:numel(f)
                arr(idx).(f{k}) = payload.(f{k});
            end
            obj.Registry.(type) = arr;
            out = arr(idx);
        end

        % --------------------------------------------------------------
        % CREATE
        % --------------------------------------------------------------
        function out = createResource(obj, type, payload)
            newId = matlab.lang.internal.uuid();
            payload.id = newId;
            payload.type = type;

            obj.Registry.(type) = [obj.Registry.(type); payload];
            out = payload;
        end

        % --------------------------------------------------------------
        % DELETE
        % --------------------------------------------------------------
        function deleteResource(obj, type, id)
            arr = obj.getResources(type);
            idx = find(string({arr.id}) == id, 1);
            if isempty(idx)
                error("MockHueBackend:NotFound","Resource not found");
            end
            arr(idx) = [];
            obj.Registry.(type) = arr;
        end
    end
end
