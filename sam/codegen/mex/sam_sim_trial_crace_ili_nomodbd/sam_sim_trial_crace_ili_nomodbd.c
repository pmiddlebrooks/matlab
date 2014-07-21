/*
 * sam_sim_trial_crace_ili_nomodbd.c
 *
 * Code generation for function 'sam_sim_trial_crace_ili_nomodbd'
 *
 * C source code generated on: Wed Oct 30 11:45:50 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sam_sim_trial_crace_ili_nomodbd.h"
#include "sam_sim_trial_crace_ili_nomodbd_emxutil.h"
#include "sam_sim_trial_crace_ili_nomodbd_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 88, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRSInfo b_emlrtRSI = { 96, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRSInfo c_emlrtRSI = { 106, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRSInfo d_emlrtRSI = { 110, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRSInfo e_emlrtRSI = { 114, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRSInfo f_emlrtRSI = { 118, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRSInfo g_emlrtRSI = { 11, "eml_li_find",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo h_emlrtRSI = { 14, "eml_li_find",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo i_emlrtRSI = { 26, "eml_li_find",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo j_emlrtRSI = { 39, "eml_li_find",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo k_emlrtRSI = { 12, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtRSInfo l_emlrtRSI = { 51, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtRSInfo m_emlrtRSI = { 55, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtRSInfo n_emlrtRSI = { 21, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtRSInfo o_emlrtRSI = { 84, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtRSInfo p_emlrtRSI = { 89, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtRSInfo q_emlrtRSI = { 54, "eml_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/eml_xgemm.m"
};

static emlrtRSInfo s_emlrtRSI = { 32, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo y_emlrtRSI = { 110, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo ab_emlrtRSI = { 111, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo bb_emlrtRSI = { 112, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo cb_emlrtRSI = { 113, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo db_emlrtRSI = { 114, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo eb_emlrtRSI = { 115, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo fb_emlrtRSI = { 119, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo gb_emlrtRSI = { 122, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo hb_emlrtRSI = { 125, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo ib_emlrtRSI = { 128, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo jb_emlrtRSI = { 131, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo kb_emlrtRSI = { 134, "eml_blas_xgemm",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m"
};

static emlrtRSInfo lb_emlrtRSI = { 14, "eml_c_cast",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/blas/external/eml_c_cast.m"
};

static emlrtRSInfo mb_emlrtRSI = { 88, "randn",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/randfun/randn.m" };

static emlrtRSInfo nb_emlrtRSI = { 14, "sqrt",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/elfun/sqrt.m" };

static emlrtRSInfo ob_emlrtRSI = { 20, "eml_error",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_error.m" };

static emlrtRSInfo pb_emlrtRSI = { 12, "any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/any.m" };

static emlrtRSInfo qb_emlrtRSI = { 24, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtRSInfo rb_emlrtRSI = { 27, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtRSInfo sb_emlrtRSI = { 109, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtMCInfo emlrtMCI = { 14, 5, "eml_li_find",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtMCInfo b_emlrtMCI = { 52, 9, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtMCInfo c_emlrtMCI = { 51, 15, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtMCInfo d_emlrtMCI = { 85, 13, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtMCInfo e_emlrtMCI = { 84, 23, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtMCInfo f_emlrtMCI = { 90, 13, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtMCInfo g_emlrtMCI = { 89, 23, "mtimes",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/ops/mtimes.m" };

static emlrtMCInfo h_emlrtMCI = { 88, 9, "randn",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/randfun/randn.m" };

static emlrtMCInfo i_emlrtMCI = { 25, 9, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtMCInfo j_emlrtMCI = { 24, 19, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtMCInfo k_emlrtMCI = { 30, 9, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtMCInfo l_emlrtMCI = { 27, 19, "eml_all_or_any",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_all_or_any.m"
};

static emlrtRTEInfo emlrtRTEI = { 1, 24, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRTEInfo b_emlrtRTEI = { 20, 9, "eml_li_find",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRTEInfo d_emlrtRTEI = { 66, 3, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRTEInfo e_emlrtRTEI = { 96, 3, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtRTEInfo f_emlrtRTEI = { 20, 5, "eml_error",
  "/Applications/MATLAB_R2013a.app/toolbox/eml/lib/matlab/eml/eml_error.m" };

static emlrtECInfo emlrtECI = { -1, 114, 6, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtECInfo b_emlrtECI = { -1, 110, 8, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo emlrtBCI = { -1, -1, 110, 12, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtECInfo c_emlrtECI = { -1, 106, 3, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo b_emlrtBCI = { -1, -1, 106, 20, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtECInfo d_emlrtECI = { -1, 106, 5, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo c_emlrtBCI = { -1, -1, 106, 9, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtECInfo e_emlrtECI = { -1, 106, 31, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo d_emlrtBCI = { -1, -1, 106, 35, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtECInfo f_emlrtECI = { -1, 102, 3, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo e_emlrtBCI = { -1, -1, 102, 7, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtECInfo g_emlrtECI = { -1, 102, 14, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo f_emlrtBCI = { -1, -1, 102, 18, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtECInfo h_emlrtECI = { -1, 96, 10, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo g_emlrtBCI = { -1, -1, 97, 25, "u",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo h_emlrtBCI = { -1, -1, 96, 19, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtDCInfo emlrtDCI = { 96, 19, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 1 };

static emlrtECInfo i_emlrtECI = { -1, 54, 1, "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m" };

static emlrtBCInfo i_emlrtBCI = { -1, -1, 54, 5, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo j_emlrtBCI = { -1, -1, 88, 17, "latInhib",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo k_emlrtBCI = { -1, -1, 88, 3, "At",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo l_emlrtBCI = { -1, -1, 106, 5, "z",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo m_emlrtBCI = { -1, -1, 106, 27, "ZLB",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo n_emlrtBCI = { -1, -1, 110, 3, "resp",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo o_emlrtBCI = { -1, -1, 114, 3, "rt",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo p_emlrtBCI = { -1, -1, 114, 26, "T",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

static emlrtBCInfo q_emlrtBCI = { -1, -1, 118, 10, "terminate",
  "sam_sim_trial_crace_ili_nomodbd",
  "/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_crace_ili_nomodbd.m", 0 };

/* Function Declarations */
static void b_eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y);
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static const mxArray *b_message(const mxArray *b, emlrtMCInfo *location);
static void check_forloop_overflow_error(boolean_T overflow);
static void eml_error(void);
static void eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y);
static void emlrt_marshallIn(const mxArray *b_randn, const char_T *identifier,
  emxArray_real_T *y);
static void error(const mxArray *b, emlrtMCInfo *location);
static const mxArray *message(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location);
static const mxArray *randn(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location);
static void s_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);

/* Function Definitions */

/*
 *
 */
static void b_eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y)
{
  int32_T n;
  int32_T k;
  boolean_T b0;
  int32_T i;
  const mxArray *b_y;
  const mxArray *m2;
  int32_T j;
  n = x->size[0] * x->size[1];
  emlrtPushRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  k = 0;
  emlrtPushRtStackR2012b(&j_emlrtRSI, emlrtRootTLSGlobal);
  if (1 > n) {
    b0 = FALSE;
  } else {
    b0 = (n > 2147483646);
  }

  if (b0) {
    emlrtPushRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
    check_forloop_overflow_error(TRUE);
    emlrtPopRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
  }

  emlrtPopRtStackR2012b(&j_emlrtRSI, emlrtRootTLSGlobal);
  for (i = 1; i <= n; i++) {
    if (x->data[i - 1]) {
      k++;
    }
  }

  emlrtPopRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  if (k <= n) {
  } else {
    emlrtPushRtStackR2012b(&h_emlrtRSI, emlrtRootTLSGlobal);
    b_y = NULL;
    m2 = mxCreateString("Assertion failed.");
    emlrtAssign(&b_y, m2);
    error(b_y, &emlrtMCI);
    emlrtPopRtStackR2012b(&h_emlrtRSI, emlrtRootTLSGlobal);
  }

  j = y->size[0];
  y->size[0] = k;
  emxEnsureCapacity((emxArray__common *)y, j, (int32_T)sizeof(int32_T),
                    &b_emlrtRTEI);
  j = 0;
  emlrtPushRtStackR2012b(&i_emlrtRSI, emlrtRootTLSGlobal);
  emlrtPopRtStackR2012b(&i_emlrtRSI, emlrtRootTLSGlobal);
  for (i = 1; i <= n; i++) {
    if (x->data[i - 1]) {
      y->data[j] = i;
      j++;
    }
  }
}

static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  s_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_message(const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  const mxArray *m5;
  pArray = b;
  return emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 1, &m5, 1, &pArray, "message",
    TRUE, location);
}

/*
 *
 */
static void check_forloop_overflow_error(boolean_T overflow)
{
  const mxArray *y;
  static const int32_T iv0[2] = { 1, 34 };

  const mxArray *m1;
  char_T cv0[34];
  int32_T i;
  static const char_T cv1[34] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o',
    'l', 'b', 'o', 'x', ':', 'i', 'n', 't', '_', 'f', 'o', 'r', 'l', 'o', 'o',
    'p', '_', 'o', 'v', 'e', 'r', 'f', 'l', 'o', 'w' };

  const mxArray *b_y;
  static const int32_T iv1[2] = { 1, 23 };

  char_T cv2[23];
  static const char_T cv3[23] = { 'c', 'o', 'd', 'e', 'r', '.', 'i', 'n', 't',
    'e', 'r', 'n', 'a', 'l', '.', 'i', 'n', 'd', 'e', 'x', 'I', 'n', 't' };

  if (!overflow) {
  } else {
    emlrtPushRtStackR2012b(&l_emlrtRSI, emlrtRootTLSGlobal);
    y = NULL;
    m1 = mxCreateCharArray(2, iv0);
    for (i = 0; i < 34; i++) {
      cv0[i] = cv1[i];
    }

    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 34, m1, cv0);
    emlrtAssign(&y, m1);
    b_y = NULL;
    m1 = mxCreateCharArray(2, iv1);
    for (i = 0; i < 23; i++) {
      cv2[i] = cv3[i];
    }

    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 23, m1, cv2);
    emlrtAssign(&b_y, m1);
    error(message(y, b_y, &b_emlrtMCI), &c_emlrtMCI);
    emlrtPopRtStackR2012b(&l_emlrtRSI, emlrtRootTLSGlobal);
  }
}

/*
 *
 */
static void eml_error(void)
{
  static char_T cv4[4][1] = { { 's' }, { 'q' }, { 'r' }, { 't' } };

  emlrtPushRtStackR2012b(&ob_emlrtRSI, emlrtRootTLSGlobal);
  emlrtErrorWithMessageIdR2012b(emlrtRootTLSGlobal, &f_emlrtRTEI,
    "Coder:toolbox:ElFunDomainError", 3, 4, 4, cv4);
  emlrtPopRtStackR2012b(&ob_emlrtRSI, emlrtRootTLSGlobal);
}

/*
 *
 */
static void eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y)
{
  int32_T k;
  boolean_T overflow;
  int32_T i;
  const mxArray *b_y;
  const mxArray *m0;
  int32_T j;
  emlrtPushRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  k = 0;
  emlrtPushRtStackR2012b(&j_emlrtRSI, emlrtRootTLSGlobal);
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

  emlrtPopRtStackR2012b(&j_emlrtRSI, emlrtRootTLSGlobal);
  for (i = 1; i <= x->size[0]; i++) {
    if (x->data[i - 1]) {
      k++;
    }
  }

  emlrtPopRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  if (k <= x->size[0]) {
  } else {
    emlrtPushRtStackR2012b(&h_emlrtRSI, emlrtRootTLSGlobal);
    b_y = NULL;
    m0 = mxCreateString("Assertion failed.");
    emlrtAssign(&b_y, m0);
    error(b_y, &emlrtMCI);
    emlrtPopRtStackR2012b(&h_emlrtRSI, emlrtRootTLSGlobal);
  }

  j = y->size[0];
  y->size[0] = k;
  emxEnsureCapacity((emxArray__common *)y, j, (int32_T)sizeof(int32_T),
                    &b_emlrtRTEI);
  j = 0;
  emlrtPushRtStackR2012b(&i_emlrtRSI, emlrtRootTLSGlobal);
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

  emlrtPopRtStackR2012b(&i_emlrtRSI, emlrtRootTLSGlobal);
  for (i = 1; i <= x->size[0]; i++) {
    if (x->data[i - 1]) {
      y->data[j] = i;
      j++;
    }
  }
}

static void emlrt_marshallIn(const mxArray *b_randn, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  b_emlrt_marshallIn(emlrtAlias(b_randn), &thisId, y);
  emlrtDestroyArray(&b_randn);
}

static void error(const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 0, NULL, 1, &pArray, "error", TRUE,
                        location);
}

static const mxArray *message(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location)
{
  const mxArray *pArrays[2];
  const mxArray *m4;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 1, &m4, 2, pArrays, "message",
    TRUE, location);
}

static const mxArray *randn(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location)
{
  const mxArray *pArrays[2];
  const mxArray *m6;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 1, &m6, 2, pArrays, "randn",
    TRUE, location);
}

static void s_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv3[1];
  boolean_T bv0[1];
  int32_T iv4[1];
  int32_T i0;
  iv3[0] = -1;
  bv0[0] = TRUE;
  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 1U,
    iv3, bv0, iv4);
  i0 = ret->size[0];
  ret->size[0] = iv4[0];
  emxEnsureCapacity((emxArray__common *)ret, i0, (int32_T)sizeof(real_T),
                    (emlrtRTEInfo *)NULL);
  emlrtImportArrayR2011b(src, ret->data, 8, FALSE);
  emlrtDestroyArray(&src);
}

/*
 * function [rt,resp,z] = sam_sim_trial_crace_ili_nomodbd(u,A,~,C,~,SI, ...
 *                                                          Z0,ZC,ZLB,dt, ...
 *                                                          tau,T, ...
 *                                                          terminate,~,latInhib, ...
 *                                                          n,~,p,t, ...
 *                                                          rt,resp, ...
 *                                                          z)
 */
void sam_sim_trial_crace_ili_nomodbd(const emxArray_real_T *u, const
  emxArray_real_T *A, const emxArray_real_T *unusedU0, const emxArray_real_T *C,
  const emxArray_real_T *unusedU1, const emxArray_real_T *SI, const
  emxArray_real_T *Z0, const emxArray_real_T *ZC, const emxArray_real_T *ZLB,
  real_T dt, real_T tau, const emxArray_real_T *T, const emxArray_boolean_T
  *terminate, const emxArray_boolean_T *unusedU2, const emxArray_boolean_T
  *latInhib, real_T n, real_T unusedU3, real_T p, real_T t, emxArray_real_T *rt,
  emxArray_boolean_T *resp, emxArray_real_T *z)
{
  emxArray_int32_T *r1;
  int32_T loop_ub;
  int32_T i4;
  emxArray_int32_T *r2;
  int32_T iv19[1];
  int32_T i;
  emxArray_real_T *At;
  emxArray_real_T *dzdt;
  emxArray_int32_T *r3;
  emxArray_real_T *b;
  emxArray_real_T *y;
  emxArray_real_T *b_y;
  emxArray_boolean_T *x;
  emxArray_boolean_T *b_resp;
  emxArray_boolean_T *b_z;
  emxArray_boolean_T *c_z;
  emxArray_boolean_T *d_z;
  emxArray_boolean_T *b_latInhib;
  emxArray_boolean_T *c_resp;
  emxArray_real_T *e_z;
  emxArray_real_T *b_u;
  emxArray_real_T *f_z;
  emxArray_int32_T *r4;
  emxArray_real_T *g_z;
  emxArray_int32_T *r5;
  emxArray_int32_T *r6;
  emxArray_int32_T *r7;
  boolean_T exitg1;
  int32_T i5;
  int32_T i6;
  int32_T i7;
  boolean_T innerDimOk;
  boolean_T guard4 = FALSE;
  const mxArray *c_y;
  static const int32_T iv20[2] = { 1, 21 };

  const mxArray *m7;
  char_T cv5[21];
  static const char_T cv6[21] = { 'C', 'o', 'd', 'e', 'r', ':', 'M', 'A', 'T',
    'L', 'A', 'B', ':', 'i', 'n', 'n', 'e', 'r', 'd', 'i', 'm' };

  const mxArray *d_y;
  static const int32_T iv21[2] = { 1, 45 };

  char_T cv7[45];
  static const char_T cv8[45] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o',
    'l', 'b', 'o', 'x', ':', 'm', 't', 'i', 'm', 'e', 's', '_', 'n', 'o', 'D',
    'y', 'n', 'a', 'm', 'i', 'c', 'S', 'c', 'a', 'l', 'a', 'r', 'E', 'x', 'p',
    'a', 'n', 's', 'i', 'o', 'n' };

  boolean_T guard3 = FALSE;
  int8_T unnamed_idx_0;
  real_T alpha1;
  real_T beta1;
  char_T TRANSB;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  double * alpha1_t;
  double * Aia0_t;
  double * Bib0_t;
  double * beta1_t;
  double * Cic0_t;
  boolean_T guard2 = FALSE;
  const mxArray *e_y;
  static const int32_T iv22[2] = { 1, 21 };

  const mxArray *f_y;
  static const int32_T iv23[2] = { 1, 45 };

  boolean_T guard1 = FALSE;
  const mxArray *g_y;
  const mxArray *h_y;
  const mxArray *i_y;
  static const int32_T iv24[2] = { 1, 45 };

  const mxArray *j_y;
  static const int32_T iv25[2] = { 1, 21 };

  int32_T iv26[1];
  int32_T h_z[1];
  int32_T iv27[1];
  boolean_T b_p;
  int32_T exitg3;
  const mxArray *k_y;
  static const int32_T iv28[2] = { 1, 41 };

  char_T cv9[41];
  static const char_T cv10[41] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o',
    'l', 'b', 'o', 'x', ':', 'e', 'm', 'l', '_', 'a', 'l', 'l', '_', 'o', 'r',
    '_', 'a', 'n', 'y', '_', 's', 'p', 'e', 'c', 'i', 'a', 'l', 'E', 'm', 'p',
    't', 'y' };

  const mxArray *l_y;
  static const int32_T iv29[2] = { 1, 51 };

  char_T cv11[51];
  static const char_T cv12[51] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o',
    'l', 'b', 'o', 'x', ':', 'e', 'm', 'l', '_', 'a', 'l', 'l', '_', 'o', 'r',
    '_', 'a', 'n', 'y', '_', 'a', 'u', 't', 'o', 'D', 'i', 'm', 'I', 'n', 'c',
    'o', 'm', 'p', 'a', 't', 'i', 'b', 'i', 'l', 'i', 't', 'y' };

  boolean_T exitg2;
  emlrtHeapReferenceStackEnterFcnR2012b(emlrtRootTLSGlobal);
  emxInit_int32_T(&r1, 1, &emlrtRTEI, TRUE);

  /*  Simulate trials: C as a race, I as lateral inhibition, no extr. and intr. modulation */
  /*  */
  /*  DESCRIPTION */
  /*  SAM trial simulation function, modeling choice as a race, inhibition as */
  /*  blocking the input, and excluding extrinisic (B) or intrinisic (D) */
  /*  modulation of connectivity. */
  /*  */
  /*  SYNTAX */
  /*  Let there be M inputs, N units, P time points, then */
  /*  u - inputs to the accumulators (MxP double) */
  /*  A - endogenous connectivity matrix (NxN double) */
  /*  B - extrinsic modulation matrix (NxNxM double) */
  /*  C - exogenous connectivity matrix (NxM double) */
  /*  D - intrinsic modulation matrix (NxNxN double) */
  /*  SI - intrinsic noise strength (MxM double) */
  /*  Z0 - starting value of activation (Nx1 double) */
  /*  ZC - threshold on activation (Nx1 double) */
  /*  ZLB - lower bound on activation (Nx1 double) */
  /*  dt - time step (1x1 double) */
  /*  tau - time scale (1x1 double) */
  /*  T - time points (1xP double) */
  /*  terminate - matrix indicating which units can terminate accumulation of */
  /*  activation when they reach threshold (Nx1 logical) */
  /*  blockInput - matrix indicating which units block which inputs when they */
  /*  reach threshold (Nx1 logical) */
  /*  latInhib - matrix indicating which elements in A remain 0 as long as */
  /*  unit n (indexed by the columns of A) has not reached */
  /*  threshold (indexed by resp) */
  /*  */
  /*  rt - response times (Nx1 double) */
  /*  resp - responses, inid (Nx1 logical) */
  /*  z - activation (NxP double) */
  /*  */
  /*  [rt,resp,z] = SAM_SIM_TRIAL_CRACE_ILI_NOMODBD(u,A,~,C,~,SI,Z0,ZC, ... */
  /*  ZLB,dt,tau,T, ... */
  /*  terminate,~,~ ... */
  /*  n,~,p,t,rt,resp,z); */
  /*  */
  /*  EXAMPLES */
  /*  */
  /*  ......................................................................... */
  /*  Bram Zandbelt, bramzandbelt@gmail.com */
  /*  $Created : Wed 24 Jul 2013 12:14:48 CDT by bram */
  /*  $Modified: Wed 25 Sep 2013 11:00:31 CDT by bram */
  /*  Set starting values of z(t) */
  /* 'sam_sim_trial_crace_ili_nomodbd:54' z(:,1) = Z0; */
  loop_ub = z->size[0];
  i4 = r1->size[0];
  r1->size[0] = loop_ub;
  emxEnsureCapacity((emxArray__common *)r1, i4, (int32_T)sizeof(int32_T),
                    &emlrtRTEI);
  for (i4 = 0; i4 < loop_ub; i4++) {
    r1->data[i4] = i4;
  }

  emxInit_int32_T(&r2, 1, &emlrtRTEI, TRUE);
  i4 = z->size[1];
  emlrtDynamicBoundsCheckFastR2012b(1, 1, i4, &i_emlrtBCI, emlrtRootTLSGlobal);
  iv19[0] = r1->size[0];
  emlrtSubAssignSizeCheckR2012b(iv19, 1, *(int32_T (*)[1])Z0->size, 1,
    &i_emlrtECI, emlrtRootTLSGlobal);
  i4 = r2->size[0];
  r2->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)r2, i4, (int32_T)sizeof(int32_T),
                    &emlrtRTEI);
  loop_ub = r1->size[0];
  for (i4 = 0; i4 < loop_ub; i4++) {
    r2->data[i4] = r1->data[i4];
  }

  i = r1->size[0];
  for (i4 = 0; i4 < i; i4++) {
    z->data[r2->data[i4]] = Z0->data[i4];
  }

  emxFree_int32_T(&r2);

  /*  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /*  1. STOCHASTIC ACCUMULATION PROCESS */
  /*  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* 'sam_sim_trial_crace_ili_nomodbd:60' while t < p - 1 */
  emxInit_real_T(&At, 2, &d_emlrtRTEI, TRUE);
  c_emxInit_real_T(&dzdt, 1, &e_emlrtRTEI, TRUE);
  emxInit_int32_T(&r3, 1, &emlrtRTEI, TRUE);
  c_emxInit_real_T(&b, 1, &emlrtRTEI, TRUE);
  c_emxInit_real_T(&y, 1, &emlrtRTEI, TRUE);
  c_emxInit_real_T(&b_y, 1, &emlrtRTEI, TRUE);
  emxInit_boolean_T(&x, 1, &emlrtRTEI, TRUE);
  emxInit_boolean_T(&b_resp, 1, &emlrtRTEI, TRUE);
  emxInit_boolean_T(&b_z, 1, &emlrtRTEI, TRUE);
  emxInit_boolean_T(&c_z, 1, &emlrtRTEI, TRUE);
  emxInit_boolean_T(&d_z, 1, &emlrtRTEI, TRUE);
  b_emxInit_boolean_T(&b_latInhib, 2, &emlrtRTEI, TRUE);
  emxInit_boolean_T(&c_resp, 1, &emlrtRTEI, TRUE);
  c_emxInit_real_T(&e_z, 1, &emlrtRTEI, TRUE);
  c_emxInit_real_T(&b_u, 1, &emlrtRTEI, TRUE);
  c_emxInit_real_T(&f_z, 1, &emlrtRTEI, TRUE);
  emxInit_int32_T(&r4, 1, &emlrtRTEI, TRUE);
  c_emxInit_real_T(&g_z, 1, &emlrtRTEI, TRUE);
  emxInit_int32_T(&r5, 1, &emlrtRTEI, TRUE);
  emxInit_int32_T(&r6, 1, &emlrtRTEI, TRUE);
  emxInit_int32_T(&r7, 1, &emlrtRTEI, TRUE);
  exitg1 = FALSE;
  while ((exitg1 == FALSE) && (t < p - 1.0)) {
    /*  Endogenous connectivity at time t (note that A is a function of t */
    /*  because lateral inhibition kicks in once a unit has reached its */
    /*  threshold) */
    /*  ----------------------------------------------------------------------- */
    /* 'sam_sim_trial_crace_ili_nomodbd:66' At = A; */
    i4 = At->size[0] * At->size[1];
    At->size[0] = A->size[0];
    At->size[1] = A->size[1];
    emxEnsureCapacity((emxArray__common *)At, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = A->size[0] * A->size[1];
    for (i4 = 0; i4 < loop_ub; i4++) {
      At->data[i4] = A->data[i4];
    }

    /*  % Extrinsic modulation at time t */
    /*  % ----------------------------------------------------------------------- */
    /*  Bt = zeros(m,m); */
    /*  for i = 1:m */
    /*  Bt = Bt + u(i,t)*B(:,:,i); */
    /*  end */
    /*  % Intrinsic modulation at time t */
    /*  % ----------------------------------------------------------------------- */
    /*  Dt = zeros(n,n); */
    /*  for j = 1:n */
    /*  Dt = Dt + z(j,t)*D(:,:,j); */
    /*  end */
    /*  % Inhibition mechanism 1: block input(s), if any */
    /*  % ----------------------------------------------------------------------- */
    /*  u(any(blockInput(:,resp),2),t) = 0; */
    /*  Inhibition mechanism 2: lateral inhibition */
    /*  ----------------------------------------------------------------------- */
    /* 'sam_sim_trial_crace_ili_nomodbd:88' At(latInhib(:,~resp)) = 0; */
    emlrtPushRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
    i4 = c_resp->size[0];
    c_resp->size[0] = resp->size[0];
    emxEnsureCapacity((emxArray__common *)c_resp, i4, (int32_T)sizeof(boolean_T),
                      &emlrtRTEI);
    loop_ub = resp->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      c_resp->data[i4] = !resp->data[i4];
    }

    eml_li_find(c_resp, r1);
    loop_ub = latInhib->size[0];
    i4 = b_latInhib->size[0] * b_latInhib->size[1];
    b_latInhib->size[0] = loop_ub;
    b_latInhib->size[1] = r1->size[0];
    emxEnsureCapacity((emxArray__common *)b_latInhib, i4, (int32_T)sizeof
                      (boolean_T), &emlrtRTEI);
    i = r1->size[0];
    for (i4 = 0; i4 < i; i4++) {
      for (i5 = 0; i5 < loop_ub; i5++) {
        i6 = latInhib->size[1];
        i7 = r1->data[i4];
        b_latInhib->data[i5 + b_latInhib->size[0] * i4] = latInhib->data[i5 +
          latInhib->size[0] * (emlrtDynamicBoundsCheckFastR2012b(i7, 1, i6,
          &j_emlrtBCI, emlrtRootTLSGlobal) - 1)];
      }
    }

    b_eml_li_find(b_latInhib, r1);
    emlrtPopRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      i5 = A->size[0] * A->size[1];
      i6 = r1->data[i4];
      At->data[emlrtDynamicBoundsCheckFastR2012b(i6, 1, i5, &k_emlrtBCI,
        emlrtRootTLSGlobal) - 1] = 0.0;
    }

    /*  % Change in activation from time t to t + 1 */
    /*  % ----------------------------------------------------------------------- */
    /*  dzdt = (At + Bt + Dt) * z(:,t) * dt/tau + ... % */
    /*  C * u(:,t) * dt/tau + ... % Inputs */
    /*  SI * randn(n,1) * sqrt(dt/tau); % Noise (in) */
    /*  % Endogenous connectivity */
    /*  % Inputs */
    /* 'sam_sim_trial_crace_ili_nomodbd:96' dzdt = At * z(:,t) * dt/tau + ... % Endogenous connectivity */
    /* 'sam_sim_trial_crace_ili_nomodbd:97'                 C * u(:,t) * dt/tau + ... % Inputs */
    /* 'sam_sim_trial_crace_ili_nomodbd:98'                 SI * randn(n,1) * sqrt(dt/tau); */
    emlrtPushRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
    loop_ub = z->size[0];
    i4 = z->size[1];
    i5 = (int32_T)emlrtIntegerCheckFastR2012b(t, &emlrtDCI, emlrtRootTLSGlobal);
    i = emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &h_emlrtBCI,
      emlrtRootTLSGlobal);
    i4 = b->size[0];
    b->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)b, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < loop_ub; i4++) {
      b->data[i4] = z->data[i4 + z->size[0] * (i - 1)];
    }

    emlrtPushRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
    i4 = z->size[0];
    innerDimOk = (At->size[1] == i4);
    if (!innerDimOk) {
      guard4 = FALSE;
      if ((At->size[0] == 1) && (At->size[1] == 1)) {
        guard4 = TRUE;
      } else {
        i4 = z->size[0];
        if (i4 == 1) {
          guard4 = TRUE;
        } else {
          emlrtPushRtStackR2012b(&p_emlrtRSI, emlrtRootTLSGlobal);
          c_y = NULL;
          m7 = mxCreateCharArray(2, iv20);
          for (i = 0; i < 21; i++) {
            cv5[i] = cv6[i];
          }

          emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 21, m7, cv5);
          emlrtAssign(&c_y, m7);
          error(b_message(c_y, &f_emlrtMCI), &g_emlrtMCI);
          emlrtPopRtStackR2012b(&p_emlrtRSI, emlrtRootTLSGlobal);
        }
      }

      if (guard4 == TRUE) {
        emlrtPushRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
        d_y = NULL;
        m7 = mxCreateCharArray(2, iv21);
        for (i = 0; i < 45; i++) {
          cv7[i] = cv8[i];
        }

        emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m7, cv7);
        emlrtAssign(&d_y, m7);
        error(b_message(d_y, &d_emlrtMCI), &e_emlrtMCI);
        emlrtPopRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
      }
    }

    emlrtPopRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
    guard3 = FALSE;
    if (At->size[1] == 1) {
      guard3 = TRUE;
    } else {
      i4 = z->size[0];
      if (i4 == 1) {
        guard3 = TRUE;
      } else {
        unnamed_idx_0 = (int8_T)At->size[0];
        emlrtPushRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&q_emlrtRSI, emlrtRootTLSGlobal);
        i4 = dzdt->size[0];
        dzdt->size[0] = unnamed_idx_0;
        emxEnsureCapacity((emxArray__common *)dzdt, i4, (int32_T)sizeof(real_T),
                          &emlrtRTEI);
        loop_ub = unnamed_idx_0;
        for (i4 = 0; i4 < loop_ub; i4++) {
          dzdt->data[i4] = 0.0;
        }

        if ((At->size[0] < 1) || (At->size[1] < 1)) {
        } else {
          emlrtPushRtStackR2012b(&s_emlrtRSI, emlrtRootTLSGlobal);
          alpha1 = 1.0;
          beta1 = 0.0;
          TRANSB = 'N';
          TRANSA = 'N';
          emlrtPushRtStackR2012b(&y_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          m_t = (ptrdiff_t)(At->size[0]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&y_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&ab_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          n_t = (ptrdiff_t)(1);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&ab_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&bb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          k_t = (ptrdiff_t)(At->size[1]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&bb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&cb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          lda_t = (ptrdiff_t)(At->size[0]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&cb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&db_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          ldb_t = (ptrdiff_t)(At->size[1]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&db_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&eb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          ldc_t = (ptrdiff_t)(At->size[0]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&eb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&fb_emlrtRSI, emlrtRootTLSGlobal);
          alpha1_t = (double *)(&alpha1);
          emlrtPopRtStackR2012b(&fb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&gb_emlrtRSI, emlrtRootTLSGlobal);
          Aia0_t = (double *)(&At->data[0]);
          emlrtPopRtStackR2012b(&gb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
          Bib0_t = (double *)(&b->data[0]);
          emlrtPopRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&ib_emlrtRSI, emlrtRootTLSGlobal);
          beta1_t = (double *)(&beta1);
          emlrtPopRtStackR2012b(&ib_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&jb_emlrtRSI, emlrtRootTLSGlobal);
          Cic0_t = (double *)(&dzdt->data[0]);
          emlrtPopRtStackR2012b(&jb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&kb_emlrtRSI, emlrtRootTLSGlobal);
          dgemm(&TRANSA, &TRANSB, &m_t, &n_t, &k_t, alpha1_t, Aia0_t, &lda_t,
                Bib0_t, &ldb_t, beta1_t, Cic0_t, &ldc_t);
          emlrtPopRtStackR2012b(&kb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&s_emlrtRSI, emlrtRootTLSGlobal);
        }

        emlrtPopRtStackR2012b(&q_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
      }
    }

    if (guard3 == TRUE) {
      loop_ub = z->size[0];
      i4 = e_z->size[0];
      e_z->size[0] = loop_ub;
      emxEnsureCapacity((emxArray__common *)e_z, i4, (int32_T)sizeof(real_T),
                        &emlrtRTEI);
      for (i4 = 0; i4 < loop_ub; i4++) {
        e_z->data[i4] = z->data[i4 + z->size[0] * ((int32_T)t - 1)];
      }

      i4 = dzdt->size[0];
      dzdt->size[0] = At->size[0];
      emxEnsureCapacity((emxArray__common *)dzdt, i4, (int32_T)sizeof(real_T),
                        &emlrtRTEI);
      loop_ub = At->size[0];
      for (i4 = 0; i4 < loop_ub; i4++) {
        dzdt->data[i4] = 0.0;
        i = At->size[1];
        for (i5 = 0; i5 < i; i5++) {
          dzdt->data[i4] += At->data[i4 + At->size[0] * i5] * e_z->data[i5];
        }
      }
    }

    i4 = dzdt->size[0];
    emxEnsureCapacity((emxArray__common *)dzdt, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = dzdt->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      dzdt->data[i4] = dzdt->data[i4] * dt / tau;
    }

    emlrtPopRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
    emlrtPushRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
    i4 = At->size[0] * At->size[1];
    At->size[0] = C->size[0];
    At->size[1] = C->size[1];
    emxEnsureCapacity((emxArray__common *)At, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = C->size[0] * C->size[1];
    for (i4 = 0; i4 < loop_ub; i4++) {
      At->data[i4] = C->data[i4];
    }

    loop_ub = u->size[0];
    i4 = u->size[1];
    i5 = (int32_T)t;
    i = emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &g_emlrtBCI,
      emlrtRootTLSGlobal);
    i4 = b->size[0];
    b->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)b, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < loop_ub; i4++) {
      b->data[i4] = u->data[i4 + u->size[0] * (i - 1)];
    }

    emlrtPushRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
    i4 = u->size[0];
    innerDimOk = (C->size[1] == i4);
    if (!innerDimOk) {
      guard2 = FALSE;
      if ((C->size[0] == 1) && (C->size[1] == 1)) {
        guard2 = TRUE;
      } else {
        i4 = u->size[0];
        if (i4 == 1) {
          guard2 = TRUE;
        } else {
          emlrtPushRtStackR2012b(&p_emlrtRSI, emlrtRootTLSGlobal);
          e_y = NULL;
          m7 = mxCreateCharArray(2, iv22);
          for (i = 0; i < 21; i++) {
            cv5[i] = cv6[i];
          }

          emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 21, m7, cv5);
          emlrtAssign(&e_y, m7);
          error(b_message(e_y, &f_emlrtMCI), &g_emlrtMCI);
          emlrtPopRtStackR2012b(&p_emlrtRSI, emlrtRootTLSGlobal);
        }
      }

      if (guard2 == TRUE) {
        emlrtPushRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
        f_y = NULL;
        m7 = mxCreateCharArray(2, iv23);
        for (i = 0; i < 45; i++) {
          cv7[i] = cv8[i];
        }

        emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m7, cv7);
        emlrtAssign(&f_y, m7);
        error(b_message(f_y, &d_emlrtMCI), &e_emlrtMCI);
        emlrtPopRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
      }
    }

    emlrtPopRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
    guard1 = FALSE;
    if (C->size[1] == 1) {
      guard1 = TRUE;
    } else {
      i4 = u->size[0];
      if (i4 == 1) {
        guard1 = TRUE;
      } else {
        unnamed_idx_0 = (int8_T)C->size[0];
        emlrtPushRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&q_emlrtRSI, emlrtRootTLSGlobal);
        i4 = y->size[0];
        y->size[0] = unnamed_idx_0;
        emxEnsureCapacity((emxArray__common *)y, i4, (int32_T)sizeof(real_T),
                          &emlrtRTEI);
        loop_ub = unnamed_idx_0;
        for (i4 = 0; i4 < loop_ub; i4++) {
          y->data[i4] = 0.0;
        }

        if ((C->size[0] < 1) || (C->size[1] < 1)) {
        } else {
          emlrtPushRtStackR2012b(&s_emlrtRSI, emlrtRootTLSGlobal);
          alpha1 = 1.0;
          beta1 = 0.0;
          TRANSB = 'N';
          TRANSA = 'N';
          emlrtPushRtStackR2012b(&y_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          m_t = (ptrdiff_t)(C->size[0]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&y_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&ab_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          n_t = (ptrdiff_t)(1);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&ab_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&bb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          k_t = (ptrdiff_t)(C->size[1]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&bb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&cb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          lda_t = (ptrdiff_t)(C->size[0]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&cb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&db_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          ldb_t = (ptrdiff_t)(C->size[1]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&db_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&eb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          ldc_t = (ptrdiff_t)(C->size[0]);
          emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&eb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&fb_emlrtRSI, emlrtRootTLSGlobal);
          alpha1_t = (double *)(&alpha1);
          emlrtPopRtStackR2012b(&fb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&gb_emlrtRSI, emlrtRootTLSGlobal);
          Aia0_t = (double *)(&At->data[0]);
          emlrtPopRtStackR2012b(&gb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
          Bib0_t = (double *)(&b->data[0]);
          emlrtPopRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&ib_emlrtRSI, emlrtRootTLSGlobal);
          beta1_t = (double *)(&beta1);
          emlrtPopRtStackR2012b(&ib_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&jb_emlrtRSI, emlrtRootTLSGlobal);
          Cic0_t = (double *)(&y->data[0]);
          emlrtPopRtStackR2012b(&jb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPushRtStackR2012b(&kb_emlrtRSI, emlrtRootTLSGlobal);
          dgemm(&TRANSA, &TRANSB, &m_t, &n_t, &k_t, alpha1_t, Aia0_t, &lda_t,
                Bib0_t, &ldb_t, beta1_t, Cic0_t, &ldc_t);
          emlrtPopRtStackR2012b(&kb_emlrtRSI, emlrtRootTLSGlobal);
          emlrtPopRtStackR2012b(&s_emlrtRSI, emlrtRootTLSGlobal);
        }

        emlrtPopRtStackR2012b(&q_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
      }
    }

    if (guard1 == TRUE) {
      loop_ub = u->size[0];
      i4 = b_u->size[0];
      b_u->size[0] = loop_ub;
      emxEnsureCapacity((emxArray__common *)b_u, i4, (int32_T)sizeof(real_T),
                        &emlrtRTEI);
      for (i4 = 0; i4 < loop_ub; i4++) {
        b_u->data[i4] = u->data[i4 + u->size[0] * ((int32_T)t - 1)];
      }

      i4 = y->size[0];
      y->size[0] = C->size[0];
      emxEnsureCapacity((emxArray__common *)y, i4, (int32_T)sizeof(real_T),
                        &emlrtRTEI);
      loop_ub = C->size[0];
      for (i4 = 0; i4 < loop_ub; i4++) {
        y->data[i4] = 0.0;
        i = C->size[1];
        for (i5 = 0; i5 < i; i5++) {
          y->data[i4] += C->data[i4 + C->size[0] * i5] * b_u->data[i5];
        }
      }
    }

    i4 = y->size[0];
    emxEnsureCapacity((emxArray__common *)y, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = y->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      y->data[i4] = y->data[i4] * dt / tau;
    }

    emlrtPopRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
    i4 = dzdt->size[0];
    i5 = y->size[0];
    emlrtSizeEqCheck1DFastR2012b(i4, i5, &h_emlrtECI, emlrtRootTLSGlobal);
    emlrtPushRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
    emlrtPushRtStackR2012b(&mb_emlrtRSI, emlrtRootTLSGlobal);
    g_y = NULL;
    m7 = mxCreateDoubleScalar(n);
    emlrtAssign(&g_y, m7);
    h_y = NULL;
    m7 = mxCreateDoubleScalar(1.0);
    emlrtAssign(&h_y, m7);
    emlrt_marshallIn(randn(g_y, h_y, &h_emlrtMCI), "randn", b);
    emlrtPopRtStackR2012b(&mb_emlrtRSI, emlrtRootTLSGlobal);
    i4 = At->size[0] * At->size[1];
    At->size[0] = SI->size[0];
    At->size[1] = SI->size[1];
    emxEnsureCapacity((emxArray__common *)At, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = SI->size[0] * SI->size[1];
    for (i4 = 0; i4 < loop_ub; i4++) {
      At->data[i4] = SI->data[i4];
    }

    emlrtPushRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
    innerDimOk = (SI->size[1] == b->size[0]);
    if (!innerDimOk) {
      if (((SI->size[0] == 1) && (SI->size[1] == 1)) || (b->size[0] == 1)) {
        emlrtPushRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
        i_y = NULL;
        m7 = mxCreateCharArray(2, iv24);
        for (i = 0; i < 45; i++) {
          cv7[i] = cv8[i];
        }

        emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m7, cv7);
        emlrtAssign(&i_y, m7);
        error(b_message(i_y, &d_emlrtMCI), &e_emlrtMCI);
        emlrtPopRtStackR2012b(&o_emlrtRSI, emlrtRootTLSGlobal);
      } else {
        emlrtPushRtStackR2012b(&p_emlrtRSI, emlrtRootTLSGlobal);
        j_y = NULL;
        m7 = mxCreateCharArray(2, iv25);
        for (i = 0; i < 21; i++) {
          cv5[i] = cv6[i];
        }

        emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 21, m7, cv5);
        emlrtAssign(&j_y, m7);
        error(b_message(j_y, &f_emlrtMCI), &g_emlrtMCI);
        emlrtPopRtStackR2012b(&p_emlrtRSI, emlrtRootTLSGlobal);
      }
    }

    emlrtPopRtStackR2012b(&n_emlrtRSI, emlrtRootTLSGlobal);
    if ((SI->size[1] == 1) || (b->size[0] == 1)) {
      i4 = b_y->size[0];
      b_y->size[0] = SI->size[0];
      emxEnsureCapacity((emxArray__common *)b_y, i4, (int32_T)sizeof(real_T),
                        &emlrtRTEI);
      loop_ub = SI->size[0];
      for (i4 = 0; i4 < loop_ub; i4++) {
        b_y->data[i4] = 0.0;
        i = SI->size[1];
        for (i5 = 0; i5 < i; i5++) {
          b_y->data[i4] += SI->data[i4 + SI->size[0] * i5] * b->data[i5];
        }
      }
    } else {
      unnamed_idx_0 = (int8_T)SI->size[0];
      emlrtPushRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
      emlrtPushRtStackR2012b(&q_emlrtRSI, emlrtRootTLSGlobal);
      i4 = b_y->size[0];
      b_y->size[0] = unnamed_idx_0;
      emxEnsureCapacity((emxArray__common *)b_y, i4, (int32_T)sizeof(real_T),
                        &emlrtRTEI);
      loop_ub = unnamed_idx_0;
      for (i4 = 0; i4 < loop_ub; i4++) {
        b_y->data[i4] = 0.0;
      }

      if ((SI->size[0] < 1) || (SI->size[1] < 1)) {
      } else {
        emlrtPushRtStackR2012b(&s_emlrtRSI, emlrtRootTLSGlobal);
        alpha1 = 1.0;
        beta1 = 0.0;
        TRANSB = 'N';
        TRANSA = 'N';
        emlrtPushRtStackR2012b(&y_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        m_t = (ptrdiff_t)(SI->size[0]);
        emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&y_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&ab_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        n_t = (ptrdiff_t)(1);
        emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&ab_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&bb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        k_t = (ptrdiff_t)(SI->size[1]);
        emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&bb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&cb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        lda_t = (ptrdiff_t)(SI->size[0]);
        emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&cb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&db_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        ldb_t = (ptrdiff_t)(SI->size[1]);
        emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&db_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&eb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        ldc_t = (ptrdiff_t)(SI->size[0]);
        emlrtPopRtStackR2012b(&lb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&eb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&fb_emlrtRSI, emlrtRootTLSGlobal);
        alpha1_t = (double *)(&alpha1);
        emlrtPopRtStackR2012b(&fb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&gb_emlrtRSI, emlrtRootTLSGlobal);
        Aia0_t = (double *)(&At->data[0]);
        emlrtPopRtStackR2012b(&gb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
        Bib0_t = (double *)(&b->data[0]);
        emlrtPopRtStackR2012b(&hb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&ib_emlrtRSI, emlrtRootTLSGlobal);
        beta1_t = (double *)(&beta1);
        emlrtPopRtStackR2012b(&ib_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&jb_emlrtRSI, emlrtRootTLSGlobal);
        Cic0_t = (double *)(&b_y->data[0]);
        emlrtPopRtStackR2012b(&jb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPushRtStackR2012b(&kb_emlrtRSI, emlrtRootTLSGlobal);
        dgemm(&TRANSA, &TRANSB, &m_t, &n_t, &k_t, alpha1_t, Aia0_t, &lda_t,
              Bib0_t, &ldb_t, beta1_t, Cic0_t, &ldc_t);
        emlrtPopRtStackR2012b(&kb_emlrtRSI, emlrtRootTLSGlobal);
        emlrtPopRtStackR2012b(&s_emlrtRSI, emlrtRootTLSGlobal);
      }

      emlrtPopRtStackR2012b(&q_emlrtRSI, emlrtRootTLSGlobal);
      emlrtPopRtStackR2012b(&m_emlrtRSI, emlrtRootTLSGlobal);
    }

    alpha1 = dt / tau;
    if (alpha1 < 0.0) {
      emlrtPushRtStackR2012b(&nb_emlrtRSI, emlrtRootTLSGlobal);
      eml_error();
      emlrtPopRtStackR2012b(&nb_emlrtRSI, emlrtRootTLSGlobal);
    }

    alpha1 = muDoubleScalarSqrt(alpha1);
    i4 = b_y->size[0];
    emxEnsureCapacity((emxArray__common *)b_y, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = b_y->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      b_y->data[i4] *= alpha1;
    }

    emlrtPopRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
    i4 = dzdt->size[0];
    i5 = b_y->size[0];
    emlrtSizeEqCheck1DFastR2012b(i4, i5, &h_emlrtECI, emlrtRootTLSGlobal);
    i4 = dzdt->size[0];
    emxEnsureCapacity((emxArray__common *)dzdt, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = dzdt->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      dzdt->data[i4] = (dzdt->data[i4] + y->data[i4]) + b_y->data[i4];
    }

    /*  Noise (in) */
    /*  Log new activation level */
    /*  ----------------------------------------------------------------------- */
    /* 'sam_sim_trial_crace_ili_nomodbd:102' z(:,t+1) = z(:,t) + dzdt; */
    i4 = z->size[1];
    i5 = (int32_T)t;
    emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &f_emlrtBCI, emlrtRootTLSGlobal);
    i4 = z->size[0];
    i5 = dzdt->size[0];
    emlrtSizeEqCheck1DFastR2012b(i4, i5, &g_emlrtECI, emlrtRootTLSGlobal);
    loop_ub = z->size[0];
    i4 = r1->size[0];
    r1->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)r1, i4, (int32_T)sizeof(int32_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < loop_ub; i4++) {
      r1->data[i4] = i4;
    }

    i4 = z->size[1];
    i5 = (int32_T)(t + 1.0);
    emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &e_emlrtBCI, emlrtRootTLSGlobal);
    iv26[0] = r1->size[0];
    loop_ub = z->size[0];
    i4 = f_z->size[0];
    f_z->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)f_z, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < loop_ub; i4++) {
      f_z->data[i4] = z->data[i4 + z->size[0] * ((int32_T)t - 1)];
    }

    h_z[0] = f_z->size[0];
    emlrtSubAssignSizeCheckR2012b(iv26, 1, h_z, 1, &f_emlrtECI,
      emlrtRootTLSGlobal);
    i4 = r4->size[0];
    r4->size[0] = r1->size[0];
    emxEnsureCapacity((emxArray__common *)r4, i4, (int32_T)sizeof(int32_T),
                      &emlrtRTEI);
    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      r4->data[i4] = r1->data[i4];
    }

    i = z->size[0];
    i4 = g_z->size[0];
    g_z->size[0] = i;
    emxEnsureCapacity((emxArray__common *)g_z, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < i; i4++) {
      g_z->data[i4] = z->data[i4 + z->size[0] * ((int32_T)t - 1)] + dzdt->
        data[i4];
    }

    loop_ub = g_z->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      z->data[r4->data[i4] + z->size[0] * (int32_T)t] = g_z->data[i4];
    }

    /*  Rectify activation if below zLB */
    /*  ----------------------------------------------------------------------- */
    /* 'sam_sim_trial_crace_ili_nomodbd:106' z(z(:,t+1) < ZLB,t+1) = ZLB(z(:,t+1) < ZLB); */
    i4 = z->size[1];
    i5 = (int32_T)(t + 1.0);
    emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &d_emlrtBCI, emlrtRootTLSGlobal);
    i4 = z->size[0];
    i5 = ZLB->size[0];
    emlrtSizeEqCheck1DFastR2012b(i4, i5, &e_emlrtECI, emlrtRootTLSGlobal);
    i4 = z->size[1];
    i5 = (int32_T)(t + 1.0);
    emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &c_emlrtBCI, emlrtRootTLSGlobal);
    i4 = z->size[0];
    i5 = ZLB->size[0];
    emlrtSizeEqCheck1DFastR2012b(i4, i5, &d_emlrtECI, emlrtRootTLSGlobal);
    emlrtPushRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
    loop_ub = z->size[0];
    i4 = d_z->size[0];
    d_z->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)d_z, i4, (int32_T)sizeof(boolean_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < loop_ub; i4++) {
      d_z->data[i4] = (z->data[i4 + z->size[0] * (int32_T)t] < ZLB->data[i4]);
    }

    eml_li_find(d_z, r1);
    i4 = r3->size[0];
    r3->size[0] = r1->size[0];
    emxEnsureCapacity((emxArray__common *)r3, i4, (int32_T)sizeof(int32_T),
                      &emlrtRTEI);
    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      i5 = z->size[0];
      i6 = r1->data[i4];
      r3->data[i4] = emlrtDynamicBoundsCheckFastR2012b(i6, 1, i5, &l_emlrtBCI,
        emlrtRootTLSGlobal) - 1;
    }

    emlrtPopRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
    i4 = z->size[1];
    i5 = (int32_T)(t + 1.0);
    emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &b_emlrtBCI, emlrtRootTLSGlobal);
    emlrtPushRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
    loop_ub = z->size[0];
    i4 = c_z->size[0];
    c_z->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)c_z, i4, (int32_T)sizeof(boolean_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < loop_ub; i4++) {
      c_z->data[i4] = (z->data[i4 + z->size[0] * (int32_T)t] < ZLB->data[i4]);
    }

    eml_li_find(c_z, r1);
    i4 = b->size[0];
    b->size[0] = r1->size[0];
    emxEnsureCapacity((emxArray__common *)b, i4, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      i5 = ZLB->size[0];
      i6 = r1->data[i4];
      b->data[i4] = ZLB->data[emlrtDynamicBoundsCheckFastR2012b(i6, 1, i5,
        &m_emlrtBCI, emlrtRootTLSGlobal) - 1];
    }

    emlrtPopRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
    iv27[0] = r3->size[0];
    emlrtSubAssignSizeCheckR2012b(iv27, 1, *(int32_T (*)[1])b->size, 1,
      &c_emlrtECI, emlrtRootTLSGlobal);
    i4 = r5->size[0];
    r5->size[0] = r3->size[0];
    emxEnsureCapacity((emxArray__common *)r5, i4, (int32_T)sizeof(int32_T),
                      &emlrtRTEI);
    loop_ub = r3->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      r5->data[i4] = r3->data[i4];
    }

    loop_ub = b->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      z->data[r5->data[i4] + z->size[0] * (int32_T)t] = b->data[i4];
    }

    /*  Identify units that crossed threshold */
    /*  ----------------------------------------------------------------------- */
    /* 'sam_sim_trial_crace_ili_nomodbd:110' resp(z(:,t+1) > ZC) = true; */
    i4 = z->size[1];
    i5 = (int32_T)(t + 1.0);
    emlrtDynamicBoundsCheckFastR2012b(i5, 1, i4, &emlrtBCI, emlrtRootTLSGlobal);
    i4 = z->size[0];
    i5 = ZC->size[0];
    emlrtSizeEqCheck1DFastR2012b(i4, i5, &b_emlrtECI, emlrtRootTLSGlobal);
    emlrtPushRtStackR2012b(&d_emlrtRSI, emlrtRootTLSGlobal);
    loop_ub = z->size[0];
    i4 = b_z->size[0];
    b_z->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)b_z, i4, (int32_T)sizeof(boolean_T),
                      &emlrtRTEI);
    for (i4 = 0; i4 < loop_ub; i4++) {
      b_z->data[i4] = (z->data[i4 + z->size[0] * (int32_T)t] > ZC->data[i4]);
    }

    eml_li_find(b_z, r1);
    emlrtPopRtStackR2012b(&d_emlrtRSI, emlrtRootTLSGlobal);
    i = resp->size[0];
    i4 = r6->size[0];
    r6->size[0] = r1->size[0];
    emxEnsureCapacity((emxArray__common *)r6, i4, (int32_T)sizeof(int32_T),
                      &emlrtRTEI);
    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      i5 = r1->data[i4];
      r6->data[i4] = emlrtDynamicBoundsCheckFastR2012b(i5, 1, i, &n_emlrtBCI,
        emlrtRootTLSGlobal) - 1;
    }

    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      resp->data[r6->data[i4]] = TRUE;
    }

    /*  Determine time of crossing threshold */
    /*  ----------------------------------------------------------------------- */
    /* 'sam_sim_trial_crace_ili_nomodbd:114' rt(resp & isinf(rt)) = T(t + 1); */
    i4 = x->size[0];
    x->size[0] = rt->size[0];
    emxEnsureCapacity((emxArray__common *)x, i4, (int32_T)sizeof(boolean_T),
                      &emlrtRTEI);
    loop_ub = rt->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      x->data[i4] = muDoubleScalarIsInf(rt->data[i4]);
    }

    i4 = resp->size[0];
    i5 = x->size[0];
    emlrtSizeEqCheck1DFastR2012b(i4, i5, &emlrtECI, emlrtRootTLSGlobal);
    emlrtPushRtStackR2012b(&e_emlrtRSI, emlrtRootTLSGlobal);
    i4 = b_resp->size[0];
    b_resp->size[0] = resp->size[0];
    emxEnsureCapacity((emxArray__common *)b_resp, i4, (int32_T)sizeof(boolean_T),
                      &emlrtRTEI);
    loop_ub = resp->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      b_resp->data[i4] = (resp->data[i4] && x->data[i4]);
    }

    eml_li_find(b_resp, r1);
    emlrtPopRtStackR2012b(&e_emlrtRSI, emlrtRootTLSGlobal);
    i = rt->size[0];
    i4 = r7->size[0];
    r7->size[0] = r1->size[0];
    emxEnsureCapacity((emxArray__common *)r7, i4, (int32_T)sizeof(int32_T),
                      &emlrtRTEI);
    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      i5 = r1->data[i4];
      r7->data[i4] = emlrtDynamicBoundsCheckFastR2012b(i5, 1, i, &o_emlrtBCI,
        emlrtRootTLSGlobal) - 1;
    }

    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      i5 = T->size[1];
      i6 = (int32_T)t + 1;
      rt->data[r7->data[i4]] = T->data[emlrtDynamicBoundsCheckFastR2012b(i6, 1,
        i5, &p_emlrtBCI, emlrtRootTLSGlobal) - 1];
    }

    /*  Break accumulation if termination criterion has been met */
    /*  ----------------------------------------------------------------------- */
    /* 'sam_sim_trial_crace_ili_nomodbd:118' if any(terminate(resp)) */
    emlrtPushRtStackR2012b(&f_emlrtRSI, emlrtRootTLSGlobal);
    eml_li_find(resp, r1);
    i4 = x->size[0];
    x->size[0] = r1->size[0];
    emxEnsureCapacity((emxArray__common *)x, i4, (int32_T)sizeof(boolean_T),
                      &emlrtRTEI);
    loop_ub = r1->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      i5 = terminate->size[0];
      i6 = r1->data[i4];
      x->data[i4] = terminate->data[emlrtDynamicBoundsCheckFastR2012b(i6, 1, i5,
        &q_emlrtBCI, emlrtRootTLSGlobal) - 1];
    }

    emlrtPushRtStackR2012b(&pb_emlrtRSI, emlrtRootTLSGlobal);
    innerDimOk = FALSE;
    b_p = FALSE;
    i = 0;
    do {
      exitg3 = 0;
      if (i < 2) {
        if (1 + i <= 1) {
          i4 = x->size[i];
        } else {
          i4 = 1;
        }

        if (i4 != 0) {
          exitg3 = 1;
        } else {
          i++;
        }
      } else {
        b_p = TRUE;
        exitg3 = 1;
      }
    } while (exitg3 == 0);

    if (!b_p) {
    } else {
      innerDimOk = TRUE;
    }

    if (!innerDimOk) {
    } else {
      emlrtPushRtStackR2012b(&qb_emlrtRSI, emlrtRootTLSGlobal);
      k_y = NULL;
      m7 = mxCreateCharArray(2, iv28);
      for (i = 0; i < 41; i++) {
        cv9[i] = cv10[i];
      }

      emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 41, m7, cv9);
      emlrtAssign(&k_y, m7);
      error(b_message(k_y, &i_emlrtMCI), &j_emlrtMCI);
      emlrtPopRtStackR2012b(&qb_emlrtRSI, emlrtRootTLSGlobal);
    }

    if ((x->size[0] == 1) || (x->size[0] != 1)) {
      b_p = TRUE;
    } else {
      b_p = FALSE;
    }

    if (b_p) {
    } else {
      emlrtPushRtStackR2012b(&rb_emlrtRSI, emlrtRootTLSGlobal);
      l_y = NULL;
      m7 = mxCreateCharArray(2, iv29);
      for (i = 0; i < 51; i++) {
        cv11[i] = cv12[i];
      }

      emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 51, m7, cv11);
      emlrtAssign(&l_y, m7);
      error(b_message(l_y, &k_emlrtMCI), &l_emlrtMCI);
      emlrtPopRtStackR2012b(&rb_emlrtRSI, emlrtRootTLSGlobal);
    }

    b_p = FALSE;
    emlrtPushRtStackR2012b(&sb_emlrtRSI, emlrtRootTLSGlobal);
    if (1 > x->size[0]) {
      innerDimOk = FALSE;
    } else {
      innerDimOk = (x->size[0] > 2147483646);
    }

    if (innerDimOk) {
      emlrtPushRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
      check_forloop_overflow_error(TRUE);
      emlrtPopRtStackR2012b(&k_emlrtRSI, emlrtRootTLSGlobal);
    }

    emlrtPopRtStackR2012b(&sb_emlrtRSI, emlrtRootTLSGlobal);
    i = 1;
    exitg2 = FALSE;
    while ((exitg2 == FALSE) && (i <= x->size[0])) {
      innerDimOk = (x->data[i - 1] == 0);
      if (!innerDimOk) {
        b_p = TRUE;
        exitg2 = TRUE;
      } else {
        i++;
      }
    }

    emlrtPopRtStackR2012b(&pb_emlrtRSI, emlrtRootTLSGlobal);
    emlrtPopRtStackR2012b(&f_emlrtRSI, emlrtRootTLSGlobal);
    if (b_p) {
      exitg1 = TRUE;
    } else {
      /*  Update time */
      /*  ----------------------------------------------------------------------- */
      /* 'sam_sim_trial_crace_ili_nomodbd:124' t = t + 1; */
      t++;
      emlrtBreakCheckFastR2012b(emlrtBreakCheckR2012bFlagVar, emlrtRootTLSGlobal);
    }
  }

  emxFree_int32_T(&r7);
  emxFree_int32_T(&r6);
  emxFree_int32_T(&r5);
  emxFree_real_T(&g_z);
  emxFree_int32_T(&r4);
  emxFree_real_T(&f_z);
  emxFree_real_T(&b_u);
  emxFree_real_T(&e_z);
  emxFree_boolean_T(&c_resp);
  emxFree_boolean_T(&b_latInhib);
  emxFree_boolean_T(&d_z);
  emxFree_boolean_T(&c_z);
  emxFree_boolean_T(&b_z);
  emxFree_boolean_T(&b_resp);
  emxFree_boolean_T(&x);
  emxFree_real_T(&b_y);
  emxFree_real_T(&y);
  emxFree_real_T(&b);
  emxFree_int32_T(&r3);
  emxFree_int32_T(&r1);
  emxFree_real_T(&dzdt);
  emxFree_real_T(&At);
  emlrtHeapReferenceStackLeaveFcnR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (sam_sim_trial_crace_ili_nomodbd.c) */
