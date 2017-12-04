function [best_x, best_y, best_guess] = RandomSearch(pad_A, pad_B, i, j, best_x, best_y, best_guess, m, n, half_patch)
    % Initializing the beginning of random search (max
    % iterations).
    rs_start = intmax;
    if rs_start > max(m + half_patch, n + half_patch)
        rs_start = max(m + half_patch, n + half_patch);
    end

    % Hardcoded value of RAND_MAX in C++ (plays the role of an
    % arbitrary value used to generate a random integer).
    rand_max = 32767; 
    while rs_start >= 1
        x_min = max(best_x - rs_start, 1 + half_patch);
        x_max = min(best_x + rs_start + 1, m + half_patch);
        y_min = max(best_y - rs_start, 1 + half_patch); 
        y_max = min(best_y + rs_start + 1, n + half_patch);                    

        % Generating the random candidates.
        xp = mod(x_min + randi(rand_max), abs(x_max - x_min));
        yp = mod(y_min + randi(rand_max), abs(y_max - y_min));

        % Handling the case where the modulo is 0 or superior
        % to the image's size.
        if xp == 0
            xp = 1;
        end
        if yp == 0
            yp = 1;
        end                    
        if xp > size(pad_B, 1) - half_patch
            xp = size(pad_B, 1) - half_patch;
        end
        if yp > size(pad_B, 2) - half_patch
            yp = size(pad_B, 2) - half_patch;
        end

        [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch);

        % Updating the iteration variable (value taken from the
        % paper).
        rs_start = floor(rs_start / 2); 
    end

end