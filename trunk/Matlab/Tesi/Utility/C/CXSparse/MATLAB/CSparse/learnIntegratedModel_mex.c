#include "cs_mex.h"
#include "math.h"
#include "stdio.h"
#include "time.h"
/* 
    [bu,bi,q,p,y,w,c]=learnIntegratedModel(urm,mu,bu,bi,iterations,knn,lrate1,lrate2,lrate3,scalingFactor,lambda6,lambda7,lambda8,q,p,y,w,c,s)
    
    -- reference paper -- 
      "Factorization Meets the Neighborhood: a Multifaceted Collaborative Filtering Model"
      Yehuda Koren, AT&T Labs - Research
      KDD 2008, Las Vegas, Nevada, USA
      
*/

#define log 1

double absolute (double x);
bool file_exists(const char * filename);

void mexFunction
(
    int nargout,
    mxArray *pargout [ ],
    int nargin,
    const mxArray *pargin [ ]
)
{
    int iterations, knn;
    double mu, lrate1, lrate2, lrate3, scalingFactor, lambda6, lambda7,lambda8;
    double *buin, *biin, *qin, *pin, *yin;
    double *bu,   *bi,   *q,   *p,   *y;
    int ls;
    int itemsNum, usersNum;
    cs_dl Amatrix, *A, WmatrixIn, *Win, *W, CmatrixIn, *Cin, *C;
    cs_dl Smatrix, *S;
    bool useruser = false;
    FILE *verbose;
    
    if (nargout < 1 || nargout > 7 || nargin < 19 || nargin > 19)
    {
        fprintf(stdout,"nargin = %d, nargout = %d \n", nargin,nargout);
        mexErrMsgTxt ("Usage: [bu,bi,q,p,y,w,c]=learnIntegratedModel(urm,mu,bu,bi,iterations,knn,lrate1,lrate2,lrate3,scalingFactor,lambda6,lambda7,lambda8,q,p,y,w,c,s) \n urm must be sparse, bu and bi must be dense") ;
    }
    
    int indexArgin = 0, indexArgout = 0;
    
    if (log>1)
    {
        verbose = fopen("/home/roby/verbose.txt", "w+"); 
        fprintf(stdout, "verbose mode");   
    }
    
    if (log) fprintf(stdout,"--input started\n");
    A = cs_dl_mex_get_sparse (&Amatrix, 0, 1, pargin [indexArgin]) ;  /* get A=urm */
        itemsNum = mxGetN(pargin[indexArgin]);
        usersNum = mxGetM(pargin[indexArgin++]);  
    mu = mxGetScalar (pargin [indexArgin++]);
    buin = mxGetPr(pargin[indexArgin++]); 
    biin = mxGetPr(pargin[indexArgin++]);
    iterations = mxGetScalar (pargin [indexArgin++]);
    knn = mxGetScalar (pargin [indexArgin++]);
    lrate1 = mxGetScalar (pargin [indexArgin++]);
    lrate2 = mxGetScalar (pargin [indexArgin++]);
    lrate3 = mxGetScalar (pargin [indexArgin++]);
    scalingFactor = mxGetScalar (pargin [indexArgin++]);
    lambda6 = mxGetScalar (pargin [indexArgin++]);
    lambda7 = mxGetScalar (pargin [indexArgin++]);
    lambda8 = mxGetScalar (pargin [indexArgin++]);
    qin = mxGetPr(pargin[indexArgin]); ls = mxGetM(pargin[indexArgin++]);  
    pin = mxGetPr(pargin[indexArgin++]);
    yin = mxGetPr(pargin[indexArgin++]);
    Win = cs_dl_mex_get_sparse (&WmatrixIn, 0, 1, pargin [indexArgin++]) ;
    Cin = cs_dl_mex_get_sparse (&CmatrixIn, 0, 1, pargin [indexArgin++]) ;   
    S = cs_dl_mex_get_sparse (&Smatrix, 0, 1, pargin [indexArgin++]);  /* get S = item-item similarity matrix */   
        
    if (log) fprintf(stdout,"users=%d, items=%d\n",usersNum,itemsNum);
    if (log) fprintf(stdout,"number of factors=%d, number of iterations=%d\n",ls,iterations);
    if (log) fprintf(stdout," bu =[%d x %d] \n", mxGetM(pargin[2]), mxGetN(pargin[2]));
    if (log) fprintf(stdout," bi =[%d x %d] \n", mxGetM(pargin[3]), mxGetN(pargin[3]));       
    
    if (log) fprintf(stdout,"--input completed\n");
    
    UF_long Am, An, Anzmax, Anz, *Ap, *Ai ;
    double *Ax ;
    if (!A) { printf ("(null)\n") ; return  ; }
    
    Am = A->m ; An = A->n ; 	    Ap = A->p ;   Ai = A->i ; 
    Ax = A->x ;	Anzmax = A->nzmax ; Anz = A->nz ;
    
    if (log) fprintf(stdout,"--urm ready \n");
    
    /* 
        B = transpose of URM
    */
    cs_dl *B;
    UF_long Bm, Bn, Bnzmax, Bnz, *Bp, *Bi ;
    double *Bx ;
    B = cs_dl_transpose (A, 1) ;                       /* B = A' = urm' */
    Bm = B->m ; Bn = B->n ; 	    Bp = B->p ;   Bi = B->i ; 
    Bx = B->x ;	Bnzmax = B->nzmax ; Bnz = B->nz ;
    
    if (log) fprintf(stdout,"--urm transpose ready\n");
    
    /*
        S = item-item similarity matrix
    */    
    UF_long Sm, Sn, Snzmax, Snz, *Sp, *Si ;
    double *Sx ;
    if (!S) { printf ("(null)\n") ; return  ; }
    
    Sm = S->m ; Sn = S->n ; 	    Sp = S->p ;   Si = S->i ; 
    Sx = S->x ;	Snzmax = S->nzmax ; Snz = S->nz ;   
    
    if (log) fprintf(stdout,"--similarity matrix ready\n"); 
    
    
    int ii;
    pargout[indexArgout]=mxCreateDoubleMatrix(usersNum,1,mxREAL);
    bu=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<usersNum;ii++) bu[ii] = buin[ii];
    if (log) fprintf(stdout,"--bu ready\n");

    pargout[indexArgout]=mxCreateDoubleMatrix(itemsNum,1,mxREAL);
    bi=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<itemsNum;ii++) bi[ii] = biin[ii];
    if (log) fprintf(stdout,"--bi ready\n");

    pargout[indexArgout]=mxCreateDoubleMatrix(ls,itemsNum,mxREAL);
    q=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<ls*itemsNum;ii++) q[ii] = qin[ii];
    if (log) fprintf(stdout,"--q ready\n");

    pargout[indexArgout]=mxCreateDoubleMatrix(ls,usersNum,mxREAL);
    p=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<ls*usersNum;ii++) p[ii] = pin[ii];
    if (log) fprintf(stdout,"--p ready\n");

    pargout[indexArgout]=mxCreateDoubleMatrix(ls,itemsNum,mxREAL); 
    y=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<ls*itemsNum;ii++) y[ii] = yin[ii];
    if (log) fprintf(stdout,"--y ready\n");
    
    cs_dl *Wtmp = cs_dl_transpose (Win, 1) ;
    W = cs_dl_transpose (Wtmp, 1) ;

    UF_long Wm, Wn, Wnzmax, Wnz, *Wp, *Wi ;
    double *Wx ;    
    Wm = W->m ; Wn = W->n ; 	    Wp = W->p ;   Wi = W->i ; 
    Wx = W->x ;	Wnzmax = W->nzmax ; Wnz = W->nz ;    
    
    pargout[indexArgout++] = cs_dl_mex_put_sparse (&W) ;    
    cs_dl_spfree (Wtmp); 
    
    if (log) fprintf(stdout,"--w ready\n");    
    
    UF_long Cm, Cn, Cnzmax, Cnz, *Cp, *Ci ;
    double *Cx;    
    cs_dl *Ctmp = cs_dl_transpose (Cin, 1) ;
    C = cs_dl_transpose (Ctmp, 1) ;
    
    Cm = C->m ; Cn = C->n ; 	    Cp = C->p ;   Ci = C->i ; 
    Cx = C->x ;	Cnzmax = C->nzmax ; Cnz = C->nz ;          
    
    pargout[indexArgout++] = cs_dl_mex_put_sparse (&C) ;    
    cs_dl_spfree (Ctmp);   

    if (log) fprintf(stdout,"--c ready\n");    
    
    if (log) fprintf(stdout," \n allocated %d outputs \n",indexArgout); 
    
    int count, u, i, j, k, z, v;
    int iii;
    int itemj;
    int numRatedItems, numRatingUsers;
    double cardden, carddenNeigh;
    double *sumyi=calloc(ls, sizeof(double));
    double *sumyi_p=calloc(ls, sizeof(double));
    double cumerror=0.0, pseudoRMSE=0.0; 
    long numTests=0;
    double r_hat, e_ui, e_ui_den, e_ui_denNeigh;
    double *unbiased_r_uj=calloc(knn, sizeof(double)); 
    int neighbor;  
    UF_long *pointerNeighbor=calloc(knn,sizeof(UF_long));
    double **pointerNeighborW=calloc(knn,sizeof(double*));
    double **pointerNeighborC=calloc(knn,sizeof(double*));    
    int numNeighborRatedItems;
    int anomaliesCounter=0;
    const int maxAnomalies=100000;
    time_t t1,t2, t0;
    (void) time(&t0);
    for (count=0;count<iterations;count++) /* FOR count=1,#iterations DO */
    {   
        (void) time(&t1);
        cumerror=0.0;
        numTests = 0; 
        anomaliesCounter = 0;
        for (u=0;u<usersNum;u++) /* FOR u=1,..,m DO */
        {
            numRatedItems = (int) (Bp [u+1] - Bp [u]);
            if (numRatedItems==0) continue;

            cardden = 1 / (sqrt((double) numRatedItems));
            
            /* FOR ALL i (itemj) IN R(u) DO */
            for (j=Bp[u]; j<Bp[u+1]; j++)
            {   
                r_hat = 0.0;
                itemj = Bi[j];
                numNeighborRatedItems = 0;
                UF_long indexRatedItems = Bp[u];                
                UF_long indextmpneigh=Sp[itemj];
                while (indexRatedItems<Bp [u+1] && indextmpneigh<Sp[itemj+1])
                {
                    if (Bi[indexRatedItems] < Si[indextmpneigh])
                    {
                        indexRatedItems++;
                    }
                    else if (Bi[indexRatedItems] > Si[indextmpneigh])
                    {
                        indextmpneigh++;
                    }
                    else
                    {
                        neighbor = Si[indextmpneigh]; /* neighbor will contain the neighborhoods of the current item itemj, rated by u */
                        pointerNeighborW[numNeighborRatedItems] = &Wx[indextmpneigh];
                        pointerNeighborC[numNeighborRatedItems] = &Cx[indextmpneigh];                        
                        unbiased_r_uj[numNeighborRatedItems] = Bx[j + indexRatedItems] - (mu + bi[neighbor]); /* bu is not substracted here because it is learned later*/
                        
                        r_hat += ((unbiased_r_uj[numNeighborRatedItems]-bu[u])*Wx[indextmpneigh] + Cx[indextmpneigh]);          
                        indextmpneigh++;
                        indexRatedItems++;
                        numNeighborRatedItems++;
                    }
                }    
                carddenNeigh = (numNeighborRatedItems > 0) ? 1 / ((double) sqrt(numNeighborRatedItems)) : 1;
                r_hat = r_hat * carddenNeigh;    

                for (iii=0;iii<ls;iii++) sumyi[iii]=0.0; /* sumyi[ls] <- 0 */
                /* SUM_{J in N(U)} {yi}*/
                for (z=Bp[u]; z<Bp[u+1]; z++)
                {   
                    itemj = Bi[z];
                    for (k=0;k<ls;k++)
                        sumyi[k] += (y[ls*itemj+k] * cardden);
                }

                /* q_i(k) * (pu + sumyi(k)) */
                for (k=0; k<ls; k++)
                    r_hat += ( q[ls*itemj+k] * ( p[ls*u+k] + sumyi[k] ) );    
                    
                r_hat += (mu + bu[u] + bi[itemj]); /* r_hat = mu + bu + bi + q_i'*sumyi */  
                e_ui = Bx[j] - r_hat; /* e_ui = r_ui - r_hat */

                e_ui_den = e_ui * cardden;
                e_ui_denNeigh = e_ui * carddenNeigh;               
                
                if (absolute(e_ui)>7) 
                {
                    fprintf(stdout, " -!- [%d] -!- user=%d, item=%d, r=%f, r_hat=%f, e_ui=%f  gradient error too large \n",anomaliesCounter,u,itemj,Bx[j],r_hat,e_ui);
                    fprintf(stdout, "  biasu=%f, biasi=%f \n", bu[u], bi[itemj]);
                    if (log>1) fclose(verbose);
                    anomaliesCounter++;
                    if (anomaliesCounter>maxAnomalies) return;    
                }
                
                cumerror += (e_ui*e_ui);
                numTests++;               
                

                /* perform gradient step on qi, bu, bi  AND on "pu" if user-user model is enabled */
                bu[u] += (lrate1 * (e_ui - lambda6*bu[u])); /* bu <- bu + gamma*(e_ui-lambda*bu) */        
                bi[itemj] += (lrate1 * (e_ui - lambda6*bi[itemj])); /* bi <- bi + gamma*(e_ui-lambda*bi) */   
                         
                                                
                for (k=0; k<ls; k++) 
                {
                    q[ls*itemj+k] += (lrate2 * (e_ui*p[ls*u+k] + (sumyi[k]) - lambda7 * q[ls*itemj+k])); /* q_i <- q_i + gamma*(e_ui*pu+|N(u)|sum...-lambda*q_i) */
                    p[ls*u+k] += (lrate2 * (e_ui) * q[ls*itemj+k] - lambda7 * p[ls*u+k]);    
                }            
                     
                
                /* FOR ALL j IN N(u) DO */
                for (z=Bp[u]; z<Bp[u+1]; z++) /* perform gradient step on yi*/
                {   
                    int curitem = Bi[z];
                    for (k=0; k<ls; k++)
                        y[ls*curitem+k] += (lrate2 * ( (e_ui_den * q[ls*itemj+k] ) - lambda7*y[ls*curitem+k] ) );   /* update of every feature of yi */
                }                    
                                  
                
                /* FOR ALL items in R^k(i;u) */
                for (v=0; v<numNeighborRatedItems; v++)
                {
                    *(pointerNeighborW[v]) += (lrate3 * ((e_ui_denNeigh*(unbiased_r_uj[v]-bu[u])) - lambda8*(*pointerNeighborW[v])));                     
                    *(pointerNeighborC[v]) += (lrate3 * ( e_ui_denNeigh  -                  lambda8*(*pointerNeighborC[v])));
                }       
                           
            }

            if (log && ( ((u-1) % 1000 == 0)) )
            {
                (void) time(&t2);
                fprintf(stdout, "[%d] partial RMSE = %g, time for last group (up to user %d) is %d secs - remaining Time =%d secs\n", cumerror / ((double) numTests), (int) t2-t0,u, (int) t2-t1, (int) ( ( (t2-t0)/((double) u+usersNum*count))*((double)((usersNum-u)))));
                if (file_exists("/home/roby/stopnow")) return;
                (void) time(&t1);
            }


        }
        pseudoRMSE = cumerror / ((double) numTests);
        if (log) 
        {   
            fprintf(stdout, " cumulative error iteration %d = %g (%d tests) \n", count, pseudoRMSE,numTests);
            if (file_exists("/home/roby/stopiter")) return;
        }
        if (mxIsNaN(pseudoRMSE))
        {
            fprintf(stdout, " -!- STOPPED -!- ");
            return;        
        }
        
        lrate1 = lrate1*scalingFactor;
        lrate2 = lrate2*scalingFactor;
        lrate3 = lrate3*scalingFactor;
    }
    if (log>1) fclose(verbose);
    
}

double absolute (double x)
{
    return (x>0 ? x : -x);
}

bool file_exists(const char * filename)
{
    FILE * file = fopen(filename, "r");
    if (file)
    {
        fclose(file);
        return true;
    }
    return false;
}
