function Q = EllipticCurveFastScalMult(P, x, a, b, p)


mult = x;
Q = [inf inf];
D = P;

while mult > 0
    if  mod(mult,2) == 1
        Q = EllipticCurvePointAdditionModp(Q, D, a, b, p);
    end   
    mult = floor(mult/2);
    D = EllipticCurvePointAdditionModp(D, D, a, b, p);
end
