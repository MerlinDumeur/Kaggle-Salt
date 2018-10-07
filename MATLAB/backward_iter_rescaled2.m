function beta = backward_iter_rescaled2(Mat_f,n,A)

    beta = zeros(n,2);
    beta(n,:) = [1.1 1.1];
    
    %rescaling
    
    resc = beta(n,1)+beta(n,2);
    beta(n,:) = beta(n,:)/resc;
    
    for i = n-1:-1:1

        rec = beta(i+1,:);
        beta(i,:) = [rec(1)*A(1,1)*Mat_f(i+1,1)+rec(2)*A(1,2)*Mat_f(i+1,2) rec(1)*A(2,1)*Mat_f(i+1,1)+rec(2)*A(2,2)*Mat_f(i+1,2)];
        
        %rescaling
        
        resc = beta(i,1)+beta(i,2);
        beta(i,:) = beta(i,:)/resc;
        
        
    end

end