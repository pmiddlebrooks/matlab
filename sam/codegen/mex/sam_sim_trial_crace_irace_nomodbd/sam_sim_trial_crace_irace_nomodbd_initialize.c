/*
 * sam_sim_trial_crace_irace_nomodbd_initialize.c
 *
 * Code generation for function 'sam_sim_trial_crace_irace_nomodbd_initialize'
 *
 * C source code generated on: Fri Jan 31 22:28:44 2014
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sam_sim_trial_crace_irace_nomodbd.h"
#include "sam_sim_trial_crace_irace_nomodbd_initialize.h"
#include "sam_sim_trial_crace_irace_nomodbd_data.h"

/* Function Definitions */
void sam_sim_trial_crace_irace_nomodbd_initialize(emlrtContext *aContext)
{
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, aContext, NULL, 1);
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, FALSE, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (sam_sim_trial_crace_irace_nomodbd_initialize.c) */
