%AHP + PROMETHEE
%SEQUÊNCIA DE CRITÉRIOS
%QUANTIDADE DE CLIENTES | EUSD TOTAL | LOCALIZAÇÃO | CLIENTES CRÍTICOS | TEMPO DE ATENDIMENTO EMERGENCIA | EVENTO DE RISCO | TEMPO DE VENCIMENTO ANEXO III

%DEFINIÇÃO MAIOR / MENOR
%1 É MAIOR 0 É MENOR
Mai_men = [1 1 0 1 1 1 0];
crit = 7;

% DEFINIÇÃO DE PESOS: DESCOMENTAR PARA ALTERAR
PESO = [0.20 0.09 0.03 0.14 0.05 0.46 0.03];
delete ("3.VARIAVEIS/PESO.mat");
save("3.VARIAVEIS/PESO.mat",'PESO');

%ATRIBUTOS
%Atr = [40 1000.00 1 0 2 0 0;100 500.00 1 0 5 0 0;5 200.00 1 1	24 1 0; 10 200.00 2 0 12 0 0;2 2000.00 2 0 2 0 0;0 1500.00 1 0 0 0 1;0 500.00 1 1 0 0 5];
%delete Atr.sai
%save Atr.sai -ascii

load PESO.mat

Max_atr = max(Atr,[],1);
Min_atr = min(Atr,[],1);

%n = número de linhas
n = length(Atr);

for i = 1:crit
    for ii=1:n
        if Mai_men(i)==1
            M1(ii,i) = (Atr(ii,i)-Min_atr(i))/(Max_atr(i)-Min_atr(i));
        else M1(ii,i) = (Max_atr(i)-Atr(ii,i))/(Max_atr(i)-Min_atr(i));
        end
    end
end

l = 1;
for i=1:n
    for ii =1:n
        if ii ~= i
            for c = 1:crit
                M2(l,c) = M1(i,c)-M1(ii,c);
            end
            l = l+1;
        end
    end
end

n2 = length(M2);

for i=1:n2
    for ii=1:crit
        if M2(i,ii) > 0
            M3(i,ii) = PESO(ii)*M2(i,ii);
        else M3(i,ii) = 0;
        end
    end
end

M3v = sum(M3,2);

i = 1;
for l = 1:n
    for c = 1:n
        if l ~= c
            M4(l,c) = M3v(i);
            i = i+1;
        else M4(l,c) = 0;
        end
    end
end

Lfl = sum(M4,2);
Efl = (sum(M4,1)).';

Mf =  Lfl-Efl;
Mfunt = (Mf-min(Mf))/abs(min(Mf))+1;

delete ("3.VARIAVEIS/Mfunt.mat");
save("3.VARIAVEIS/Mfunt.mat",'Mfunt');
