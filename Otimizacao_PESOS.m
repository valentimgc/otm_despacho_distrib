close all
%clc;
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

load VX_60.mat
load VY_60.mat
load n_60.mat
load qv_60.mat
load Drand_60.mat
load Atr_60.mat

%RODAR AHP/PROMETHEE
AHP_PROMETHEE

%Mfunt = [10000 2 3 1 2 1 1 1000 2 3 4 5 2 1 2 3 4 1 100000 1];

%VARIAVEIS DE ENTRADA
qclusd = n; %cluster distancia
qclusp = qv; %cluster angular

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

%ACHA INDIVÍDUO VEICULAR ORIGINAL
% for i=1:n
%     NVx(1,Ang_ax(i,2)) = Ang_ax(i,3);
% end

%ORDENA NOTAS POR PESOS E ACHA INDIVIDUO ORIGINAL DAS SEQUÊNCIAS
D0ax(:,2) = Mfunt;
for i=1:n
    D0ax(i,1) = i;
end
D0ax = sortrows(D0ax,2,'descend');
NSx(1,:) = D0ax(:,1);

%% HEURÍSTICA BUSCA TABU PARA PERCORRER VEÍCULOS
c=1;
for it = 1:(divn) % GIRO ANGULAR
    %REFERÊNCIA DPO NSx
    NSref(it,:) = D0ax(:,1);
    %CÁLCULO DO NVx
    for i=1:n
        NVx(it,Ang_ax(i,2)) = Ang_ax(i,3);
    end
    
    Tabu = zeros(n) + diag(zeros(n,1)+it);
    
    if it == 1
        %fobjmin(it,1) = Fx_PESOS(n,qv,NSx(1,1,:),NVx(1,:),Drand,VX,VY,Mfunt);
        fobjmin(1) = Fx_PESOS(n,qv,NSx(1,:),NVx(1,:),Drand,VX,VY,Mfunt);
        NSxmin = NSx(1,:);
        NVxmin = NVx(1,:);
        fminV = fobjmin(it,1);
    %else fobjmin(it,1) = fminV;
    end
    
    fminit(it) = Fx_PESOS(n,qv,NSx(1,:),NVx(1,:),Drand,VX,VY,Mfunt);

    %BUSCA TABU POR CONFIGURAÇÃO DE NVX
    same = 0;
    i =1;
    while same<3 %CRITÉRIO DE PARADA
        i = i+1;
        %c = 1;
        ii = 1;
        while ii<=n-1 && same<n %PERCORRE TODAS AS NOTAS
            n1 = D0ax(ii,1);
            n2 = D0ax(1,1);
            iii = 1;
            while (Tabu(n1,n2) ~=0 || NVx(it,n1) ~= NVx(it,n2) || n1==n2 ) && iii~=(n+1)
                n2 = D0ax(iii,1);
                iii = iii + 1;
            end
            if Tabu(n1,n2) ==0
                Tabu(n1,n2) = i;
                Tabu(n2,n1) = i;
            end
            if c == 37
                clear k;
            end
            
            if iii ~= (n+1)
                Itv(c) = it;
                Ittabu1(c) = i;
                Ittabu2(c) = ii;
                %NSx(c,:) = NSxmin;
                NSx(c,:) = NSref(it,:);
                p1 = NSx(c,n1);
                p2 = NSx(c,n2);
                NSx(c,n2) = p1;
                NSx(c,n1) = p2;
                fob(c) = Fx_PESOS(n,qv,NSx(c,:),NVx(it,:),Drand,VX,VY,Mfunt);
                %fob(it,c) = Fx_PESOS(n,qv,NSx(it,c,:),NVx(it,:),Drand,VX,VY,Mfunt);
                
                if fob(c) < fminit(it)
                    fminit(it) = fob(c);
                    NSref(it,:) = NSx(c,:);
                    same = 0;
                end
                
                if fob(c) < fminV
                %if fob(it,c) < fminV
                    %fobjmin(it,c+1) = fob(it,c);
                    fobjmin(c+1) = fob(c);
                    %fminV = fob(it,c);
                    fminV = fob(c);
                    NSxmin = NSx(c,:);
                    NVxmin = NVx(it,:);
                    same = 0;
                else 
                    fobjmin(c+1) = fobjmin (c);
                %else fobjmin(it,c+1) = fobjmin (it,c);
                    %fminV = fobjmin (it,c);
                    fminV = fobjmin (c);
                end
                c= c+1;
            else
            ii = ii+1;  
            end
            same = same+1;
        end
        %ii = ii+1;
    end
    
    %VARIAÇÃO ANGULAR
    Ang_axi = Ang_ax;
    temp = Ang_axi;
    i = 1;
    for i = 1:n-1
        Ang_axi(i+1,3) = temp(i,3);
    end
    Ang_axi(1,3) = temp(n,3);
    Ang_ax = Ang_axi;
end

%% PLOTAR FIGURAS

%PLOTAR NOTAS
figure
scatter(VX,VY,20,[0 0 0],'filled')
title('Serviços disponíveis para atendimento')

%Plotar FOB
figure
plot(fobjmin,"Color",'k');
hold on
plot(fob,"LineStyle",":","Color",'k');
title('Evolução do valor da Função Objetivo')
xlabel('Iterações (i)');
ylabel('Valor da função objetivo F(x_i)')
legend({'Solução incumbente','F(x_i)'},"Location","north")

%Plotar Iterações
figure
plot(Itv,"Color",'k');
title('Permanência das Iterações por giro angular')
xlabel('Iterações (i)');
ylabel('Identificador de giro angular')
%figure;
%plot(fob);

%% PLOTAGEM DOS 2 CLUSTERS E DA SOLUÇÃO INICIAL
sym = 'o+*.xsd^v><ph';

%PLOTAR MELHOR SOLUÇÃO
Plot_Solucao(n,qv,NSxmin,NVxmin,VX,VY)
title('Melhor solução')
figure
gscatter(VX,VY,NVxmin,'k',sym);
legend('Location','northeastoutside','Orientation','vertical');
leg = legend('show');
title(leg,'Veículos');
title('Cluzterização melhor solução');
    
    %%
    % [Clus_d,C,sumd,Ctr_d] = kmeans(Dist.', qclusd);
    %NVx = Clus_a.';
    %NSx = Clus_d.';
    
    
    %AVALIAR TODOS ABAIXO:
    
    
%     fobj(it) = Fx(n,qv,NSx(it,:),NVx(it,:),Drand,VX,VY);
%     
%     %MENOR FUNÇÃO OBJETIVO
%     if it == 1
%         fobjmin(it) = fobj(it);
%     elseif fobj(it) < fobjmin(it-1)
%         fobjmin(it) = fobj(it);
%     else fobjmin(it) = fobjmin(it-1);
%     end
%     
%     %Variação sequência angular entre notas
%     Ang_axi = Ang_ax;
%     temp = Ang_axi;
%     i = 1;
%     for i = 1:n-1
%         Ang_axi(i+1,3) = temp(i,3);
%     end
%     Ang_axi(1,3) = temp(n,3);
%     Ang_ax = Ang_axi;
% 
% posmin = find(fobj==min(fobj));
% NVxmin = NVx(posmin,:);
% NVxmin = NVxmin(1,:);
% NSxmin = NSx(posmin,:);
% NSxmin = NSxmin(1,:);
% 

% 
% %PLOTAR SOLUÇÃO ORIGINAL
% Plot_Solucao(n,qv,NSx(1,:),NVx(1,:),VX,VY)
% title('Solução original');
% figure
% gscatter(VX,VY,NVx(1,:),'k',sym);
% legend('Location','northeastoutside','Orientation','vertical');
% leg = legend('show');
% title(leg,'Veículos');
% title('Cluzterização original');
% 
% figure
% %PLOTAR FUNÇÃO OBJETIVO
% plot(fobj,'LineWidth',1,"LineStyle","--","Marker","*","Color",'k',"DisplayName","Original");
% hold on
% plot(fobjmin,'LineWidth',2,"LineStyle","-","Marker","o","Color",'k');
% legend({'Simulações','Melhor Resultado'},"Location","north")
% title('Evolução do valor da função objetivo')