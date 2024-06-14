function perm132(n)
% Generates all permutations of n elements avoiding the pattern 132.

% Define a helper function to check if a permutation contains the pattern 132.
    function res = has132(p)
        for i = 1:length(p)-2
           if p(i) < p(i+2) && p(i+2) < p(i+1)
                res = true;
                return;
            end
        end
        res = false;
    end

% Define the recursive function to generate all permutations avoiding 132.
    function generate(current, remaining)
        if isempty(remaining)
            disp(current)
        else
            for i = 1:length(remaining)
                if ~has132([current remaining(i)])
                    generate([current remaining(i)], remaining([1:i-1 i+1:end]))
                end
            end
        end
    end

% Start the recursion with an empty current permutation and all elements remaining.
    generate([], 1:n)
end
