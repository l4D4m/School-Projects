clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread('ishihara-0.png');
figure(1);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

% Affichage du canal R :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(R);
axis off;
axis equal;
title('Canal R','FontSize',20);

% Affichage du canal V :
subplot(2,2,3);
imagesc(V);
axis off;
axis equal;
title('Canal V','FontSize',20);

% Affichage du canal B :
subplot(2,2,4);
imagesc(B);
axis off;
axis equal;
title('Canal B','FontSize',20);

% Affichage du nuage de pixels dans le repere RVB :
figure(2);				% Deuxieme fenetre d'affichage
plot3(R,V,B,'b.');
axis equal;
xlabel('R');
ylabel('V');
zlabel('B');
rotate3d;

% Matrice des donnees :
X = [R(:), V(:), B(:)];			% Les trois canaux sont vectorises et concatenes

% Matrice de variance/covariance :
[n,~] = size (X);
Xc = X - ones(n, 1)*mean(X);
sigma = Xc'*Xc/n;

% Calcul des valeurs et vecteurs propres de la matrice sigma :
[W, D] = eig(sigma);
D = sort (diag(D), 'descend');
W = [ W(:,3), W(:,2), W(:,1)];
C = X*W;

% Reconstruire l'image :
Dim1 = reshape(C(:,1), size(I, 1), size(I, 2));
Dim2 = reshape(C(:,2), size(I, 1), size(I, 2));
Dim3 = reshape(C(:,3), size(I, 1), size(I, 2));

% Affichage de Dim1 :
subplot(2,2,4);
imagesc(Dim1);
axis off;
axis equal;
title('Canal Dim1','FontSize',20);

% Affichage de Dim2 :
subplot(2,2,2);
imagesc(Dim2);
axis off;
axis equal;
title('Canal Dim2','FontSize',20);

% Affichage de Dim3 :
subplot(2,2,1);
imagesc(Dim3);
axis off;
axis equal;
title('Canal Dim3','FontSize',20);
