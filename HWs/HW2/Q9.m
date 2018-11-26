%% Q9a
x_1=[ 1 3 -4]
x_2=[-1 2 -3 1 7]
x_k=conv(x_1,x_2)

x_z=filt([0 x_k] , [1])

%% Q9b

a= [1 -3 4];
b= [1 -1 1 -1];
[r,p,k]=residuez(a , b);
[rsize1,rsize2]=size(r);

i=1;
fprintf('The inverse z-transform of given function is:\n')
while i<(rsize1+1)
   fprintf('x[%i]= %f (%f)^(n)\n',i, r(i),p(i));
   i=i+1;
end

%% Q9c

a_c= [1 -0.2 -1.2 ]
b_c= [1 -0.9 0.81]
[r_c,p_c,k_c]=residuez(a_c , b_c)


zplane(b_c,a_c)
hold on
plot(p_c,'^r')
title("Pole-Zero Diagram for the System Function at part c")
hold off

