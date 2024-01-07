class ZCL_BTOCS_SEC_T_BEARER definition
  public
  inheriting from ZCL_BTOCS_SEC_T
  create public .

public section.

  methods ZIF_BTOCS_SEC_T~SET_TOKEN_TO_REQUEST
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_T_BEARER IMPLEMENTATION.


  METHOD zif_btocs_sec_t~set_token_to_request.
    IF iv_token IS INITIAL.
      get_logger( )->error( |SET_TOKEN_TO_REQUEST: missing token| ).
    ELSE.
      rv_success = ir_request->set_header_field(
          iv_name      = 'Authorization'
          iv_value     = |Bearer { iv_token }|
          iv_overwrite = abap_true
      ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
