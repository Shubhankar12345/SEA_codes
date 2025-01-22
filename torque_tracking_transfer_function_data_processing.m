function [timerx, reftorque, acttorque, torqueTFpt] = torque_tracking_transfer_functon_data_processing(str)
    [ConvertedData,ConvertVer,ChanNames,GroupNames,ci] = convertTDMS(0,str) ;
    trialdata = ConvertedData.Data.MeasuredData(:,3).Data ;
    k = 1 ;
    for i=1:5:length(trialdata)
       reftorque(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end  
    k = 1 ;
    for i=2:5:length(trialdata)
       acttorque(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end 
    k = 1 ;
    for i=3:5:length(trialdata)
       refcurrent(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end 
    k = 1 ;
    for i=4:5:length(trialdata)
       meascurrent(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end 
    k = 1 ;
    for i=5:5:length(trialdata)
       timerx(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end 
    tmax = max(timerx) - 5; tmin = tmax - 30 ;
    timrange = find(timerx>tmin & timerx<tmax);
    tminr = min(timrange); tmaxr = max(timrange);
    timerx = timerx(tminr:tmaxr); reftorque = reftorque(tminr:tmaxr); acttorque = acttorque(tminr:tmaxr); 
    refl2n = norm(reftorque, 2); actl2n = norm(acttorque, 2);
    torqueTFpt = 20*log(actl2n/refl2n);
end