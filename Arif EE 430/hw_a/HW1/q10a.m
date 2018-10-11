%Take the coefficients of the polynomials as the vector elements.
p1=[23 45 21 67]; %23x^3+45x^2+21x+67

p2=[12 23 1 0  0 9]; %12x^5+23x^4+x^3+9

p3=conv(p1,p2); %p3 is the multiplication of p1 and p2