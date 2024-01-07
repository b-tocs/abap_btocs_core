class ZCL_BTOCS_SEC_A definition
  public
  inheriting from ZCL_BTOCS_SEC_MET
  create public .

public section.

  interfaces ZIF_BTOCS_SEC_A .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_A IMPLEMENTATION.


  METHOD zif_btocs_sec_a~prepare_auth.
    get_logger( )->error( |PREPARE_AUTH not redefined| ).
  ENDMETHOD.
ENDCLASS.
