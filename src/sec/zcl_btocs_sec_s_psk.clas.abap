class ZCL_BTOCS_SEC_S_PSK definition
  public
  inheriting from ZCL_BTOCS_SEC_S
  create public .

public section.

  methods ZIF_BTOCS_SEC_S~GET_SECRET
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_S_PSK IMPLEMENTATION.


  METHOD zif_btocs_sec_s~get_secret.
    IF mv_param IS INITIAL.
      get_logger( )->error( |secret missing in config param| ).
    ELSE.
      ev_is_binary = abap_false.
      ev_secret    = mv_param.
      rv_success   = abap_true.
      get_logger( )->debug( |secret determinded from config param| ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
