%% 
% simula o modelo proposto por eichbaun e rabelo (2019)

clear; clc; close all;

%%
% parametros calibrados e etc

betta=0.96^(1/52);  % Fator de disconto semanal
pid=7*0.005/18;     % Probabilidade semanal de morrer
pir=7*1/18-pid;     % Probabilidade semanal de se recuperar
phii=0.8;           % Produtividade das pessoas infectadas

deltav=0/52;        % Probabilidade semanal de descobrirem uma vacina
deltac=0/52;        %Probabilidade semanal de descobrirem um tratamento
kappa=0;            %inclinaçao na função de probabilidade - endogeneidade

%%
%calibragem para horas semanais e renda semanal
n_target=28;         % Horas de trabalho medio semanal
inc_target=58000/52; % Salario médio semanal

%%
% Calibragem das probabilidades da função de transmissão
pis3_shr_target=1; %2/3; % percentual de pessoas que se infectam por interação social       
pis1_shr_target=(1-pis3_shr_target)/2; % percentual de pessoas que se infectam por trabalho
pis2_shr_target=(1-pis3_shr_target)/2; % percentual de pessoas que se infectam por consumo
RplusD_target=0.60;                    % percentual de pessoas ou ja recuperadas ou mortas

%%
% População e infectados
pop_ini=1; % População inicial
i_ini=0.001; % Infectados ao inicio da pandemia

%% 
% Numero de períodos para a simulação
HH=250;

%%
% Contigenciamento social

muc=zeros(HH,1);    % Variavel exogena
                    % Se deseja adotar uma política de contingenciamento de
                    % por exemplo 10% durante 50 semanas, defina muc(1:50)
                    % = 0.1. Assegurar que ao fim das 250 semanas a
                    % política de contingenciamento estará em 0 - estado
                    % estacionario
                    % Se selecionada a opção abaixo, o modelo ira otimizar
                    % a função utilidade
                    
do_opt_policy=0;    % Se o selecionado for 1, o modelo simula 
                    % contingenciamento otimo, e reescreve o muc
                    
use_parallel=0;     % usa paralelo na fmincon

%%
% Definições das opções
opts_fsolve=optimoptions('fsolve','Display','iter','TolFun',1e-9); %options for fsolve
opts_fsolve_fmincon=optimoptions('fsolve','Display','off','TolFun',1e-9); %options for fsolve used opt. policy calcs. (fmincon)
if use_parallel==0
    opts_fmincon=optimoptions('fmincon','Display','iter','TolFun',1e-7,'MaxFunctionEvaluations',2000,'FiniteDifferenceStepSize',1e-2); %options for fmincon w/o parallel comp.
elseif use_parallel==1
    opts_fmincon=optimoptions('fmincon','Display','iter','TolFun',1e-7,'MaxFunctionEvaluations',10000,'UseParallel',true);
end

%%
% Calculos do estado estacionário

theta=1/n_target^2;     % Calcula a desutilidade marginal do trabalho 
                        % parametro theta, então no estagio pre infecção
                        % esse parametro é dado pela função objetivo n =
                        % (1/theta)^(1/2)                       
A=inc_target/n_target;  % Calcula o parametro A, tl que a renda é igual a 
                        % função c = inc_target=A*n_target
                        
%%
% Estado estacionario

nrss=(1/theta)^(1/2);           % N de pessoas recuperadas
crss=A*nrss;                    % C de pessoas recuperadas
urss=log(crss)-theta/2*nrss^2;  % U(c,n) de pessoas recuperadas
Urss=1/(1-betta)*urss;          % pv U da vida de pessoas recuperadas
UrssConsUnits=Urss*crss;        % pv "custo" da utilidade da vida
niss=(1/theta)^(1/2);           % N infectadas
ciss=phii*A*niss;               % C infectadas
uiss=log(ciss)-theta/2*niss^2;  % U(c,n) infectadas
Uiss=1/(1-(1-deltac)*betta*(1-pir-pid))*(uiss...
+(1-deltac)*betta*pir*Urss+deltac*betta*Urss);  % U da vida de pessoas 
                                                % infectadas
                
%%
% utilidade de recuperados TEM que ser maior que de infectados
if Uiss-Urss>0
    error(['Error: parametrização implica que Uiss>Urss: ', ...
        num2str(Uiss-Urss)])
end
        
%%
% Calibragem dos pis da função

calibrar_parametros



                        