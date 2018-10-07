function beta = backward2(Mat_f,n,A)


    function intermediaire = recursive(m)
        
        if (m == n)
            
            intermediaire = [1.1 1.1];

        else
            
            rec = recursive(m+1);

            ligne = [rec(1,1)*A(1,1)*Mat_f(m+1,1)+rec(1,2)*A(1,2)*Mat_f(m+1,2) rec(1,1)*A(2,1)*Mat_f(m+1,1)+rec(1,2)*A(2,2)*Mat_f(m+1,2)];
            intermediaire = [ligne ; rec];

        end
            
    end

    beta = recursive(1);

end