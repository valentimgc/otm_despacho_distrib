% FUNCAO OBJETIVO PONDERADA
%CALCULADA PARA UMA GERACAO DE NS x NV, ou seja, vetores lineares

function [fobti] = Fx_PESOS(n,qv,NS,NV,D,VX,VY,Mfunt)

    fobd = zeros([qv 1]);
    fobp = zeros([qv 1]);
    Ant = zeros([qv 1]);
    for i=1:n
        ii = 1;
        while NS(ii) ~= i
            ii = ii+1;
        end
        if fobd(NV(ii)) ~= 0
            td = D(ii,Ant(NV(ii))); %TEMPO DESLOCAMENTO ENTRE NOTAS
        else td = sqrt(VX(ii)^2+VY(ii)^2);
        end
        te = D(ii,ii); %TEMPO SERVIÇO
        fobd(NV(ii)) = fobd(NV(ii)) + td + te; %ARQUIVA TEMPOS
        aux = fobd(NV(ii))*Mfunt(ii); %MULTIPLICA TEMPOS * PESOS
        fobp(NV(ii)) = fobp(NV(ii)) + aux;
        Ant(NV(ii)) = ii; %ARQUIVA NOTA ANTERIOR
    end
    fobti = sum(fobp);
    
end