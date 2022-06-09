
% TP2 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Bouam
% Prénom : Adam
% Groupe : 1SN-G

function varargout = fonctions_TP2_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)
     x_G = mean(x_donnees_bruitees);
     y_G = mean(y_donnees_bruitees);
     x_donnees_bruitees_centrees = x_donnees_bruitees - x_G;
     y_donnees_bruitees_centrees = y_donnees_bruitees - y_G;    
end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)
[~, ~, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

phi = (rand(n_tests, 1)-0.5)*pi;
yi = repmat(y_donnees_bruitees_centrees, n_tests,1);
xi = repmat(x_donnees_bruitees_centrees, n_tests,1);
Y = (yi - tan(phi).*xi).^2;
S= sum(Y,2);
[~, ind] = min(S);
phi_min = phi(ind);
a_Dyx = tan(phi_min);
b_Dyx = mean(y_donnees_bruitees -a_Dyx * x_donnees_bruitees);


end

% Fonction estimation_Dyx_MC (exercice_2.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)
    A = [x_donnees_bruitees; ones(1, length(x_donnees_bruitees))]';
    B = y_donnees_bruitees';
    X = pinv(A)*B;
    a_Dyx = X(1);
    b_Dyx = X(2);
end

% Fonction estimation_Dorth_MV (exercice_3.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
         estimation_Dorth_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)
[~, ~, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
    theta  = (rand(n_tests, 1)-0.5)*pi;
    yi = repmat(y_donnees_bruitees_centrees, n_tests,1);
    xi = repmat(x_donnees_bruitees_centrees, n_tests,1);
    T = (yi.*sin(theta) + cos(theta).*xi).^2;
    S= sum(T,2);
    [~, ind] = min(S);
    theta_Dorth = theta(ind);
    rho_Dorth = mean(x_donnees_bruitees)*cos(theta_Dorth) + mean(y_donnees_bruitees)*sin(theta_Dorth);
end

% Fonction estimation_Dorth_MC (exercice_4.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
                 estimation_Dorth_MC(x_donnees_bruitees,y_donnees_bruitees)
[~, ~, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
    
    C = [x_donnees_bruitees_centrees; y_donnees_bruitees_centrees]';
    [V, D] = eig(C'*C);
    [~, i] = min(diag(D));
    Y = V(:,i);
    Y = Y/norm(Y);
    theta_Dorth = atan(Y(2)/Y(1));
    rho_Dorth = mean(x_donnees_bruitees)*cos(theta_Dorth) + mean(y_donnees_bruitees)*sin(theta_Dorth);

end
