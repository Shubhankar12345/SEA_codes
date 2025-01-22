clc; clear all;
%% Torque TF data 
nums = 0.2:0.1:1.2; k = length(nums); z2 = [1.5,1.7,2,2.5,3,3.5,4,5];
for i = 1:8
   nums(:,k+1) = z2(:,i);
   k = k+1;
end
for i = 1:19
   str(i,:) = strcat("torquecontrol",num2str(nums(:,i)),"Hz.tdms"); 
end
for i = 1:19
    [tx, rt, at, tfpt] = torque_tracking_transfer_function_data_processing(str(i));
%     reftorque(i,:) = rt';
%     timerx(i,:) = tx';
%     acttorque(i,:) = at';
    torque_TF_pts(i,:) = tfpt;
end
fitpoly = fit(nums', torque_TF_pts,"poly8");
freqHZ = 0.2:0.1:5 ;
for i = 1:length(freqHZ)
   torque_TF_data(:,i) = fitpoly.p1*freqHZ(:,i)^8 + fitpoly.p2*freqHZ(:,i)^7 + fitpoly.p3*freqHZ(:,i)^6 ...
   + fitpoly.p4*freqHZ(:,i)^5 + fitpoly.p5*freqHZ(:,i)^4 + fitpoly.p6*freqHZ(:,i)^3 ...
   + fitpoly.p7*freqHZ(:,i)^2 + fitpoly.p8*freqHZ(:,i) + fitpoly.p9 ;
end
fig1 = figure();
plot(freqHZ,torque_TF_data,'r','Linewidth',2);
hold on;
plot(nums,torque_TF_pts,'ko');
xlabel('Frequency in Hz'); ylabel('Magnitude in dB');legend('Fitted model','Actual Data');
