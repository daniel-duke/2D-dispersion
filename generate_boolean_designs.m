function generate_boolean_designs(n,cumvec)
    if n>0
        n = n - 1;
        for next_entry = [0 1]
            cumvec = [cumvec next_entry];
            generate_boolean_designs(n,cumvec);
        end
    else
        disp(cumvec)
    end
end
