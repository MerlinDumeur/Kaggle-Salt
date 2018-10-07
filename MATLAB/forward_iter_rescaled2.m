function alfa = forward_iter_rescaled2(Mat_f,n,A,p10,p20)
    
    alfa = zeros(n, 2);
    alfa(1,:) = [p10*Mat_f(1,1) p20*Mat_f(1,2)];
    
    %rescaling
    
    resc = alfa(1,1)+alfa(1,2);
    alfa(1,:) = alfa(1,:)/resc;
    
    for i = 2:n
       
        rec = alfa(i-1,:);
        alfa(i,:) = [(rec(1)*A(1,1) + rec(2)*A(2,1))*Mat_f(i,1) (rec(1)*A(1,2) + rec(2)*A(2,2))*Mat_f(i,2)];
        
        %rescaling
        
        resc = alfa(i,1)+alfa(i,2);
        alfa(i,:) = alfa(i,:)/resc;
        
    end

end