y=[1 1 2 3 4 -1 5];
x=1:5;

h=deconv(y,x);
stem(h);