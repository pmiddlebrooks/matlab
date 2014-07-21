/*
 * sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_api.c
 *
 * Code generation for function 'sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_api'
 *
 * C source code generated on: Wed Oct 30 11:46:41 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.h"
#include "sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_api.h"
#include "sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_emxutil.h"

/* Type Definitions */
#ifndef typedef_ResolvedFunctionInfo
#define typedef_ResolvedFunctionInfo

typedef struct {
  const char * context;
  const char * name;
  const char * dominantType;
  const char * resolved;
  uint32_T fileTimeLo;
  uint32_T fileTimeHi;
  uint32_T mFileTimeLo;
  uint32_T mFileTimeHi;
} ResolvedFunctionInfo;

#endif                                 /*typedef_ResolvedFunctionInfo*/

/* Variable Definitions */
static emlrtRTEInfo e_emlrtRTEI = { 1, 1,
  "sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_api", "" };

/* Function Declarations */
static void ab_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_boolean_T *ret);
static void b_emlrt_marshallOut(emxArray_boolean_T *u, const mxArray *y);
static void bb_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_boolean_T *ret);
static void c_emlrt_marshallIn(const mxArray *u, const char_T *identifier,
  emxArray_real_T *y);
static void c_emlrt_marshallOut(emxArray_real_T *u, const mxArray *y);
static void d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static void e_emlrt_marshallIn(const mxArray *A, const char_T *identifier,
  emxArray_real_T *y);
static void emlrt_marshallOut(emxArray_real_T *u, const mxArray *y);
static void f_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static void g_emlrt_marshallIn(const mxArray *C, const char_T *identifier,
  emxArray_real_T *y);
static void h_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static void i_emlrt_marshallIn(const mxArray *Z0, const char_T *identifier,
  emxArray_real_T *y);
static void info_helper(ResolvedFunctionInfo info[69]);
static void j_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static real_T k_emlrt_marshallIn(const mxArray *dt, const char_T *identifier);
static real_T l_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static void m_emlrt_marshallIn(const mxArray *T, const char_T *identifier,
  emxArray_real_T *y);
static void n_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static void o_emlrt_marshallIn(const mxArray *terminate, const char_T
  *identifier, emxArray_boolean_T *y);
static void p_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_boolean_T *y);
static void q_emlrt_marshallIn(const mxArray *blockInput, const char_T
  *identifier, emxArray_boolean_T *y);
static void r_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_boolean_T *y);
static void t_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);
static void u_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);
static void v_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);
static void w_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);
static real_T x_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId);
static void y_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);

/* Function Definitions */
static void ab_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_boolean_T *ret)
{
  int32_T iv15[1];
  boolean_T bv7[1];
  int32_T iv16[1];
  iv15[0] = 50;
  bv7[0] = TRUE;
  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "logical", FALSE, 1U,
    iv15, bv7, iv16);
  ret->size[0] = iv16[0];
  ret->allocatedSize = ret->size[0];
  ret->data = (boolean_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

static void b_emlrt_marshallOut(emxArray_boolean_T *u, const mxArray *y)
{
  mxSetData((mxArray *)y, (void *)u->data);
  mxSetDimensions((mxArray *)y, u->size, 1);
}

static void bb_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_boolean_T *ret)
{
  int32_T iv17[2];
  boolean_T bv8[2];
  int32_T i;
  int32_T iv18[2];
  for (i = 0; i < 2; i++) {
    iv17[i] = 50;
    bv8[i] = TRUE;
  }

  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "logical", FALSE, 2U,
    iv17, bv8, iv18);
  ret->size[0] = iv18[0];
  ret->size[1] = iv18[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (boolean_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

static void c_emlrt_marshallIn(const mxArray *u, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  d_emlrt_marshallIn(emlrtAlias(u), &thisId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallOut(emxArray_real_T *u, const mxArray *y)
{
  mxSetData((mxArray *)y, (void *)u->data);
  mxSetDimensions((mxArray *)y, u->size, 2);
}

static void d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  t_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const mxArray *A, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  f_emlrt_marshallIn(emlrtAlias(A), &thisId, y);
  emlrtDestroyArray(&A);
}

static void emlrt_marshallOut(emxArray_real_T *u, const mxArray *y)
{
  mxSetData((mxArray *)y, (void *)u->data);
  mxSetDimensions((mxArray *)y, u->size, 1);
}

static void f_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  u_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void g_emlrt_marshallIn(const mxArray *C, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  h_emlrt_marshallIn(emlrtAlias(C), &thisId, y);
  emlrtDestroyArray(&C);
}

static void h_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  v_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void i_emlrt_marshallIn(const mxArray *Z0, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  j_emlrt_marshallIn(emlrtAlias(Z0), &thisId, y);
  emlrtDestroyArray(&Z0);
}

static void info_helper(ResolvedFunctionInfo info[69])
{
  info[0].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  info[0].name = "eml_li_find";
  info[0].dominantType = "";
  info[0].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_li_find.m";
  info[0].fileTimeLo = 1286843986U;
  info[0].fileTimeHi = 0U;
  info[0].mFileTimeLo = 0U;
  info[0].mFileTimeHi = 0U;
  info[1].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_li_find.m";
  info[1].name = "eml_index_class";
  info[1].dominantType = "";
  info[1].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[1].fileTimeLo = 1323195778U;
  info[1].fileTimeHi = 0U;
  info[1].mFileTimeLo = 0U;
  info[1].mFileTimeHi = 0U;
  info[2].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_li_find.m!compute_nones";
  info[2].name = "eml_index_class";
  info[2].dominantType = "";
  info[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[2].fileTimeLo = 1323195778U;
  info[2].fileTimeHi = 0U;
  info[2].mFileTimeLo = 0U;
  info[2].mFileTimeHi = 0U;
  info[3].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_li_find.m!compute_nones";
  info[3].name = "eml_int_forloop_overflow_check";
  info[3].dominantType = "";
  info[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m";
  info[3].fileTimeLo = 1346535540U;
  info[3].fileTimeHi = 0U;
  info[3].mFileTimeLo = 0U;
  info[3].mFileTimeHi = 0U;
  info[4].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m!eml_int_forloop_overflow_check_helper";
  info[4].name = "intmax";
  info[4].dominantType = "char";
  info[4].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m";
  info[4].fileTimeLo = 1311280516U;
  info[4].fileTimeHi = 0U;
  info[4].mFileTimeLo = 0U;
  info[4].mFileTimeHi = 0U;
  info[5].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_li_find.m!compute_nones";
  info[5].name = "eml_index_plus";
  info[5].dominantType = "double";
  info[5].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[5].fileTimeLo = 1286843978U;
  info[5].fileTimeHi = 0U;
  info[5].mFileTimeLo = 0U;
  info[5].mFileTimeHi = 0U;
  info[6].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[6].name = "eml_index_class";
  info[6].dominantType = "";
  info[6].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[6].fileTimeLo = 1323195778U;
  info[6].fileTimeHi = 0U;
  info[6].mFileTimeLo = 0U;
  info[6].mFileTimeHi = 0U;
  info[7].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_li_find.m";
  info[7].name = "eml_int_forloop_overflow_check";
  info[7].dominantType = "";
  info[7].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m";
  info[7].fileTimeLo = 1346535540U;
  info[7].fileTimeHi = 0U;
  info[7].mFileTimeLo = 0U;
  info[7].mFileTimeHi = 0U;
  info[8].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_li_find.m";
  info[8].name = "eml_index_plus";
  info[8].dominantType = "double";
  info[8].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[8].fileTimeLo = 1286843978U;
  info[8].fileTimeHi = 0U;
  info[8].mFileTimeLo = 0U;
  info[8].mFileTimeHi = 0U;
  info[9].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  info[9].name = "any";
  info[9].dominantType = "double";
  info[9].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/any.m";
  info[9].fileTimeLo = 1286844034U;
  info[9].fileTimeHi = 0U;
  info[9].mFileTimeLo = 0U;
  info[9].mFileTimeHi = 0U;
  info[10].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/any.m";
  info[10].name = "eml_all_or_any";
  info[10].dominantType = "char";
  info[10].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[10].fileTimeLo = 1286843894U;
  info[10].fileTimeHi = 0U;
  info[10].mFileTimeLo = 0U;
  info[10].mFileTimeHi = 0U;
  info[11].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[11].name = "eml_assert_valid_dim";
  info[11].dominantType = "double";
  info[11].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_dim.m";
  info[11].fileTimeLo = 1286843894U;
  info[11].fileTimeHi = 0U;
  info[11].mFileTimeLo = 0U;
  info[11].mFileTimeHi = 0U;
  info[12].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_dim.m";
  info[12].name = "eml_scalar_floor";
  info[12].dominantType = "double";
  info[12].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
  info[12].fileTimeLo = 1286843926U;
  info[12].fileTimeHi = 0U;
  info[12].mFileTimeLo = 0U;
  info[12].mFileTimeHi = 0U;
  info[13].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_dim.m";
  info[13].name = "eml_index_class";
  info[13].dominantType = "";
  info[13].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[13].fileTimeLo = 1323195778U;
  info[13].fileTimeHi = 0U;
  info[13].mFileTimeLo = 0U;
  info[13].mFileTimeHi = 0U;
  info[14].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_dim.m";
  info[14].name = "intmax";
  info[14].dominantType = "char";
  info[14].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m";
  info[14].fileTimeLo = 1311280516U;
  info[14].fileTimeHi = 0U;
  info[14].mFileTimeLo = 0U;
  info[14].mFileTimeHi = 0U;
  info[15].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[15].name = "eml_matrix_vstride";
  info[15].dominantType = "double";
  info[15].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_vstride.m";
  info[15].fileTimeLo = 1286843988U;
  info[15].fileTimeHi = 0U;
  info[15].mFileTimeLo = 0U;
  info[15].mFileTimeHi = 0U;
  info[16].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_vstride.m";
  info[16].name = "eml_index_minus";
  info[16].dominantType = "double";
  info[16].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_minus.m";
  info[16].fileTimeLo = 1286843978U;
  info[16].fileTimeHi = 0U;
  info[16].mFileTimeLo = 0U;
  info[16].mFileTimeHi = 0U;
  info[17].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_minus.m";
  info[17].name = "eml_index_class";
  info[17].dominantType = "";
  info[17].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[17].fileTimeLo = 1323195778U;
  info[17].fileTimeHi = 0U;
  info[17].mFileTimeLo = 0U;
  info[17].mFileTimeHi = 0U;
  info[18].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_vstride.m";
  info[18].name = "eml_index_class";
  info[18].dominantType = "";
  info[18].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[18].fileTimeLo = 1323195778U;
  info[18].fileTimeHi = 0U;
  info[18].mFileTimeLo = 0U;
  info[18].mFileTimeHi = 0U;
  info[19].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_vstride.m";
  info[19].name = "eml_size_prod";
  info[19].dominantType = "logical";
  info[19].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_size_prod.m";
  info[19].fileTimeLo = 1286843998U;
  info[19].fileTimeHi = 0U;
  info[19].mFileTimeLo = 0U;
  info[19].mFileTimeHi = 0U;
  info[20].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_size_prod.m";
  info[20].name = "eml_index_class";
  info[20].dominantType = "";
  info[20].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[20].fileTimeLo = 1323195778U;
  info[20].fileTimeHi = 0U;
  info[20].mFileTimeLo = 0U;
  info[20].mFileTimeHi = 0U;
  info[21].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_size_prod.m";
  info[21].name = "eml_index_times";
  info[21].dominantType = "double";
  info[21].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_times.m";
  info[21].fileTimeLo = 1286843980U;
  info[21].fileTimeHi = 0U;
  info[21].mFileTimeLo = 0U;
  info[21].mFileTimeHi = 0U;
  info[22].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_times.m";
  info[22].name = "eml_index_class";
  info[22].dominantType = "";
  info[22].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[22].fileTimeLo = 1323195778U;
  info[22].fileTimeHi = 0U;
  info[22].mFileTimeLo = 0U;
  info[22].mFileTimeHi = 0U;
  info[23].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[23].name = "eml_index_minus";
  info[23].dominantType = "double";
  info[23].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_minus.m";
  info[23].fileTimeLo = 1286843978U;
  info[23].fileTimeHi = 0U;
  info[23].mFileTimeLo = 0U;
  info[23].mFileTimeHi = 0U;
  info[24].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[24].name = "eml_index_times";
  info[24].dominantType = "coder.internal.indexInt";
  info[24].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_times.m";
  info[24].fileTimeLo = 1286843980U;
  info[24].fileTimeHi = 0U;
  info[24].mFileTimeLo = 0U;
  info[24].mFileTimeHi = 0U;
  info[25].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[25].name = "eml_matrix_npages";
  info[25].dominantType = "double";
  info[25].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_npages.m";
  info[25].fileTimeLo = 1286843986U;
  info[25].fileTimeHi = 0U;
  info[25].mFileTimeLo = 0U;
  info[25].mFileTimeHi = 0U;
  info[26].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_npages.m";
  info[26].name = "eml_index_plus";
  info[26].dominantType = "double";
  info[26].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[26].fileTimeLo = 1286843978U;
  info[26].fileTimeHi = 0U;
  info[26].mFileTimeLo = 0U;
  info[26].mFileTimeHi = 0U;
  info[27].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_npages.m";
  info[27].name = "eml_index_class";
  info[27].dominantType = "";
  info[27].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[27].fileTimeLo = 1323195778U;
  info[27].fileTimeHi = 0U;
  info[27].mFileTimeLo = 0U;
  info[27].mFileTimeHi = 0U;
  info[28].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_matrix_npages.m";
  info[28].name = "eml_size_prod";
  info[28].dominantType = "logical";
  info[28].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_size_prod.m";
  info[28].fileTimeLo = 1286843998U;
  info[28].fileTimeHi = 0U;
  info[28].mFileTimeLo = 0U;
  info[28].mFileTimeHi = 0U;
  info[29].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[29].name = "eml_index_class";
  info[29].dominantType = "";
  info[29].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[29].fileTimeLo = 1323195778U;
  info[29].fileTimeHi = 0U;
  info[29].mFileTimeLo = 0U;
  info[29].mFileTimeHi = 0U;
  info[30].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[30].name = "eml_index_plus";
  info[30].dominantType = "coder.internal.indexInt";
  info[30].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[30].fileTimeLo = 1286843978U;
  info[30].fileTimeHi = 0U;
  info[30].mFileTimeLo = 0U;
  info[30].mFileTimeHi = 0U;
  info[31].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[31].name = "eml_int_forloop_overflow_check";
  info[31].dominantType = "";
  info[31].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m";
  info[31].fileTimeLo = 1346535540U;
  info[31].fileTimeHi = 0U;
  info[31].mFileTimeLo = 0U;
  info[31].mFileTimeHi = 0U;
  info[32].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[32].name = "eml_index_plus";
  info[32].dominantType = "double";
  info[32].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[32].fileTimeLo = 1286843978U;
  info[32].fileTimeHi = 0U;
  info[32].mFileTimeLo = 0U;
  info[32].mFileTimeHi = 0U;
  info[33].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m!eml_int_forloop_overflow_check_helper";
  info[33].name = "intmin";
  info[33].dominantType = "char";
  info[33].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmin.m";
  info[33].fileTimeLo = 1311280518U;
  info[33].fileTimeHi = 0U;
  info[33].mFileTimeLo = 0U;
  info[33].mFileTimeHi = 0U;
  info[34].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  info[34].name = "isnan";
  info[34].dominantType = "logical";
  info[34].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  info[34].fileTimeLo = 1286843960U;
  info[34].fileTimeHi = 0U;
  info[34].mFileTimeLo = 0U;
  info[34].mFileTimeHi = 0U;
  info[35].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  info[35].name = "mtimes";
  info[35].dominantType = "double";
  info[35].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  info[35].fileTimeLo = 1289544892U;
  info[35].fileTimeHi = 0U;
  info[35].mFileTimeLo = 0U;
  info[35].mFileTimeHi = 0U;
  info[36].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  info[36].name = "eml_index_class";
  info[36].dominantType = "";
  info[36].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[36].fileTimeLo = 1323195778U;
  info[36].fileTimeHi = 0U;
  info[36].mFileTimeLo = 0U;
  info[36].mFileTimeHi = 0U;
  info[37].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  info[37].name = "eml_scalar_eg";
  info[37].dominantType = "double";
  info[37].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  info[37].fileTimeLo = 1286843996U;
  info[37].fileTimeHi = 0U;
  info[37].mFileTimeLo = 0U;
  info[37].mFileTimeHi = 0U;
  info[38].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  info[38].name = "eml_xgemm";
  info[38].dominantType = "char";
  info[38].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/eml_xgemm.m";
  info[38].fileTimeLo = 1299101972U;
  info[38].fileTimeHi = 0U;
  info[38].mFileTimeLo = 0U;
  info[38].mFileTimeHi = 0U;
  info[39].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/eml_xgemm.m";
  info[39].name = "eml_blas_inline";
  info[39].dominantType = "";
  info[39].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/eml_blas_inline.m";
  info[39].fileTimeLo = 1299101968U;
  info[39].fileTimeHi = 0U;
  info[39].mFileTimeLo = 0U;
  info[39].mFileTimeHi = 0U;
  info[40].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m";
  info[40].name = "eml_index_class";
  info[40].dominantType = "";
  info[40].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[40].fileTimeLo = 1323195778U;
  info[40].fileTimeHi = 0U;
  info[40].mFileTimeLo = 0U;
  info[40].mFileTimeHi = 0U;
  info[41].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m";
  info[41].name = "eml_scalar_eg";
  info[41].dominantType = "double";
  info[41].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  info[41].fileTimeLo = 1286843996U;
  info[41].fileTimeHi = 0U;
  info[41].mFileTimeLo = 0U;
  info[41].mFileTimeHi = 0U;
  info[42].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/external/eml_blas_xgemm.m";
  info[42].name = "eml_refblas_xgemm";
  info[42].dominantType = "char";
  info[42].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[42].fileTimeLo = 1299101974U;
  info[42].fileTimeHi = 0U;
  info[42].mFileTimeLo = 0U;
  info[42].mFileTimeHi = 0U;
  info[43].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[43].name = "eml_index_minus";
  info[43].dominantType = "double";
  info[43].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_minus.m";
  info[43].fileTimeLo = 1286843978U;
  info[43].fileTimeHi = 0U;
  info[43].mFileTimeLo = 0U;
  info[43].mFileTimeHi = 0U;
  info[44].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[44].name = "eml_index_class";
  info[44].dominantType = "";
  info[44].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[44].fileTimeLo = 1323195778U;
  info[44].fileTimeHi = 0U;
  info[44].mFileTimeLo = 0U;
  info[44].mFileTimeHi = 0U;
  info[45].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[45].name = "eml_scalar_eg";
  info[45].dominantType = "double";
  info[45].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  info[45].fileTimeLo = 1286843996U;
  info[45].fileTimeHi = 0U;
  info[45].mFileTimeLo = 0U;
  info[45].mFileTimeHi = 0U;
  info[46].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[46].name = "eml_index_times";
  info[46].dominantType = "coder.internal.indexInt";
  info[46].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_times.m";
  info[46].fileTimeLo = 1286843980U;
  info[46].fileTimeHi = 0U;
  info[46].mFileTimeLo = 0U;
  info[46].mFileTimeHi = 0U;
  info[47].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[47].name = "eml_index_plus";
  info[47].dominantType = "coder.internal.indexInt";
  info[47].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[47].fileTimeLo = 1286843978U;
  info[47].fileTimeHi = 0U;
  info[47].mFileTimeLo = 0U;
  info[47].mFileTimeHi = 0U;
  info[48].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[48].name = "eml_int_forloop_overflow_check";
  info[48].dominantType = "";
  info[48].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m";
  info[48].fileTimeLo = 1346535540U;
  info[48].fileTimeHi = 0U;
  info[48].mFileTimeLo = 0U;
  info[48].mFileTimeHi = 0U;
  info[49].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/blas/refblas/eml_refblas_xgemm.m";
  info[49].name = "eml_index_plus";
  info[49].dominantType = "double";
  info[49].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[49].fileTimeLo = 1286843978U;
  info[49].fileTimeHi = 0U;
  info[49].mFileTimeLo = 0U;
  info[49].mFileTimeHi = 0U;
  info[50].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  info[50].name = "mrdivide";
  info[50].dominantType = "double";
  info[50].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  info[50].fileTimeLo = 1357976748U;
  info[50].fileTimeHi = 0U;
  info[50].mFileTimeLo = 1319755166U;
  info[50].mFileTimeHi = 0U;
  info[51].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  info[51].name = "rdivide";
  info[51].dominantType = "double";
  info[51].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  info[51].fileTimeLo = 1346535588U;
  info[51].fileTimeHi = 0U;
  info[51].mFileTimeLo = 0U;
  info[51].mFileTimeHi = 0U;
  info[52].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  info[52].name = "eml_scalexp_compatible";
  info[52].dominantType = "double";
  info[52].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m";
  info[52].fileTimeLo = 1286843996U;
  info[52].fileTimeHi = 0U;
  info[52].mFileTimeLo = 0U;
  info[52].mFileTimeHi = 0U;
  info[53].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  info[53].name = "eml_div";
  info[53].dominantType = "double";
  info[53].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  info[53].fileTimeLo = 1313373010U;
  info[53].fileTimeHi = 0U;
  info[53].mFileTimeLo = 0U;
  info[53].mFileTimeHi = 0U;
  info[54].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  info[54].name = "diag";
  info[54].dominantType = "logical";
  info[54].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/diag.m";
  info[54].fileTimeLo = 1286843886U;
  info[54].fileTimeHi = 0U;
  info[54].mFileTimeLo = 0U;
  info[54].mFileTimeHi = 0U;
  info[55].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/diag.m";
  info[55].name = "eml_index_class";
  info[55].dominantType = "";
  info[55].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  info[55].fileTimeLo = 1323195778U;
  info[55].fileTimeHi = 0U;
  info[55].mFileTimeLo = 0U;
  info[55].mFileTimeHi = 0U;
  info[56].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/diag.m";
  info[56].name = "eml_index_plus";
  info[56].dominantType = "coder.internal.indexInt";
  info[56].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  info[56].fileTimeLo = 1286843978U;
  info[56].fileTimeHi = 0U;
  info[56].mFileTimeLo = 0U;
  info[56].mFileTimeHi = 0U;
  info[57].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/diag.m";
  info[57].name = "eml_scalar_eg";
  info[57].dominantType = "logical";
  info[57].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  info[57].fileTimeLo = 1286843996U;
  info[57].fileTimeHi = 0U;
  info[57].mFileTimeLo = 0U;
  info[57].mFileTimeHi = 0U;
  info[58].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/diag.m";
  info[58].name = "eml_int_forloop_overflow_check";
  info[58].dominantType = "";
  info[58].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m";
  info[58].fileTimeLo = 1346535540U;
  info[58].fileTimeHi = 0U;
  info[58].mFileTimeLo = 0U;
  info[58].mFileTimeHi = 0U;
  info[59].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  info[59].name = "randn";
  info[59].dominantType = "double";
  info[59].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/randfun/randn.m";
  info[59].fileTimeLo = 1313373024U;
  info[59].fileTimeHi = 0U;
  info[59].mFileTimeLo = 0U;
  info[59].mFileTimeHi = 0U;
  info[60].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/randfun/randn.m";
  info[60].name = "eml_is_rand_extrinsic";
  info[60].dominantType = "";
  info[60].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/randfun/eml_is_rand_extrinsic.m";
  info[60].fileTimeLo = 1334096690U;
  info[60].fileTimeHi = 0U;
  info[60].mFileTimeLo = 0U;
  info[60].mFileTimeHi = 0U;
  info[61].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  info[61].name = "sqrt";
  info[61].dominantType = "double";
  info[61].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  info[61].fileTimeLo = 1343855586U;
  info[61].fileTimeHi = 0U;
  info[61].mFileTimeLo = 0U;
  info[61].mFileTimeHi = 0U;
  info[62].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  info[62].name = "eml_error";
  info[62].dominantType = "char";
  info[62].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_error.m";
  info[62].fileTimeLo = 1343855558U;
  info[62].fileTimeHi = 0U;
  info[62].mFileTimeLo = 0U;
  info[62].mFileTimeHi = 0U;
  info[63].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  info[63].name = "eml_scalar_sqrt";
  info[63].dominantType = "double";
  info[63].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_sqrt.m";
  info[63].fileTimeLo = 1286843938U;
  info[63].fileTimeHi = 0U;
  info[63].mFileTimeLo = 0U;
  info[63].mFileTimeHi = 0U;
}

static void j_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  w_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T k_emlrt_marshallIn(const mxArray *dt, const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = l_emlrt_marshallIn(emlrtAlias(dt), &thisId);
  emlrtDestroyArray(&dt);
  return y;
}

static real_T l_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  real_T y;
  y = x_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void m_emlrt_marshallIn(const mxArray *T, const char_T *identifier,
  emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  n_emlrt_marshallIn(emlrtAlias(T), &thisId, y);
  emlrtDestroyArray(&T);
}

static void n_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  y_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void o_emlrt_marshallIn(const mxArray *terminate, const char_T
  *identifier, emxArray_boolean_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  p_emlrt_marshallIn(emlrtAlias(terminate), &thisId, y);
  emlrtDestroyArray(&terminate);
}

static void p_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_boolean_T *y)
{
  ab_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void q_emlrt_marshallIn(const mxArray *blockInput, const char_T
  *identifier, emxArray_boolean_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  r_emlrt_marshallIn(emlrtAlias(blockInput), &thisId, y);
  emlrtDestroyArray(&blockInput);
}

static void r_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_boolean_T *y)
{
  bb_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void t_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv5[2];
  boolean_T bv1[2];
  int32_T i2;
  int32_T iv6[2];
  for (i2 = 0; i2 < 2; i2++) {
    iv5[i2] = 50 + 999950 * i2;
    bv1[i2] = TRUE;
  }

  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 2U,
    iv5, bv1, iv6);
  ret->size[0] = iv6[0];
  ret->size[1] = iv6[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

static void u_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv7[2];
  boolean_T bv2[2];
  int32_T i;
  int32_T iv8[2];
  for (i = 0; i < 2; i++) {
    iv7[i] = 50;
    bv2[i] = TRUE;
  }

  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 2U,
    iv7, bv2, iv8);
  ret->size[0] = iv8[0];
  ret->size[1] = iv8[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

static void v_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv9[2];
  boolean_T bv3[2];
  int32_T i3;
  int32_T iv10[2];
  for (i3 = 0; i3 < 2; i3++) {
    iv9[i3] = 50 + 950 * i3;
    bv3[i3] = TRUE;
  }

  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 2U,
    iv9, bv3, iv10);
  ret->size[0] = iv10[0];
  ret->size[1] = iv10[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

static void w_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv11[1];
  boolean_T bv4[1];
  int32_T iv12[1];
  iv11[0] = 50;
  bv4[0] = TRUE;
  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 1U,
    iv11, bv4, iv12);
  ret->size[0] = iv12[0];
  ret->allocatedSize = ret->size[0];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

static real_T x_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId)
{
  real_T ret;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 0U, 0);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static void y_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  int32_T iv13[2];
  boolean_T bv5[2];
  int32_T i4;
  static const boolean_T bv6[2] = { FALSE, TRUE };

  int32_T iv14[2];
  for (i4 = 0; i4 < 2; i4++) {
    iv13[i4] = 1 + 999999 * i4;
    bv5[i4] = bv6[i4];
  }

  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", FALSE, 2U,
    iv13, bv5, iv14);
  ret->size[0] = iv14[0];
  ret->size[1] = iv14[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = FALSE;
  emlrtDestroyArray(&src);
}

const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  ResolvedFunctionInfo info[69];
  ResolvedFunctionInfo (*b_info)[69];
  ResolvedFunctionInfo u[69];
  int32_T i;
  const mxArray *y;
  int32_T iv2[1];
  ResolvedFunctionInfo *r0;
  const char * b_u;
  const mxArray *b_y;
  const mxArray *m2;
  const mxArray *c_y;
  const mxArray *d_y;
  const mxArray *e_y;
  uint32_T c_u;
  const mxArray *f_y;
  const mxArray *g_y;
  const mxArray *h_y;
  const mxArray *i_y;
  nameCaptureInfo = NULL;
  info_helper(info);
  b_info = (ResolvedFunctionInfo (*)[69])info;
  (*b_info)[64].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  (*b_info)[64].name = "isinf";
  (*b_info)[64].dominantType = "double";
  (*b_info)[64].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isinf.m";
  (*b_info)[64].fileTimeLo = 1286843960U;
  (*b_info)[64].fileTimeHi = 0U;
  (*b_info)[64].mFileTimeLo = 0U;
  (*b_info)[64].mFileTimeHi = 0U;
  (*b_info)[65].context =
    "[E]/Users/paulmiddlebrooks/matlab/sam/sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise.m";
  (*b_info)[65].name = "any";
  (*b_info)[65].dominantType = "logical";
  (*b_info)[65].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/any.m";
  (*b_info)[65].fileTimeLo = 1286844034U;
  (*b_info)[65].fileTimeHi = 0U;
  (*b_info)[65].mFileTimeLo = 0U;
  (*b_info)[65].mFileTimeHi = 0U;
  (*b_info)[66].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  (*b_info)[66].name = "isequal";
  (*b_info)[66].dominantType = "double";
  (*b_info)[66].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isequal.m";
  (*b_info)[66].fileTimeLo = 1286843958U;
  (*b_info)[66].fileTimeHi = 0U;
  (*b_info)[66].mFileTimeLo = 0U;
  (*b_info)[66].mFileTimeHi = 0U;
  (*b_info)[67].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isequal.m";
  (*b_info)[67].name = "eml_isequal_core";
  (*b_info)[67].dominantType = "double";
  (*b_info)[67].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_isequal_core.m";
  (*b_info)[67].fileTimeLo = 1286843986U;
  (*b_info)[67].fileTimeHi = 0U;
  (*b_info)[67].mFileTimeLo = 0U;
  (*b_info)[67].mFileTimeHi = 0U;
  (*b_info)[68].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_all_or_any.m";
  (*b_info)[68].name = "eml_const_nonsingleton_dim";
  (*b_info)[68].dominantType = "logical";
  (*b_info)[68].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_const_nonsingleton_dim.m";
  (*b_info)[68].fileTimeLo = 1286843896U;
  (*b_info)[68].fileTimeHi = 0U;
  (*b_info)[68].mFileTimeLo = 0U;
  (*b_info)[68].mFileTimeHi = 0U;
  for (i = 0; i < 69; i++) {
    u[i] = info[i];
  }

  y = NULL;
  iv2[0] = 69;
  emlrtAssign(&y, mxCreateStructArray(1, iv2, 0, NULL));
  for (i = 0; i < 69; i++) {
    r0 = &u[i];
    b_u = r0->context;
    b_y = NULL;
    m2 = mxCreateString(b_u);
    emlrtAssign(&b_y, m2);
    emlrtAddField(y, b_y, "context", i);
    b_u = r0->name;
    c_y = NULL;
    m2 = mxCreateString(b_u);
    emlrtAssign(&c_y, m2);
    emlrtAddField(y, c_y, "name", i);
    b_u = r0->dominantType;
    d_y = NULL;
    m2 = mxCreateString(b_u);
    emlrtAssign(&d_y, m2);
    emlrtAddField(y, d_y, "dominantType", i);
    b_u = r0->resolved;
    e_y = NULL;
    m2 = mxCreateString(b_u);
    emlrtAssign(&e_y, m2);
    emlrtAddField(y, e_y, "resolved", i);
    c_u = r0->fileTimeLo;
    f_y = NULL;
    m2 = mxCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL);
    *(uint32_T *)mxGetData(m2) = c_u;
    emlrtAssign(&f_y, m2);
    emlrtAddField(y, f_y, "fileTimeLo", i);
    c_u = r0->fileTimeHi;
    g_y = NULL;
    m2 = mxCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL);
    *(uint32_T *)mxGetData(m2) = c_u;
    emlrtAssign(&g_y, m2);
    emlrtAddField(y, g_y, "fileTimeHi", i);
    c_u = r0->mFileTimeLo;
    h_y = NULL;
    m2 = mxCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL);
    *(uint32_T *)mxGetData(m2) = c_u;
    emlrtAssign(&h_y, m2);
    emlrtAddField(y, h_y, "mFileTimeLo", i);
    c_u = r0->mFileTimeHi;
    i_y = NULL;
    m2 = mxCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL);
    *(uint32_T *)mxGetData(m2) = c_u;
    emlrtAssign(&i_y, m2);
    emlrtAddField(y, i_y, "mFileTimeHi", i);
  }

  emlrtAssign(&nameCaptureInfo, y);
  emlrtNameCapturePostProcessR2012a(emlrtAlias(nameCaptureInfo));
  return nameCaptureInfo;
}

void sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_api(const mxArray *prhs[22],
  const mxArray *plhs[3])
{
  emxArray_real_T *u;
  emxArray_real_T *A;
  emxArray_real_T *unusedU0;
  emxArray_real_T *C;
  emxArray_real_T *unusedU1;
  emxArray_real_T *SI;
  emxArray_real_T *Z0;
  emxArray_real_T *ZC;
  emxArray_real_T *ZLB;
  emxArray_real_T *T;
  emxArray_boolean_T *terminate;
  emxArray_boolean_T *blockInput;
  emxArray_boolean_T *unusedU2;
  emxArray_real_T *rt;
  emxArray_boolean_T *resp;
  emxArray_real_T *z;
  real_T dt;
  real_T tau;
  real_T n;
  real_T p;
  real_T t;
  real_T unusedU3;
  emlrtHeapReferenceStackEnterFcnR2012b(emlrtRootTLSGlobal);
  emxInit_real_T(&u, 2, &e_emlrtRTEI, TRUE);
  emxInit_real_T(&A, 2, &e_emlrtRTEI, TRUE);
  b_emxInit_real_T(&unusedU0, 3, &e_emlrtRTEI, TRUE);
  emxInit_real_T(&C, 2, &e_emlrtRTEI, TRUE);
  b_emxInit_real_T(&unusedU1, 3, &e_emlrtRTEI, TRUE);
  emxInit_real_T(&SI, 2, &e_emlrtRTEI, TRUE);
  c_emxInit_real_T(&Z0, 1, &e_emlrtRTEI, TRUE);
  c_emxInit_real_T(&ZC, 1, &e_emlrtRTEI, TRUE);
  c_emxInit_real_T(&ZLB, 1, &e_emlrtRTEI, TRUE);
  emxInit_real_T(&T, 2, &e_emlrtRTEI, TRUE);
  emxInit_boolean_T(&terminate, 1, &e_emlrtRTEI, TRUE);
  b_emxInit_boolean_T(&blockInput, 2, &e_emlrtRTEI, TRUE);
  b_emxInit_boolean_T(&unusedU2, 2, &e_emlrtRTEI, TRUE);
  c_emxInit_real_T(&rt, 1, &e_emlrtRTEI, TRUE);
  emxInit_boolean_T(&resp, 1, &e_emlrtRTEI, TRUE);
  emxInit_real_T(&z, 2, &e_emlrtRTEI, TRUE);
  prhs[0] = emlrtProtectR2012b(prhs[0], 0, FALSE, -1);
  prhs[19] = emlrtProtectR2012b(prhs[19], 19, TRUE, -1);
  prhs[20] = emlrtProtectR2012b(prhs[20], 20, TRUE, -1);
  prhs[21] = emlrtProtectR2012b(prhs[21], 21, TRUE, -1);

  /* Marshall function inputs */
  c_emlrt_marshallIn(emlrtAlias(prhs[0]), "u", u);
  e_emlrt_marshallIn(emlrtAlias(prhs[1]), "A", A);
  g_emlrt_marshallIn(emlrtAlias(prhs[3]), "C", C);
  e_emlrt_marshallIn(emlrtAlias(prhs[5]), "SI", SI);
  i_emlrt_marshallIn(emlrtAlias(prhs[6]), "Z0", Z0);
  i_emlrt_marshallIn(emlrtAlias(prhs[7]), "ZC", ZC);
  i_emlrt_marshallIn(emlrtAlias(prhs[8]), "ZLB", ZLB);
  dt = k_emlrt_marshallIn(emlrtAliasP(prhs[9]), "dt");
  tau = k_emlrt_marshallIn(emlrtAliasP(prhs[10]), "tau");
  m_emlrt_marshallIn(emlrtAlias(prhs[11]), "T", T);
  o_emlrt_marshallIn(emlrtAlias(prhs[12]), "terminate", terminate);
  q_emlrt_marshallIn(emlrtAlias(prhs[13]), "blockInput", blockInput);
  n = k_emlrt_marshallIn(emlrtAliasP(prhs[15]), "n");
  p = k_emlrt_marshallIn(emlrtAliasP(prhs[17]), "p");
  t = k_emlrt_marshallIn(emlrtAliasP(prhs[18]), "t");
  i_emlrt_marshallIn(emlrtAlias(prhs[19]), "rt", rt);
  o_emlrt_marshallIn(emlrtAlias(prhs[20]), "resp", resp);
  c_emlrt_marshallIn(emlrtAlias(prhs[21]), "z", z);

  /* Invoke the target function */
  sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise(u, A, unusedU0, C, unusedU1, SI, Z0,
    ZC, ZLB, dt, tau, T, terminate, blockInput, unusedU2, n, unusedU3, p, t, rt,
    resp, z);

  /* Marshall function outputs */
  emlrt_marshallOut(rt, prhs[19]);
  plhs[0] = prhs[19];
  b_emlrt_marshallOut(resp, prhs[20]);
  plhs[1] = prhs[20];
  c_emlrt_marshallOut(z, prhs[21]);
  plhs[2] = prhs[21];
  z->canFreeData = FALSE;
  emxFree_real_T(&z);
  resp->canFreeData = FALSE;
  emxFree_boolean_T(&resp);
  rt->canFreeData = FALSE;
  emxFree_real_T(&rt);
  emxFree_boolean_T(&unusedU2);
  blockInput->canFreeData = FALSE;
  emxFree_boolean_T(&blockInput);
  terminate->canFreeData = FALSE;
  emxFree_boolean_T(&terminate);
  T->canFreeData = FALSE;
  emxFree_real_T(&T);
  ZLB->canFreeData = FALSE;
  emxFree_real_T(&ZLB);
  ZC->canFreeData = FALSE;
  emxFree_real_T(&ZC);
  Z0->canFreeData = FALSE;
  emxFree_real_T(&Z0);
  SI->canFreeData = FALSE;
  emxFree_real_T(&SI);
  emxFree_real_T(&unusedU1);
  C->canFreeData = FALSE;
  emxFree_real_T(&C);
  emxFree_real_T(&unusedU0);
  A->canFreeData = FALSE;
  emxFree_real_T(&A);
  u->canFreeData = FALSE;
  emxFree_real_T(&u);
  emlrtHeapReferenceStackLeaveFcnR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (sam_sim_trial_cffi_ibi_nomodbd_inpdepnoise_api.c) */
