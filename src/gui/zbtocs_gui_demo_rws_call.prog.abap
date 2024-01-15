*&---------------------------------------------------------------------*
*& Report ZBTOCS_GUI_DEMO_RWS_CALL
*&---------------------------------------------------------------------*
*& Call external webservice
*&---------------------------------------------------------------------*
REPORT zbtocs_gui_demo_rws_call.

* ------- interface
PARAMETERS: p_rfc TYPE rfcdest.
PARAMETERS: p_url TYPE mwc_url LOWER CASE.
PARAMETERS: p_prf TYPE zbtocs_rws_profile.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_meth TYPE zbtocs_option_http_method DEFAULT 'GET'.
PARAMETERS: p_cntt TYPE zbtocs_content_type LOWER CASE.
PARAMETERS: p_cont TYPE zbtocs_content LOWER CASE.
SELECTION-SCREEN: ULINE.
PARAMETERS: pclipbd AS CHECKBOX TYPE zbtocs_flag_clipboard_input DEFAULT 'X'.
PARAMETERS: p_encod AS CHECKBOX TYPE zbtocs_flag_encode_data DEFAULT 'X'.
PARAMETERS: p_trace AS CHECKBOX TYPE zbtocs_flag_display_trace DEFAULT 'X'.



INITIALIZATION.
* --------- report util
  DATA(lo_gui_utils) = zcl_btocs_factory=>create_gui_util( ).
  DATA(lo_logger)    = lo_gui_utils->get_logger( ).


* --------- init client
  DATA(lo_ws_client) = zcl_btocs_factory=>create_web_service_client( ).
  lo_ws_client->set_logger( lo_logger ).


START-OF-SELECTION.


* ---------- set endpoint
  IF p_rfc IS INITIAL AND p_url IS INITIAL.
    lo_logger->error( |enter rfc or url| ).
  ELSEIF p_rfc IS NOT INITIAL.
    lo_ws_client->set_endpoint_by_rfc_dest( p_rfc ).
    IF p_url IS NOT INITIAL.
      lo_ws_client->set_endpoint_path( CONV string( p_url ) ).
      IF p_prf IS NOT INITIAL.
        lo_ws_client->set_config_by_profile( p_prf ).
      ENDIF.
    ENDIF.
  ELSE.
    lo_ws_client->set_endpoint_by_url(
      iv_url = CONV string( p_url )
      iv_profile = p_prf
    ).
  ENDIF.

* ----------- prepare
  IF lo_ws_client->is_client_initialized( ) EQ abap_true.

* ---------- user input?
    DATA(lv_content) = lo_gui_utils->get_input_with_clipboard(
        iv_current   = p_cont
        iv_clipboard = abap_true
        iv_longtext  = abap_true
    ).

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
      DATA(lo_request) = lo_ws_client->new_request( ).
      IF p_encod EQ abap_true.
        lo_request->set_data_encoded(
            iv_content_type = p_cntt
            iv_content      = lv_content
        ).
      ELSE.
        lo_request->set_data(
            iv_content_type = p_cntt
            iv_content      = lv_content
        ).
      ENDIF.
    ENDIF.


* ----------- execute
    DATA(lo_response) = lo_ws_client->execute( iv_method = p_meth ).
    DATA(lv_response) = lo_response->get_content( ).
    DATA(lv_conttype) = lo_response->get_content_type( ).

    IF lv_response IS INITIAL.
      lo_logger->error( |no response| ).
    ELSE.
      cl_demo_output=>begin_section( title = |Response| ).
      cl_demo_output=>write_text( text = |Content-Type: { lv_conttype }| ).
      cl_demo_output=>write_html( lv_response ).
      cl_demo_output=>end_section( ).
    ENDIF.
  ENDIF.

END-OF-SELECTION.

* ------------ cleanup
  DATA(lt_msg) = lo_logger->get_messages( ).
  lo_ws_client->destroy( ).

* ------------ display trace
  IF p_trace = abap_true
    AND lt_msg[] IS NOT INITIAL.
    cl_demo_output=>begin_section( title = |Trace| ).
    cl_demo_output=>write_data(
      value   = lt_msg
      name    = 'Trace'
    ).
    cl_demo_output=>end_section( ).
  ENDIF.

* ------------ display data
  cl_demo_output=>display( ).
