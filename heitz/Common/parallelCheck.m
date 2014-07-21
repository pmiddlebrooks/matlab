%check to see if java is enabled and if so, whether we can use parallel processing.
%
%RPH
if usejava('desktop')
    if matlabpool('size') > 1
        useParallel = 1;
    else
        useParallel = 0;
    end
else
    useParallel = 0;
end