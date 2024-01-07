class ZCL_BTOCS_SEC_S definition
  public
  inheriting from ZCL_BTOCS_SEC_MET
  create public .

public section.

  interfaces ZIF_BTOCS_SEC_S .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_S IMPLEMENTATION.


  METHOD zif_btocs_sec_s~get_secret.
    get_logger( )->error( |GET_SECRET not redefined| ).
  ENDMETHOD.
ENDCLASS.
