function [RMSE, RMSEoNaive, Rquad, Mae, foreArray] = fuzzyoutOfSampleTest(algorithm,Data, stepsAhead, noutofsample)


if strcmp(algorithm,'FuzzyRBTModel')
    for i=1:1:noutofsample+1
        [original,forecast,naive, forestepsahead] = FuzzyRBTModel(Data(i:end-noutofsample+i-1),stepsAhead);
        foreArray(i) = forestepsahead;
 
    end
    Dataout = Data(end-noutofsample+1:end);
    foreout = foreArray(1:end-1);
    naiveout = Data(end-noutofsample+1-stepsAhead:end-stepsAhead);

    [RMSE, RMSEoNaive, Rquad, Mae] = plotForecast('Testing Results',Dataout,foreout',naiveout)
end

end