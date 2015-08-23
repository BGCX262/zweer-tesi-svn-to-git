#include "cs_mex.h"
#include <stdio.h>

#define log 0 
/* 
    A = provaNormalize (A,b), for any column j, substracts b(j). A and b must be sparse.
*/
void mexFunction
(
    int nargout,
    mxArray *pargout [ ],
    int nargin,
    const mxArray *pargin [ ]
)
{
    CS_INT modeAllElement ;
    if (nargout > 1 || nargin < 2 || nargin > 2)
    {
        mexErrMsgTxt ("Usage: A = provaNormalize (A,b)") ;
    }

    double *b = mxGetPr(pargin[1]);
    cs_dl Amatrix, *A;
    A = cs_dl_mex_get_sparse (&Amatrix, 0, 1, pargin [0]) ; /* get A */

    UF_long p, i, Am, An, Anzmax, Anz, *Ap, *Ai ; 
    double *Ax;
    if (!A || !b) { if (log) printf ("(null)\n") ; return  ; }
    Am = A->m ; An = A->n ; 	Ap = A->p ; 	Ai = A->i ; Ax = A->x ;	Anzmax = A->nzmax ; Anz = A->nz ;
    fprintf(stdout,"loaded matrix\n");

    cs *returnMatrix  = cs_spalloc (Am, An, Anz, 1, 1) ;  
    for (i = 0 ; i < An ; i++)
    {
        for (p=Ap[i] ; p<Ap[i+1] ; p++)
        {
            cs_entry(returnMatrix,Ai[p],i,Ax[p]-b[i]);
            if (log) fprintf(stdout,"(%d,%d)?=%f-%f <- %f\n",Ai[p],i,Ax[p],b[i],Ax[p]-b[i]);
        }
    }
    returnMatrix = cs_compress(returnMatrix);
    pargout [0] = cs_dl_mex_put_sparse (&returnMatrix) ;               /* return A */

}
