CLASS zcl_btocs_rws_request DEFINITION
  PUBLIC
  INHERITING FROM zcl_btocs_util_base
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_btocs_rws_request .
protected section.

  data MV_CONTENT type STRING .
  data MV_BINARY type XSTRING .
  data MV_CONTENT_TYPE type STRING .
  data MV_CONTENT_CODEPAGE type ABAP_ENCODING .
  data MT_HEADER type TIHTTPNVP .
  data MT_FORM_FIELDS type ZBTOCS_T_FORM_DATA .
  data MT_QUERY_PARAMS type TIHTTPNVP .
  data MV_FORM_FIELD_ENCODING type I .
  data MO_VALUE_MGR type ref to ZIF_BTOCS_VALUE_MGR .

  methods SET_FORM_DATA_TO_CLIENT
    importing
      !IO_HTTP_CLIENT type ref to IF_HTTP_CLIENT
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  PRIVATE SECTION.
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
      IF mv_content IS NOT INITIAL.
        io_http_client->request->if_http_entity~set_content_type( 'application/json' ).
      ENDIF.
    ELSE.
      io_http_client->request->if_http_entity~set_content_type( mv_content_type ).
    ENDIF.


* ------ set header
    IF mt_header[] IS NOT INITIAL.
      CALL METHOD io_http_client->request->if_http_entity~set_header_fields
        EXPORTING
          fields = mt_header.
*      LOOP AT mt_header ASSIGNING FIELD-SYMBOL(<ls_header>).
*        CALL METHOD io_http_client->request->if_http_entity~set_header_field
*          EXPORTING
*            name  = <ls_header>-name
*            value = <ls_header>-value.
*      ENDLOOP.
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
      IF set_form_data_to_client( io_http_client ) EQ abap_false.
        get_logger( )->warning( |set form fields data failed| ).
      ELSE.
        get_logger( )->debug( |form fields content set to client| ).
      ENDIF.
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


  METHOD zif_btocs_rws_request~set_header_fields.
    mt_header = it_header.
  ENDMETHOD.


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


  METHOD zif_btocs_rws_request~get_form_fields.
    LOOP AT mt_form_fields
      ASSIGNING FIELD-SYMBOL(<ls_form>)
      WHERE binary IS INITIAL.
      APPEND INITIAL LINE TO rt_fields ASSIGNING FIELD-SYMBOL(<ls_field>).
      MOVE-CORRESPONDING <ls_form> TO <ls_field>.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~get_header_fields.
    rt_header = mt_header.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~get_query_params.
    rt_params = mt_query_params.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_form_field.
*   check existing
    READ TABLE mt_form_fields ASSIGNING FIELD-SYMBOL(<ls_field>)
      WITH KEY name = iv_name.
    IF sy-subrc EQ 0.
      IF iv_overwrite EQ abap_false.
        RETURN.
      ENDIF.
    ELSE.
*   new data
      APPEND INITIAL LINE TO mt_form_fields ASSIGNING <ls_field>.
      <ls_field>-name  = iv_name.
      <ls_field>-value = iv_value.
    ENDIF.

*     change or set values
    <ls_field>-value  = iv_value.
    IF iv_binary IS NOT INITIAL.
      <ls_field>-binary         = iv_binary.
      <ls_field>-content_type   = iv_content_type.
      <ls_field>-filename       = iv_filename.
    ENDIF.

    rv_success = abap_true.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_form_type.
    IF iv_content_type IS NOT INITIAL.
      mv_content_type = iv_content_type.
    ENDIF.
    mv_form_field_encoding = iv_form_field_encoding.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_form_type_urlencoded.
    zif_btocs_rws_request~set_form_type(
         iv_content_type        = 'application/x-www-form-urlencoded'
         iv_form_field_encoding = zif_btocs_rws_request=>c_form_encoding-urlencoded
    ).
  ENDMETHOD.


  METHOD set_form_data_to_client.

* ------ check
    IF mt_form_fields[] IS INITIAL.
      get_logger( )->warning( |no form data found| ).
      RETURN.
    ENDIF.
    DATA(lt_form_fields) = zif_btocs_rws_request~get_form_fields( ).

* ------- set data
    CASE mv_form_field_encoding.
      WHEN zif_btocs_rws_request=>c_form_encoding-urlencoded.
        io_http_client->request->set_formfield_encoding( zif_btocs_rws_request=>c_form_encoding-urlencoded ).
        io_http_client->request->if_http_entity~set_form_fields( fields = lt_form_fields ).

      WHEN zif_btocs_rws_request=>c_form_encoding-multipart_formdata.
        io_http_client->request->set_formfield_encoding( zif_btocs_rws_request=>c_form_encoding-raw ).
        IF mv_content_type IS INITIAL.
          io_http_client->request->set_content_type( 'multipart/form-data' ).
        ENDIF.

        LOOP AT mt_form_fields ASSIGNING FIELD-SYMBOL(<ls_field>).

          DATA(lo_part) = io_http_client->request->if_http_entity~add_multipart( ).
          DATA(lv_filename)     = |file.bin|.
          DATA(lv_content_type) = |application/octet-stream|.
          DATA(lv_content_disp) = |form-data; name="{ <ls_field>-name }"|.

          IF <ls_field>-binary IS INITIAL.
            lo_part->set_cdata( <ls_field>-value ).
          ELSE.
            lo_part->set_data( <ls_field>-binary ).
            IF <ls_field>-content_type IS NOT INITIAL.
              lv_content_type = <ls_field>-content_type.
            ENDIF.
            IF <ls_field>-filename IS NOT INITIAL.
              lv_filename = <ls_field>-filename.
            ENDIF.
            lv_content_disp = |form-data; name="{ <ls_field>-name }"; filename="{ lv_filename }";|.
            lo_part->set_content_type( lv_content_type ).
          ENDIF.

          lo_part->set_header_field(
            name  = |Content-Disposition|
            value = lv_content_disp
          ).
        ENDLOOP.

      WHEN OTHERS.
        io_http_client->request->if_http_entity~set_form_fields( fields = lt_form_fields ).
        get_logger( )->warning( |no form encoding found| ).
    ENDCASE.


*   result
    get_logger( )->debug( |form data set to client| ).
    rv_success = abap_true.

  ENDMETHOD.


  METHOD zif_btocs_rws_request~add_form_field_file.
    rv_success = zif_btocs_rws_request~set_form_field(
                   iv_name          = iv_name
                   iv_binary        = iv_binary
                   iv_filename      = iv_filename
                   iv_content_type  = iv_content_type
                   iv_overwrite     = abap_false
                 ).
  ENDMETHOD.


  METHOD zif_btocs_rws_request~get_form_fields_with_bin.
    rt_fields = mt_form_fields.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~set_form_type_multipart.
    zif_btocs_rws_request~set_form_type(
         iv_content_type        = 'multipart/form-data'
         iv_form_field_encoding = zif_btocs_rws_request=>c_form_encoding-multipart_formdata
    ).
  ENDMETHOD.


  METHOD zif_btocs_rws_request~get_value_manager.
    IF mo_value_mgr IS INITIAL.
      mo_value_mgr = zcl_btocs_factory=>create_value_manager( ).
      mo_value_mgr->set_logger( get_logger( ) ).
    ENDIF.
    ro_mgr = mo_value_mgr.
  ENDMETHOD.


  METHOD zif_btocs_rws_request~new_json_array.
    ro_value = zif_btocs_rws_request~get_value_manager( )->new_json_array(
        is_options = is_options
    ).
  ENDMETHOD.


  method ZIF_BTOCS_RWS_REQUEST~NEW_JSON_OBJECT.
    ro_value = ZIF_BTOCS_RWS_REQUEST~get_value_manager( )->new_json_object(
        is_options = is_options
    ).
  endmethod.
ENDCLASS.
