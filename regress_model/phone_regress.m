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


function strength = simple_log_dist(dist)
  strength = 20 * 1.1 * log10(0.125 / (4 * pi() * dist));
end;

function strength = simple_log_dist_without_coeff(dist)
  strength = 20 * log10(0.125 / (4 * 3.14 * dist));
end;

theoret_model = [];
x_labels = unique(steps);

for i = 1 : length(x_labels),
  theoret_model = [ theoret_model, -simple_log_dist(x_labels(i)) ];
end;

hold on;
grid on;
plot(x_labels, theoret_model, 'b-');

theoret_model = []
for i = 1 : length(x_labels),
  theoret_model = [ theoret_model, -simple_log_dist_without_coeff(x_labels(i)) ];
end;
hold on;
plot(x_labels, theoret_model, 'c--');
grid on;

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


legend('raw values', 'log-model coeff = 1.1', 'log-model without coeff', 'median values', 'location', 'northeast', 'boxon');
legend('left');


pause()
