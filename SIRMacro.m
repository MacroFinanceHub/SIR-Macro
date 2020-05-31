%% 
% simula o modelo proposto por eichbaun e rabelo (2019)

clear all; clc; close all;

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