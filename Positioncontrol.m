clc ;
clear all ;
[ConvertedData,ConvertVer,ChanNames,GroupNames,ci] = convertTDMS(0,'SEApositiondatasquare.tdms') ;
currents = ConvertedData.Data.MeasuredData(3).Data ;
k = 1 ;
for i=1:3:length(currents)
   reference(k,:) = currents(i,:) ; 
   k = k+1 ;
end  
ref_min = min(reference) - 0.5 ;
ref_max = max(reference) + 0.5 ;
% marker1 = (ref_min:(ref_max - ref_min)/(length(reference)-1):ref_max)' ;
k = 1 ;
for i=2:3:length(currents)
   actualcurrent(k,:) = currents(i,:) ; 
   k = k+1 ;
end
act_min = min(actualcurrent) - 1 ;
act_max = max(actualcurrent) + 1 ;
k = 1 ;
for i=3:3:length(currents)
   timerx(k,:) = currents(i,:) - currents(3,:) ; 
   k = k+1 ;
end 
% timer1 = timerx(8018,1)*ones(length(timerx),1) ;
% timer2 = timerx(24048,1)*ones(length(timerx),1) ;
% timer3 = timerx(37588,1)*ones(length(timerx),1) ;
plot(timerx,reference,'r','linewidth',1) ;
hold on;
% plot(timer1,marker1,'b','linewidth',2) ;
hold on;
% plot(timer2,marker1,'b','linewidth',2) ;
hold on;
% plot(timer3,marker1,'b','linewidth',2) ;
hold on;
plot(timerx,actualcurrent,'k--','linewidth',1) ;
xlabel('Time (s)') ;
ylabel('Position (rad)') ;
legend('reference','actual') ;
axis([0 timerx(end) ref_min ref_max]) ;
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
hgexport(gcf,'SEA square wave position.pdf',figure_property); %Set desired file name