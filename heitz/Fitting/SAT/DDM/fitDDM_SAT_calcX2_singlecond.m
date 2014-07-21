
function X2 = fitDDM_SAT_calcX2_singlecond(param,ntiles,trls,obs_freq)
% params.slow = param(1:7);
% 
% 
% slow_correct_made_dead = trls.slow_correct_made_dead;
% slow_errors_made_dead = trls.slow_errors_made_dead;
% 
% 
% N.slow = length(slow_correct_made_dead) + length(slow_errors_made_dead);
% 
% 
% 
% pred_freq.slow_correct_made_dead(1) = N.slow * CDFDif(ntiles.slow_correct_made_dead(1),1,params.slow);
% pred_freq.slow_correct_made_dead(2) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(2),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(1),1,params.slow));
% pred_freq.slow_correct_made_dead(3) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(3),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(2),1,params.slow));
% pred_freq.slow_correct_made_dead(4) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(4),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(3),1,params.slow));
% pred_freq.slow_correct_made_dead(5) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(5),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(4),1,params.slow));
% 
% %at infinity, equals marginal probability
% pred_freq.slow_correct_made_dead(6) = N.slow * (CDFDif(inf,1,params.slow));
% 
% pred_freq.slow_errors_made_dead(1) = N.slow * CDFDif(ntiles.slow_errors_made_dead(1),0,params.slow);
% pred_freq.slow_errors_made_dead(2) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(2),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(1),0,params.slow));
% pred_freq.slow_errors_made_dead(3) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(3),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(2),0,params.slow));
% pred_freq.slow_errors_made_dead(4) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(4),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(3),0,params.slow));
% pred_freq.slow_errors_made_dead(5) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(5),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(4),0,params.slow));
%  
% %at infinity, equals marginal probability
% pred_freq.slow_errors_made_dead(6) = N.slow * (CDFDif(inf,0,params.slow));
% 
% 
% 
% 
% all_obs = [obs_freq.slow_correct_made_dead' ; obs_freq.slow_errors_made_dead'];
% 
% all_pred = [pred_freq.slow_correct_made_dead' ; pred_freq.slow_errors_made_dead'];
% 
% X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) )
% 
% disp([param(1:7)'])
% %disp(mat2str(param))
% 
% % defective_correct = length(slow_correct_made_dead) / (length(slow_correct_made_dead) + length(slow_errors_made_dead));
% % defective_errors = 1 - defective_correct;
% 
% % plot([ntiles.slow_correct_made_dead ; inf],cumsum(obs_freq.slow_correct_made_dead)./length(slow_correct_made_dead),'ok')
% % hold on
% % plot([ntiles.slow_correct_made_dead ; inf],cumsum(pred_freq.slow_correct_made_dead)./length(slow_correct_made_dead),'k')
% % plot([ntiles.slow_errors_made_dead ; inf],cumsum(obs_freq.slow_errors_made_dead)./length(slow_errors_made_dead),'or')
% % plot([ntiles.slow_errors_made_dead ; inf],cumsum(pred_freq.slow_errors_made_dead)./length(slow_errors_made_dead),'r')
% % xlim([0 1])
% % ylim([0 1])
% % pause(.001)
% % cla
% 
% plot([ntiles.slow_correct_made_dead ; inf],cumsum(obs_freq.slow_correct_made_dead)./N.slow,'ok')
% hold on
% plot([ntiles.slow_correct_made_dead ; inf],cumsum(pred_freq.slow_correct_made_dead)./N.slow,'-xk')
% plot([ntiles.slow_errors_made_dead ; inf],cumsum(obs_freq.slow_errors_made_dead)./N.slow,'or')
% plot([ntiles.slow_errors_made_dead ; inf],cumsum(pred_freq.slow_errors_made_dead)./N.slow,'-xr')
% xlim([0 1])
% ylim([0 1])
% 
% pause(.001)
% cla




params.med = param(1:7);
 
 
med_correct = trls.med_correct;
med_errors = trls.med_errors;
 
 
N.med = length(med_correct) + length(med_errors);
 
 
 
pred_freq.med_correct(1) = N.med * CDFDif(ntiles.med_correct(1),1,params.med);
pred_freq.med_correct(2) = N.med * (CDFDif(ntiles.med_correct(2),1,params.med) - CDFDif(ntiles.med_correct(1),1,params.med));
pred_freq.med_correct(3) = N.med * (CDFDif(ntiles.med_correct(3),1,params.med) - CDFDif(ntiles.med_correct(2),1,params.med));
pred_freq.med_correct(4) = N.med * (CDFDif(ntiles.med_correct(4),1,params.med) - CDFDif(ntiles.med_correct(3),1,params.med));
pred_freq.med_correct(5) = N.med * (CDFDif(ntiles.med_correct(5),1,params.med) - CDFDif(ntiles.med_correct(4),1,params.med));
 
%at infinity, equals marginal probability
pred_freq.med_correct(6) = N.med * (CDFDif(inf,1,params.med));
 
pred_freq.med_errors(1) = N.med * CDFDif(ntiles.med_errors(1),0,params.med);
pred_freq.med_errors(2) = N.med * (CDFDif(ntiles.med_errors(2),0,params.med) - CDFDif(ntiles.med_errors(1),0,params.med));
pred_freq.med_errors(3) = N.med * (CDFDif(ntiles.med_errors(3),0,params.med) - CDFDif(ntiles.med_errors(2),0,params.med));
pred_freq.med_errors(4) = N.med * (CDFDif(ntiles.med_errors(4),0,params.med) - CDFDif(ntiles.med_errors(3),0,params.med));
pred_freq.med_errors(5) = N.med * (CDFDif(ntiles.med_errors(5),0,params.med) - CDFDif(ntiles.med_errors(4),0,params.med));
 
%at infinity, equals marginal probability
pred_freq.med_errors(6) = N.med * (CDFDif(inf,0,params.med));
 
 
 
 
all_obs = [obs_freq.med_correct' ; obs_freq.med_errors'];
 
all_pred = [pred_freq.med_correct' ; pred_freq.med_errors'];
 
X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
 
disp([param(1:7)']);
%disp(mat2str(param))
 
% defective_correct = length(med_correct) / (length(med_correct) + length(med_errors));
% defective_errors = 1 - defective_correct;
 
% plot([ntiles.med_correct ; inf],cumsum(obs_freq.med_correct)./length(med_correct),'ok')
% hold on
% plot([ntiles.med_correct ; inf],cumsum(pred_freq.med_correct)./length(med_correct),'k')
% plot([ntiles.med_errors ; inf],cumsum(obs_freq.med_errors)./length(med_errors),'or')
% plot([ntiles.med_errors ; inf],cumsum(pred_freq.med_errors)./length(med_errors),'r')
% xlim([0 1])
% ylim([0 1])
% pause(.001)
% cla
 
plot([ntiles.med_correct ; inf],cumsum(obs_freq.med_correct)./N.med,'ok')
hold on
plot([ntiles.med_correct ; inf],cumsum(pred_freq.med_correct)./N.med,'-xk')
plot([ntiles.med_errors ; inf],cumsum(obs_freq.med_errors)./N.med,'or')
plot([ntiles.med_errors ; inf],cumsum(pred_freq.med_errors)./N.med,'-xr')
xlim([0 1])
ylim([0 1])
 
pause(.001)
cla


end