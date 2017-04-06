function [alpha, beta] = sir_optimize(dataInfected, dataRecovered, initS)
    %initialize given data
    init = [initS, 1, 0];
    
    %standard sir equations
    function dSIR = model(t,SIR)
        dSIR = [0; 0; 0];
        dSIR(1) = -1.*alpha.*SIR(1).*SIR(2);
        dSIR(2) = alpha .* SIR(1).* SIR(2) - 1 .* beta .* SIR(2);
        dSIR(3) = beta .* SIR(2);
    end
    alpha = 1;
    beta = 2;
    
    %create a function whose job is to substitute alpha and beta
    function [t,x] = instantiate(a, b)
        alpha = a;
        beta = b;
        [time, vals] = ode23(@model, 1:10:length(dataInfected), init);
        t = time;
        x = vals;
    end
    i = 0;
    %create an error function
    function errorVal = error(a)
        errorVal = 0;
        [t,x] = instantiate(a(1),a(2));
        i = i + 1;
        if i % 10 == 0
            disp(i);
        end
        disp(i)
        singI = 1; %%iterates by 1 each time
        for tVal = 1:10:length(dataInfected)
            errorVal = errorVal + (x(singI, 2) - dataInfected(tVal)) .^ 2;
            errorVal = errorVal + (x(singI, 3) - dataRecovered(tVal)) .^ 2;
            singI = singI + 1;
        end
    end
    [alpha beta] = fminsearch(@error, [.01 .01]);
end