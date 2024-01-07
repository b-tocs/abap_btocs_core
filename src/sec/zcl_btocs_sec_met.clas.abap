class ZCL_BTOCS_SEC_MET definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_SEC_MET .
protected section.

  data MV_METHOD type STRING .
  data MV_PARAM type STRING .
  data MS_CONFIG type ZBTOCS_CFG_S_RFC_REC .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_MET IMPLEMENTATION.


  METHOD zif_btocs_sec_met~set_context.
    mv_method = iv_method.
    mv_param  = iv_param.
    ms_config = is_config.
    set_logger( ir_parent->get_logger( ) ).
  ENDMETHOD.
ENDCLASS.
