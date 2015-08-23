#include "cs_mex.h"
#include "stdio.h"
/* 
    [RMSE]=testRMSEFactorModel(urm,urmtest,mu,bu,bi,q,x,y,[p,z])
    
    -- reference paper -- 
      "Factor in the Neighbors: Scalable and Accurate Collaborative Filtering"
      Yehuda Koren, AT&T Labs - Research
      
*/

#define log 1

double absolute (double x);

void mexFunction
(
    int nargout,
    mxArray *pargout [ ],
    int nargin,
    const mxArray *pargin [ ]
)
{
    double mu, lrate, lambda;
    double *buin, *biin, *qin, *xin, *yin, *pin, *zin;
    int ls;
    int itemsNum, usersNum;
    cs_dl Amatrix, *A;
    cs_dl Probematrix, *PROBE;
    bool useruser = false;
    
    if (nargout < 1 || nargout > 1 || nargin < 8 || nargin > 10)
    {
        mexErrMsgTxt ("Usage: [RMSE]=testRMSEFactorModel(urm,urmtest,mu,bu,bi,q,x,y,[p,z]) \n urmtest must be sparse, bu and bi must be dense") ;
    }
    
    if (nargin>9)
    {
        useruser=true; /* enable the integration of the user-user model into the item-item model */
        if (log) fprintf(stdout,"user-user model enabled\n");
    }    
    
    int indexArgin = 0;
    
    if (log) fprintf(stdout,"--input started\n");
    A = cs_dl_mex_get_sparse (&Amatrix, 0, 1, pargin [indexArgin]) ;  usersNum = mxGetM(pargin[indexArgin++]);  /* get URM */
    PROBE = cs_dl_mex_get_sparse (&Probematrix, 0, 1, pargin [indexArgin++]) ;  /* get URM probe set */    
    mu = mxGetScalar (pargin [indexArgin++]);
    buin = mxGetPr(pargin[indexArgin++]); 
    biin = mxGetPr(pargin[indexArgin++]);
    qin = mxGetPr(pargin[indexArgin]); ls = mxGetM(pargin[indexArgin]); itemsNum = mxGetN(pargin[indexArgin++]); 
    xin = mxGetPr(pargin[indexArgin++]);
    yin = mxGetPr(pargin[indexArgin++]);
    if (useruser)
    {
        pin = mxGetPr(pargin[indexArgin++]);
        zin = mxGetPr(pargin[indexArgin++]);      
    }  
        
    if (log) fprintf(stdout,"users=%d, items=%d\n",usersNum,itemsNum);
    if (log) fprintf(stdout,"number of factors=%d\n",ls);
    if (log) fprintf(stdout," bu =[%d x %d] \n", mxGetM(pargin[3]), mxGetN(pargin[3]));
    if (log) fprintf(stdout," bi =[%d x %d] \n", mxGetM(pargin[4]), mxGetN(pargin[4]));    
    if (log) fprintf(stdout,"--input completed\n");
    
    /* URM */
    UF_long Am, An, Anzmax, Anz, *Ap, *Ai ;
    double *Ax ;
    if (!PROBE) { printf ("(null)\n") ; return  ; }
    Am = PROBE->m ; An = PROBE->n ; 	    Ap = PROBE->p ;   Ai = PROBE->i ; 
    Ax = PROBE->x ;	Anzmax = PROBE->nzmax ; Anz = PROBE->nz ;
    
    /* URM PROBE SET */
    UF_long Probe_m, Probe_n, Probe_nzmax, Probe_nz, *Probe_p, *Probe_i ;
    double *Probe_x ;
    if (!PROBE) { printf ("(null)\n") ; return  ; }
    Probe_m = PROBE->m ; Probe_n = PROBE->n ; 	    Probe_p = PROBE->p ;   Probe_i = PROBE->i ; 
    Probe_x = PROBE->x ;	Probe_nzmax = PROBE->nzmax ; Probe_nz = PROBE->nz ;    
    
    /* 
        B = transpose of URM
    */
    cs_dl *B;
    UF_long Bm, Bn, Bnzmax, Bnz, *Bp, *Bi ;
    double *Bx ;
    B = cs_dl_transpose (PROBE, 1) ;                       /* B = PROBE' */
    Bm = B->m ; Bn = B->n ; 	    Bp = B->p ;   Bi = B->i ; 
    Bx = B->x ;	Bnzmax = B->nzmax ; Bnz = B->nz ;
    
    
    int u, i, j, k;
    int iii;
    int usertest, itemtest;
    double biasu;
    double biasi;
    double r_hat_ui, r_ui;
    int numRatedItems, numRatingUsers;
    double puCoeff, zvCoeff;
    double *pu=calloc(ls, sizeof(double));
    double *zv=calloc(ls, sizeof(double)); 
    double RMSE;
    long numTest=0;
    double error;

    RMSE=0.0; 
    /* FOR (usertest,itemtest) in PROBE DO */
    for (itemtest=0; itemtest<itemsNum; itemtest++)
    {   
        for (i=Probe_p[itemtest]; i<Probe_p[itemtest+1]; i++)
        {
            usertest=Probe_i[i];
                
            for (iii=0;iii<ls;iii++) pu[iii]=0.0; /* pu[ls] <- 0 */
            
            numRatedItems = Bp [usertest+1] - Bp [usertest];
            if (numRatedItems==0) 
            {
                continue;
            }
            biasu=buin[usertest];
            biasi = biin[itemtest]; /* bias item j */
            /* compute the component independent of i*/
            for (j=Bp[usertest]; j<Bp[usertest+1]; j++)
            {   
                double ruj, biasii, xjk, yjk;
                int itemj;
                itemj = Bi[j];
                ruj=Bx[j]; /* r_uj */
                
                biasii=biin[itemj];
                puCoeff = (ruj - (mu + biasu + biasii)) / (sqrt(numRatedItems)); /* |R(u)|^-1/2 * (r_uj - b_uj) */
                for (k=0;k<ls;k++) /* compute pu for each feature k*/
                {   
                    xjk = xin[ls*itemj+k]; /* x[ls*itemj+k] = x[ls,itemj] */ 
                    yjk = yin[ls*itemj+k]; /* y[ls*itemj+k] = y[ls,itemj] */                                                      
                    pu[k] += puCoeff * xjk;          
                    pu[k] += yjk / (sqrt(numRatedItems));      
                }
            }

            r_hat_ui=0.0;
            if (useruser) /* if user-user is enabled */
            {
                int useri;
                numRatingUsers = Ap [itemtest+1] - Ap [itemtest]; /* |R(i)| */
                for (iii=0;iii<ls;iii++) zv[iii]=0.0; /* zv[ls] <- 0 */ 
                for (i=Ap[itemtest]; i<Ap[itemtest+1]; i++)
                {   
                    double rvj, biasvj, zjk;
                    useri = Ai[i];
                    rvj=Ax[i];
                    
                    biasvj=buin[useri];
                    zvCoeff = (rvj - (mu + biasvj + biasi)) / (sqrt(numRatingUsers)); /* |R(i)|^-1/2 * (r_vj - b_vj) */
                    for (k=0;k<ls;k++) /* compute pu for each feature k*/
                    {   
                        zjk = zin[ls*usertest+k]; /* z[ls*itemj+k] = z[ls,itemj] */      
                        zv[k] += zvCoeff * zjk;
                    }
                }
                for (k=0; k<ls; k++) /* p_u' * z_v */
                {
                    r_hat_ui += ( pin[ls*usertest+k] * zv[k] ); /* p_u(k) * zv(k) */
                }                       
            }                                 
            for (k=0; k<ls; k++) /* q_i' * pu */
            {                    
                r_hat_ui += ( qin[ls*itemtest+k] * pu[k] ); /* q_i(k) * pu(k) */
            }
            r_hat_ui += mu + biasu + biasi; /* r_hat_ui = mu + bu + bi + q_i'*pu */     
            r_ui = Probe_x[i]; /* r_ui */
            
            error = r_ui - r_hat_ui;
            RMSE += (error*error);
            if (log && ((numTest%100000)==0 || error>4)) fprintf(stdout, "[%d] - (user %d, item %d): r_ui=%f r_hat_ui=%f, squareErr = %f, RMSE=%f\n", numTest,usertest,itemtest,r_ui,r_hat_ui,(error*error),sqrt(RMSE/((double)numTest))); 
            numTest++; 
        }
    }
    
    fprintf(stdout, "number of tests: %d\n", numTest);
    pargout[0] = mxCreateDoubleScalar (sqrt(RMSE/(double)numTest));    
    
}

double absolute (double x)
{
    return (x>0 ? x : -x);
}

