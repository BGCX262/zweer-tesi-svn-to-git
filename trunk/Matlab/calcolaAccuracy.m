function calcolaAccuracy(path,nomeAlg,alg,dataset,typetest,ls)
%function calcolaAccuracy(path,nomeAlg,alg,dataset,typetest,ls)
%path=percorso dove si trovano i file su cui calcolare recall/fallout
%nomeAlg='SVD-CF','SVD-CF-antiloo','GlobalEffectAntiloo'
%alg='svd','dr','globeff'
%dataset='Netflix','MovieLens'
%typetest='recall','fallout'
%ls=[300 100 50 15 5 2 1] per svd, ls=1 altrimenti

soglia1=2;
soglia5=20000;
racc=5;
meta1='1half';
meta2='2half';
nomeTop='topRatedAll';

if(strcmp(typetest,'recall'))
    if(strcmp(dataset,'Netflix'))
        soglia2=218;
        soglia3=465;
        soglia4=841;

        profilo='cortissimo'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia2,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia2,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia1,soglia2,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia1,soglia2,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='corto'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia2,soglia3,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia2,soglia3,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia2,soglia3,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia2,soglia3,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='lungo'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia3,soglia4,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia3,soglia4,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia3,soglia4,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia3,soglia4,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='lunghissimo'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia4,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia4,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia4,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia4,soglia5,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='tuttiutenti'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia1,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia1,soglia5,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

    elseif(strcmp(dataset,'MovieLens'))
        soglia2=147;
        soglia3=302;
        soglia4=544;     
        
        profilo='cortissimo'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia2,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia2,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia1,soglia2,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia1,soglia2,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='corto'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia2,soglia3,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia2,soglia3,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia2,soglia3,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia2,soglia3,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='lungo'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia3,soglia4,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia3,soglia4,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia3,soglia4,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia3,soglia4,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='lunghissimo'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia4,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia4,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia4,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia4,soglia5,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');

        profilo='tuttiutenti'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia1,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia1,soglia5,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');
        
    elseif(strcmp(dataset,'Fastweb'))
        profilo='tuttiutenti'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,80,racc,soglia1,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,80,racc,soglia1,soglia5,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');
    elseif(strcmp(dataset,'NFcw'))
        profilo='tuttiutenti'
        a=strcat(path,'recall',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,340,racc,soglia1,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,340,racc,soglia1,soglia5,ls);
        RE=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'RE');    
    end
elseif(strcmp(typetest,'fallout'))
    if(strcmp(dataset,'Netflix'))
        soglia2=218;
        soglia3=465;
        soglia4=841;

        profilo='cortissimo'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia2,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia2,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia1,soglia2,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia1,soglia2,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='corto'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia2,soglia3,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia2,soglia3,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia2,soglia3,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia2,soglia3,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='lungo'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia3,soglia4,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia3,soglia4,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia3,soglia4,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia3,soglia4,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='lunghissimo'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia4,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia4,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia4,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia4,soglia5,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='tuttiutenti'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,600,racc,soglia1,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,600,racc,soglia1,soglia5,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

    elseif(strcmp(dataset,'MovieLens'))
        soglia2=147;
        soglia3=302;
        soglia4=544;
        
        profilo='cortissimo'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia2,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia2,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia1,soglia2,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia1,soglia2,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='corto'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia2,soglia3,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia2,soglia3,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia2,soglia3,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia2,soglia3,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='lungo'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia3,soglia4,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia3,soglia4,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia3,soglia4,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia3,soglia4,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='lunghissimo'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia4,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia4,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia4,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia4,soglia5,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');

        profilo='tuttiutenti'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,450,racc,soglia1,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,450,racc,soglia1,soglia5,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');
        
    elseif(strcmp(dataset,'NFcw'))
        soglia2=147;
        soglia3=302;
        soglia4=544;
  
        profilo='tuttiutenti'
        a=strcat(path,'fallout',alg,profilo);
        [f1,ft1,fnt1]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,10,racc,soglia1,soglia5,ls);
        [f2,ft2,fnt2]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,10,racc,soglia1,soglia5,ls);
        [f3,ft3,fnt3]=accuracy(path,strcat(nomeAlg,meta1),nomeTop,340,racc,soglia1,soglia5,ls);
        [f4,ft4,fnt4]=accuracy(path,strcat(nomeAlg,meta2),nomeTop,340,racc,soglia1,soglia5,ls);
        FO=[(f1+f2)/2 (ft1+ft2)/2 (fnt1+fnt2)/2 (ft3+ft4)/2 (fnt3+fnt4)/2];
        save(a,'FO');      
    end

end