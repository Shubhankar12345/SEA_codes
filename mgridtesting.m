clc;
close all;
clear;
%%
R = 0.035 ; % Pulley radius
r = 1 ; % Gear ratio
alpha = [1.2,1.8] ; % Pole placement parameter
k_s = [100,1000,10000] ; % spring constant
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
    else
        x1 = 'b' ;
    end
    for j = 1:length(alpha)
        wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
        w0 = alpha(:,j)*wn ;
        kp(:,i) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
        % kp = 0.0011 ;
        kd(:,i) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
        % kd = 0.00011 ;
        C = kp(:,i) + kd(:,i)*s ;
        transparency_TF(:,i) = tf([-Jeq*k_s(:,i) -Beq*k_s(:,i) 0],[Jeq (Beq+ ... 
                kd(:,i)*k_s(:,i)*r) k_s(:,i)*(lambda+kp(:,i))*r]);
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        if(j == 1)
            z = strcat(x1,'-') ;
        else
           z = strcat(x1,'--') ;
        end
        hold on ;
        bodemag(transparency_TF(:,i),z,options) ;
        s2(:,k) = strcat('k_s =', ' ', num2str(k_s(:,i)), '(alpha =',' ',num2str(alpha(:,j)),')') ;
        legend(s2) ;
        k = k+1 ;
    end
end 
s1 = string([]) ;
kp = [] ; kd = [] ; k = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    else
        x1 = 'b' ;
    end
    for j = 1:length(alpha)
        wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
        w0 = alpha(:,j)*wn ;
        kp(:,i) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
        % kp = 0.0011 ;
        kd(:,i) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
        % kd = 0.00011 ;
        C = kp(:,i) + kd(:,i)*s ;
        torque_TF(:,i) = tf([k_s(:,i)*r*kd(:,i) k_s(:,i)*r* ...
        (lambda + kp(:,i))],[Jeq (Beq+kd(:,i)*k_s(:,i)*r)  ...
        k_s(:,i)*(lambda+kp(:,i))*r]);
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        if(j == 1)
            z = strcat(x1,'-') ;
        else
           z = strcat(x1,'--') ;
        end
        hold on ;
        bodemag(torque_TF(:,i),z,options) ;
        s1(:,k) = strcat('k_s =', ' ', num2str(k_s(:,i)), '(alpha =',' ',num2str(alpha(:,j)),')') ;
        legend(s1) ;
        k = k+1 ;
    end
end
%% Motor power
s3 = string([]) ;
kp = [] ; kd = [] ; k = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    elseif(i == 2)
        x1 = 'k' ;
    else
        x1 = 'b' ;
    end
    for j = 1:length(alpha)
        wn = sqrt(k_s(:,i)/Jeq) ; % plant natural frequency 
        w0 = alpha(:,j)*wn ;
        kp(:,i) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
        % kp = 0.0011 ;
        kd(:,i) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
        % kd = 0.00011 ;
        C = kp(:,i) + kd(:,i)*s ;
        motor_power_TF(:,i) = tf([Jeq (Beq) k_s(:,i)],[k_s(:,i)*r]);
        options = bodeoptions;
        options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
        if(j == 1)
            z = strcat(x1,'-') ;
        else
           z = strcat(x1,'--') ;
        end
        hold on ;
        bodemag(motor_power_TF(:,i),z,options) ;
        s3(:,k) = strcat('k_s =', ' ', num2str(k_s(:,i)), '(alpha =',' ',num2str(alpha(:,j)),')') ;
        legend(s3) ;
        k = k+1 ;
    end
end
%% Impedance rendering
K_virt = 1000 ;
D_virt = 20 ;
s4 = string([]) ;
kp = [] ; kd = [] ; k = 1 ;
alpha = 1.2 ;
k_s = [100,10000] ;
reference_impedance_TF = -(K_virt + D_virt*s) ;
figno = 1 ;
for i = 1:length(k_s)
    if(i == 1)
        x1 = 'r' ;
    else
        x1 = 'b' ;
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
%         figure_property.units = 'inches';
%         figure_property.format = 'pdf';
%         figure_property.Preview= 'none';   
%         figure_property.Width= '8'; % Figure width on canvas
%         figure_property.Height= '4'; % Figure height on canvas
%         figure_property.Units= 'inches';
%         figure_property.Color= 'rgb';
%         figure_property.Background= 'w';
%         figure_property.FixedfontSize= '12';
%         figure_property.ScaledfontSize= 'auto';
%         figure_property.FontMode= 'scaled';
%         figure_property.FontSizeMin= '12';
%         figure_property.FixedLineWidth= '1';
%         figure_property.ScaledLineWidth= 'auto';
%         figure_property.LineMode= 'none';
%         figure_property.LineWidthMin= '0.1';
%         figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
%         figure_property.FontWeight= 'auto';
%         figure_property.FontAngle= 'auto';
%         figure_property.FontEncoding= 'latin1';
%         figure_property.PSLevel= '3';
%         figure_property.Renderer= 'painters';
%         figure_property.Resolution= '600';
%         figure_property.LineStyleMap= 'none';
%         figure_property.ApplyStyle= '0';
%         figure_property.Bounds= 'tight';
%         figure_property.LockAxes= 'off';
%         figure_property.LockAxesTick_s(:,i)= 'off';
%         figure_property.ShowUI= 'off';
%         figure_property.SeparateText= 'off';
%         chosen_figure=gcf;
%         set(chosen_figure,'PaperUnits','inches');
%         set(chosen_figure,'PaperPositionMode','auto');
%         set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
%         set(chosen_figure,'Units','inches');
%         hgexport(gcf,'SEA impedance rendering low stiffness.pdf',figure_property); %Set desired file name
    else
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
%         figure_property.units = 'inches';
%         figure_property.format = 'pdf';
%         figure_property.Preview= 'none';   
%         figure_property.Width= '8'; % Figure width on canvas
%         figure_property.Height= '4'; % Figure height on canvas
%         figure_property.Units= 'inches';
%         figure_property.Color= 'rgb';
%         figure_property.Background= 'w';
%         figure_property.FixedfontSize= '12';
%         figure_property.ScaledfontSize= 'auto';
%         figure_property.FontMode= 'scaled';
%         figure_property.FontSizeMin= '12';
%         figure_property.FixedLineWidth= '1';
%         figure_property.ScaledLineWidth= 'auto';
%         figure_property.LineMode= 'none';
%         figure_property.LineWidthMin= '0.1';
%         figure_property.FontName= 'Times New Roman';% Might want to change this to something that is available
%         figure_property.FontWeight= 'auto';
%         figure_property.FontAngle= 'auto';
%         figure_property.FontEncoding= 'latin1';
%         figure_property.PSLevel= '3';
%         figure_property.Renderer= 'painters';
%         figure_property.Resolution= '600';
%         figure_property.LineStyleMap= 'none';
%         figure_property.ApplyStyle= '0';
%         figure_property.Bounds= 'tight';
%         figure_property.LockAxes= 'off';
%         figure_property.LockAxesTick_s(:,i)= 'off';
%         figure_property.ShowUI= 'off';
%         figure_property.SeparateText= 'off';
%         chosen_figure=gcf;
%         set(chosen_figure,'PaperUnits','inches');
%         set(chosen_figure,'PaperPositionMode','auto');
%         set(chosen_figure,'PaperSize',[str2num(figure_property.Width) str2num(figure_property.Height)]); % Canvas Size
%         set(chosen_figure,'Units','inches');
%         hgexport(gcf,'SEA impedance rendering high stiffness.pdf',figure_property); %Set desired file name
    end
    k = k + 1 ;
    figno = figno + 1 ;
end
%% Optimal stiffness selection

k_s = linspace(100,2000,100) ;
kp = 0*k_s;
kd = 0*k_s;

K_virt = 1000 ;
D_virt = 75 ;
for i = 1:length(k_s)
    kp(:,i) = (Jeq*w0^2)/(k_s(:,i)*r) - 1 ; % PID proportional
% kp = 0.0011 ;
    kd(:,i) = (2*Jeq*w0 - Beq)/k_s(:,i)*r ; % PID derivative
end

ome = linspace(0.1,100,100);
[Ks,Ome] = meshgrid(k_s,ome);
% Z = 0*meshgrid(k_s,ome);
cost = 0*meshgrid(k_s,ome);
KS = 0;
OME = 0;
OMEold = 0 ;
for i = 1:100
for j = 1:100
KS = Ks(i,j);
OME = Ome(i,j);
Z = tf([-KS*(Jeq + kd(:,i)*D_virt) -KS*(Beq + ... 
K_virt*kd(:,i)+(kp(:,i)+1)*D_virt) -KS*K_virt*(kp(:,i) +  ...
1)],[Jeq (Beq + kd(:,i)*KS*r) KS*(lambda+kp(:,i))*r]) ;
Z_mag = mag_phase(Z,OME) ;
ref_Z_mag = mag_phase(reference_impedance_TF,OME) ;
cost(i,j) = 20*log(Z_mag/ref_Z_mag) ;
if cost(i,j)>=-3 && cost(i,j)<=3
if OMEold<=OME
OMEold = OME 
KS
end
end
end
end

