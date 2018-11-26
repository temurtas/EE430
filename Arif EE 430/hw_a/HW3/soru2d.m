x1=[1 2 3 4];
x2=[-1 -2 -3 -4];
x3=x1;
h=[2 -1 1];
X1=fft(x1,6);
X2=fft(x2,6);
X3=fft(x3,6);
H=fft(h,6);
Y1=X1.*H;
Y2=X2.*H;
Y3=X3.*H;
y1=ifft(Y1);
y2=ifft(Y2);
y3=ifft(Y3);
stem(y1,'color','red');
hold on;
stem(y2,'color','blue');
hold on;
stem(y3,'color','green');

