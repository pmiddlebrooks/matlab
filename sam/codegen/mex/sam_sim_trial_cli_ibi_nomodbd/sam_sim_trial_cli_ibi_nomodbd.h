/*
 * sam_sim_trial_cli_ibi_nomodbd.h
 *
 * Code generation for function 'sam_sim_trial_cli_ibi_nomodbd'
 *
 * C source code generated on: Wed Oct 30 11:46:13 2013
 *
 */

#ifndef __SAM_SIM_TRIAL_CLI_IBI_NOMODBD_H__
#define __SAM_SIM_TRIAL_CLI_IBI_NOMODBD_H__
/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"

#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "sam_sim_trial_cli_ibi_nomodbd_types.h"

/* Function Declarations */
extern void check_forloop_overflow_error(boolean_T overflow);
extern void sam_sim_trial_cli_ibi_nomodbd(emxArray_real_T *u, const emxArray_real_T *A, const emxArray_real_T *unusedU0, const emxArray_real_T *C, const emxArray_real_T *unusedU1, const emxArray_real_T *SI, const emxArray_real_T *Z0, const emxArray_real_T *ZC, const emxArray_real_T *ZLB, real_T dt, real_T tau, const emxArray_real_T *T, const emxArray_boolean_T *terminate, const emxArray_boolean_T *blockInput, const emxArray_boolean_T *unusedU2, real_T n, real_T unusedU3, real_T p, real_T t, emxArray_real_T *rt, emxArray_boolean_T *resp, emxArray_real_T *z);
#endif
/* End of code generation (sam_sim_trial_cli_ibi_nomodbd.h) */
