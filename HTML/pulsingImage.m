classdef pulsingImage < handle
    properties
        HtmlComp   % handle to the HTML UI component
    end

    methods
        function obj = pulsingImage(parent, imageFile, varargin)
            % Create HTML component
            obj.HtmlComp = uihtml(parent);
            obj.HtmlComp.HTMLSource = 'pulsingImage.html';

            % Default settings
            data.on = true;
            data.speed = 2.4;
            data.src = imageFile;

            % Apply overrides
            if ~isempty(varargin)
                for i = 1:2:numel(varargin)
                    data.(varargin{i}) = varargin{i+1};
                end
            end

            obj.HtmlComp.Data = data;
        end

        function setOn(obj, tf)
            obj.HtmlComp.Data.on = logical(tf);
        end

        function setSpeed(obj, s)
            obj.HtmlComp.Data.speed = s;
        end

        function setImage(obj, file)
            obj.HtmlComp.Data.src = file;
        end
    end
end