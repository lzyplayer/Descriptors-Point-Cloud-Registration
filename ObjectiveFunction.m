function [Phi] = ObjectiveFunction(MSE, Tr)

lamga= 2;
Phi = MSE./(Tr.^((1+lamga)));
%   Phi = MSE./(Tr.^((1+lamga)))./exp(1+lamga);
%    Phi = MSE./(Tr.^lamga)./exp(lamga);

% Phi = MSE./(Tr.^lamga)./exp(lamga);
%   Phi = 1./MSE.^(Tr);

% Phi = MSE./(Tr.^(1+lamga))./(1+lamga)^0;

% Phi = log(MSE)-(1+lamga).*log(Tr)-(1+lamga);

%  Phi = MSE./(Tr.^(1+lamga))./(1+lamga)^4;
 
%  Phi =(1./(Tr.^lamga)).*sqrt(MSE);


