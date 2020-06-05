%%
% Calibra os pis do sirmacro

scale1=1000000; scale2=1000; %escala dos parametros para a solução

%%
% fsolve...
[sol,fval,exitflag]=fsolve(@calibrar_parametros,[0.2;0.2;0.2],opts_fsolve,HH,i_ini,pop_ini,pir,pid,pis1_shr_target,pis2_shr_target,RplusD_target,phii,crss,nrss,scale1,scale2);

%%
% erros do modelo
if exitflag~=1
    error('Fsolve não pode calibrar o SIR Model');
else
    [err,pis1,pis2,pis3,RnotSIR,I,S,D,R,T] =calibrar_parametros(sol,HH,i_ini,pop_ini,pir,pid,pis1_shr_target,pis2_shr_target,RplusD_target,phii,crss,nrss,scale1,scale2);
    
    disp(['Max. abs. error in calibration targets:',num2str(max(abs(err)))]);
    disp([' ']);
    pis1=sol(1)/scale1
    pis2=sol(2)/scale2
    pis3=sol(3)
    RnotSIR
end
