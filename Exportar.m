%% EXPORTAR MATRIZ / VETOR PARA CSV 
% ---- ALTERAR NOME E VARIÁVEL
%writematrix("3.VARIAVEIS/PESO.mat",'EXP_TAB/M_tab.csv',"Delimiter",'tab')
%writematrix("3.VARIAVEIS/Atr.mat",'EXP_TAB/M_tab.csv',"Delimiter",'tab')

%% EXPORTAR FIGURA
% ---- RODAR FUNÇÃO COM A FIGURA ABERTA
set(gcf, 'PaperUnits', 'inches');
x_width=6 ;
y_width=3.5;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
saveas(gcf,"IMAGENS/60_melhor_solucao_500.png")