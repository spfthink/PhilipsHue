
% Supervisor script for HueDashboard.mlapp ..

restarts = 0;
while restarts < 6 % Restart max 5 times
    try
        restart = 0;
        clc
        disp('Launching HueDashboard..');
        pause(2);
        app = HueDashboard;
        uiwait(app.HueDashboardUIFigure);  % Block until app closes normally
        disp('Exit.');
        break;         % Normal exit → leave Launcher
    catch ME
        warning("App crashed: %s", ME.message);
        pause(0.5);    % Small delay to avoid tight crash loops
        restarts = restarts + 1;
        fprintf('\nRestart no. %d\n', restarts);
    end
end
