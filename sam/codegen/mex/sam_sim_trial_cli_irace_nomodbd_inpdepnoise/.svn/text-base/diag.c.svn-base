/*
 * diag.c
 *
 * Code generation for function 'diag'
 *
 * C source code generated on: Wed Oct 30 11:46:50 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sam_sim_trial_cli_irace_nomodbd_inpdepnoise.h"
#include "diag.h"
#include "sam_sim_trial_cli_irace_nomodbd_inpdepnoise_emxutil.h"
#include "sam_sim_trial_cli_irace_nomodbd_inpdepnoise_data.h"

/* Variable Definitions */
static emlrtRSInfo hb_emlrtRSI = { 46, "diag",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/elmat/diag.m" };

static emlrtRTEInfo b_emlrtRTEI = { 1, 14, "diag",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/elmat/diag.m" };

/* Function Definitions */

/*
 *
 */
void diag(const emxArray_boolean_T *v, emxArray_boolean_T *d)
{
  int32_T unnamed_idx_0;
  int32_T unnamed_idx_1;
  int32_T i0;
  boolean_T overflow;
  unnamed_idx_0 = v->size[0];
  unnamed_idx_1 = v->size[0];
  i0 = d->size[0] * d->size[1];
  d->size[0] = unnamed_idx_0;
  emxEnsureCapacity((emxArray__common *)d, i0, (int32_T)sizeof(boolean_T),
                    &b_emlrtRTEI);
  i0 = d->size[0] * d->size[1];
  d->size[1] = unnamed_idx_1;
  emxEnsureCapacity((emxArray__common *)d, i0, (int32_T)sizeof(boolean_T),
                    &b_emlrtRTEI);
  unnamed_idx_0 *= unnamed_idx_1;
  for (i0 = 0; i0 < unnamed_idx_0; i0++) {
    d->data[i0] = FALSE;
  }

  emlrtPushRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
  if (1 > v->size[0]) {
    overflow = FALSE;
  } else {
    overflow = (v->size[0] > 2147483646);
  }

  if (overflow) {
    emlrtPushRtStackR2012b(&r_emlrtRSI, emlrtRootTLSGlobal);
    check_forloop_overflow_error(TRUE);
    emlrtPopRtStackR2012b(&r_emlrtRSI, emlrtRootTLSGlobal);
  }

  emlrtPopRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
  for (unnamed_idx_0 = 0; unnamed_idx_0 + 1 <= v->size[0]; unnamed_idx_0++) {
    d->data[unnamed_idx_0 + d->size[0] * unnamed_idx_0] = v->data[unnamed_idx_0];
  }
}

/* End of code generation (diag.c) */
