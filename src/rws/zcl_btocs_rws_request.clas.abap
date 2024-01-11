class ZCL_BTOCS_RWS_REQUEST definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_RWS_REQUEST .
protected section.

  data MV_CONTENT type STRING .
  data MV_BINARY type XSTRING .
  data MV_CONTENT_TYPE type STRING .
  data MV_CONTENT_CODEPAGE type ABAP_ENCODING .
  data MT_HEADER type TIHTTPNVP .
  data MT_FORM_FIELDS type TIHTTPNVP .
  data MT_QUERY_PARAMS type TIHTTPNVP .
  data MV_FORM_FIELD_ENCODING type I .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_RWS_REQUEST IMPLEMENTATION.


  METHOD zif_btocs_rws_request~add_header_field.
    rv_success = zif_btocs_rws_request~set_header_field(
                   iv_name      = iv_name
                   iv_value     = iv_value
                   iv_overwrite = abap_false
                 ).
  ENDMETHOD.


  METHOD zif_btocs_rws_request~clear.
    CLEAR: mv_content,
           mv_content_type,
           mv_binary,
           mt_form_fields,
           mt_query_params,
           mt_header.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_client.

* ------ set content type
    IF mv_content_type IS INITIAL.
      io_http_client->request->if_http_entity~set_content_type( 'application/json' ).
    ELSE.
      io_http_client->request->if_http_entity~set_content_type( mv_content_type ).
    ENDIF.


* ------ set header
    IF mt_header[] IS NOT INITIAL.
*      CALL METHOD io_http_client->request->if_http_entity~set_header_fields
*        EXPORTING
*          fields = mt_header.
      LOOP AT mt_header ASSIGNING FIELD-SYMBOL(<ls_header>).
        CALL METHOD io_http_client->request->if_http_entity~set_header_field
          EXPORTING
            name  = <ls_header>-name
            value = <ls_header>-value.
      ENDLOOP.
    ENDIF.


* ------ set content
    IF mv_binary IS NOT INITIAL.
* -------- binary data
      CALL METHOD io_http_client->request->if_http_entity~set_data
        EXPORTING
          data = mv_binary.
      get_logger( )->debug( |binary content set to client| ).
    ELSEIF mv_content IS NOT INITIAL.
* -------- text content
      CALL METHOD io_http_client->request->if_http_entity~set_cdata
        EXPORTING
          data = mv_content.
      get_logger( )->debug( |char data content set to client| ).
    ELSEIF mt_form_fields[] IS NOT INITIAL.
* -------- form data
      IF mv_form_field_encoding IS INITIAL.
        get_logger( )->warning( |no form encoding found| ).
      ELSE.
        io_http_client->request->set_formfield_encoding( mv_form_field_encoding ).
      ENDIF.

      CALL METHOD io_http_client->request->if_http_entity~set_form_fields
        EXPORTING
          fields = mt_form_fields
*         multivalue = 0
        .
      get_logger( )->debug( |form fields content set to client| ).
    ELSE.
* -------- no content found
      get_logger( )->debug( |no content to set to client| ).
    ENDIF.

    rv_success = abap_true.

  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_data.
    zif_btocs_rws_request~clear( ).
    mv_content_type = iv_content_type.
    mv_binary = iv_binary.
    mv_content = iv_content.
    rv_success = abap_true.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_header_field.
    READ TABLE mt_header ASSIGNING FIELD-SYMBOL(<ls_header>)
      WITH KEY name = iv_name.
    IF sy-subrc EQ 0.
      IF iv_overwrite EQ abap_false.
        RETURN.
      ENDIF.
      <ls_header>-value = iv_value.
    ELSE.
      APPEND INITIAL LINE TO mt_header ASSIGNING <ls_header>.
      <ls_header>-name  = iv_name.
      <ls_header>-value = iv_value.
    ENDIF.

    rv_success = abap_true.
  ENDMETHOD.


  method ZIF_BTOCS_RWS_REQUEST~SET_HEADER_FIELDS.
    mt_header = it_header.
  endmethod.


  METHOD zif_btocs_rws_request~set_data_encoded.

* --------- prepare
    DATA lv_binary TYPE xstring.
    DATA lv_mimetype(50).

* --------- encode
    IF iv_codepage IS NOT INITIAL
      AND iv_content IS NOT INITIAL.

      lv_mimetype = iv_content_type.

      CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
        EXPORTING
          text     = iv_content
          mimetype = lv_mimetype
          encoding = iv_codepage
        IMPORTING
          buffer   = lv_binary
        EXCEPTIONS
          failed   = 1
          OTHERS   = 2.
      IF sy-subrc EQ 0
        AND lv_binary IS NOT INITIAL.
        mv_binary  = lv_binary.
        mv_content_type = iv_content_type.
        CLEAR mv_content.
        get_logger( )->debug( |content set with encoding| ).
        rv_success = abap_true.
        RETURN.
      ENDIF.
    ENDIF.

* ------- error
    get_logger( )->error( |set encoded content failed| ).


  ENDMETHOD.


  METHOD zif_btocs_rws_request~add_query_param.
    READ TABLE mt_query_params ASSIGNING FIELD-SYMBOL(<ls_param>)
      WITH KEY name = iv_name.
    IF sy-subrc NE 0.
      APPEND INITIAL LINE TO mt_query_params ASSIGNING <ls_param>.
    ENDIF.

    <ls_param>-name   = iv_name.
    <ls_param>-value  = iv_value.
    rv_success        = abap_true.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~add_form_field.
    rv_success = zif_btocs_rws_request~set_form_field(
                   iv_name      = iv_name
                   iv_value     = iv_value
                   iv_overwrite = abap_false
                 ).
  ENDMETHOD.


  METHOD zif_btocs_rws_request~add_form_fields.

    rv_success = abap_true.
    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<ls_field>).
      IF zif_btocs_rws_request~set_form_field(
           iv_name      = <ls_field>-name
           iv_value     = <ls_field>-value
           iv_overwrite = abap_false
         ) EQ abap_false.
        rv_success = abap_false.
        get_logger( )->error( |set value to form field { <ls_field>-name } failed| ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  method ZIF_BTOCS_RWS_REQUEST~GET_FORM_FIELDS.
    rt_fields = mt_form_fields.
  endmethod.


  method ZIF_BTOCS_RWS_REQUEST~GET_HEADER_FIELDS.
    rt_header = mt_header.
  endmethod.


  METHOD zif_btocs_rws_request~get_query_params.
    rt_params = mt_query_params.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_form_data_type.
    IF iv_content_type IS NOT INITIAL.
      mv_content_type = iv_content_type.
    ENDIF.
    IF iv_form_field_encoding IS NOT INITIAL.
      mv_form_field_encoding = iv_form_field_encoding.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_RWS_REQUEST~SET_FORM_FIELD.
    READ TABLE mt_form_fields ASSIGNING FIELD-SYMBOL(<ls_field>)
      WITH KEY name = iv_name.
    IF sy-subrc EQ 0.
      IF iv_overwrite EQ abap_false.
        RETURN.
      ENDIF.
      <ls_field>-value = iv_value.
    ELSE.
      APPEND INITIAL LINE TO mt_form_fields ASSIGNING <ls_field>.
      <ls_field>-name  = iv_name.
      <ls_field>-value = iv_value.
    ENDIF.

    rv_success = abap_true.
  endmethod.


  METHOD zif_btocs_rws_request~set_form_type.
    IF iv_content_type IS NOT INITIAL.
      mv_content_type = iv_content_type.
    ENDIF.
    IF iv_form_field_encoding IS NOT INITIAL.
      mv_form_field_encoding = iv_form_field_encoding.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_form_type_urlencoded.
    zif_btocs_rws_request~set_form_type(
         iv_content_type        = 'application/x-www-form-urlencoded'
         iv_form_field_encoding = if_http_entity=>co_formfield_encoding_encoded
    ).

  ENDMETHOD.
ENDCLASS.
