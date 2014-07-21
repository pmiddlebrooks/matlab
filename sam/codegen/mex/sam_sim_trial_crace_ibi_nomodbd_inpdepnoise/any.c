/*
 * any.c
 *
 * Code generation for function 'any'
 *
 * C source code generated on: Wed Oct 30 11:46:27 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sam_sim_trial_crace_ibi_nomodbd_inpdepnoise.h"
#include "any.h"
#include "sam_sim_trial_crace_ibi_nomodbd_inpdepnoise_emxutil.h"
#include "sam_sim_trial_crace_ibi_nomodbd_inpdepnoise_data.h"

/* Variable Definitions */
static emlrtRSInfo m_emlrtRSI = { 15, "any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/any.m" };

static emlrtRSInfo n_emlrtRSI = { 105, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtRTEInfo c_emlrtRTEI = { 1, 14, "any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/any.m" };

/* Function Definitions */

/*
 *
 */
void any(const emxArray_boolean_T *x, emxArray_boolean_T *y)
{
  uint32_T outsize[2];
  int32_T iy;
  int32_T i1;
  int32_T i2;
  boolean_T overflow;
  int32_T j;
  int32_T ix;
  boolean_T exitg1;
  emlrtPushRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
  for (iy = 0; iy < 2; iy++) {
    outsize[iy] = (uint32_T)x->size[iy];
  }

  iy = y->size[0];
  y->size[0] = (int32_T)outsize[0];
  emxEnsureCapacity((emxArray__common *)y, iy, (int32_T)sizeof(boolean_T),
                    &c_emlrtRTEI);
  i1 = (int32_T)outsize[0];
  for (iy = 0; iy < i1; iy++) {
    y->data[iy] = FALSE;
  }

  iy = -1;
  i1 = 0;
  i2 = (x->size[1] - 1) * x->size[0];
  emlrtPushRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
  if (1 > x->size[0]) {
    overflow = FALSE;
  } else {
    overflow = (x->size[0] > 2147483646);
  }

  if (overflow) {
    emlrtPushRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
    check_forloop_overflow_error(TRUE);
    emlrtPopRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
  }

  emlrtPopRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
  for (j = 1; j <= x->size[0]; j++) {
    i1++;
    i2++;
    iy++;
    emlrtPushRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
    if ((x->size[0] == 0) || ((x->size[0] > 0) && (i1 > i2))) {
      overflow = FALSE;
    } else if (x->size[0] > 0) {
      overflow = (i2 > MAX_int32_T - x->size[0]);
    } else {
      overflow = (i2 < MIN_int32_T - x->size[0]);
    }

    if (overflow) {
      emlrtPushRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
      check_forloop_overflow_error(TRUE);
      emlrtPopRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
    }

    emlrtPopRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
    ix = i1;
    exitg1 = FALSE;
    while ((exitg1 == FALSE) && ((x->size[0] > 0) && (ix <= i2))) {
      overflow = (x->data[ix - 1] == 0);
      if (!overflow) {
        y->data[iy] = TRUE;
        exitg1 = TRUE;
      } else {
        ix += x->size[0];
      }
    }
  }

  emlrtPopRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
}

/* End of code generation (any.c) */
