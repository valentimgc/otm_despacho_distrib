%FUN��O PLOTAR SOLU��O FINAL

function Plot_Solucao(n,qv,NSmin,NVmin,VX,VY)

arrplotx = zeros(n,qv);
arrploty = zeros(n,qv);
qvaux = zeros(1,qv)+1;

for ii=1:n
    for i=1:n
        if NSmin(1,i) == ii
            posqv = qvaux(NVmin(i)); %procura a posi��o do ve�culo
            qvaux(NVmin(i)) = qvaux(NVmin(i))+1; % adiciona uma pois��o para a proxima nota
            if VX(i) == 0
                VX(i) = 0.001;
            end
            if VY(i) == 0
                VY(i) = 0.001;
            end
            arrplotx(posqv,NVmin(i)) = VX(i);
            arrploty(posqv,NVmin(i)) = VY(i);
        end
    end
end

%scatter(VX,VY,'o')

plaux = zeros(1,qv);

arrplotx(arrplotx==0)=nan;
arrploty(arrploty==0)=nan;

arrplotx = [plaux; arrplotx];
arrploty = [plaux; arrploty];

figure
%plot(arrplotx,arrploty,'-o')
plot(arrplotx,arrploty,'-o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',5,"Color",'k')

end