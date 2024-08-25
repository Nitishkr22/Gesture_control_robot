function outputdata = RC4IM2(key, inputdata)
ln = length(inputdata);
s = 0:255;
j = 0;
for i = 0:255
k = key(mod(i,ln)+1);
j= mod(j+k + s(i+1), 256);
tmp = s(i+1);
s(i+1) = s(j+1);
s(j+1) = tmp;
end
i = 0;
j = 0;
for k = 1:ln
i = mod(i+1, 256);
j= mod(j+s(i+1), 256);
tmp = s(i+1);
s(i+1) = s(j+1);
s(j+1) = tmp;
t = mod(s(i+1) + mod(s(j+1), 256), 256);
A1 = int16(inputdata(k)) - int16(s(t+1));
if A1 < 0
A1 = A1 + 256;
end
outputdata(k) = mod(A1, 256);
end
end