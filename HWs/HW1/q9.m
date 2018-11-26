x=[1:2]
w=[0:0.0001:2*pi]
X=exp(-j*w)+2*exp(-j*2*w)
freqz(X)