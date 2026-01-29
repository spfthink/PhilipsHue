classdef HueBridgeV2 < handle

    properties
        Mode
        BaseUrl
        AppKey
        HttpBackend
    end

    methods
        function obj = HueBridgeV2(varargin)

            p = inputParser;
            addParameter(p, "Mode", "real");
            addParameter(p, "BaseUrl", "");
            addParameter(p, "AppKey", "");
            parse(p, varargin{:});

            obj.Mode    = string(p.Results.Mode);
            obj.BaseUrl = string(p.Results.BaseUrl);
            obj.AppKey  = string(p.Results.AppKey);

            % Backend selection
            if obj.Mode == "mock"
                obj.HttpBackend = MockHueBackend();
            else
                obj.HttpBackend = RealHueBackend(obj.BaseUrl, obj.AppKey);
            end
        end

        % --------------------------------------------------------------
        % WRAPPER METHODS (required for App Designer)
        % --------------------------------------------------------------
        function out = getResources(obj, type)
            out = obj.HttpBackend.getResources(type);
        end

        function out = getResource(obj, type, id)
            out = obj.HttpBackend.getResource(type, id);
        end

        function out = updateResource(obj, type, id, payload)
            out = obj.HttpBackend.updateResource(type, id, payload);
        end

        function out = createResource(obj, type, payload)
            out = obj.HttpBackend.createResource(type, payload);
        end

        function deleteResource(obj, type, id)
            obj.HttpBackend.deleteResource(type, id);
        end
    end
end
