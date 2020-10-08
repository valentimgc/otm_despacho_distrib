%ROTINA PARA MATRIZ NS ESTÁTICA A PARTIR DA MENOR DISTÂNCIA

clc;
%clear esc
%clear idx2
%clear Max
%clear Dist
%clear NSx
%clear NVx
%clear Ang
%clear fobj
clc
clear vars
clear
close all

load VX.mat
load VY.mat
load n
load Drand


%VARIAVEIS DE ENTRADA
qv = 4;
qclusd = n; %cluster distancia
qclusp = qv; %cluster angular

%DADOS CLUSTER DISTANCIA
for iii=1:n
   Dist(iii,1) =  sqrt(VX(iii)^2+VY(iii)^2);
   Dist(iii,2) =  iii;
end
Dist_ax = sortrows(Dist);

for iii=1:n
    NSx(1,Dist_ax(iii,2)) = iii;
end

%INDIVIDUO ORIGINAL
%DADOS CLUSTER ANGULAR
Ang = atan2(VX,VY);
Ang = Ang.';
Ang(:,2) = [1:1:n];
Ang_ax = sortrows(Ang,1);
divn = fix(n/qclusp);

c = 1;
i = 1;
for i=1:n
    Ang_ax(i,3) = ceil(i/divn);
    if Ang_ax(i,3)>qclusp
        Ang_ax(i,3)=qclusp;
    end
end

for it = 1:(divn+divn)
%for it = 1:qv

    i = 1;
    for i=1:n
        NVx(it,Ang_ax(i,2)) = Ang_ax(i,3);
    end
    
    % [Clus_d,C,sumd,Ctr_d] = kmeans(Dist.', qclusd);
    %NVx = Clus_a.';
    %NSx = Clus_d.';
    fobj(it) = Fx(n,qv,NSx,NVx(it,:),Drand,VX,VY);
    
    %MENOR FUNÇÃO OBJETIVO
    if it == 1
        fobjmin(it) = fobj(it);
    elseif fobj(it) < fobjmin(it-1)
        fobjmin(it) = fobj(it);
    else fobjmin(it) = fobjmin(it-1);
    end
    
    %Variação sequência angular entre notas
    Ang_axi = Ang_ax;
    temp = Ang_axi;
    i = 1;
    for i = 1:n-1
        Ang_axi(i+1,3) = temp(i,3);
    end
    Ang_axi(1,3) = temp(n,3);
    Ang_ax = Ang_axi;
    
end

posmin = find(fobj==min(fobj));
NVxmin = NVx(posmin,:);
NVxmin = NVxmin(1,:);

%% PLOTAGEM DSOS 2 CLUSTERS E DA SOLUÇÃO INICIAL
%gscatter(VX.', VY.',NVxmin.')

%PLOTAR MELHOR SOLUÇÃO
Plot_Solucao(n,qv,NSx,NVxmin,VX,VY)
title('Melhor solução')
axis([-200 200 -200 200])

%PLOTAR SOLUÇÃO ORIGINAL
Plot_Solucao(n,qv,NSx,NVx(1,:),VX,VY)
title('Solução original')
axis([-200 200 -200 200])

figure
%PLOTAR FUNÇÃO OBJETIVO
plot(fobj,'LineWidth',1,"LineStyle","--","Marker","*","Color",'k',"DisplayName","Original");
hold on
plot(fobjmin,'LineWidth',2,"LineStyle","-","Marker","o","Color",'k');
legend({'Simulações','Melhor Resultado'},"Location","north")
title('Evolução do valor da função objetivo')