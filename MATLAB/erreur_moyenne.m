m1 = [120 127 127 127 127];
m2 = [130 127 128 128 128];
sig1 = [1 1 1 0.1 2];
sig2 = [2 5 1 0.1 3];

s = signal();

for i = 1:5

    T = 1000;

    abscisse = 1:T;
    tempo = premiere_idee_MV(s,m1(i),sig1(i),m2(i),sig2(i));
    res = zeros(size(abscisse));
    res(1) = tempo;

    for k = 2:T
        taux = premiere_idee_MV(s,m1(i),sig1(i),m2(i),sig2(i));
        tempo = tempo + (taux/(k-1));
        tempo = tempo * ((k-1)/k);
        res(k) = tempo;
    end

    plot(abscisse,res)
    figure()
    res(T)
end