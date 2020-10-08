close all

clc
clear vars
clear

% %MATRIZ RAND�MICA
n = 40;
qv = 4;
% rg = 20;%range de tempo de execu��o e dist�ncia
% 
% %MODO MATRIZ DIST�NCIA
% d = floor(rg*rand(n,1)); % The diagonal values
% t = floor(triu(bsxfun(@min,d,d.').*rand(n),1)); % The upper trianglar random values
% Drand = diag(d)+t+t.'+1; % Put them together in a symmetric matrix

%MATRIZ RANDOMICA xy

xmax = 200;
ymax = 200;
Drand = zeros(n,n);

VX = randi([-xmax xmax], 1, n);
VY = randi([-ymax ymax], 1, n);

%figure
%scatter(VX,VY,10,[0 0 0], 'filled')

for i = 1:n
    for ii = 1:n
        if i == ii
            Drand(i,ii) = 0;
            else Drand(i,ii) = pdist([VX(i) VY(i);VX(ii) VY(ii)],'euclidean');
        end
    end
end

delete ("3.VARIAVEIS/Drand_40.mat");
save ("3.VARIAVEIS/Drand_40.mat",'Drand');
delete ("3.VARIAVEIS/VX_40.mat");
save ("3.VARIAVEIS/VX_40.mat",'VX');
delete ("3.VARIAVEIS/VY_40.mat");
save ("3.VARIAVEIS/VY_40.mat",'VY');
delete ("3.VARIAVEIS/n_40.mat");
save ("3.VARIAVEIS/n_40.mat",'n');
delete ("3.VARIAVEIS/qv_40.mat");
save ("3.VARIAVEIS/qv_40.mat",'qv');

%% GERAÇÃO DE ATRIBUTOS ALEATÓRIOS
%7 ATRIBUTOS CONFORME SEQUÊNCIA
%COME OU EMERG

for i =1:n
    %ATRIBUTOS PARA AMBOS
    Atr(i,2) = randi(50)*10;
    if rand()>0.7
        Atr(i,3) = 2;
    else Atr(i,3) = 1;
    end
    if rand()>0.7
        Atr(i,4) = 1;
    else Atr(i,4) = 0;
    end
    %Com ou emerg
    if rand() > 0.75
        %COMERCIAL
        Atr(i,1) = 0;
        Atr(i,5) = 0;
        Atr(i,6) = 0;
        Atr(i,7) = randi(12);
    else
        %EMERG
        if rand>0.8
            Atr(i,1) = randi(1000);
        else 
            if rand > 0.5
                Atr(i,1) = randi(100);
            else 
                if rand > 0.25
                    Atr(i,1) = randi(10);
                else Atr(i,1) = 1;
                end
            end
        end
        Atr(i,5) = randi(24);
        if rand()>0.7
            Atr(i,6) = 1;
        else Atr(i,6) = 0;
        end
        Atr(i,7) = 0;
        %EUSD TOTAL É EUSD * QUANTIDADE DE CLIENTES
        Atr(i,2) = Atr(i,2) * Atr(i,1);
    end

end

delete ("3.VARIAVEIS/Atr_40.mat");
save("3.VARIAVEIS/Atr_40.mat",'Atr');

scatter(VX,VY)