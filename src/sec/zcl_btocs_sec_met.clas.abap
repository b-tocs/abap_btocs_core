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
  data MO_MGR type ref to ZIF_BTOCS_SEC_MGR .
  data MO_PARENT type ref to ZIF_BTOCS_UTIL_BASE .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_MET IMPLEMENTATION.


  METHOD zif_btocs_sec_met~set_context.
    mv_method = iv_method.
    mv_param  = iv_param.
    ms_config = is_config.
    mo_parent = ir_parent.
    mo_mgr    = ir_mgr.
    set_logger( ir_parent->get_logger( ) ).
  ENDMETHOD.


  METHOD zif_btocs_sec_met~get_manager.
    IF mo_mgr IS INITIAL.
      mo_mgr = zcl_btocs_factory=>create_secret_manager( ).
      mo_mgr->set_logger( get_logger( ) ).
    ENDIF.
    ro_mgr = mo_mgr.
  ENDMETHOD.


  method ZIF_BTOCS_SEC_MET~GET_PARENT.
    ro_parent = mo_parent.
  endmethod.
ENDCLASS.
