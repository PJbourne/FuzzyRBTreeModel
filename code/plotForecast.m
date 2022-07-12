function [RMSEpredito, RMpreditorelativonaive2, Rquad, Mae] = plotForecast(name,Data,fore,naive)

original = Data; 
predito = fore;

n = 1:length(original);
figure
plot(n,original,n,predito,n,naive);

legend('Original','Forecasted','Naive');
title(name);
xlabel('Sample'); ylabel('Ibovespa Closing Index')
grid

RMSEpredito = sqrt(sum((original - predito).^2)/length(original));
RMSEnaive = sqrt(sum((original - naive).^2)/length(original));
RMpreditorelativonaive2 = RMSEpredito/RMSEnaive;

Rquad = sum((original - predito).^2)/sum((original - mean(original)).^2);

Mae = sum(abs(original - predito))/length(original);

end