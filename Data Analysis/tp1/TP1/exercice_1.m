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
sigma = (Xc'*Xc)/n;

% Coefficients de correlation lineaire :
r_RV = sigma(1, 2)/sqrt(sigma(1, 1)*sigma(2, 2));
r_RB = sigma(1, 3)/sqrt(sigma(1, 1)*sigma(3, 3));
r_VB = sigma(2, 3)/sqrt(sigma(2, 3)*sigma(3, 3));

% Proportions de contraste :
c_R = sigma(1, 1)/trace(sigma);
c_V = sigma(2, 2)/trace(sigma);
c_B = sigma(3, 3)/trace(sigma);