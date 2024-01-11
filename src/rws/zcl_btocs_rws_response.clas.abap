class ZCL_BTOCS_RWS_RESPONSE definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_RWS_RESPONSE .
protected section.

  data MV_STATUS_CODE type I value 500 ##NO_TEXT.
  data MV_REASON type STRING value 'unkown error' ##NO_TEXT.
  data MV_CONTENT_TYPE type STRING .
  data MV_CONTENT_LENGTH type I .
  data MV_CONTENT type STRING .
  data MV_BINARY type XSTRING .
  data MO_RESPONSE type ref to IF_HTTP_RESPONSE .
  data MO_REQUEST type ref to IF_HTTP_REQUEST .
  data MT_HEADER type TIHTTPNVP .
  data MT_FORM_FIELDS type TIHTTPNVP .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_RWS_RESPONSE IMPLEMENTATION.


  method ZIF_BTOCS_RWS_RESPONSE~GET_BINARY.
    rv_binary = mv_binary.
  endmethod.


  method ZIF_BTOCS_RWS_RESPONSE~GET_CONTENT.
    rv_content = mv_content.
  endmethod.


  METHOD zif_btocs_rws_response~get_content_type.
    rv_content_type = mv_content_type.
  ENDMETHOD.


  method ZIF_BTOCS_RWS_RESPONSE~GET_FORM_FIELDS.
    rt_form_fields = mt_form_fields.
  endmethod.


  method ZIF_BTOCS_RWS_RESPONSE~GET_HEADER_FIELDS.
    rt_header = mt_header.
  endmethod.


  METHOD zif_btocs_rws_response~get_reason.
    rv_reason = mv_reason.
  ENDMETHOD.


  method ZIF_BTOCS_RWS_RESPONSE~GET_STATUS_CODE.
    rv_status = mv_status_code.
  endmethod.


  METHOD zif_btocs_rws_response~is_binary.

    IF mv_binary IS NOT INITIAL AND strlen( mv_content ) <> xstrlen( mv_binary ).
      rv_binary = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_rws_response~is_form_fields.
    rv_form_fields = COND #( WHEN mt_form_fields[] IS NOT INITIAL
                             THEN abap_true
                             ELSE abap_false ).
  ENDMETHOD.


  METHOD zif_btocs_rws_response~is_header_fields.
    rv_header_fields = COND #( WHEN mt_header[] IS NOT INITIAL
                             THEN abap_true
                             ELSE abap_false ).
  ENDMETHOD.


  METHOD zif_btocs_rws_response~is_http_request_success.
    IF mv_status_code >= 200 AND mv_status_code <= 300.
      rv_success = abap_true.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_RWS_RESPONSE~IS_JSON_OBJECT.
    if ZIF_BTOCS_RWS_RESPONSE~is_json_response( ) eq abap_true
      and mv_content cp '{*}'.
      rv_json_object = abap_true.
    endif.
  endmethod.


  METHOD zif_btocs_rws_response~is_json_response.
    DATA(lv_content) = mv_content.
    CONDENSE lv_content.
    DATA(lv_len) = strlen( lv_content ).
    DATA(lv_last) = lv_len - 1.

    IF lv_len >= 2
      AND lv_content(1) CA '{['
      AND lv_content+lv_last(1) CA '}]'.
      rv_json = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_rws_response~set_from_client.

* ----- check client
    IF io_http_client IS INITIAL
      OR io_http_client->response IS INITIAL.
      zif_btocs_rws_response~set_reason( |invalid http response| ).
      RETURN.
    ENDIF.


* ------ set request
    IF io_http_client->request IS NOT INITIAL.
      mo_request = io_http_client->request.
    ENDIF.

* ------- set response
    mo_response = io_http_client->response.
    rv_success  = zif_btocs_rws_response~set_from_response( mo_response ).

  ENDMETHOD.


  METHOD zif_btocs_rws_response~set_from_response.
* ----- check
    IF io_http_response IS INITIAL.
      zif_btocs_rws_response~set_reason( |invalid response| ).
      RETURN.
    ENDIF.

* ----- get status
    CALL METHOD io_http_response->get_status
      IMPORTING
        code   = mv_status_code
        reason = mv_reason.
    get_logger( )->debug( |HTTP result: { mv_status_code } - { mv_reason }| ).

* ----- get content
    mv_content_type   = io_http_response->if_http_entity~get_content_type( ).
    mv_binary         = io_http_response->if_http_entity~get_data( ).
    mv_content        = io_http_response->if_http_entity~get_cdata( ).

    io_http_response->if_http_entity~get_data_length(
      IMPORTING
        data_length = mv_content_length
    ).

    io_http_response->if_http_entity~get_header_fields(
      CHANGING
        fields = mt_header
    ).
    io_http_response->if_http_entity~get_form_fields_cs(
      EXPORTING
        formfield_encoding = 0
        search_option      = 3
      CHANGING
        fields             = mt_form_fields
    ).


    rv_success = abap_true.

  ENDMETHOD.


  METHOD zif_btocs_rws_response~set_reason.
    IF iv_reason IS NOT INITIAL.
      mv_reason = iv_reason.
      get_logger( )->error( |Reason: { mv_reason }| ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_rws_response~set_status_code.
    mv_status_code = iv_status_code.
  ENDMETHOD.
ENDCLASS.
