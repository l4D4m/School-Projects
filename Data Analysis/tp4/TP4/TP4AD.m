%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Analyse de donnees
% TP4 - Reconnaissance de chiffres manuscrits par k plus proches voisins
% TP4AD.m
%--------------------------------------------------------------------------

clear
close all
clc

% Chargement des images d'apprentissage et de test
load MNIST

%   database_test_images       10000x784             
%   database_test_labels       10000x1             
%   database_train_images      60000x784           
%   database_train_labels      60000x1      

DataA = database_train_images;
clear database_train_images
DataT = database_test_images;
clear database_test_images
LabelA = database_train_labels;
clear database_train_labels
LabelT = database_test_labels;
clear database_test_labels

% Choix du nombre de voisins
K = 1;

% Initialisation du vecteur des classes
ListeClass = 0:9;

% Nombre d'images test
[Nt,~] = size(DataT);
Nt_test = 30; % A changer, pouvant aller de 1 jusqu'à Nt

% Classement par l'algorithme des k-ppv
[Partition] = kppv(DataA, LabelA, DataT, Nt_test, K, ListeClass);
matrice_confusion = zeros(Nt_test);
for i = 1:10
    matrice_confusion(LabelT(i)+1, Partition(i)+1) = 1;
end
% affichage des images avec leur label calculé
figure;
for i = 1 : 30
    subplot(5,6,i);
    colormap gray;
    imagesc(reshape(DataT(i,:),28,28));
    axis off;
    axis equal;
    title(int2str(Partition(i)),'FontSize',20);
end
