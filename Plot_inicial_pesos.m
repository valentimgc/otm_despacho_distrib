%PLOTAR COM E SEM PESOS
load VX
load VY
load Mfunt
figure
scatter(VX,VY,15,[0 0 0])%,'filled')
xlim([-200 200])
ylim([-200 200])
title('Indicação geográfica de notas de serviço')

%PLOTAR COM PESOS
%figure
%scatter(VX,VY,Mfunt*10,[0 0 0],'filled')
%xlim([-200 200])
%ylim([-200 200])
%title('Indicação de notas de serviço ponderadas por seus pesos')
