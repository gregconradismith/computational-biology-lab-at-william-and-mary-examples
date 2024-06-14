% 132 avoiding permuton 
close all

% Define the coordinates of the permuton curve.
x = [0 1/3 1/2 2/3 1];
y = [0 0 1/6 1/6 1];

% Plot the permuton curve and the line of symmetry.
hold on
plot(x, y, 'r', 'LineWidth', 2)
plot([0 1], [0.5 0.5], 'g--', 'LineWidth', 1)

% Add labels and title to the plot.
title('Permuton for permutations avoiding 132')
xlabel('Proportion of permutations')
ylabel('Density of permutations')

% Adjust the axis limits and tick marks.
xlim([0 1])
ylim([0 1])
xticks([0 1/3 1/2 2/3 1])
yticks([0 1/6 1/3 1/2 2/3 5/6 1])

return

% Define the coordinates of the horizontal and diagonal segments.
x = [0 1/3 1/2 2/3 1];
y = [0 0 1/6 1/6 1];
slope = [0 (1/6)/(1/6-0) 1];

% Plot the horizontal segments.
for i = 1:length(x)-1
    if slope(i) == slope(i+1)
        plot(x(i:i+1), y(i:i+1), 'b-', 'LineWidth', 2)
    else
        xmid = (y(i)-y(i+1)+slope(i+1)*x(i+1)-slope(i)*x(i))/(slope(i+1)-slope(i));
        ymid = slope(i)*(xmid-x(i))+y(i);
        plot([x(i) xmid x(i+1)], [y(i) ymid y(i+1)], 'b-', 'LineWidth', 2)
    end
    hold on
end

% Plot the diagonal segments.
for i = 1:length(x)-2
    xmid = (y(i)-y(i+2)+slope(i+2)*x(i+2)-slope(i)*x(i))/(slope(i+2)-slope(i));
    ymid = slope(i)*(xmid-x(i))+y(i);
    plot([x(i) xmid x(i+2)], [y(i) ymid y(i+2)], 'r-', 'LineWidth', 2)
    hold on
end

% Plot the line of symmetry.
plot([0 1], [0.5 0.5], 'g--', 'LineWidth', 1)

% Set the axis limits and labels.
axis([0 1 0 1])
xlabel('Proportion of permutation length')
ylabel('Proportion of avoided pattern')
title('Permuton for permutations avoiding 132')

% Turn off the axis tick marks and box.
set(gca, 'XTick', [], 'YTick', [])
box off
