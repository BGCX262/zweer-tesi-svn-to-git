#include "cs_mex.h"
#include "math.h"
#include "stdio.h"
#include "time.h"
/* 
    [bu,bi,q,x,y]=learnFactorModelTopK(urm,mu,bu,bi,iterations,lrate,lambda,q,x,y,numSampleItems)
    
    TOP-K RECOMMENDATION TASK
    
    -- reference paper -- 
      "Factor in the Neighbors: Scalable and Accurate Collaborative Filtering"
      Yehuda Koren, AT&T Labs - Research
      
*/

#define log 1

const double scalingfactorLrate = 1.0;

double absolute (double x);
double maxDouble (double a, double b);
bool file_exists(const char * filename);
void randomSample (const int * population, const int populationSize, const int sampleSize, int * vectorOfRandomSample);
void sortRatings (double * ratings, const int ratingSize, int * sortedIndexes);
void unratedItems (const UF_long * ratingsPositions, const int numberOfRatings, const int numItems, int * vectorUnratedItems);
void randomSampleUnratedItems (const int numItems, const UF_long * ratingsPositions, const int numberOfRatings, const int sampleSize, int * vectorOfRandomSample);

void mexFunction
(
    int nargout,
    mxArray *pargout [ ],
    int nargin,
    const mxArray *pargin [ ]
)
{
    int iterations;
    int numSampleItems;
    double mu, lrate, lambda;
    double *buin, *biin, *qin, *xin, *yin, *pin, *zin;
    double *bu,   *bi,   *q,   *x,   *y,   *p,   *z;
    int ls;
    int itemsNum, usersNum;
    cs_dl Amatrix, *A;
    FILE *verbose;
    
    if (nargout < 5 || nargout > 5 || nargin < 11 || nargin > 11)
    {
        mexErrMsgTxt ("Usage: [bu,bi,q,x,y]=learnFactorModelTopK(urm,mu,bu,bi,iterations,lrate,lambda,q,x,y,numSampleItems) \n urm must be sparse, bu and bi must be dense") ;
    }
    
    int indexArgin = 0, indexArgout = 0;;
    
    if (log>1)
    {
        verbose = fopen("/home/roby/verbose.txt", "w+"); 
        fprintf(stdout, "verbose mode");   
    }
    
    if (log) fprintf(stdout,"--input started\n");
    A = cs_dl_mex_get_sparse (&Amatrix, 0, 1, pargin [indexArgin]) ;  usersNum = mxGetM(pargin[indexArgin++]);  /* get A=urm */
    mu = mxGetScalar (pargin [indexArgin++]);
    buin = mxGetPr(pargin[indexArgin++]); 
    biin = mxGetPr(pargin[indexArgin++]);
    iterations = mxGetScalar (pargin [indexArgin++]);
    lrate = mxGetScalar (pargin [indexArgin++]);
    lambda = mxGetScalar (pargin [indexArgin++]);
    qin = mxGetPr(pargin[indexArgin]); ls = mxGetM(pargin[indexArgin]); itemsNum = mxGetN(pargin[indexArgin++]); 
    xin = mxGetPr(pargin[indexArgin++]);
    yin = mxGetPr(pargin[indexArgin++]);
    numSampleItems = mxGetScalar (pargin [indexArgin++]);
    
    if (numSampleItems>=itemsNum)
    {
        mexErrMsgTxt ("CHECK the number of sample items") ;
    }    
        
    if (log) fprintf(stdout,"users=%d, items=%d\n",usersNum,itemsNum);
    if (log) fprintf(stdout,"number of factors=%d, number of iterations=%d\n",ls,iterations);
    if (log) fprintf(stdout," bu =[%d x %d] \n", mxGetM(pargin[2]), mxGetN(pargin[2]));
    if (log) fprintf(stdout," bi =[%d x %d] \n", mxGetM(pargin[3]), mxGetN(pargin[3]));       
    if (log) fprintf(stdout," number of items to consider in top-K rec task is %d\n", numSampleItems);
    
    if (log) fprintf(stdout,"--input completed\n");
    
    UF_long Am, An, Anzmax, Anz, *Ap, *Ai ;
    double *Ax ;
    if (!A) { printf ("(null)\n") ; return  ; }
    
    Am = A->m ; An = A->n ; 	    Ap = A->p ;   Ai = A->i ; 
    Ax = A->x ;	Anzmax = A->nzmax ; Anz = A->nz ;
    
    /* 
        B = transpose of URM
    */
    cs_dl *B;
    UF_long Bm, Bn, Bnzmax, Bnz, *Bp, *Bi ;
    double *Bx ;
    B = cs_dl_transpose (A, 1) ;                       /* B = A' = urm' */
    Bm = B->m ; Bn = B->n ; 	    Bp = B->p ;   Bi = B->i ; 
    Bx = B->x ;	Bnzmax = B->nzmax ; Bnz = B->nz ;
    
    int ii;
    pargout[indexArgout]=mxCreateDoubleMatrix(usersNum,1,mxREAL);
    bu=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<usersNum;ii++) bu[ii] = buin[ii];

    pargout[indexArgout]=mxCreateDoubleMatrix(itemsNum,1,mxREAL);
    bi=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<itemsNum;ii++) bi[ii] = biin[ii];

    pargout[indexArgout]=mxCreateDoubleMatrix(ls,itemsNum,mxREAL);
    q=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<ls*itemsNum;ii++) q[ii] = qin[ii];

    pargout[indexArgout]=mxCreateDoubleMatrix(ls,itemsNum,mxREAL);
    x=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<ls*itemsNum;ii++) x[ii] = xin[ii];

    pargout[indexArgout]=mxCreateDoubleMatrix(ls,itemsNum,mxREAL);
    y=mxGetPr(pargout[indexArgout++]);
    for (ii=0;ii<ls*itemsNum;ii++) y[ii] = yin[ii];
     
    if (log) fprintf(stdout," \n allocated %d outputs \n",indexArgout);    
    
    int count, u, i, j, k;
    int iii;
    int itemj;
    double r_ui;
    int numRatedItems, numRatingUsers;
    int * listUnratedItems = calloc (itemsNum, sizeof(int));
    int * topredictItems = calloc(numSampleItems+1,sizeof(int));
    double * r_hat_uis = calloc(numSampleItems+1, sizeof(double));
    double * sortedRatings = calloc(numSampleItems+1,sizeof(double));;
    int * sortedRatingsPositions = calloc(numSampleItems+1,sizeof(int));
    double puCoeff, zvCoeff;
    double *pu=calloc(ls, sizeof(double));
    double *zv=calloc(ls, sizeof(double)); 
    double sum[ls];
    double cumerror=0.0, pseudoRMSE=0.0; 
    long numTests=0;
    int anomaliesCounter=0;
    const int maxAnomalies=100;
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
            double errorUU=0;
            for (iii=0;iii<ls;iii++) pu[iii]=0.0; /* pu[ls] <- 0 */
            numRatedItems = (int) (Bp [u+1] - Bp [u]);
            if (numRatedItems==0) continue;
           
            /* compute the component independent of i*/
            for (j=Bp[u]; j<Bp[u+1]; j++)
            {   
                double ruj, biasi, xjk, yjk;
                itemj = Bi[j];
                ruj=Bx[j]; /* r_uj */
                
                biasi=bi[itemj];
                puCoeff = (ruj - (mu + bu[u] + biasi)) / (sqrt((double) numRatedItems)); /* |R(u)|^-1/2 * (r_uj - b_uj) */
                for (k=0;k<ls;k++) /* compute pu for each feature k*/
                {   
                    xjk = x[ls*itemj+k]; /* x[ls*itemj+k] = x[ls,itemj] */ 
                    pu[k] = pu[k] + (puCoeff * xjk);
                }
                for (k=0;k<ls;k++) /* compute pu for each feature k*/
                {                   
                    yjk = y[ls*itemj+k]; /* y[ls*itemj+k] = y[ls,itemj] */
                    pu[k] = pu[k] + (yjk / (sqrt((double) numRatedItems)));                
                }
            }
            for (iii=0;iii<ls;iii++) sum[iii]=0.0; /* sum[ls] <- 0 */


/*
            unratedItems (&Bi[Bp[u]], numRatedItems, itemsNum, listUnratedItems);             
            randomSample (listUnratedItems, itemsNum-numRatedItems, numSampleItems, topredictItems);
*/            
            randomSampleUnratedItems (itemsNum, &Bi[Bp[u]], numRatedItems, numSampleItems, topredictItems);

            /* FOR ALL i (itemj) IN R(u) DO */
            for (j=Bp[u]; j<Bp[u+1]; j++)
            {   
                double r_hat_ui, e_ui;
                itemj = Bi[j];
               
                topredictItems[numSampleItems] = itemj; /* active item */                
                
                int h;
                for (h=0; h<numSampleItems; h++)
                {
                    double r_hat_ui;
                    int curitem = topredictItems[h];
                    r_hat_ui = 0;
                    for (k=0; k<ls; k++) /* q_i' * pu */
                    {                
                        r_hat_ui += ( q[ls*curitem+k] * pu[k] ); /* q_i(k) * pu(k) */                  
                    }
                    r_hat_ui += (mu + bu[u] + bi[curitem]); /* r_hat_ui = mu + bu + bi + q_i'*pu */
                    r_hat_uis[h] = r_hat_ui;
                }                           
                
                h = numSampleItems;
                r_hat_ui = 0;
                for (k=0; k<ls; k++) /* q_i' * pu */
                {                
                    r_hat_ui += ( q[ls*itemj+k] * pu[k] ); /* q_i(k) * pu(k) */                  
                }
                r_hat_ui += (mu + bu[u] + bi[itemj]); /* r_hat_ui = mu + bu + bi + q_i'*pu */
                r_hat_uis[h] = r_hat_ui; /* r_hat_ui is the current-item rating*/
                
                sortRatings (r_hat_uis, numSampleItems+1, sortedRatingsPositions);             
                
                r_ui = Bx[j];
/*                double referenceRating = (r_ui > 3) ? r_hat_uis[0] : ((r_ui <3) ? r_hat_uis[numSampleItems] : r_ui); */
                double referenceRating = (r_ui > 3 && r_hat_uis[0]>r_ui ) ? r_hat_uis[0] : r_ui;
                referenceRating = (referenceRating>5.5) ? 5.5 : ((referenceRating<0.5) ? 0.5 : referenceRating);
                referenceRating = referenceRating;

                e_ui = referenceRating - r_hat_ui; /* e_ui = r_ui - r_hat_ui */
                
/*                if (log>1) fprintf(verbose,"referenceRating=%g - item %d=%g \n",referenceRating,itemj,r_hat_uis[numSampleItems]); */
/*                if (mxIsNaN(e_ui) || mxIsInf(e_ui) || absolute(e_ui)>100000) 
                {
                    fprintf(stdout, " -!- [%d] -!- user=%d, item=%d, r=%f, r_hat=%f, e_ui=%f  gradient error too large \n",anomaliesCounter,u,itemj,Bx[j],r_hat_ui,e_ui);
                    fprintf(stdout, "  biasu=%f, biasi=%f \n", bu[u], bi[itemj]);
                    if (log>1) fclose(verbose);
                    return;    
                }                
                if (absolute(e_ui)>7) 
                {
                    fprintf(stdout, " -!- [%d] -!- user=%d, item=%d, r=%f, r_hat=%f, e_ui=%f  gradient error too large \n",anomaliesCounter,u,itemj,Bx[j],r_hat_ui,e_ui);
                    fprintf(stdout, "  biasu=%f, biasi=%f \n", bu[u], bi[itemj]);
                    if (log>1) fclose(verbose);
                    anomaliesCounter++;
                    if (anomaliesCounter>maxAnomalies) return;    
                }
*/
                cumerror += (e_ui*e_ui);
                numTests++;
                
                if (e_ui==0) continue;                
                
                for (k=0; k<ls; k++) /* sum <- sum + e_ui * q_i */
                {
                    sum[k] += (e_ui*q[ls*itemj+k]); /* sum(k) = e_ui * q_i(k) */
                }

                /* perform gradient step on qi, bu, bi  AND on "pu" if user-user model is enabled */
                bu[u] += (lrate * (e_ui - lambda*bu[u]));  /* bu <- bu + gamma*(e_ui-lambda*bu) */        
                bi[itemj] += (lrate * (e_ui - lambda*bi[itemj])); /* bi <- bi + gamma*(e_ui-lambda*bi) */                                   
                for (k=0; k<ls; k++) 
                {
                    q[ls*itemj+k] += (lrate * (e_ui*pu[k] - lambda* q[ls*itemj+k])); /* q_i <- q_i + gamma*(e_ui*pu-lambda*q_i) */
                }                
            }
            /* FOR ALL i IN R(u) DO */
            for (j=Bp[u]; j<Bp[u+1]; j++) /* perform gradient step on xi*/
            {   
                itemj = Bi[j];
                double ruj = Bx[j];
                double biasi = bi[itemj];
                puCoeff = (1/sqrt(numRatedItems)) * (ruj - (mu + bu[u] + biasi)); /* |R(u)|^-1/2 * (r_ui - b_ui) */
                for (k=0; k<ls; k++)
                {
                    x[ls*itemj+k] += (lrate * ( puCoeff*sum[k] - lambda*x[ls*itemj+k] ));   /* update of every feature of xi */
                }   
            }
            /* FOR ALL i IN N(u) DO */
            for (j=Bp[u]; j<Bp[u+1]; j++) /* perform gradient step on yi*/
            {   
                itemj = Bi[j];
                puCoeff = (1/sqrt(numRatedItems)); /* |N(u)|^-1/2 */
                for (k=0; k<ls; k++)
                {
                    y[ls*itemj+k] += (lrate * ( puCoeff*sum[k] - lambda*y[ls*itemj+k] ) );   /* update of every feature of yi */
                }          
            }                   
            const int NUMUSERSTOLOG = 1000;
            if (log && ( ((u-1) % NUMUSERSTOLOG == 0)) )
            {
                (void) time(&t2);
                fprintf(stdout, "[%d] time for last group (up to user %d) is %d secs - err=%g - remaining Time =%d secs\n", (int) t2-t0,u, cumerror / ((double) numTests), (int) t2-t1, (int) ( ( (t2-t0)/((double) u+usersNum*count))*((double)((usersNum-u)))));
                if ((((double) (t2-t1))/(double)NUMUSERSTOLOG)>1.0) fprintf (stdout, "warning... high computing time");
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
        lrate = scalingfactorLrate*lrate;
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

void randomSample (const int * population, const int populationSize, const int sampleSize, int * vectorOfRandomSample)
{
    int i, elem;
    int extractedEl=0;
    bool isNew = false;
    if (vectorOfRandomSample == NULL)
        vectorOfRandomSample = calloc (sampleSize, sizeof(int));
    int * counter = calloc (populationSize, sizeof(int));
    int j=0;
    while (extractedEl<sampleSize)
    {
        isNew = false;
        while (!isNew)
        {
            elem = (int) (rand() % populationSize);
            if (counter[elem] == 0)
            {
                counter[elem] = 1;
                vectorOfRandomSample[j++] = population[elem];
                isNew=true;
            }
        }
        extractedEl++;
    }
    free(counter);
}

void sortRatings (double * ratings, const int ratingSize, int * sortedIndexes)
{
    int alto=ratingSize;
    int i, tmpind;
    double tmp;
           
    while (alto>0) 
    {
        for (i=1;i<alto;i++)
        {       
            if (ratings[i-1] < ratings[i])
            {
                tmp = ratings[i-1];
                ratings[i-1] = ratings[i];
                ratings[i] = tmp;
/*                tmpind = sortedIndexes[i-1];                
                sortedIndexes[i-1] = sortedIndexes[i];
                sortedIndexes[i] = tmpind;
*/                
            }
        }
        alto--;
    } 
}

void unratedItems (const UF_long * ratingsPositions, const int numberOfRatings, const int numItems, int * vectorUnratedItems)
{
    if (vectorUnratedItems == NULL)
        vectorUnratedItems = calloc (numItems - numberOfRatings, sizeof(int));
    int i,j, k;
    j=0; k=0;
    for (i=0;i<numItems;i++)
    {
        while (((int) ratingsPositions[j])<i & j<numberOfRatings-1) j++;
        if (((int) ratingsPositions[j])!=i) 
        {
            vectorUnratedItems[k] = i;
            k++;
        }
    }
    if (k != (numItems - numberOfRatings))
        fprintf (stdout, "warning in function unratedItems: k=%d, (numItems-numberOfRating)=%d-%d\n",k,numItems,numberOfRatings);    
}

void randomSampleUnratedItems (const int numItems, const UF_long * ratingsPositions, const int numberOfRatings, const int sampleSize, int * vectorOfRandomSample)
{
    int i, elem;
    int extractedEl=0;
    bool isNew = false;
    if (vectorOfRandomSample == NULL)
        vectorOfRandomSample = calloc (sampleSize, sizeof(int));
    int * counter = calloc (numItems, sizeof(int));

    for (i=0;i<numberOfRatings;i++)
        counter[ratingsPositions[i]] = -1;    
        
    while (extractedEl<sampleSize)
    {
        isNew = false;
        while (!isNew)
        {
            elem = (int) (rand() % numItems);
            if (counter[elem] == 0)
            {
                counter[elem] = 1;
                vectorOfRandomSample[extractedEl++] = elem;
                isNew=true;
            }
        }
    }
    free(counter);
}

double maxDouble (double a, double b)
{
    return (a > b) ? a : b;
}   
