class ZCL_BTOCS_SEC_T definition
  public
  inheriting from ZCL_BTOCS_SEC_MET
  create public .

public section.

  interfaces ZIF_BTOCS_SEC_T .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_T IMPLEMENTATION.


  METHOD zif_btocs_sec_t~set_token_to_request.
    get_logger( )->error( |SET_TOKEN_TO_REQUEST not redefined| ).
  ENDMETHOD.
ENDCLASS.
