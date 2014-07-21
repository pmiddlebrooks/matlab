/*
 * sam_sim_trial_cffi_ili_nomodbd_mex.c
 *
 * Code generation for function 'sam_sim_trial_cffi_ili_nomodbd'
 *
 * C source code generated on: Wed Oct 30 11:46:04 2013
 *
 */

/* Include files */
#include "mex.h"
#include "sam_sim_trial_cffi_ili_nomodbd_api.h"
#include "sam_sim_trial_cffi_ili_nomodbd_initialize.h"
#include "sam_sim_trial_cffi_ili_nomodbd_terminate.h"

/* Function Declarations */
static void sam_sim_trial_cffi_ili_nomodbd_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);
MEXFUNCTION_LINKAGE mxArray *emlrtMexFcnProperties(void);

/* Variable Definitions */
emlrtContext emlrtContextGlobal = { true, false, EMLRT_VERSION_INFO, NULL, "sam_sim_trial_cffi_ili_nomodbd", NULL, false, {2045744189U,2170104910U,2743257031U,4284093946U}, NULL };
emlrtCTX emlrtRootTLSGlobal = NULL;

/* Function Definitions */
static void sam_sim_trial_cffi_ili_nomodbd_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  mxArray *outputs[3];
  mxArray *inputs[22];
  int n = 0;
  int nOutputs = (nlhs < 1 ? 1 : nlhs);
  int nInputs = nrhs;
  /* Module initialization. */
  sam_sim_trial_cffi_ili_nomodbd_initialize(&emlrtContextGlobal);
  /* Check for proper number of arguments. */
  if (nrhs != 22) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs", 5, mxINT32_CLASS, 22, mxCHAR_CLASS, 30, "sam_sim_trial_cffi_ili_nomodbd");
  } else if (nlhs > 3) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:TooManyOutputArguments", 3, mxCHAR_CLASS, 30, "sam_sim_trial_cffi_ili_nomodbd");
  }
  /* Temporary copy for mex inputs. */
  for (n = 0; n < nInputs; ++n) {
    inputs[n] = (mxArray *)prhs[n];
  }
  /* Call the function. */
  sam_sim_trial_cffi_ili_nomodbd_api((const mxArray**)inputs, (const mxArray**)outputs);
  /* Copy over outputs to the caller. */
  for (n = 0; n < nOutputs; ++n) {
    plhs[n] = emlrtReturnArrayR2009a(outputs[n]);
  }
  /* Module finalization. */
  sam_sim_trial_cffi_ili_nomodbd_terminate();
}

void sam_sim_trial_cffi_ili_nomodbd_atexit_wrapper(void)
{
   sam_sim_trial_cffi_ili_nomodbd_atexit();
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(sam_sim_trial_cffi_ili_nomodbd_atexit_wrapper);
  /* Dispatch the entry-point. */
  sam_sim_trial_cffi_ili_nomodbd_mexFunction(nlhs, plhs, nrhs, prhs);
}

mxArray *emlrtMexFcnProperties(void)
{
  const char *mexProperties[] = {
    "Version",
    "ResolvedFunctions",
    "EntryPoints"};
  const char *epProperties[] = {
    "Name",
    "NumberOfInputs",
    "NumberOfOutputs",
    "ConstantInputs"};
  mxArray *xResult = mxCreateStructMatrix(1,1,3,mexProperties);
  mxArray *xEntryPoints = mxCreateStructMatrix(1,1,4,epProperties);
  mxArray *xInputs = NULL;
  xInputs = mxCreateLogicalMatrix(1, 22);
  mxSetFieldByNumber(xEntryPoints, 0, 0, mxCreateString("sam_sim_trial_cffi_ili_nomodbd"));
  mxSetFieldByNumber(xEntryPoints, 0, 1, mxCreateDoubleScalar(22));
  mxSetFieldByNumber(xEntryPoints, 0, 2, mxCreateDoubleScalar(3));
  mxSetFieldByNumber(xEntryPoints, 0, 3, xInputs);
  mxSetFieldByNumber(xResult, 0, 0, mxCreateString("8.1.0.604 (R2013a)"));
  mxSetFieldByNumber(xResult, 0, 1, (mxArray*)emlrtMexFcnResolvedFunctionsInfo());
  mxSetFieldByNumber(xResult, 0, 2, xEntryPoints);

  return xResult;
}
/* End of code generation (sam_sim_trial_cffi_ili_nomodbd_mex.c) */
