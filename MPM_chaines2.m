function X_apost=MPM_chaines2(Mat_f,n,cl1,cl2,A,p10,p20)

    alfa = forward_iter_rescaled2(Mat_f,n,A,p10,p20);
    beta = backward_iter_rescaled2(Mat_f,n,A);
    
    %alfa = forward_iter2(Mat_f,n,A,p10,p20);
    %beta = backward_iter2(Mat_f,n,A);
    
    C = alfa .* beta;
    
    Xsi = C ./ sum(C,2);
    
    B = double(Xsi(:,1) > Xsi(:,2));
    
    X_apost = B*cl1 + (1-B)*cl2;
    X_apost = X_apost';
    
end