/*
 * sam_sim_trial_crace_irace_nomodbd_terminate.c
 *
 * Code generation for function 'sam_sim_trial_crace_irace_nomodbd_terminate'
 *
 * C source code generated on: Fri Jan 31 22:28:44 2014
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sam_sim_trial_crace_irace_nomodbd.h"
#include "sam_sim_trial_crace_irace_nomodbd_terminate.h"

/* Function Definitions */
void sam_sim_trial_crace_irace_nomodbd_atexit(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void sam_sim_trial_crace_irace_nomodbd_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (sam_sim_trial_crace_irace_nomodbd_terminate.c) */