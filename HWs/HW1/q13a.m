clc 
clear all 
close all 
x=input('Enter the first sequence: '); 
l1=input('Enter the lower limit: '); 
u1=input('Enter the upper limit: '); 
x1=l1:1:u1; 
h=input('Enter the second sequence: '); 
l2=input('Enter the lower limit: '); 
u2=input('Enter the upper limit: '); 
h1=l2:1:u2; 
l=l1+l2; 
u=u1+u2; 
n=l:1:u; 
s=numel(n); 
i=1; 
for i=1:s 
y(i)=0; 
for k=1:numel(x) 
if (i+1-k)<=0 
y(i)=y(i)+(x(k)*0); 
else if (i+1-k)>numel(h) 
y(i)=y(i)+(x(k)*0); 
else 
y(i)=y(i)+(x(k)*h(i+1-k)); 
k=k+1; 
end 
end 
end 
i=i+1; 
end 
disp(y); 
subplot(2,2,1);stem(x1,x); 
title('First sequence');xlabel('n');ylabel('x(n)'); 
subplot(2,2,2);stem(h1,h); 
title('Second Sequence');xlabel('n');ylabel('h(n)'); 
subplot(2,2,[3 4]);stem(n,y); 
title('Convoluted sequence');xlabel('n');ylabel('y(n)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=[-2:5]
x2=[-4:10]
y=[0 1 2 1 0 3 1 0]
y2=[0 1/2 1 3/2 2 3/2 1 1/2 0 3/2 3 2 1 1/2 0]
 
subplot(1,2,1)
stem(x,y)
title('An Example Input')
subplot(1,2,2)
stem(x2,y2)
title('The Output for Given Input')
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z  = myconv (x,h)
    i=1
    while i < 50
        k=1
        y(1)=0
        z(1)=0;
        while k<50
           y(k)=x(k)*h(i-k)
           k=k+1
           z(i)=z(i)+y(k)
        end
    end
        
end
%%%%%%%%%%%%%%%%%%%%