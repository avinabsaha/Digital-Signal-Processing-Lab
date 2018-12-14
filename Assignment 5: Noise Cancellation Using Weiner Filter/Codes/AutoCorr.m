function y = AutoCorr(X)

for i=1:length(X)
    y(i,:)=sum([zeros(1,i-1),X].*[X,zeros(1,i-1)])/(length(X));
end

end

