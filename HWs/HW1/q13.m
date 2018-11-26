function y  = myconv (x,h)
    i=1; 
    for i=1:10 
        y(i)=0; 
        for k=1:numel(x) 
            if (i+1-k)<=0 
                y(i)=y(i)+(x(k)*0); 
            else
                if (i+1-k)>numel(h)
                    y(i)=y(i)+(x(k)*0); 
                else 
                    y(i)=y(i)+(x(k)*h(i+1-k)); 
                    k=k+1; 
                end 
            end 
        end 
        i=i+1; 
    end 
end

%%%%%%%%%%%%%%%%%%%

x = [1:5 4:-1:1]
h = [1 1 1]

y=myconv(x,h)

y2=conv(x,h)

stem(y2)
%%%%%%%%%%%%%%%%%%%%%%

freqz(h,1024)

%%%%%%%%%%%%%%%%%%%%%

h2=[1 -2 1]

y3=conv(x,h2)

stem(y3)
%%%%%%%%%%%%%%%%%%%%

freqz(h2,1024)

%%%%%%%%%%%%%%%%%%%,
i=1;
z(1)=0;
while i<60
    if i < 1
        z(i)=0;
    else
        z(i)=1+sin(pi/3*i)+sin(2*pi/3*i)
    end
    i=i+1;
end

freqz(z,1024)

%%%%%%%%%%%%%%%%%%%%%%%%%%

y=conv(z,h)

freqz(y,1024)

%%%%%%%%%%%%%%%%%%%%%%%%%%