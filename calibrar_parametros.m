function [ err,pis1,pis2,pis3,RnotSIR,I,S,D,R,T ] = function(pis_guess,HH,i_ini,pop_ini,pir,pid,pis1_shr_target,pis2_shr_target,RplusD_target,phii,C,N,scale1,scale2)
% Calibra os parametros relativos a funcao de transmissao
%
% Autor: Gustavo Vital, com base em Rabelo/Trabandt
% Data: 28/04/2020
%
% ------------------------------------------------------------------------


%%
% Condições iniciais
pis1=pis_guess(1)/scale1;
pis2=pis_guess(2)/scale2;
pis3=pis_guess(3);

% Infectados, Suscetíveis, Mortos, Recuperados, Transmissão.
I=NaN*ones(HH+1,1);
S=NaN*ones(HH+1,1);
D=NaN*ones(HH+1,1);
R=NaN*ones(HH+1,1);
T=NaN*ones(HH,1);

I(1)=i_ini;
S(1)=pop_ini-I(1);
D(1)=0;
R(1)=0;

% Interação para o sir-macro
for j=1:1:horiz
    T(j,1)=pis1*S(j)*C^2*I(j)+pis2*S(j)*N^2*I(j)+pis3*S(j)*I(j);
    S(j+1,1)=S(j)-T(j);
    I(j+1,1)=I(j)+T(j)-(pir+pid)*I(j);
    R(j+1,1)=R(j)+pir*I(j);
    D(j+1,1)=D(j)+pid*I(j);
end

err(1)=pis1_shr_target-(pis1*C^2)/(pis1*C^2+pis2*N^2+pis3);
err(2)=pis2_shr_target-(pis2*N^2)/(pis1*C^2+pis2*N^2+pis3);
err(3)=RplusD_target-(R(end)+D(end));

RnotSIR=T(1)/I(1)/(pir+pid);

end 
