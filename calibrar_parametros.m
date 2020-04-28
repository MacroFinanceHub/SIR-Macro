function [ out ] = function(pi_est, horiz, i_ini, pop_ini)
% -----------------------------------------------------------------------------
% Calibra os parâmetros relativos a função de transmição
%
% Autor: Gustavo Vital, com base em Rabelo/Trabandt
% Data: 28/04/2020
%
% -----------------------------------------------------------------------------
%
% ARGUMENTOS:
%
% pi_est: Vetor contendo a estimativa de transmissão (c, n, i)
% horiz: horizonte estimado
% i_ini: população de infectados no período t_0 (%)
% pop_ini: população inicial (%)

% Condições iniciais
pi_1 = pi_est(1)/esc_c;
pi_2 = pi_est(2)/esc_n;
pi_3 = pi_est(3);

% Infectados, Suscetíveis, Mortos, Recuperados, Transmissão.
I=NaN*ones(horiz+1,1);
S=NaN*ones(horiz+1,1);
D=NaN*ones(horiz+1,1);
R=NaN*ones(horiz+1,1);
T=NaN*ones(horiz,1);

I(1)=i_ini;
S(1)=pop_ini-I(1);
D(1)=0;
R(1)=0;

for j=1:1:horiz
    T(j,1)=pis1*S(j)*C^2*I(j)+pis2*S(j)*N^2*I(j)+pis3*S(j)*I(j);
    S(j+1,1)=S(j)-T(j);
    I(j+1,1)=I(j)+T(j)-(pir+pid)*I(j);
    R(j+1,1)=R(j)+pir*I(j);
    D(j+1,1)=D(j)+pid*I(j);
end

end  % function
