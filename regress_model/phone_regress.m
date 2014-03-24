% ###################################
%
% ################################### 


phone_data = dlmread("./../raw_data/timed_phone_data.csv", ";");


view_data = [];
steps = [1.1];
is_step_added = false;
for i = 3 : length(phone_data),
  if phone_data(i, 1) == 0,
    % add new step-distance
    steps = [steps, steps(length(steps)) + 1.1];
    %disp("added step"), disp(steps(length(steps)));
    is_step_added = true;
  else
    if i != length(phone_data),
      if is_step_added == false,
        %disp("added the same step");
        steps = [steps, steps(length(steps))];
        is_step_added = false;
      else
        is_step_added = false;
      end;
    end;
    
    view_data = [view_data, phone_data(i, 2)];
  end;
end;

length(steps)
length(view_data)

plot(steps, view_data, 'g*');
grid on;
hold on;

title("Galaxy Nexus WiFi propagation");
ylabel("signal strength, -dB")


function strength = simple_log_dist_117(dist)
  strength = 20 * 1.17 * log10(0.125 / (4 * pi() * dist));
end;

function strength = simple_log_dist(dist)
  strength = 20 * 1.1 * log10(0.125 / (4 * pi() * dist));
end;

function strength = simple_log_dist_without_coeff(dist)
  strength = 20 * log10(0.125 / (4 * 3.14 * dist));
end;

%theoret_model = [];
x_labels = unique(steps);
%
%for i = 1 : length(x_labels),
%  theoret_model = [ theoret_model, -simple_log_dist(x_labels(i)) ];
%end;
%
%hold on;
%grid on;
%plot(x_labels, theoret_model, 'b-');

theoret_model = []
for i = 1 : length(x_labels),
  theoret_model = [ theoret_model, -simple_log_dist_without_coeff(x_labels(i)) ];
end;
hold on;
plot(x_labels, theoret_model, 'c--');
grid on;


%theoret_model = []
%for i = 1 : length(x_labels),
%  theoret_model = [ theoret_model, -simple_log_dist_117(x_labels(i)) ];
%end;
%hold on;
%plot(x_labels, theoret_model, 'r--');
%grid on;

tmp = [];
median_data = [];

for i = 3 : length(phone_data),
  if phone_data(i, 1) == 0,
    disp('size of median array '), disp(length(tmp));
    median_data = [median_data, median(tmp)];
    tmp = [];
  else
    tmp = [tmp, phone_data(i, 2)];
  end;

  if i == length(phone_data),
    median_data = [median_data, median(tmp)];
  end;
end;
hold on;
length(x_labels)
length(median_data)

plot(x_labels, median_data, 'b*');


legend('raw values', 'log-model without coeff', 'median values', 'location', 'northeast', 'boxon');
legend('left');


s_log_dist = [];
s_log_dist_117 = [];
log_dist = [];

disp('Computing localization errors');
for i = 1 : length(view_data)
  %(-1) * view_data(i)
  s_log_dist     = [s_log_dist,       -view_data(i) - simple_log_dist(steps(i))];
  s_log_dist_117 = [s_log_dist_117,   -view_data(i) - simple_log_dist_117(steps(i))];
  log_dist       = [log_dist,         -view_data(i) - simple_log_dist_without_coeff(steps(i))];
end;

printf('With coeff 1.1 min     error, dB   %f  \n'), min(abs(s_log_dist))
printf('With coeff 1.1 max     error, dB   %f  \n'), max(abs(s_log_dist))
printf('With coeff 1.1 median  error, dB   %f  \n'), median(abs(s_log_dist))
printf('\n')
printf('With coeff 1.17 min    error, dB   %f  \n'), min(abs(s_log_dist_117))
printf('With coeff 1.17 max    error, dB   %f  \n'), max(abs(s_log_dist_117))
printf('With coeff 1.17 media  error, dB   %f  \n'), median(abs(s_log_dist_117))
printf('\n')
printf('simple  min            %f  \n'),  min(abs(log_dist))
printf('simple  max            %f  \n'),  max(abs(log_dist))
printf('simple  median         %f  \n'),  median(abs(log_dist))


function strength = straightforward(dist)
  strength = (0.89 * dist + 42.7) * (-1);
end

disp('')
disp('DIstance dependency:')
for i = 1 : length(median_data)
  %i
  s = x_labels(i);
  m = median_data(i);
  e = abs(simple_log_dist(s) + m);
  %e = abs(straightforward(s) + m);
  printf('dist: %f, error %f dB\n', x_labels(i), e);
end


pause()
