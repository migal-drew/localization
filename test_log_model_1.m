data = dlmread('~/experiment_median.csv', ';');


%function res = log_model(dist)
%  Gt = -1.4;
%  Gr = -5;
%  lambda = 0.125;
%
%  %res = 20 * 1.2 * log10(lambda / (4 * pi * dist)) + 10 * log10(Gt * Gr);
%
%  res = 20 * log10(lambda / (4 * pi * dist));
%  %res = 10 * log10(dist);
%end;

function res = log_distance(level)
  lambda = 0.125;
  res = lambda / (4 * pi * (10^(level / 20 / 1.1)));
  %res = 10^((level - 92.45 - 20*log10(2.4)) / 20) * 1000;
end;

x1 = 5.54;
x2 = 1.6;
x3 = 3.4;

errors1 = []
errors2 = []
errors3 = []

for i = 1 : 96,
  level = -data(i, 4)
  ap_num = data(i, 3)

  if (ap_num == 14)
    s = x1;
    err = (s - log_distance(level))^2;
    errors1 = [errors1, [err]];
  end;
  if (ap_num == 15)
    s = x2;
    err = (s - log_distance(level))^2;
    errors2 = [errors2, [err]];
  end;
  if (ap_num == 16)
    s = x3;
    err = (s - log_distance(level))^2;
    errors3 = [errors3, [err]];
  end;
  printf('\n');
end;

printf('Access point 14\n');
sqrt(median(errors1))
printf('\n');

printf('Access point 15\n');
sqrt(median(errors2))
printf('\n');

printf('Access point 16\n');
sqrt(median(errors3))
printf('\n');

plot(sqrt(errors1), '.'); %14
axis([0, length(errors1), 0,  7]);
hold on;
plot(sqrt(errors2), 'g+'); %15
plot(sqrt(errors3), 'r*'); %16

pause;
