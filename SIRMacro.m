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
kappa=0;            %inclina�ao na fun��o de probabilidade - endogeneidade

%%
%calibragem para horas semanais e renda semanal
n_target=28;         % Horas de trabalho medio semanal
inc_target=58000/52; % Salario m�dio semanal

%%
% Calibragem das probabilidades da fun��o de transmiss�o
pis3_shr_target=1; %2/3; % percentual de pessoas que se infectam por intera��o social       
pis1_shr_target=(1-pis3_shr_target)/2; % percentual de pessoas que se infectam por trabalho
pis2_shr_target=(1-pis3_shr_target)/2; % percentual de pessoas que se infectam por consumo
RplusD_target=0.60;                    % percentual de pessoas ou ja recuperadas ou mortas

%%
% Popula��o e infectados
pop_ini=1; % Popula��o inicial
i_ini=0.001; % Infectados ao inicio da pandemia

%% 
% Numero de per�odos para a simula��o
HH=250;

%%
% Contigenciamento social

muc=zeros(HH,1);    % Variavel exogena
                    % Se deseja adotar uma pol�tica de contingenciamento de
                    % por exemplo 10% durante 50 semanas, defina muc(1:50)
                    % = 0.1. Assegurar que ao fim das 250 semanas a
                    % pol�tica de contingenciamento estar� em 0 - estado
                    % estacionario
                    % Se selecionada a op��o abaixo, o modelo ira otimizar
                    % a fun��o utilidade
                    
do_opt_policy=0;    % Se o selecionado for 1, o modelo simula 
                    % contingenciamento otimo, e reescreve o muc
                    
use_parallel=0;     % usa paralelo na fmincon

%%
% Defini��es das op��es
opts_fsolve=optimoptions('fsolve','Display','iter','TolFun',1e-9); %options for fsolve
opts_fsolve_fmincon=optimoptions('fsolve','Display','off','TolFun',1e-9); %options for fsolve used opt. policy calcs. (fmincon)
if use_parallel==0
    opts_fmincon=optimoptions('fmincon','Display','iter','TolFun',1e-7,'MaxFunctionEvaluations',2000,'FiniteDifferenceStepSize',1e-2); %options for fmincon w/o parallel comp.
elseif use_parallel==1
    opts_fmincon=optimoptions('fmincon','Display','iter','TolFun',1e-7,'MaxFunctionEvaluations',10000,'UseParallel',true);
end

%%
% Calculos do estado estacion�rio

theta=1/n_target^2;     %calculate disutility of labor parameter theta
                        %so that pre-infection steady state labor is equal to
                        %desired target (using n=(1/theta)^(1/2) pre-infection 
                        %steady state equation)
A=inc_target/n_target;  %calculate parameter A such that income is equal to
                        %desired target, c=inc_target=A*n_target
                        
                        
                        