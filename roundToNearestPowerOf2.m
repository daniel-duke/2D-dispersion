function nearestPowerOf2 = roundToNearestPowerOf2(num)
    if num < 1
        error('Number must be greater than or equal to 1');
    end

    % Calculate the nearest powers of 2
    lowerPower = 2^floor(log2(num));
    upperPower = 2^ceil(log2(num));

    % Find which power is closer
    if (num - lowerPower) < (upperPower - num)
        nearestPowerOf2 = lowerPower;
    else
        nearestPowerOf2 = upperPower;
    end
end
