/*
 * sam_sim_trial_cli_ili_nomodbd_terminate.c
 *
 * Code generation for function 'sam_sim_trial_cli_ili_nomodbd_terminate'
 *
 * C source code generated on: Wed Oct 30 11:46:18 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sam_sim_trial_cli_ili_nomodbd.h"
#include "sam_sim_trial_cli_ili_nomodbd_terminate.h"

/* Function Definitions */
void sam_sim_trial_cli_ili_nomodbd_atexit(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void sam_sim_trial_cli_ili_nomodbd_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (sam_sim_trial_cli_ili_nomodbd_terminate.c) */
