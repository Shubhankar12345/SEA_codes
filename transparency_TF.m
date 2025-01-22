clc; clear all;
%% Transparency TF data 
nums = 0.2:0.1:0.5; k = length(nums); z2 = [1,1.5,2,2.5,3,3.5,4];
for i = 1:7
   nums(:,k+1) = z2(:,i);
   k = k+1;
end
for i = 1:11
   str(i,:) = strcat("transparency",num2str(nums(:,i)),"Hz.tdms"); 
end
for i = 1:11
    [tx, jt, alp, tfpt] = transparency_transfer_function_data_processing(str(i));
    transparency_TF_pts(i,:) = tfpt;
end
freqfit = nums; tpfit = transparency_TF_pts;
freqfit(:,3) = []; freqfit(:,3) = []; freqfit(:,8) = [];
tpfit(3,:) = []; tpfit(3,:) = []; tpfit(8,:) = [];
fitpoly = fit(freqfit',tpfit,"poly3");
freqHZ = 0.2:0.1:4;
transparency_TF_data = fitpoly.p1.*freqHZ.^3 + fitpoly.p2.*freqHZ.^2 + fitpoly.p3.*freqHZ + fitpoly.p4 ;
plot(nums,transparency_TF_pts,'ko');
hold on;
plot(freqHZ,transparency_TF_data,'r','Linewidth',2);
xlabel('Frequency in Hz'); ylabel('Magnitude in dB');legend('Actual Data','Fitted Model');
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
hgexport(gcf,'Experimental setup transparency transfer function.pdf',figure_property); %Set desired file name