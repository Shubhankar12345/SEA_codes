clc;
close all;
clear;
%% Transparency
R = 0.035 ; % Pulley radius
r = 1 ; % Gear ratio
alpha = [1.2,1.8] ; % Pole placement parameter
k_s = [100,1000,10000,575] ; % spring constant
dgl = 0.01 ;
% Jm = 6.3e-06 ; % Motor inertia
% Bm = 1e-4 ; % Motor damping
% Jg = 1.1200e-06 ; % Gearbox inertia
% Bg = 0.01 ; % Gearbox damping
Jeq = 6.3e-04 ; % Equivalent inertia based on WALKMAN actuator
Beq = 0.5 ; % Equivalent damping based on WALKMAN actuator
lambda = 1 ; % feedforward
s = tf('s') ;
s2 = string([]) ;
kp = [] ; kd = [] ;
k = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
    for j = 1:length(alpha)
        wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
        w0 = alpha(:,j)*wn ;
        kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
        % kp = 0.0011 ;
        kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
        % kd = 0.00011 ;
        C = kp(:,k) + kd(:,k)*s ;
        transparency_TF(:,k) = tf([-Jeq*k_s(:,i) -Beq*k_s(:,i) 0],[Jeq (Beq+ ... 
                kd(:,k)*k_s(:,i)*r) k_s(:,i)*(lambda+kp(:,k))*r]);
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        if(j == 1)
            z = strcat(x1,'-') ;
        else
           z = strcat(x1,'--') ;
        end
        hold on ;
        bodemag(transparency_TF(:,k),z,options) ;
        s2(:,k) = strcat('$k_{s} =', ' ', num2str(k_s(:,i)), ' (K_{p} =',' ',num2str(kp(:,k)),')', ' ', '(K_{d} =',' ',num2str(kd(:,k)),')$') ;
        legend(s2,'Location','Southeast') ;
        legend(s2,'Interpreter','Latex') ;
        legend(s2,'FontSize',10);
        k = k+1 ;
    end
end 
% Get the axes handle
ax = gca;

% Find all line objects in the Bode plot
lines = findall(ax, 'Type', 'line');

% Set the line width for all lines
set(lines, 'LineWidth', 2);  % Set line width to 2
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '10'; % Figure width on canvas
figure_property.Height= '6'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA transparency.pdf',figure_property); %Set desired file name
%% Torque tracking
s1 = string([]) ;
kp = [] ; kd = [] ; k = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ;
    end
    for j = 1:length(alpha)
        wn(:,k) = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
        w0(:,k) = alpha(:,j)*wn(:,k) ;
        kp(:,k) = (Jeq*w0(:,k)^2)/(k_s(:,i)*r) - 1 ; % PID proportional
        % kp = 0.0011 ;
        kd(:,k) = (2*Jeq*w0(:,k) - Beq)/k_s(:,i)*r ; % PID derivative
        % kd = 0.00011 ;
        C = kp(:,k) + kd(:,k)*s ;
        torque_TF(:,k) = tf([k_s(:,i)*r*kd(:,k) k_s(:,i)*r* ...
        (lambda + kp(:,k))],[Jeq (Beq+kd(:,k)*k_s(:,i)*r)  ...
        k_s(:,i)*(lambda+kp(:,k))*r]);
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        if(j == 1)
            z = strcat(x1,'-') ;
        else
           z = strcat(x1,'--') ;
        end
        hold on ;
        bodemag(torque_TF(:,k),z,options) ;
        s1(:,k) = strcat('$k_{s} =', ' ', num2str(k_s(:,i)), '(K_{p} =',' ',num2str(kp(:,k)),')', '(K_{d} =',' ',num2str(kd(:,k)),')$') ;
        legend(s1,'Location','Southwest') ;
        legend(s1,'Interpreter','Latex');
        legend(s1,'FontSize',12);
        k = k+1 ;
    end
end
% Get the axes handle
ax = gca;

% Find all line objects in the Bode plot
lines = findall(ax, 'Type', 'line');

% Set the line width for all lines
set(lines, 'LineWidth', 2);  % Set line width to 2
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '10'; % Figure width on canvas
figure_property.Height= '6'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA torque tracking.pdf',figure_property); %Set desired file name
%% Motor power
s3 = string([]) ;
kp = [] ; kd = [] ; k = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ;
    end
%     for j = 1:length(alpha)
%         wn(:,k) = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%         w0(:,k) = alpha(:,j)*wn ;
%         kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%         % kp = 0.0011 ;
%         kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
        % kd = 0.00011 ;
%         C = kp(:,k) + kd(:,k)*s ;
        motor_power_TF(:,i) = tf([Jeq (Beq) k_s(:,i)],[k_s(:,i)*r]);
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%         if(j == 1)
%             z = strcat(x1,'-') ;
%         else
%            z = strcat(x1,'--') ;
%         end
        hold on ;
        bodemag(motor_power_TF(:,i),x1,options) ;
        s3(:,k) = strcat('k_s =', ' ', num2str(k_s(:,i))) ;
        legend(s3,'Location','Northwest') ;
        k = k+1 ;
%     end
end
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '12'; % Figure width on canvas
figure_property.Height= '6'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA motor power1.pdf',figure_property); %Set desired file name
%% Impedance rendering
K_virt = 1000 ;
D_virt = 20 ;
s4 = string([]) ;
kp = [] ; kd = [] ; k = 1 ;
alpha = 1.2 ;
k_s = [100,10000,575] ;
reference_impedance_TF = -(K_virt + D_virt*s) ;
figno = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'b' ;
    else
        x1 = 'r' ;
    end
    wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
    w0 = alpha*wn ;
    kp(:,i) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
    % kp = 0.0011 ;
    kd(:,i) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
    % kd = 0.00011 ;
%         C = kp(:,i) + kd(:,i)*s ;
    Z(:,i) = tf([-k_s(:,i)*(Jeq + kd(:,i)*D_virt) -k_s(:,i)*(Beq + ... 
        K_virt*kd(:,i)+(kp(:,i)+1)*D_virt) -k_s(:,i)*K_virt*(kp(:,i) +  ...
        1)],[Jeq (Beq + kd(:,i)*k_s(:,i)*r) k_s(:,i)*(lambda+kp(:,i))*r]) ;
    if(figno == 1)
        fig1 = figure('Name','low stiffness') ;
        z = strcat('k','--') ;
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        bodemag(reference_impedance_TF,z,options) ;
        hold on;
        bodemag(Z(:,i),x1,options) ;
        hold on;
        bodemag(torque_TF(:,i),'m',options) ;
        hold on;
        bodemag(transparency_TF(:,i),'g',options) ; 
        legend('reference','rendered_impedance','torque tracking', ...
        'transparency','Location','northwest','Orientation','vertical') ;
        figure_property.units = 'inches';
        figure_property.format = 'pdf';
        figure_property.Preview= 'none';   
        figure_property.Width= '8'; % Figure width on canvas
        figure_property.Height= '4'; % Figure height on canvas
        figure_property.Units= 'inches';
        figure_property.Color= 'rgb';
        figure_property.Background= 'w';
        figure_property.FixedfontSize= '12';
        figure_property.ScaledfontSize= 'auto';
        figure_property.FontMode= 'scaled';
        figure_property.FontSizeMin= '12';
        figure_property.FixedLineWidth= '1';
        figure_property.ScaledLineWidth= 'auto';
        figure_property.LineMode= 'none';
        figure_property.LineWidthMin= '0.1';
        figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
        figure_property.FontWeight= 'auto';
        figure_property.FontAngle= 'auto';
        figure_property.FontEncoding= 'latin1';
        figure_property.PSLevel= '3';
        figure_property.Renderer= 'painters';
        figure_property.Resolution= '600';
        figure_property.LineStyleMap= 'none';
        figure_property.ApplyStyle= '0';
        figure_property.Bounds= 'tight';
        figure_property.LockAxes= 'off';
        figure_property.LockAxesTicks= 'off';
        figure_property.ShowUI= 'off';
        figure_property.SeparateText= 'off';
        chosen_figure=gcf;
        set(chosen_figure,'PaperUnits','inches');
        set(chosen_figure,'PaperPositionMode','auto');
        set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
        set(chosen_figure,'Units','inches');
        hgexport(gcf,'SEA impedance rendering low stiffness.pdf',figure_property); %Set desired file name
    elseif(figno == 2)
        fig2 = figure('Name','High stiffness') ;
        z = strcat('k','--') ;
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        bodemag(reference_impedance_TF,z,options) ;
        hold on;
        bodemag(Z(:,i),x1,options) ;
        hold on;
        bodemag(torque_TF(:,i),'m',options) ;
        hold on;
        bodemag(transparency_TF(:,i),'g',options) ;
        legend('reference','rendered_impedance','torque tracking', ...
        'transparency','Location','northwest','Orientation','vertical') ;
        figure_property.units = 'inches';
        figure_property.format = 'pdf';
        figure_property.Preview= 'none';   
        figure_property.Width= '8'; % Figure width on canvas
        figure_property.Height= '4'; % Figure height on canvas
        figure_property.Units= 'inches';
        figure_property.Color= 'rgb';
        figure_property.Background= 'w';
        figure_property.FixedfontSize= '12';
        figure_property.ScaledfontSize= 'auto';
        figure_property.FontMode= 'scaled';
        figure_property.FontSizeMin= '12';
        figure_property.FixedLineWidth= '1';
        figure_property.ScaledLineWidth= 'auto';
        figure_property.LineMode= 'none';
        figure_property.LineWidthMin= '0.1';
        figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
        figure_property.FontWeight= 'auto';
        figure_property.FontAngle= 'auto';
        figure_property.FontEncoding= 'latin1';
        figure_property.PSLevel= '3';
        figure_property.Renderer= 'painters';
        figure_property.Resolution= '600';
        figure_property.LineStyleMap= 'none';
        figure_property.ApplyStyle= '0';
        figure_property.Bounds= 'tight';
        figure_property.LockAxes= 'off';
        figure_property.LockAxesTicks= 'off';
        figure_property.ShowUI= 'off';
        figure_property.SeparateText= 'off';
        chosen_figure=gcf;
        set(chosen_figure,'PaperUnits','inches');
        set(chosen_figure,'PaperPositionMode','auto');
        set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
        set(chosen_figure,'Units','inches');
        hgexport(gcf,'SEA impedance rendering high stiffness.pdf',figure_property); %Set desired file name
    else
        fig3 = figure('Name','Selected stiffness') ;
        z = strcat('k','--') ;
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        bodemag(reference_impedance_TF,z,options) ;
        hold on;
        bodemag(Z(:,i),x1,options) ;
        hold on;
        bodemag(torque_TF(:,i),'m',options) ;
        hold on;
        bodemag(transparency_TF(:,i),'g',options) ;
        legend('reference','rendered_impedance','torque tracking', ...
        'transparency','Location','northwest','Orientation','vertical') ;
        figure_property.units = 'inches';
        figure_property.format = 'pdf';
        figure_property.Preview= 'none';   
        figure_property.Width= '8'; % Figure width on canvas
        figure_property.Height= '4'; % Figure height on canvas
        figure_property.Units= 'inches';
        figure_property.Color= 'rgb';
        figure_property.Background= 'w';
        figure_property.FixedfontSize= '12';
        figure_property.ScaledfontSize= 'auto';
        figure_property.FontMode= 'scaled';
        figure_property.FontSizeMin= '12';
        figure_property.FixedLineWidth= '1';
        figure_property.ScaledLineWidth= 'auto';
        figure_property.LineMode= 'none';
        figure_property.LineWidthMin= '0.1';
        figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
        figure_property.FontWeight= 'auto';
        figure_property.FontAngle= 'auto';
        figure_property.FontEncoding= 'latin1';
        figure_property.PSLevel= '3';
        figure_property.Renderer= 'painters';
        figure_property.Resolution= '600';
        figure_property.LineStyleMap= 'none';
        figure_property.ApplyStyle= '0';
        figure_property.Bounds= 'tight';
        figure_property.LockAxes= 'off';
        figure_property.LockAxesTicks= 'off';
        figure_property.ShowUI= 'off';
        figure_property.SeparateText= 'off';
        chosen_figure=gcf;
        set(chosen_figure,'PaperUnits','inches');
        set(chosen_figure,'PaperPositionMode','auto');
        set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
        set(chosen_figure,'Units','inches');
        hgexport(gcf,'SEA impedance rendering selected stiffness.pdf',figure_property); %Set desired file name
    end
    k = k + 1 ;
    figno = figno + 1 ;
end
%% Open-loop analysis Position transfer function 
Jl = 0.4 ;
Bl = 0.15 ;
s2 = string([]) ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Position_TF(:,i) = tf([2*k_s(:,i)*R^2],[Jl Bl 2*k_s(:,i)*R^2]);
%     options = bodeoptions;
%     options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
%     bodemag(transparency_TF(:,k),x1,options) ;
    step(Position_TF(:,i)) ;
    s2(:,i) = strcat('$k_s = ', ' ', num2str(k_s(:,i)),'$') ;
    leg1 = legend(s2,'Location','Southeast')  ;
    set(leg1,'Interpreter','latex') ;
%     end
end 
return 
% figure_property.units = 'inches';
% figure_property.format = 'pdf';
% figure_property.Preview= 'none';   
% figure_property.Width= '8'; % Figure width on canvas
% figure_property.Height= '4'; % Figure height on canvas
% figure_property.Units= 'inches';
% figure_property.Color= 'rgb';
% figure_property.Background= 'w';
% figure_property.FixedfontSize= '12';
% figure_property.ScaledfontSize= 'auto';
% figure_property.FontMode= 'scaled';
% figure_property.FontSizeMin= '12';
% figure_property.FixedLineWidth= '1';
% figure_property.ScaledLineWidth= 'auto';
% figure_property.LineMode= 'none';
% figure_property.LineWidthMin= '0.1';
% figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
% figure_property.FontWeight= 'auto';
% figure_property.FontAngle= 'auto';
% figure_property.FontEncoding= 'latin1';
% figure_property.PSLevel= '3';
% figure_property.Renderer= 'painters';
% figure_property.Resolution= '600';
% figure_property.LineStyleMap= 'none';
% figure_property.ApplyStyle= '0';
% figure_property.Bounds= 'tight';
% figure_property.LockAxes= 'off';
% figure_property.LockAxesTicks= 'off';
% figure_property.ShowUI= 'off';
% figure_property.SeparateText= 'off';
% chosen_figure=gcf;
% set(chosen_figure,'PaperUnits','inches');
% set(chosen_figure,'PaperPositionMode','auto');
% set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
% set(chosen_figure,'Units','inches');
% hgexport(gcf,'SEA position open loop.pdf',figure_property); %Set desired file name
s2 = string([]) ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Position_TF(:,i) = tf([2*k_s(:,i)*R^2],[Jl Bl 2*k_s(:,i)*R^2]);
%     options = bodeoptions;
%     options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
%     bodemag(transparency_TF(:,k),x1,options) ;
    pzmap(Position_TF(:,i)) ;
    s2(:,i) = strcat('k_s = ', ' ', num2str(k_s(:,i))) ;
    legend(s2,'Location','Southeast') ;
%     end
end 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA position pzmap.pdf',figure_property); %Set desired file name
s2 = string([]) ;
r = [1,10,100,200] ;
k_s = 575 ;
for i = 1:length(r)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Position_TF(:,i) = tf([2*k_s*R^2],[Jl*r(:,i) Bl*r(:,i) 2*k_s*R^2*r(:,i)]);
%     options = bodeoptions;
%     options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
%     bodemag(transparency_TF(:,k),x1,options) ;
    step(Position_TF(:,i)) ;
    s2(:,i) = strcat('r = ', ' ', num2str(r(:,i))) ;
    legend(s2,'Location','Northeast') ;
%     end
end 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA position gear ratio.pdf',figure_property); %Set desired file name
s2 = string([]) ;
r = [1,10,100,200] ;
k_s = 575 ;
for i = 1:length(r)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Position_TF(:,i) = tf([2*k_s*R^2],[Jl*r(:,i) Bl*r(:,i) 2*k_s*R^2*r(:,i)]);
%     options = bodeoptions;
%     options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
%     bodemag(transparency_TF(:,k),x1,options) ;
    pzmap(Position_TF(:,i)) ;
    s2(:,i) = strcat('r = ', ' ', num2str(r(:,i))) ;
    legend(s2,'Location','Northeast') ;
%     end
end 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA position pz map gear ratio.pdf',figure_property); %Set desired file name
s2 = string([]) ;
k_s = [100, 1000, 10000, 575] ;
r = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Position_TF(:,i) = tf([2*k_s(:,i)*R^2],[Jl Bl 2*k_s(:,i)*R^2]);
    options = bodeoptions;
    options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
    bode(Position_TF(:,i),x1,options) ;
%     step(Position_TF(:,i)) ;
    s2(:,i) = strcat('k_s = ', ' ', num2str(k_s(:,i))) ;
    legend(s2,'Location','Southeast') ;
%     end
end 
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA position open loop frequency response.pdf',figure_property); %Set desired file name
s2 = string([]) ;
k_s = 575 ;
r = [1, 10, 100, 200] ;
for i = 1:length(r)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Position_TF(:,i) = tf([2*k_s*R^2],[Jl*r(:,i) Bl*r(:,i) 2*k_s*R^2*r(:,i)]);
    options = bodeoptions;
    options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
    bode(Position_TF(:,i),x1,options) ;
%     step(Position_TF(:,i)) ;
    s2(:,i) = strcat('r = ', ' ', num2str(r(:,i))) ;
    legend(s2,'Location','Southeast') ;
%     end
end 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA position open loop frequency response varying gear ratio.pdf',figure_property); %Set desired file name
%% Torque open-loop transfer function
Jm = 6.3e-06 ; % Motor inertia
Jl = 1 ; % Load inertia (kg-m^2)
Bm = 1e-4 ; % Motor damping
Jg = 1.1200e-06 ; % Gearbox inertia
Bg = 0.01 ; % Gearbox damping
Bl = 0.5 ; % Load damping (Ns/m)
s2 = string([]) ;
k_s = [100,1000,10000,575] ;
for i = 1:length(k_s)
    J_eq = Jm*r^2 + Jg ;
    B_eq = Bm*r^2 + Bg ;
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Torque_TF(:,i) = tf([2*k_s(:,i)*R^2*Jl 2*k_s(:,i)*R^2*Bl 0], [J_eq*Jl (J_eq*Bl+B_eq*Jl) (2*k_s(:,i)*R^2*(J_eq+Jl)+B_eq*Bl) 2*k_s(:,i)*R^2*(B_eq+Bl) 0]) ;
%     options = bodeoptions;
%     options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
%     bodemag(transparency_TF(:,k),x1,options) ;
    step(Torque_TF(:,i)) ;
    s2(:,i) = strcat('$k_s=',num2str(k_s(:,i)),'$') ;
    legend(s2,'Location','Southeast') ;
    legend(s2,'interpreter','latex') ;
%     end
end 
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA torque open loop.pdf',figure_property); %Set desired file name
%return ;
r = 1 ;
s2 = string([]) ;
for i = 1:length(k_s)
    J_eq = Jm*r^2 + Jg ;
    B_eq = Bm*r^2 + Bg ;
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
    Torque_TF(:,i) = tf([2*k_s(:,i)*R^2*Jl 2*k_s(:,i)*R^2*Bl 0], [J_eq*Jl (J_eq*Bl+B_eq*Jl) (2*k_s(:,i)*R^2*(J_eq+Jl)+B_eq*Bl) 2*k_s(:,i)*R^2*(B_eq+Bl) 0]) ;
    hold on ;
    pzmap(Torque_TF(:,i)) ;
    s2(:,i) = strcat('$k_s = ', ' ', num2str(k_s(:,i)),'$') ;
    legend(s2,'Location','Southeast') ;
    legend(s2,'interpreter','latex') ;
%     end
end 
return
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA torque pzmap.pdf',figure_property); %Set desired file name
s2 = string([]) ;
k_s = 575 ;
r = [1,10,100,200] ;
for i = 1:length(r)
    J_eq = Jm*r(:,i)^2 + Jg ;
    B_eq = Bm*r(:,i)^2 + Bg ;
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Torque_TF(:,i) = tf([2*k_s*R^2*Jl 2*k_s*R^2*Bl 0], [J_eq*Jl (J_eq*Bl+B_eq*Jl) (2*k_s*R^2*(J_eq+Jl)+B_eq*Bl) 2*k_s*R^2*(B_eq+Bl) 0]) ;
%     options = bodeoptions;
%     options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
%     bodemag(transparency_TF(:,k),x1,options) ;
    step(Torque_TF(:,i)) ;
    s2(:,i) = strcat('r = ', ' ', num2str(r(:,i))) ;
    legend(s2,'Location','Southeast') ;
%     end
end 
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA torque step response varying gear ratio.pdf',figure_property); %Set desired file name
s2 = string([]) ;
k_s = 575 ;
r = [1,10,100,200] ;
for i = 1:length(r)
    J_eq = Jm*r(:,i)^2 + Jg ;
    B_eq = Bm*r(:,i)^2 + Bg ;
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Torque_TF(:,i) = tf([2*k_s*R^2*Jl 2*k_s*R^2*Bl 0], [J_eq*Jl (J_eq*Bl+B_eq*Jl) (2*k_s*R^2*(J_eq+Jl)+B_eq*Bl) 2*k_s*R^2*(B_eq+Bl) 0]) ;
%     options = bodeoptions;
%     options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
%     bodemag(transparency_TF(:,k),x1,options) ;
    pzmap(Torque_TF(:,i)) ;
    s2(:,i) = strcat('r = ', ' ', num2str(r(:,i))) ;
    legend(s2,'Location','Southeast') ;
%     end
end 
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA torque pz map varying gear ratio.pdf',figure_property); %Set desired file name
s2 = string([]) ;
k_s = [100, 1000, 10000, 575] ;
r = 1 ;
for i = 1:length(k_s)
    J_eq = Jm*r^2 + Jg ;
    B_eq = Bm*r^2 + Bg ;
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Torque_TF(:,i) = tf([2*k_s(:,i)*R^2*Jl 2*k_s(:,i)*R^2*Bl 0], [J_eq*Jl (J_eq*Bl+B_eq*Jl) (2*k_s(:,i)*R^2*(J_eq+Jl)+B_eq*Bl) 2*k_s(:,i)*R^2*(B_eq+Bl) 0]) ;
    options = bodeoptions;
    options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
    bode(Torque_TF(:,i),x1,options) ;
%     step(Position_TF(:,i)) ;
    s2(:,i) = strcat('k_s = ', ' ', num2str(k_s(:,i))) ;
    legend(s2,'Location','Southeast') ;
%     end
end 
return 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA torque open loop frequency response.pdf',figure_property); %Set desired file name
s2 = string([]) ;
k_s = 575 ;
r = [1, 10, 100, 200] ;
for i = 1:length(r)
    J_eq = Jm*r(:,i)^2 + Jg ;
    B_eq = Bm*r(:,i)^2 + Bg ;
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    elseif(i == 3)
        x1 = 'b' ;
    else
        x1 = 'g' ; 
    end
%     for j = 1:length(alpha)
%     wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
%     w0 = alpha(:,j)*wn ;
%     kp(:,k) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
%     % kp = 0.0011 ;
%     kd(:,k) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
%     % kd = 0.00011 ;
%     C = kp(:,k) + kd(:,k)*s ;
    Torque_TF(:,i) = tf([2*k_s*R^2*Jl*r(:,i) 2*k_s*R^2*Bl*r(:,i) 0], [J_eq*Jl (J_eq*Bl+B_eq*Jl) (2*k_s*R^2*(J_eq+Jl)+B_eq*Bl) 2*k_s*R^2*(B_eq+Bl) 0]) ;
    options = bodeoptions;
    options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
%     if(j == 1)
%         z = strcat(x1,'-') ;
%     else
%        z = strcat(x1,'--') ;
%     end
    hold on ;
    bode(Torque_TF(:,i),x1,options) ;
%     step(Position_TF(:,i)) ;
    s2(:,i) = strcat('r = ', ' ', num2str(r(:,i))) ;
    legend(s2,'Location','Southeast') ;
%     end
end 
figure_property.units = 'inches';
figure_property.format = 'pdf';
figure_property.Preview= 'none';   
figure_property.Width= '8'; % Figure width on canvas
figure_property.Height= '4'; % Figure height on canvas
figure_property.Units= 'inches';
figure_property.Color= 'rgb';
figure_property.Background= 'w';
figure_property.FixedfontSize= '12';
figure_property.ScaledfontSize= 'auto';
figure_property.FontMode= 'scaled';
figure_property.FontSizeMin= '12';
figure_property.FixedLineWidth= '1';
figure_property.ScaledLineWidth= 'auto';
figure_property.LineMode= 'none';
figure_property.LineWidthMin= '0.1';
figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
figure_property.FontWeight= 'auto';
figure_property.FontAngle= 'auto';
figure_property.FontEncoding= 'latin1';
figure_property.PSLevel= '3';
figure_property.Renderer= 'painters';
figure_property.Resolution= '600';
figure_property.LineStyleMap= 'none';
figure_property.ApplyStyle= '0';
figure_property.Bounds= 'tight';
figure_property.LockAxes= 'off';
figure_property.LockAxesTicks= 'off';
figure_property.ShowUI= 'off';
figure_property.SeparateText= 'off';
chosen_figure=gcf;
set(chosen_figure,'PaperUnits','inches');
set(chosen_figure,'PaperPositionMode','auto');
set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
set(chosen_figure,'Units','inches');
hgexport(gcf,'SEA torque open loop frequency response varying gear ratio.pdf',figure_property); %Set desired file name
%% Optimal stiffness selection
k_s = 100:100:2000 ;
x0 = 2 ;
for i = 1:length(k_s)
    kp(:,i) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
% kp = 0.0011 ;
    kd(:,i) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
end
wb = fmincon(@(x) cost_fun(x,Jeq,Beq,kp,kd,lambda,r,k_s,K_virt,D_virt,reference_impedance_TF),2,[],[],[],[],0,1E5) ;
function [cost] = cost_fun(x,Jeq,Beq,kp,kd,lambda,r,k_s,K_virt,D_virt,reference_impedance_TF)
    for i = 1:length(k_s)
        Z(:,i) = tf([-k_s(:,i)*(Jeq + kd(:,i)*D_virt) -k_s(:,i)*(Beq + ... 
        K_virt*kd(:,i)+(kp(:,i)+1)*D_virt) -k_s(:,i)*K_virt*(kp(:,i) +  ...
        1)],[Jeq (Beq + kd(:,i)*k_s(:,i)*r) k_s(:,i)*(lambda+kp(:,i))*r]) ;
        Z_mag = mag_phase(Z(:,i),x(1)) ;
        ref_Z_mag = mag_phase(reference_impedance_TF,x(1)) ;
%         cost = 20*log(Z_mag/ref_Z_mag) ;
        cost =1/(x(1)^2) + 10* (3 - abs(ref_Z_mag));
    end

end

