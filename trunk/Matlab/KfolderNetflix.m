function KfolderNetflix(pathUrm,k,typeOfTest,ls)

% test KfolderAll per Netflix utilizzabile nei casi esplicito e implicito

% 'pathUrm': path in cui si trova la urm che vogliamo utilizzare
% 'k': numero di folder in cui suddividiamo il test (k=2)
% 'typeOfTest': tipo di test che vogliamo eseguire (es: SVDCF)
% 'ls': latent size da passare all'algoritmo SVD
% 'soglia': parametro utilizzato per qualche algoritmo di fusione, indica
% la soglia di creazione del cluster
% 'visMin' e 'visMax': parametri aggiuntivi utilizzati per altri algoritmi
% di fusione



for i=1:k
    %
    % algoritmo content based che si basa sulla SVD
    %
    if(strcmp(typeOfTest,'SVD-CF'))
        SVDCFnet(ls,pathUrm,i,typeOfTest);
           
    %
    %
    % algoritmo di tipo item-item che sfrutta la matrice DR e normalizza poi
    % applicando la formula freq(i,j)/freq(i)+C senza gli alpha, dove C è
    % una costante che facciamo variare C=1,2,5. DRcad sta per DR con "C Al
    % Denominatore"
    %
    %
    elseif(strcmp(typeOfTest,'DRCnet'))    
        DRCnet(pathUrm,i,typeOfTest);    
        
    elseif(strcmp(typeOfTest,'DRCnetAntiloo'))    
        DRCnetAntiloo(pathUrm,i,typeOfTest);    

    elseif(strcmp(typeOfTest,'GlobalEffect'))    
        GlobalEffect(pathUrm,i,typeOfTest);   
        
    elseif(strcmp(typeOfTest,'GlobalEffectAntiloo'))    
        GlobalEffectAntiloo(pathUrm,i,typeOfTest);  
        
    elseif(strcmp(typeOfTest,'AdjustedCosenoRecall'))    
        AdjustedCosenoRecall(pathUrm,i,typeOfTest);    
        
    elseif(strcmp(typeOfTest,'AdjustedCosenoFallout'))    
        AdjustedCosenoFallout(pathUrm,i,typeOfTest);    
                
    elseif(strcmp(typeOfTest,'CosenoRecall'))    
        CosenoRecall(pathUrm,i,typeOfTest);    
        
    elseif(strcmp(typeOfTest,'CosenoFallout'))    
        CosenoFallout(pathUrm,i,typeOfTest); 
        
    elseif(strcmp(typeOfTest,'netSVD-CF'))    
        SVDCFnetSVD(ls,pathUrm,i,typeOfTest);
    
    elseif(strcmp(typeOfTest,'SVD-CF-antiloo'))    
        SVDCFnetAntiLoo(ls,pathUrm,i,typeOfTest);
    end
    
    disp(strcat('passata: ',num2str(i)))
    
end
