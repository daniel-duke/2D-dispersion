function w = uniform_logF(min_logF,max_logF)
    logF = min_logF + rand*(max_logF-min_logF);
    w = 1/roundToNearestPowerOf2(10^logF);
end