function [timerx, jointtorque, actloadposn, transparencyTFpt] = transparency_transfer_function_data_processing(str)
    [ConvertedData,ConvertVer,ChanNames,GroupNames,ci] = convertTDMS(0,str) ;
    trialdata = ConvertedData.Data.MeasuredData(:,3).Data ;
    k = 1 ;
    for i=1:4:length(trialdata)
       loadrefposn(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end  
    k = 1 ;
    for i=2:4:length(trialdata)
       actloadposn(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end 
    k = 1 ;
    for i=3:4:length(trialdata)
       jointtorque(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end 
    k = 1;
    for i=4:4:length(trialdata)
       timerx(k,:) = trialdata(i,:) ; 
       k = k+1 ;
    end 
    tmax = max(timerx) - 5; tmin = tmax - 30 ;
    timrange = find(timerx>tmin & timerx<tmax);
    tminr = min(timrange); tmaxr = max(timrange);
    timerx = timerx(tminr:tmaxr); jointtorque = jointtorque(tminr:tmaxr); actloadposn = actloadposn(tminr:tmaxr); 
    jttorql2n = norm(jointtorque, 2); actldpsnl2n = norm(actloadposn, 2);
    transparencyTFpt = 20*log(jttorql2n/actldpsnl2n);
end