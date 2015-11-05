
fs = zeros(6,8);
fs(1,:) = [40 0 0 0 0 0 0 60];
fs(2,:) = [0 2 8 19 29 26 13 3];
fs(3,:) = [0 0 0 0 81 18 1 0];
fs(4,:) = [0 0 0 0 0 0 20 80];
fs(5,:) = [0 0 0 0 100 0 0 0];
fs(6,:) = [0 60 20 20 0 0 0 0];
fs = fs./100;

l=['a','b','c','d','e','f'];
figure(1);

for ii=1:6
f = fs(ii,:);

L = length(f);
T = fix(L/2);
i = 1:(T+mod(L,2)); j = (T+1):L;

%crando la funcion de pesos 
beta = 1; alpha = 2;
w = zeros(L,1);
w(i) = -beta;
w(j) = (L-j+1)*alpha/L;

M = f*w;

subplot(2,3,ii), bar(f)
hold on; 
plot(w); 
hold off;
xlabel(sprintf('Dp %.3f\n %s)',M,l(ii)));


% %     len=length(h);
% %     h=h/sum(h);
% %     subplot(2,3,gr), bar(0:len-1,h);
% %     axis([-1 len 0 1.2]);
% %     hold on;
% %     Y = normpdf(1:len,len/2,len/5.0);
% %     Y(1:end/2)=0;
% %     Y=Y/max(Y);
% %     plot(0:len-1,Y,'r');
% %     m=corr2(h,Y);
% %     hold off;
% %     


end
