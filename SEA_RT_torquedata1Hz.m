clc ;
clear all ;
[ConvertedData,ConvertVer,ChanNames,GroupNames,ci] = convertTDMS(0,'SEAtorquedata_1Hz_1Nm.tdms') ;
torques = ConvertedData.Data.MeasuredData(3).Data ;
[ConvertedData1,ConvertVer1,ChanNames1,GroupNames1,ci1] = convertTDMS(0,'SEAencoderevalues_1Hz_1Nm.tdms') ;
angles = ConvertedData1.Data.MeasuredData(3).Data ;
[ConvertedData2,ConvertVer2,ChanNames2,GroupNames2,ci2] = convertTDMS(0,'SEAcontrolinputs_1Hz_1Nm.tdms') ;
control_ip = ConvertedData2.Data.MeasuredData(3).Data ;
k = 1 ;
for i=1:3:length(torques)
   desired_torque(k,:) = torques(i,:) ; 
   k = k+1 ;
end  
k = 1 ;
for i=2:3:length(torques)
   actual_torque(k,:) = torques(i,:) ; 
   k = k+1 ;
end
k = 1 ;
for i=3:3:length(torques)
   timerx(k,:) = torques(i,:) - torques(3,:) ; 
   k = k+1 ;
end 
k = 1 ;
for i=1:2:length(angles)
   motorangle(k,:) = angles(i,:) ;
   k = k+1 ;
end
k = 1 ;
for i=2:2:length(angles)
   jointangle(k,:) = angles(i,:) ;
   k = k+1 ;
end
k = 1 ;
for i=1:2:length(control_ip)
   torquepid(k,:) = control_ip(i,:) ;
   k = k+1 ;
end
k = 1 ;
for i=2:2:length(angles)
   CCpid(k,:) = angles(i,:) ;
   k = k+1 ;
end
subplot(3,1,1) ;
plot(timerx,desired_torque,'r','Linewidth',1) ;
hold on ;
plot(timerx,actual_torque,'k--','Linewidth',1) ;
title('Joint torque tracking with only P controller. Kp = 2') ;
legend('desired','actual') ;
xlabel('Time (s)') ;
ylabel('Torque (Nm)') ;
subplot(3,1,2) ;
plot(timerx,motorangle,'r','Linewidth',1) ;
hold on ;
plot(timerx,jointangle,'k--','Linewidth',1) ;
title('Motor and joint angles') ;
leg1 = legend('$\theta_m$','$\theta_j$') ;
set(leg1,'Interpreter','latex') ;
xlabel('Time (s)') ;
ylabel('Angle (rad)') ;
subplot(3,1,3) ;
plot(timerx,torquepid,'r','Linewidth',1) ;
hold on ;
plot(timerx,CCpid,'k--','Linewidth',1) ;
title('Torque and Current Controller inputs') ;
leg2 = legend('$\tau_{PID}$','$CC_{PID}$') ;
set(leg2,'Interpreter','latex') ;
xlabel('Time (s)') ;
ylabel('control input') ;
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
hgexport(gcf,'SEA torque tracking 1 Hz 1 Nm reference.pdf',figure_property); %Set desired file name