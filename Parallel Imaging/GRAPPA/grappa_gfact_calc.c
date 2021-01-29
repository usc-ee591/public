#include "mex.h" 
#include <stdio.h>
#include <complex.h>
#include <tgmath.h>
#include <string.h>

/*#include <math.h>*/

//#define DEBUG   1

//x'y 
complex double dotProd(complex double *x, complex double *y, int order)
{
	int ii;
	complex double temp;

	temp = 0.0;
	for(ii=0;ii<order;ii++)
	{
		temp += x[ii]*y[ii];
	}
	
	return temp;
}

// y = A*x where A is nxn matrix and x is nx1 vector 
void multmatvecR(complex double **A, complex double *x, complex double *y, int order)
{
	int ii;

	for(ii=0; ii<order; ii++)
	{
		y[ii] = dotProd(*(A+ii), x, order);
	}
}

// y = x'A where A is nxn matrix and x is nx1 vector 
void multmatvecL(complex double **A, complex double *x, complex double *y, int order)
{
	int ii,jj;
	complex double *Acol; 

	Acol = malloc(order * sizeof(complex double));

	//printf("Acol:\n");
	for(ii=0; ii<order; ii++)
	{
		for(jj=0; jj<order; jj++)
		{
			Acol[jj] = *(*(A+jj)+ii);
			//printf("%0.2f\t", creal(Acol[jj]));
		}
		//printf("\n");

		y[ii] = dotProd(Acol, x, order);
	}
}

complex double sos(complex double *x, int order)
{
	int ii;
	complex double temp;
	temp = 0.0;
	for(ii=0; ii<order; ii++)
	{
		temp += cpow(x[ii],2);
	}

	return csqrt(temp);
}

complex double * conjv(complex double *x, int order)
{
	int ii;

	for(ii=0; ii<order; ii++)
	{
		x[ii] = creal(x[ii]) - cimag(x[ii]) * I;
	}

	return x;
}


void grappa_gfact_calc(double *im_r, double *im_i, double *psi_r, double *psi_i, double *wim_r, double *wim_i, double *gsos, int npixel, int ncoil)
{

complex double *p_vect;/*vector of sensitivity map pixel across coils*/
complex double **psi, **wim;	/*Make psi a complex double*/
complex double *temp_vect1, *temp_vect2, *temp_vect3; 
complex double SNR_sos_temp, SNR_b1_temp, im_b1_temp, gsos_temp;
complex double sos_vect; 
int ii, jj, kk;

gsos_temp = 0; 

p_vect = malloc(ncoil * sizeof(complex double));
temp_vect1 = malloc(ncoil* sizeof(complex double));
temp_vect2 = malloc(ncoil* sizeof(complex double));
temp_vect3 = malloc(ncoil* sizeof(complex double));

/*Generate Complex psi matrix*/
psi = malloc(ncoil * sizeof(complex double*));
for(ii=0;ii<ncoil;ii++)
{
	//printf("loop %d\n", ii);
	*(psi+ii) = malloc(ncoil * sizeof(complex double));
}

/*Generate Complex Wim matrix*/
wim = malloc(ncoil * sizeof(complex double*));
for(ii=0;ii<ncoil;ii++)
{
	//printf("loop %d\n", ii);
	*(wim+ii) = malloc(ncoil * sizeof(complex double));
}

//printf("psi_real=\n");
for(ii=0;ii<ncoil;ii++)
{
	for (jj=0;jj<ncoil;jj++)
	{	
		//printf("%0.2f\t", *(psi_r+ii+jj*ncoil));
		//printf("%0.2f\t", psi_r[ii+jj*ncoil]);
		*(*(psi+ii)+jj) = *(psi_r+ii+jj*ncoil) + *(psi_i+ii+jj*ncoil) * I;
		//*(*(psi+ii)+jj) = jj*1.0+ii*1.0*I;
	}
	//printf("\n");
}

/* Start looping for each pixel */
for(ii=0; ii<npixel; ii++)
{
	/*initialize b_vect and p_vect*/
	for (jj=0; jj<ncoil; jj++)
	{
		*(p_vect+jj) = im_r[ii+jj*npixel] + im_i[ii+jj*npixel] * I;	
	}

	/* Extract Current Wim grappa weights */
	//printf("wim=\n");
	for(jj=0;jj<ncoil;jj++)
	{
		for (kk=0;kk<ncoil;kk++)
		{	
		//	printf("%0.2f\t", wim_r[jj+kk*ncoil+ii*ncoil*ncoil]);
			*(*(wim+jj)+kk) = *(wim_r+jj+kk*ncoil+ii*ncoil*ncoil) + *(wim_i+jj+kk*ncoil+ii*ncoil*ncoil) * I;
		}
	//printf("\n");
	}


	// Calculate gsos

	// p = im(ii,jj,:)./im_sos(ii,jj);
    // p = p(:);
    // gsos(ii,jj) = sqrt(abs((p'*W)*sig*(p'*W)'))/...
    // sqrt(abs((p'*eye(Nc))*sig*(p'*eye(Nc))'));

	// Normalize p_vect by sos of p_vect



	sos_vect = sos(p_vect, ncoil);
	for (jj=0; jj<ncoil; jj++)
	{
		p_vect[jj] = p_vect[jj]/sos_vect;
	}

	multmatvecL(wim, conjv(p_vect,ncoil), temp_vect1, ncoil); 			//p'*W
	multmatvecL(psi, temp_vect1, temp_vect2, ncoil);		//(p'*W)*sig
	multmatvecL(psi, p_vect, temp_vect3, ncoil);			//p'*sig (here, p_vect is still conjugated by first conj operator)


	gsos_temp = csqrt(cabs(dotProd(temp_vect2, conjv(temp_vect1, ncoil), ncoil))) / (csqrt(cabs(dotProd(temp_vect3, conjv(p_vect, ncoil), ncoil))));
	*(gsos+ii) = creal(gsos_temp);


	//printf("im_b1_real[ii] = %0.3f\t", im_b1_r[ii]);
	//printf("im_B1_imag[ii] = %0.3f\n", im_b1_i[ii]);
}

free(temp_vect1);
free(temp_vect2);
free(temp_vect3);
free(p_vect);


/*DON'T KNOW WHY MEX FREEZES WHEN I FREE PSI!!!???*/
for(ii=0;ii<ncoil;ii++)
{
	free(psi[ii]);
}
free(psi);

}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
/*Input Arrays*/
double *im_r;		/*image real*/
double *im_i;		/*image imaginary*/
double *psi_r;	    /*Inverse Coil-Covariance Matrix real*/
double *psi_i;		/*Inverse Coil-Covariance Matrix imaginary*/
double *wim_r;		/*Grappa Image Weight Matrix real*/
double *wim_i;		/*Grappa Image Weight Matrix imaginary */

/* Output Arrays */
double *gsos;   	/*Roemer b1 coil combination real*/

int *outsize; 

int ntot; 	  /*Number of elements in image*/
int npixel;   /* Number of pixels in image */
int ncoil;   /* Number of coils */

int ndim; 

int ii;
int jj;

#ifdef DEBUG
  printf("---------------------------------------\n");
  printf("Getting Inputs\n");
  printf("---------------------------------------\n\n");
#endif

npixel = mxGetM(prhs[0]);   /*Number of pixels*/
ncoil =  mxGetN(prhs[0]);	/*Number of coils*/
ntot = npixel*ncoil;

#ifdef DEBUG
  printf("%d total number of Image Data, with %d pixels and %d coils\n",ntot, npixel, ncoil);
#endif

/* ====================== Image =========================*/

if (mxIsComplex(prhs[0]))
{
	im_r = mxGetPr(prhs[0]); // Real 
	im_i = mxGetPi(prhs[0]);  // Imag
}
else
{
	im_r = mxGetPr(prhs[0]);
	im_i = (double *)malloc(ntot * sizeof(double));
	for (ii=0; ii < ntot; ii++)
		im_i[ii]=0.0;
}

#ifdef DEBUG
  printf("image Done.\n");
#endif

/* ======================= Noise Covariance  ========================= */

if (mxIsComplex(prhs[1]))
{
	psi_r = mxGetPr(prhs[1]); //Real
	psi_i = mxGetPi(prhs[1]); //Imag
}
else
{
	psi_r = mxGetPr(prhs[1]);
	psi_i = (double *)malloc(ncoil*ncoil * sizeof(double));

	for (ii=0; ii < ncoil*ncoil; ii++)
		psi_i[ii]=0.0;
}

#ifdef DEBUG
  printf("Coil Covariance Matrix\n");
#endif

if ( mxGetM(prhs[1]) != mxGetN(prhs[1]) )
{
 mexErrMsgIdAndTxt("MyProg:DimensionMismatch",
           "Coil Covariance Matrix Must Be Square");
}

/* ======================= Weight Image Covariance  ========================= */

if (mxIsComplex(prhs[2]))
{
	wim_r = mxGetPr(prhs[2]); //Real
	wim_i = mxGetPi(prhs[2]); //Imag
}
else
{
	wim_r = mxGetPr(prhs[2]);
	wim_i = (double *)malloc(ncoil*ncoil*ntot * sizeof(double));

	for (ii=0; ii < ncoil*ncoil*ntot; ii++)
		wim_i[ii]=0.0;
}

#ifdef DEBUG
  printf("GRAPPA Image-domain Weight Matrix .\n");
#endif

if ( mxGetM(prhs[2]) != mxGetN(prhs[0]) )
{
 mexErrMsgIdAndTxt("MyProg:DimensionMismatch",
           "weight matrix must have same number of coils as grappa images");
}



/* ======================= Output Size for images  ========================= */


ndim = (int)fmax((float)mxGetM(prhs[3]), (float)mxGetN(prhs[3]));
outsize = malloc(ndim * sizeof(int));

for(ii=0; ii<ndim; ii++)
	outsize[ii] = (int)( *( (double *)(mxGetData(prhs[3]) + ii*sizeof(double)) ) );

/*============== Run SNR Calculation ===============================   */

gsos = malloc(npixel*sizeof(double));
// for(ii=0; ii<npixel; ii++)
// 	gsos[ii] = 0;

#ifdef DEBUG
  printf("Calling SNR_Calc() function in Mex file.\n");
#endif

grappa_gfact_calc(im_r,im_i,psi_r,psi_i,wim_r, wim_i,gsos,npixel,ncoil);

/* ============= Allocate Output SNR maps ==========================.	*/


/*TJ added ntnfnposnvel entries*/
plhs[0] = mxCreateDoubleMatrix(npixel,1,mxREAL);	/* gsos, output. */

memcpy(mxGetPr(plhs[0]), gsos, npixel * sizeof(double));

/* ======= Reshape Output Matrices ====== */

mxSetDimensions(plhs[0],outsize,ndim); 


/* ====== Free up allocated memory, if necessary. ===== */

free(outsize);
if (!mxIsComplex(prhs[0]))
	free(im_i);
if (!mxIsComplex(prhs[1]))
	free(psi_i);
if (!mxIsComplex(prhs[2]))
	free(wim_i);


}