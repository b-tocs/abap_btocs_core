class ZCL_BTOCS_SEC_A_JWT_TRUST definition
  public
  inheriting from ZCL_BTOCS_SEC_A
  create public .

public section.

  methods ZIF_BTOCS_SEC_A~PREPARE_AUTH
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_A_JWT_TRUST IMPLEMENTATION.


  METHOD zif_btocs_sec_a~prepare_auth.
    get_logger( )->warning( |jwt not implemented yet| ).
    ev_token = |{ sy-sysid }{ sy-uname }{ sy-datum }{ sy-uzeit }|.
    rv_success = abap_true.
  ENDMETHOD.
ENDCLASS.
