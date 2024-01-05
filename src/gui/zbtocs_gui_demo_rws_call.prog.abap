*&---------------------------------------------------------------------*
*& Report ZBTOCS_GUI_DEMO_RWS_CALL
*&---------------------------------------------------------------------*
*& Call external webservice
*&---------------------------------------------------------------------*
REPORT zbtocs_gui_demo_rws_call.

* ------- interface
PARAMETERS: p_rfc TYPE rfcdest.
PARAMETERS: p_url TYPE mwc_url LOWER CASE.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_meth TYPE zbtocs_option_http_method DEFAULT 'GET'.
PARAMETERS: p_cntt TYPE zbtocs_content_type LOWER CASE.
PARAMETERS: p_cont TYPE zbtocs_content LOWER CASE.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_trace AS CHECKBOX TYPE zbtocs_flag_display_trace DEFAULT 'X'.


INITIALIZATION.
* --------- init client
  DATA(lr_ws_client) = zcl_btocs_factory=>create_web_service_client( ).
  DATA(lr_logger)    = lr_ws_client->get_logger( ).


START-OF-SELECTION.


* ---------- set endpoint
  IF p_rfc IS INITIAL AND p_url IS INITIAL.
    lr_logger->error( |enter rfc or url| ).
  ELSEIF p_rfc IS NOT INITIAL.
    lr_ws_client->set_endpoint_by_rfc_dest( p_rfc ).
    IF p_url IS NOT INITIAL.
      lr_ws_client->set_endpoint_path( CONV string( p_url ) ).
    ENDIF.
  ELSE.
    lr_ws_client->set_endpoint_by_url( CONV string( p_url ) ).
  ENDIF.

* ----------- prepare
  IF lr_ws_client->is_client_initialized( ) EQ abap_true.

* ---------- user input?
    DATA(lv_content) = p_cont.
    IF p_cntt IS NOT INITIAL
      AND lv_content IS INITIAL.
      cl_demo_input=>add_field(
        EXPORTING
          text        = 'Content'
        CHANGING
          field       = lv_content
      ).
      cl_demo_input=>request( ).
    ENDIF.

    IF lv_content IS NOT INITIAL.
      DATA(lo_request) = lr_ws_client->new_request( ).
      lo_request->set_data_encoded(
          iv_content_type = p_cntt
          iv_content      = lv_content
      ).
    ENDIF.


* ----------- execute
    DATA(lo_response) = lr_ws_client->execute( p_meth ).
    DATA(lv_response) = lo_response->get_content( ).
    DATA(lv_conttype) = lo_response->get_content_type( ).

    IF lv_response IS INITIAL.
      lr_logger->error( |no response| ).
    ELSE.
*      cl_demo_output=>begin_section
      cl_demo_output=>write_text( text = |Content-Type: { lv_conttype }| ).
      cl_demo_output=>write_html( lv_response ).
    ENDIF.
  ENDIF.

END-OF-SELECTION.

* ------------ cleanup
  DATA(lt_msg) = lr_logger->get_messages( ).
  lr_ws_client->destroy( ).

* ------------ display trace
  IF p_trace = abap_true
    AND lt_msg[] IS NOT INITIAL.
    cl_demo_output=>write_data(
      value   = lt_msg
      name    = 'Trace'
    ).
  ENDIF.

* ------------ display data
  cl_demo_output=>display( ).
