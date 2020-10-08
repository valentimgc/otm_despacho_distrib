load Drand_60.mat
load n_60.mat

for i = 1:n
    for ii = 1:n
        if i == ii
            Drand(i,ii) = 500;
        end
    end
end

save ("3.VARIAVEIS/Drand_60.mat",'Drand');