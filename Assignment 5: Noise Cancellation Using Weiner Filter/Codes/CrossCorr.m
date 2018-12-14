function y = CrossCorr(X,Z)

x=[X,zeros(1,length(Z)-length(X))];
z=[Z,zeros(1,length(X)-length(Z))];

for i=1:length(z)
    y(i,:)=sum([x,zeros(1,i-1)].*[zeros(1,i-1),z])/(length(z));
end

end

