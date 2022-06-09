%--------------------------------------------------------------------------
% Données :
% DataA      : les données d'apprentissage (connues)
% LabelA     : les labels des données d'apprentissage
%
% DataT      : les données de test (on veut trouver leur label)
% Nt_test    : nombre de données tests qu'on veut labelliser
%
% K          : le K de l'algorithme des k-plus-proches-voisins
% ListeClass : les classes possibles (== les labels possibles)
%
% Résultat :
% [personne, posture] : pour les Nt_test données de test, le label calculé
%
%--------------------------------------------------------------------------
function [personne, posture] = kppv(DataA, LabelA, image_test, Nt_test, k, ListeClass)

[Na,~] = size(DataA);

% Initialisation du vecteur d'étiquetage des images tests et de la matrice
% de confusion
Partition = zeros(Nt_test,1);


disp(['Classification des images test dans ' num2str(length(ListeClass)) ' classes'])
disp(['par la methode des ' num2str(k) ' plus proches voisins:'])
% Boucle sur les vecteurs test de l'ensemble de l'évaluation
for i = 1:Nt_test
    
    disp(['image test n°' num2str(i)])

    % Calcul des distances entre le vecteur de test 
    % et les vecteurs d'apprentissage (voisins)
    A = repmat(DataT(i,:),Na, 1);
    M = A - DataA;
    D = sqrt(sum(M.*M,2));
    
    % On ne garde que les indices des K + proches voisins
    [~, ind] = sort(D, "ascend");
    classes = LabelA(ind,:);
    data = DataA(ind, :);
    classes = classes(1 : k);
    data = data(1 : k, :);

    % Comptage du nombre de voisins appartenant à chaque classe
    nb_v = [sum(classes == 0)];
    for j = 1: 9
        nb_v = [nb_v; sum(classes == j)];
    end
    % Recherche des classes contenant le maximum de voisins
    [~,cls_max] = max(nb_v);
    nb_cls_max = sum(classes == cls_max);
    % Si l'image test a le plus grand nombre de voisins dans plusieurs  
    % classes différentes, alors on lui assigne celle du voisin le + proche,
    % sinon on lui assigne l'unique classe contenant le plus de voisins 
    if nb_cls_max == 1
        cls_max = classes(1);
    end
    
    % Assignation de l'étiquette correspondant à la classe trouvée au point 
    % correspondant à la i-ème image test dans le vecteur "Partition" 
    Partition(i) = cls_max-1;
    
end
