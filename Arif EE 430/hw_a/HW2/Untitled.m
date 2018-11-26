h=zeros(1,1000);
h(1)=1;
h(2)=-0.5;
h(3)=0.75;
for i=4:1:1000
    h(i)=h(i-1)/2;
end
[H,w] = freqz(h,1,1000,'whole');
plot(w,abs(H));
figure;
plot(w,angle(H));