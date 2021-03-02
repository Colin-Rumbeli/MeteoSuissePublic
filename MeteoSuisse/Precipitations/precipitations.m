%précipitations : sommation sur 10 minutes

%nom de la station
nom='Zermatt'

%définition fid
fid=fopen(['C:\Users\colin\Documents\Cours\Round 2\Info\MeteoSuisse\MeteoSuisse\Precipitations\',nom,'.csv'],'r')

%extraction données :   date heure      mesure
data_pluie=textscan(fid,'%s %f %*s %*s','Headerlines',1,'Delimiter',',');

%%%%%%%%%%%%%précipitations journalières : sommation
%
%création d'un tableau avec une case par jour
pluie_jour = zeros(ceil(length(data_pluie{1, 2})/144),1);
%sommation des data par jour
for j=1:length(pluie_jour)
    ligne = j*144;
    for i=ligne-143:ligne
        if i>length(data_pluie{1, 2})
            break
        else
            pluie_jour(j) = pluie_jour(j)+data_pluie{1, 2}(i);
        end
    end
end

%%%%%%%%%%%%%précipitations mensuelles : sommation
%
%
% inititalisation des variables
pluie_mens={0,0};
month=1
som_mois_courant=0;
%nom premier mois
pluie_mens{1,1}=datestr(data_pluie{1, 1}(1, 1),'mmmyyyy');
for j=2:length(data_pluie{1, 1})
    %dernier mois
    if j==length(data_pluie{1,1});
        pluie_mens{month,2}=som_mois_courant
        %     changement de mois
    elseif datestr(data_pluie{1, 1}(j, 1),'mmmyyyy')==datestr(data_pluie{1, 1}(j-1,1),'mmmyyyy');
        % sommation
        som_mois_courant=som_mois_courant+data_pluie{1, 2}(j, 1);
    else
        %transfert mois courant à tableau pluie mensuel
        pluie_mens{month,2}=som_mois_courant
        % mois courant +1
        month=month+1
        % nom nouveau mois courant
        pluie_mens{month,1}=datestr(data_pluie{1, 1}(j, 1),'mmmyyyy');
        
        % remise à zéro du compteur
        som_mois_courant=0;
    end
end

%%%%%%%%%%%%%%travail des sommes mensuelles
%
%
% changement de type de donnée pour graphe
overall=zeros(length(pluie_mens),1)
overall=cell2mat(pluie_mens(:,2))
%graphique et options
%plot(data_pluie{1, 2})
% plot(overall)

save(nom)