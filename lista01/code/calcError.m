function err = calcError( y, yest )

err = sum((y~=yest))/length(y);


end

