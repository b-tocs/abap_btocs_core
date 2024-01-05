class ZCL_BTOCS_UTIL_CFG_MGR definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_CFG_MGR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_CFG_MGR IMPLEMENTATION.


  METHOD zif_btocs_util_cfg_mgr~read_rws_config_profile.
* ------- select
    SELECT SINGLE *
      FROM ztc_btocs_prf
      INTO CORRESPONDING FIELDS OF rs_config
     WHERE rws_profile = iv_profile
       AND active  = abap_true.

    IF sy-subrc <> 0.
      get_logger( )->debug( |RWS PRF config not found for { iv_profile }| ).
      RETURN.
    ELSE.
      get_logger( )->debug( |RWS PRF config found for { iv_profile }| ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_cfg_mgr~read_rws_config_rfcdest.

* ------- select
    SELECT SINGLE *
      FROM ztc_btocs_rfc
      INTO CORRESPONDING FIELDS OF rs_config
     WHERE rfcdest = iv_rfcdest
       AND active  = abap_true.

    IF sy-subrc <> 0.
      get_logger( )->debug( |RWS RFC config not found for { iv_rfcdest }| ).
      RETURN.
    ELSE.
      get_logger( )->debug( |RWS RFC config found for { iv_rfcdest }| ).
    ENDIF.


* ------- read profile
    IF rs_config-rws_profile IS NOT INITIAL
      AND iv_read_profile EQ abap_true.
      DATA(ls_prf_cfg) = zif_btocs_util_cfg_mgr~read_rws_config_profile( rs_config-rws_profile ).
      IF ls_prf_cfg IS NOT INITIAL.
        MOVE-CORRESPONDING ls_prf_cfg TO rs_config.
        get_logger( )->debug( |RWS RFC config for { iv_rfcdest } overwritten by profile { rs_config-rws_profile }| ).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
