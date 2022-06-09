close all;
clear;
%% Données :
Fe = 24000;
Te = 1/Fe;

%% ETUDE SANS CANAL :
% Nombre de bits générés :
nb_bits = 10000; %100
Rb = 3000;
% Nombre d échantillons (Ts=NsTe)
Rs = Rb/log2(2); 
Ns = floor(Fe/Rb);
Ts = nb_bits/Rb;

% Réponse impulsionnelle du filtre de mise en forme :
h = ones (1, Ns);
% Réponse impulsionnelle du filtre de reception :
hr = h;
% Gérération de l'information binaire :
bits = randi ([0, 1], 1, nb_bits);
% Mapping :
Symboles = 2 * bits - 1;
% Génération des impulsions :
Impulsions = kron(Symboles, [1 zeros(1, Ns-1)]);
% Filtrage de mise en forme :
x = filter (h, 1, Impulsions);    %Signal à la sortie du modulateur

% Calcul de Puissance:
Px = mean(abs(x).^2);

%diagramme de l'oeil pour diffenrentes valeurs de Eb/N0
i=1;
figure;
for Eb_N0_dB = linspace(0,30,4)

    % Ajouter le bruit
    sigma_n = Px* Ns  / (2 * log2(2) * 10 ^ (Eb_N0_dB / 10));
    bruit = sqrt(sigma_n)*randn(1,length(x));
    y = x + bruit;
    
    % Filtrage de réception
    z = filter(hr, 1, y);
    
    %diagramme de l'oeil
    subplot(2,2,i);
    plot(reshape(z(Ns+1 : end),Ns,(length(z)-Ns)/Ns));
    title(strcat("Diagramme de l'oeil pour Eb/N0 = ", string(Eb_N0_dB), " dB."));
    i=i+1;
end

%Calcul de TEB
TEB = zeros(1, 9);
for Eb_N0_dB = 0 : 8
    % Ajouter le bruit
    sigma_n = Px* Ns  / (2 * log2(2) * 10 ^ (Eb_N0_dB / 10));
    bruit = sqrt(sigma_n)*randn(1,length(x));
    y = x + bruit;
    
    % Filtrage de réception
    z = filter(hr, 1, y);

    % Echantillonnage du signal
    z_echant = z(Ns : Ns : end);
    
    % Detecteur à seuil
    decr = sign(z_echant); % Décisions
    % Demapping
    demr = (decr + 1)/2; 
    testr = demr - bits;
    
    TEB(Eb_N0_dB+1) = length(find(testr~=0))/length(bits);
end
Eb_No = [0:8];

%%
% le taux d’erreur binaire (TEB) obtenu en fonction Eb/N0
figure;
semilogy([Eb_No], TEB, 'b-');
title("le taux d'erreur binaire (TEB) obtenu en fonction Eb/N0 (dB) pour la chaine de référence");
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

%Comparaison entre le TEB théorique et estimé
figure;
semilogy([Eb_No], TEB, 'b-');
hold on


semilogy([Eb_No], qfunc(sqrt((2 * 10 .^ ([0 : 8] / 10)))));
grid
title('Comparaison entre le TEB théorique et estimé pour la chaine de référence');
legend('TEB estimé','TEB théorique')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

%% Première chaine à étudier, implanter et comparer à la chaine de référence
%%
%Implantation de la chaine sans bruit
% Nombre de bits générés :

nb_bits = 10000;
Rb = 3000;
% Nombre d échantillons (Ts=NsTe)
Ns = floor(Fe/Rb);

% Gérération de l'information binaire :
bits = randi ([0, 1], 1, nb_bits);
% Mapping :
Symboles = 2 * bits - 1;
% Génération des impulsions :
Impulsions = kron(Symboles, [1 zeros(1, Ns-1)]);


% Réponse impulsionnelle du filtre de reception :
hr = [ones(1,Ns/2) zeros(1, Ns/2)];
h = ones(1,Ns);
x = filter (h, 1, Impulsions);    %Signal à la sortie du modulateur
r = filter (hr, 1, x);
figure; plot(reshape(r(Ns+1 : end),Ns,(length(r)-Ns)/Ns));
title("Diagramme de l'oeil en sortie du filtre de réception pour la première chaine");


%TEB
x_echant = r(Ns : Ns : end);
symboles_decides = sign(x_echant);
bits_decides = (symboles_decides + 1) / 2;
TEB = length(find(bits_decides ~= bits)) / length(bits);
fprintf("TEB obtenu sans bruit pour la première chaine est : %f\n",TEB);

%%
%Implantation de la chaine avec bruit
% Calcul de Puissance:
Px = mean(abs(x).^2);

%diagramme de l'oeil pour diffenrentes valeurs de Eb/N0
i=1;
figure;
for Eb_N0_dB = linspace(0,30,4)

    % Ajouter le bruit
    sigma_n = Px* Ns  / (2 * log2(2) * 10 ^ (Eb_N0_dB / 10));
    bruit = sqrt(sigma_n)*randn(1,length(x));
    y = x + bruit;
    
    % Filtrage de réception
    z = filter(hr, 1, y);
    
    %diagramme de l'oeil
    subplot(2,2,i);
    plot(reshape(z(Ns+1 : end),Ns,(length(z)-Ns)/Ns));
    title(strcat("Diagramme de l'oeil pour Eb/N0 = ", string(Eb_N0_dB), " dB."));
    i=i+1;
end

%TEB
TEB = zeros(1, 9);
for Eb_N0_dB = 0 : 8
    % Ajouter le bruit
    sigma_n = Px* Ns  / (2 * log2(2) * 10 ^ (Eb_N0_dB / 10));
    bruit = sqrt(sigma_n)*randn(1,length(x));
    y = x + bruit;
    
    % Filtrage de réception
    z = filter(hr, 1, y);

    % Echantillonnage du signal
    z_echant = z(Ns/2 : Ns : end);
    
    % Detecteur à seuil
    symboles_decides = sign(z_echant);
    % Demapping
    bits_decides = (symboles_decides + 1) / 2;
    TEB(Eb_N0_dB + 1) = length(find(bits_decides ~= bits)) / length(bits);
end

%%
% le taux d’erreur binaire (TEB) obtenu en fonction Eb/N0
figure;
semilogy([Eb_No], TEB, 'b-');
title("le taux d'erreur binaire (TEB) obtenu en fonction Eb/N0 (dB) pour la première chaine");
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

%Comparaison entre le TEB théorique et estimé
figure;
semilogy([Eb_No], TEB, 'b-');
hold on

semilogy([Eb_No], qfunc(sqrt((10 .^ ([0 : 8] / 10)))));
grid
title('Comparaison entre le TEB théorique et estimé pour la première chaine');
legend('TEB estimé','TEB théorique')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

%%
% Comparaison entre le TEB de la chaine de réference et la première chaine
figure;
semilogy([0 : 8], qfunc(sqrt((2 * 10 .^ ([0 : 8] / 10)))), 'r-');
hold on
semilogy([0 : 8], qfunc(sqrt((10 .^ ([0 : 8] / 10)))), 'b-');
grid
title('Comparaison entre le TEB de la chaine de réference et de la première chaine');
legend('TEB de la chaine de réference', 'TEB de la première chaine')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

%% Deuxième chaine à étudier, implanter et comparer à la chaine de référence
nb_bits = 10000;
Rb = 3000;
% Nombre d échantillons (Ts=NsTe)
Ns = floor(Fe/Rb);

% Réponse impulsionnelle du filtre de mise en forme :
h = ones (1, Ns);
% Réponse impulsionnelle du filtre de reception :
hr = h;
% Mapping :
Symboles = (2 * bi2de(reshape(bits, 2, length(bits)/2).') - 3).';
%%
%--------------------------------------------------------------------------
% Implantation de la chaine sans bruit
%--------------------------------------------------------------------------

% Génération des impulsions :
Impulsions = kron(Symboles, [1 zeros(1, Ns-1)]);
x = filter (h, 1, Impulsions);    %Signal à la sortie du modulateur

z = filter(hr, 1, x);

figure; plot(reshape(z(Ns+1 : end),Ns,(length(z)-Ns)/Ns));

title("Diagramme de l'oeil en sortie du filtre de réception pour la deuxième chaine");

%TEB
z_echant = z(Ns : Ns : end);
symboles_decides = zeros(1, length(z_echant));
for i = 1 : length(z_echant)
    if (z_echant(i) > 2 * Ns)
        symboles_decides(i) = 3;
    elseif (z_echant(i) >= 0)
        symboles_decides(i) = 1;
    elseif (z_echant(i) < - 2 * Ns)
        symboles_decides(i) = -3;
    else
        symboles_decides(i) = -1;
    end
end

% Demapping
bits_decides = reshape(de2bi((symboles_decides + 3)/2).', 1, length(bits));

TES = length(find(Symboles ~= symboles_decides)) / length(Symboles);       
TEB = TES/2;

fprintf("TEB obtenu sans bruit pour la deuxième chaine est : %f\n",TEB);
%%
%--------------------------------------------------------------------------
% Implantation de la chaine avec bruit
%--------------------------------------------------------------------------
% Calcul de Puissance:
Px = mean(abs(x).^2);

%calcul de TEB et TES en fonction de Eb_n0
TEB = zeros(1, 9);
TES = zeros(1, 9);
for Eb_N0_dB = 0 : 8
    % Ajouter le bruit
    sigma_n = Px* Ns  / (2 * log2(4) * 10 ^ (Eb_N0_dB / 10));
    bruit = sqrt(sigma_n)*randn(1,length(x));
    y = x + bruit;
    
    % Filtrage de réception
    z = filter(hr, 1, y);
    
    % Echantillonnage du signal
    z_echant = z(Ns : Ns : end);
    
    % Detecteur à seuil
    symboles_decides = zeros(1, length(z_echant));
    for i = 1 : length(z_echant)
        if (z_echant(i) > 2 * Ns)
            symboles_decides(i) = 3;
        elseif (z_echant(i) >= 0)
            symboles_decides(i) = 1;
        elseif (z_echant(i) < - 2 * Ns)
            symboles_decides(i) = -3;
        else
            symboles_decides(i) = -1;
        end
    end
    
    % Demapping
    bits_decides = reshape(de2bi((symboles_decides + 3)/2).', 1, length(bits));

    % Calcul du TES et du TEB
    TES(Eb_N0_dB + 1) = length(find(Symboles ~= symboles_decides)) / length(Symboles);       
    TEB(Eb_N0_dB + 1) = TES(Eb_N0_dB + 1)/2;

end
Eb_No = 0 : 8;

% le (TES) obtenu en fonction Eb/N0
figure;
semilogy([Eb_No], TES, 'b-');
title("le TES obtenu en fonction Eb/N0 (dB) pour la deuxième chaine");
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TES');

% Comparaison entre le TES théorique et le TES simulé
figure;
semilogy([Eb_No], TES, 'b-');
hold on

semilogy([Eb_No], (3 / 2) * qfunc(sqrt((4 / 5) * 10 .^ ([Eb_No] / 10))));
grid
title('Comparaison entre le TES théorique et estimé pour la deuxième chaine');
legend('TES estimé','TES théorique')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TES');

%%
% le taux d’erreur binaire (TEB) obtenu en fonction Eb/N0
figure;
semilogy([Eb_No], TEB, 'b-');
title("le taux d'erreur binaire (TEB) obtenu en fonction Eb/N0 (dB) pour la deuxième chaine");
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

% le taux d’erreur binaire (TEB) obtenu en fonction Eb/N0
figure;
semilogy([Eb_No], TEB, 'b-');
% Comparaison entre le TEB théorique et estimé pour la deuxième chaine
hold on
semilogy([Eb_No], ((3 / 2) * qfunc(sqrt((4 / 5) * 10 .^ ([Eb_No] / 10)))) / 2);
grid
title('Comparaison entre le TEB théorique et estimé pour la deuxième chaine');
legend('TEB estimé','TEB théorique')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');

%%
% Comparaison entre le TEB de la chaine de réference et la deuxième chaine
figure;
semilogy([0 : 8], qfunc(sqrt((2 * 10 .^ ([0 : 8] / 10)))), 'b-');
hold on
semilogy([0 : 8], ((3 / 2) * qfunc(sqrt((4 / 5) * 10 .^ ([Eb_No] / 10)))) / 2, 'r-');
grid
title('Comparaison entre le TEB de la chaine de réference et de la deuxième chaine');
legend('TEB de la chaine de réference', 'TEB de la deuxième chaine')
xlabel("$\frac{Eb}{N_{o}}$ (dB)", 'Interpreter', 'latex');
ylabel('TEB');
