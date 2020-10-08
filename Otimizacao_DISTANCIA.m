close all;
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

load VX_60.mat
load VY_60.mat
load n_60.mat
load qv_60.mat
load Drand_60.mat
load Atr_60.mat

%VARIAVEIS DE ENTRADA
qclusd = n; %cluster distancia
qclusp = qv; %cluster angular

%RODAR AHP/PROMETHEE
AHP_PROMETHEE

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

iterac = 5;

NSx = zeros(iterac,n);

for it = 1:(divn*2)
    if it == 3
        3;
    end
    i = 1;
    for i=1:n
        NVx(it,Ang_ax(i,2)) = Ang_ax(i,3);
    end
    
    %% HEURÍSTICA PARA MENOR DISTANCIA A PARTIR DA NOTA
    cs = 1;
    for i=1:qv % PERCORRE VEICULOS
        clear Seqax
        
        c = 1;
        for ii=1:n
            if NVx(it,ii) == i
                Seqax(c) = ii;
                c = c+1;
            end
        end
        Seqax = Seqax';
        tam = length(Seqax);
        
        %ENCONTRA A NOTA MAIS PERTO DA ORIGEM
        D0ax = Seqax;
        for ii=1:tam
            D0ax(ii,2) = sqrt(VX(D0ax(ii))^2+VY(D0ax(ii))^2);
        end
        D0ax = sortrows(D0ax,2);
        NSx(it,D0ax(1,1)) = cs;
        cs = cs+1;
        
        %ORDENA NOTAS DENTRO DO CLUSTER
        naux = D0ax(1,1);
        
        for ii=1:(tam-1)
            Dnax = Seqax;
            %ORDENA EM RELAÇÃO À NOTA NAUX
            for iii=1:tam
                %Matriz Dnax: n | dist até naux
                Dnax(iii,2) = Drand(naux,Dnax(iii,1));
            end
            Dnax = sortrows(Dnax,2);
            
            %ENCONTRA O MAIS PERTO VIÁVEL
            iii = 1;
            while NSx(it,Dnax(iii,1))~=0
                iii = iii+1;
                if iii > tam
                    break
                end
            end
            if iii <= tam
                NSx(it,Dnax(iii,1)) = cs; %%%COLOCAR PRÓXIMO ÍNDICE
                cs = cs+1;
            end
            naux = Dnax(iii,1);
        end
    
    1;
    
    
    
    
    
    
    end
    
    %%
    % [Clus_d,C,sumd,Ctr_d] = kmeans(Dist.', qclusd);
    %NVx = Clus_a.';
    %NSx = Clus_d.';
    fobj(it) = Fx(n,qv,NSx(it,:),NVx(it,:),Drand,VX,VY);
    
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
NSxmin = NSx(posmin,:);
NSxmin = NSxmin(1,:);

%% PLOTAGEM DOS 2 CLUSTERS E DA SOLUÇÃO INICIAL
%AJUSTAR PARA QUANTIDADE DE SIMBOLOS
%sym = 'o+*.xsd^v><ph';
sym = 'o+*.xsd^v><ph';

%PLOTAR NOTAS
figure
scatter(VX,VY,20,[0 0 0],'filled')
title('Serviços disponíveis para atendimento')

%PLOTAR SOLUÇÃO ORIGINAL
Plot_Solucao(n,qv,NSx(1,:),NVx(1,:),VX,VY)
title('Solução original');
figure
gscatter(VX,VY,NVx(1,:),'k',sym);
legend('Location','northeastoutside','Orientation','vertical');
leg = legend('show');
title(leg,'Veículos');
title('Clusterização original');

figure
gscatter(VX,VY,NVx(2,:),'k',sym);
legend('Location','northeastoutside','Orientation','vertical');
leg = legend('show');
title(leg,'Veículos');
title('Clusterização primeira iteração');

figure
gscatter(VX,VY,NVx(3,:),'k',sym);
legend('Location','northeastoutside','Orientation','vertical');
leg = legend('show');
title(leg,'Veículos');
title('Clusterização segunda iteração');

%PLOTAR MELHOR SOLUÇÃO
Plot_Solucao(n,qv,NSxmin,NVxmin,VX,VY)
title('Melhor solução')
figure
gscatter(VX,VY,NVxmin,'k',sym);
legend('Location','northeastoutside','Orientation','vertical');
leg = legend('show');
title(leg,'Veículos');
title('Clusterização melhor solução');

figure
%PLOTAR FUNÇÃO OBJETIVO
plot(fobj,'LineWidth',1,"LineStyle","--","Marker","*","Color",'k',"DisplayName","Original");
hold on
plot(fobjmin,'LineWidth',2,"LineStyle","-","Marker","o","Color",'k');
legend({'F(x_i)','Solução incumbente'},"Location","north")
title('Evolução do valor da função objetivo')
xlabel('Iterações (i)');
ylabel('Valor da função objetivo F(x_i)')