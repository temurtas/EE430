x=random('unid', 10,1,7);
h=random('unid', 10,1,7);
y=conv(x,h);
figure
stem(x);
figure
stem(h);
figure
stem(y);
