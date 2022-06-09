
% TP1 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : BOUAM
% Prénom : Adam
% Groupe : 1SN-G

function varargout = fonctions_TP1_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction G_et_R_moyen (exercice_1.m) ----------------------------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
    n = size(x_donnees_bruitees, 2);
    G = zeros(1,2);
    G(1,1) = (1/n) * (ones(1,n) * x_donnees_bruitees');
    G(1,2) = (1/n) * (ones(1,n) * y_donnees_bruitees');
    distances = vecnorm (G-[x_donnees_bruitees' y_donnees_bruitees'], 2, 2);
    R_moyen = mean(distances);
end

% Fonction estimation_C_uniforme (exercice_1.m) ---------------------------
function [C_estime, R_moyen] = ...
         estimation_C_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)
     [G, R_moyen, ~] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
    
    alpha1 =rand(n_tests,1);
    alpha2 = rand(n_tests, 1);
    C_x = alpha1.*(G(1,1)-R_moyen) + (1-alpha1).*(G(1,1) + R_moyen);
    C_y = alpha2.*(G(1,2)-R_moyen) + (1-alpha2).*(G(1,2) + R_moyen);
    C = [C_x C_y];
    X = repmat(x_donnees_bruitees,n_tests,1);
    Y = repmat(y_donnees_bruitees,n_tests,1);
    dist = sqrt((X-C(:,1)).^2 + (Y-C(:,2)).^2);
    [~, indice] = min(sum((dist - R_moyen).^2,2));
    C_estime = C(indice,:);
end
     


% Fonction estimation_C_et_R_uniforme (exercice_2.m) ----------------------
function [C_estime, R_estime] = ...
         estimation_C_et_R_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)

[G, R_moyen, ~] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);

C = (rand(n_tests,2)-0.5)*R_moyen + G;
%R = alpha.*R_moyen/2 + (1-alpha)*3*R_moyen/2;
R = (rand(n_tests,1) + 1)*R_moyen;

X = repmat(x_donnees_bruitees,n_tests,1);
Y = repmat(y_donnees_bruitees,n_tests,1);
dist = sqrt((X-C(:,1)).^2 + (Y-C(:,2)).^2);
[~, indice] = min(sum((dist - R).^2,2));

% C_x = repmat(C(:,1),1,length(x_donnees_bruitees));
% C_y = repmat(C(:,2),1,length(y_donnees_bruitees));
% X = repmat(x_donnees_bruitees,n_tests,1);
% Y = repmat(y_donnees_bruitees,n_tests,1);
% dist = sqrt((X-C_x).^2 + (Y-C_y).^2);
% [minimum indice] = min(sum(dist - R,2).^2);

 C_estime = C(indice,:);
 R_estime = R(indice);


end

% Fonction occultation_donnees (donnees_occultees.m) ----------------------
function [x_donnees_bruitees, y_donnees_bruitees] = ...
         occultation_donnees(x_donnees_bruitees, y_donnees_bruitees, theta_donnees_bruitees)
t_1 = rand(1)*2*pi;
t_2 = rand(1)*2*pi;
if(t_1<=t_2)
    b = theta_donnees_bruitees >= t_1 & theta_donnees_bruitees <= t_2;
    x_donnees_bruitees = x_donnees_bruitees(b);
    y_donnees_bruitees = y_donnees_bruitees(b);
else
    b = theta_donnees_bruitees >= t_1 | theta_donnees_bruitees <= t_2;
    x_donnees_bruitees = x_donnees_bruitees(b);
    y_donnees_bruitees = y_donnees_bruitees(b);
end
end

% Fonction estimation_C_et_R_normale (exercice_4.m, bonus) ----------------
function [C_estime, R_estime] = ...
         estimation_C_et_R_normale(x_donnees_bruitees,y_donnees_bruitees,n_tests)

[G, R_moyen, ~] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);

C = (randn(n_tests,2)-0.5)*R_moyen + G;
R = (randn(n_tests,1) + 1)*R_moyen;

X = repmat(x_donnees_bruitees,n_tests,1);
Y = repmat(y_donnees_bruitees,n_tests,1);
dist = sqrt((X-C(:,1)).^2 + (Y-C(:,2)).^2);
[~, indice] = min(sum((dist - R).^2,2));
 C_estime = C(indice,:);
 R_estime = R(indice);
end
