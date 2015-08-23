#include "cs_mex.h"
/* C = cs_transpose (A), computes C=A', where A must be sparse.
   C = cs_transpose (A,kind) computes C=A.' if kind <= 0, C=A' if kind > 0 
   C = cs_transpose (A,kind,unbias) computes C=A.' if kind <= 0, C=A' if kind > 0 */
void mexFunction
(
    int nargout,
    mxArray *pargout [ ],
    int nargin,
    const mxArray *pargin [ ]
)
{
    CS_INT values ;
    double unbias=0.0;
    if (nargout > 1 || nargin < 1 || nargin > 3)
    {
        mexErrMsgTxt ("Usage: C = cs_transpose(A,kind,unbias)") ;
    }
    values = (nargin > 1) ? mxGetScalar (pargin [1]) : 1 ;
    values = (values <= 0) ? -1 : 1 ;
    
    if (nargin > 2) unbias = mxGetScalar (pargin [2]);

        cs_dl Amatrix, *A, *C ;
        A = cs_dl_mex_get_sparse (&Amatrix, 0, 1, pargin [0]) ; /* get A */
        C = cs_dl_transpose (A, values) ;                       /* C = A' */

    UF_long p, j, m, n, nzmax, nz, *Ap, *Ai ;
    double *Ax ;
    if (!C) { printf ("(null)\n") ; return  ; }
    	m = C->m ; 
	n = C->n ; 
	Ap = C->p ; 
	Ai = C->i ; 
	Ax = C->x ;
	nzmax = C->nzmax ; 
	nz = C->nz ;

    for (j = 0 ; j < n ; j++)
    {
        for (p = Ap [j] ; p < Ap [j+1] ; p++)
        {
	       Ax[p] = Ax[p]-unbias;
        }
    }


    cs_dl_dupl (C);
    cs_dl_dropzeros (C);
    pargout [0] = cs_dl_mex_put_sparse (&C) ;               /* return C */

}
