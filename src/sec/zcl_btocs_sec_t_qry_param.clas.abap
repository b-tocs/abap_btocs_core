class ZCL_BTOCS_SEC_T_QRY_PARAM definition
  public
  inheriting from ZCL_BTOCS_SEC_T
  create public .

public section.

  methods ZIF_BTOCS_SEC_T~SET_TOKEN_TO_REQUEST
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_T_QRY_PARAM IMPLEMENTATION.


  METHOD zif_btocs_sec_t~set_token_to_request.
    IF iv_token IS INITIAL.
      get_logger( )->error( |SET_TOKEN_TO_REQUEST: missing token| ).
    ELSEIF mv_param IS INITIAL.
      get_logger( )->error( |SET_TOKEN_TO_REQUEST: missing param for query param name| ).
    ELSE.
      rv_success = ir_request->add_query_param(
                     iv_name  = mv_param
                     iv_value = iv_token
                   ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
