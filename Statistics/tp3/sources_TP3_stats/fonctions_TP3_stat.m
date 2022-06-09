
% TP3 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Bouam
% Prenom : Adam
% Groupe : 1SN-G

function varargout = fonctions_TP3_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction estimation_F (exercice_1.m) ------------------------------------
function [rho_F,theta_F,ecart_moyen] = estimation_F(rho,theta)
    B = rho;
    A = [cos(theta) sin(theta)];
    X = pinv(A)*B;
    x_F = X(1); y_F = X(2);
    rho_F = sqrt(x_F^2 + y_F^2);
    theta_F = atan2(y_F,x_F);

    % A modifier lors de l'utilisation de l'algorithme RANSAC (exercice 2)
    ecart_moyen = sum(abs(rho - rho_F*cos(theta-theta_F)))/length(rho);

end

% Fonction RANSAC_2 (exercice_2.m) ----------------------------------------
function [rho_F_estime,theta_F_estime] = RANSAC_2(rho,theta,parametres)
    n = length(rho);
    ECARTS = [];
    ENS_CONF = [];
    for i=1:parametres(3)
        p = randperm(n,2);
        [rho_F,theta_F,ecart_moyen] = estimation_F(rho(p),theta(p));
        C = abs(rho - rho_F*cos(theta-theta_F)) < parametres(1);
        if sum(C)/n > parametres(2)
            ENS_CONF = [ENS_CONF C];
            ECARTS = [ECARTS ecart_moyen];
        end
    end
       [~, in] = min (ECARTS);
       LENS = ENS_CONF(:, in);
       [rho_F_estime,theta_F_estime,~] = estimation_F(rho(LENS==1),theta(LENS==1));
end

% Fonction G_et_R_moyen (exercice_3.m, bonus, fonction du TP1) ------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
    
     n = size(x_donnees_bruitees, 2);
    G = zeros(1,2);
    G(1,1) = (1/n) * (ones(1,n) * x_donnees_bruitees');
    G(1,2) = (1/n) * (ones(1,n) * y_donnees_bruitees');
    distances = vecnorm (G-[x_donnees_bruitees' y_donnees_bruitees'], 2, 2);
    R_moyen = mean(distances);

end

% Fonction estimation_C_et_R (exercice_3.m, bonus, fonction du TP1) -------
function [C_estime,R_estime] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,n_tests,C_tests,R_tests)
     
    % Attention : par rapport au TP1, le tirage des C_tests et R_tests est 
    %             considere comme etant deje effectue 
    %             (il doit etre fait au debut de la fonction RANSAC_3)
    %[G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
    X = repmat(x_donnees_bruitees,n_tests,1);
    Y = repmat(y_donnees_bruitees,n_tests,1);
    dist = sqrt((X-C_tests(:,1)).^2 + (Y-C_tests(:,2)).^2);
    [~, indice] = min(sum((dist - R_tests).^2,2));
    C_estime = C_tests(indice,:);
    R_estime = R_tests(indice);
end

% Fonction RANSAC_3 (exercice_3, bonus) -----------------------------------
function [C_estime,R_estime] = ...
         RANSAC_3(x_donnees_bruitees,y_donnees_bruitees,parametres)
    [G, R_moyen, ~] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
    C_tests = [];
    R_tests = [];
    for i =1:parametres(3)
        p = randperm(length(x_donnees_bruitees), 3);

        x = x_donnees_bruitees(p);
        y = y_donnees_bruitees(p);
        C = zeros(1,2);
        R = 0;
        [C,R] = estimation_cercle_3points(x',y');
        
        Bool= (abs(sqrt((x_donnees_bruitees-C(1)).^2 + (y_donnees_bruitees-C(2)).^2) - R_moyen) < parametres(1));
        
        s = sum(Bool)
        l = length(Bool)

        if  sum(Bool)/length(Bool) > parametres(2)
            C_tests = [C_tests; C'];
            R_tests = [R_tests; R];
        end
    end
     n_tests = length(R_tests);
     [C_estime,R_estime] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,n_tests,C_tests,R_tests);

end
