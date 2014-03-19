% ###################################
%
% ################################### 


phone_data = dlmread("./../raw_data/phone_tunnel.csv", ";");
plot(phone_data, 'b*');
grid on;
hold on;
tablet_data = dlmread("./../raw_data/tablet_tunnel.csv", ";");
plot(tablet_data, 'g*');

title("Galaxy Nexus in comparison with Perfeo tablet");
ylabel("signal strength, -dB")


function strength = simple_log_dist(dist)
  strength = 20 * 1.125 * log10(0.125 / (4 * 3.14 * dist));
end;

function strength = simple_log_dist_without_coeff(dist)
  strength = 20 * log10(0.125 / (4 * 3.14 * dist));
end;


%simple_log_dist(1)
%simple_log_dist(26)
%
%num_samples = 15
%
%data = rand(1, num_samples) * 90
%steps = 0.5:num_samples
%
%plot(steps, data, "*");
%grid on;
%
%hold on;


%model_data = zeros(1, length(steps));
%for i = 1 : length(steps)
%  model_data(i) = -simple_log_dist(steps(i));
%end;
%hold on;
%plot(steps, model_data)
%
%model_data = zeros(1, length(steps));
%for i = 1 : length(steps)
%  model_data(i) = -simple_log_dist_without_coeff(steps(i));
%end;
%hold on;
%plot(steps, model_data, "g-")


pause()
