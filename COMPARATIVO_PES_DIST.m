%TESTES FUNÇÕES

close all

Otimizacao_DISTANCIA
NSdist = NSxmin;
NVdist = NVxmin;

delete ("3.VARIAVEIS/NSdist.mat");
save ("3.VARIAVEIS/NSdist.mat",'NSdist');
delete ("3.VARIAVEIS/NVdist.mat");
save ("3.VARIAVEIS/NVdist.mat",'NVdist');

Otimizacao_PESOS
NSpes = NSxmin;
NVpes = NVxmin;

load NSdist
load NVdist

close all

%PLOTAR DISTANCIA
Plot_Solucao(n,qv,NSdist,NVdist,VX,VY)
title('Melhor solução Distância')

%PLOTAR PESOS
Plot_Solucao(n,qv,NSpes,NVpes,VX,VY)
title('Melhor solução Pesos')
    
fPESO_melhor_DIST = Fx_PESOS(n,qv,NSdist,NVdist,Drand,VX,VY,Mfunt)
fPESO_melhor_PESO = Fx_PESOS(n,qv,NSpes,NVpes,Drand,VX,VY,Mfunt)

fDIST_melhor_DIST = Fx(n,qv,NSdist,NVdist,Drand,VX,VY)
fDIST_melhor_PESO = Fx(n,qv,NSpes,NVpes,Drand,VX,VY)