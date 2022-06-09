close all;
clear;
clc;

%% Données :
    Fe = 24000;
    Te = 1/Fe;
    % Nombre de bits générés :
    nb_bits = 1000;
    Rb = 3000;
    % Nombre d échantillons (Ts=NsTe)
    Ns=10;
    Ts = nb_bits/Rb;
    % Réponse impulsionnelle du filtre de mise en forme :
    h = ones (1, Ns);
    % Réponse impulsionnelle du filtre de reception :
    hr = h;
    % Gérération de l'information binaire :
    bits = randi ([0, 1], 1, nb_bits);
    % L'échelle de temps :
    t = linspace(0,(10000)*Ts,10000);


%% ETUDE SANS CANAL :
    % Question 1 : Implantation du modulateur et demodulateur:
    % Mapping binaire à moyenne nulle : 0 -> -1, 1 -> +1
    Symboles = 2*bits - 1;
    % Génération des impulsions :
    Impulsions = kron(Symboles, [1 zeros(1, Ns-1)]);
    % Filtrage de mise en forme :
    r = filter (h, 1, Impulsions);    %Signal à la sortie du modulateur
    x = filter (hr, 1, r);

    % Question 2 : Tracage du signal à la sortielc du filtre de réception
    figure; plot(t,x);
    title('Signal à la sortie du filtre de réception');
    axis([0 100 -10 10]);

    % Question 3 : Tracage de la réponse impulsionnelle de la chaine de transmission g :
    g = conv(h, hr);
    figure; plot(linspace(0,(20)*Ts,19), g);
    title('Réponse impultionnelle de la chaine sans canal');
    ylabel('g = h*hr')
    axis([0 7 -10 10]);

    % Question 4 : L'instant optimal d'échantillonage :
        n0 = Ns;

    % Question 5 : Diagramme de l'oeil :
        figure; plot(reshape(x(Ns+1 : end),Ns,(length(x)-Ns)/Ns));
        title("Diagramme de l'oeil");
        eyediagram(x(Ns + Ns/2 : end), Ns);


    % Question 6 : Confirmation de la réponse de la Q.4
        % Oui, ...

    % Question 7 : Echantillonner le signal en sortie du filtre de réception et faire les décisions :
        % Pour n0 optimal :
        x_echantillonne = x(n0 : Ns : end);
        bits_estimes = x_echantillonne > 0;
        Decision = (bits_estimes == bits);
        TEB = 1-sum(Decision)/1000;
        fprintf("-----Le TEB pour l'instant optimal d'échantillonage n0 = Ns-----\n")
        fprintf("TEB = %d\n\n", TEB);
        % Pour n0 = 3 : On obtient des erreurs à cause des interferences.
        x_echantillonne2 = x(3 : Ns : end);
        bits_estimes2 = x_echantillonne2 > 0;
        Decision2 = (bits_estimes2 == bits);
        % Taux d'erreur binaire pour n0 = 3 :
        TEB = 1-sum(Decision2)/1000;
        fprintf("-----Le TEB pour l'instant d'échantillonage no = 3 (non optimal)-----\n")
        fprintf("TEB = %d\n\n", TEB);



%% ETUDE AVEC CANAL DE PROPAGATION :


% Données :
    % Fréquences de coupure :
    fc1 = 8000;
    fc2 = 1000;
    
% Pour BW = fc :
    fc = fc1;

% Réponse impulsionnelle du canal de propagation :
    hc = (2*fc/Fe)*sinc(2*(fc/Fe)*(-(51-1)/2 : (51-1)/2));

% Tracage de la réponse impulsionnelle globale de la chaine de transmission
    g_canal = conv(g, hc);
    figure; plot(g_canal);
    title(strcat("Réponse impultionnelle de la chaine avec canal cas BW = ", string(fc), "Hz"));
    ylabel('g = h*hr*hc')
    %axis([0 7 -10 10]);

% Diagramme de l'oeil :
    z = filter (g_canal, 1, Impulsions);
    figure; plot(reshape(z(Ns+1 : end),Ns,(length(z)-Ns)/Ns));
    title( strcat("Diagramme de l'oeil pour la chaine avec canal cas BW = ", string(fc), "Hz"));
%     eyediagram(z(Ns + Ns/2 : end), Ns);
%     title( strcat("Diagramme de l'oeil pour la chaine avec canal cas BW = ", string(fc), "Hz"));


% Représentation des réponses impulsionnelles en fréquence :
    n_fft = 1024;
    freq = linspace(-Fe/2, Fe/2,n_fft); % Echelle de fréquence
    Hc = (1/Ts) * abs(fft(hc , n_fft)).^ 2;
    H = (1/Ts) * abs(fft(h , n_fft)).^ 2;
    Hr = (1/Ts) * abs(fft(hr , n_fft)).^ 2;
    G = H.*Hr;
    figure; semilogy(freq, fftshift(Hc), 'g', freq, fftshift(G), 'r');
    title(strcat("Tracage des réponses en fréquence cas BW = ", string(fc), "Hz"));
    xlabel("Fréquence")
    legend('|Hc(f)|', '|H(f)Hr(f)|')

% Calcul de TEB : 
    z_echantillonne = z(n0 : Ns : end);
    bits_estimes = z_echantillonne > 0;
    Decision = (bits_estimes == bits);
    TEB = 1-sum(Decision)/1000;
    fprintf("-----Le TEB avec canal pour l'instant d'échantillonage optimal et BW = %d Hz-----\n", fc)
    fprintf("TEB = %d\n\n", TEB);