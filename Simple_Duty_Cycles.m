%% Disco 2 Duty cycles
clc,clear,close

average_gain_w = 8.5; % watt ind fra solcelle
average_use_w = 8; % watt brug

Orbit_time = 95.52*60;
Sunlit_time = 62.35*60;
Eclipse_time = Orbit_time-Sunlit_time;

Total_battery = 190800; % 53 watthours -> joule

Battery_iteration = [];
Battery_iteration = [Battery_iteration Total_battery];

time=[0];

Totbat=Total_battery;


% Battery_iteration = zeros(1,100000);
while Battery_iteration(end) > 0
    
    for i=1:Sunlit_time
    % Brug I dagslys
        time=[time time(end)+1];
    
        if Totbat<Total_battery
            Totbat = Battery_iteration(end) + average_gain_w / (Sunlit_time/Orbit_time) - average_use_w; 
        end
        Battery_iteration = [Battery_iteration Totbat];
    end

    for j=1:Eclipse_time
    % brug I eclipse
        Totbat = Battery_iteration(end) - average_use_w * 1.5; 
        Battery_iteration = [Battery_iteration Totbat];
        time=[time time(end)+1];
    end

    if time(end)>1E5
        disp('Max time reached')
        break;
    end

end

plot(time,Battery_iteration,LineWidth=2)

ylim([0 Total_battery])
title('DISCO 2 Power cycles')
xlabel('time [s]')
ylabel('Power [W]')
grid

fprintf('Number of powered orbits = %.2f\n',length(time)/Orbit_time)

