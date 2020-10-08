% FUNCAO OBJETIVO
%CALCULADA PARA UMA GERACAO DE NS x NV, ou seja, vetores lineares

function [fobti] = Fx(n,qv,NS,NV,D,VX,VY)

%for iii=1:pop %POP
        fob = zeros(qv,1); %funcao objetivo para cada veiculo        
        Vaux = zeros(qv,1); % grava sequencia imediatamente anterior para cada veiculo
        ord = 1;
        while ord <= n
            i = 1; % percorre as sequencias
            while NS(1,i) ~= ord
                i =i+1;
            end
            vi = NV(1,i);

            if Vaux(vi,1) == 0
                ser = D(i,i); % tempo servico
                des = sqrt(VX(i)^2+VY(i)^2); %deslocamento a partir da EA (ponto 0,0)
                fob(vi) = ser;
            else
                ser = D(i,i);
                des = D(Vaux(vi),i); %tempo deslocamento
                fob(vi) = des + ser + fob(vi);
            end
            Vaux(vi) = i;
            ord = ord + 1;
        end
        fobti = sum(fob);
end