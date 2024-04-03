*&---------------------------------------------------------------------*
*& Report ZBTOCS_GUI_DEMO_BOD_GEN
*&---------------------------------------------------------------------*
*& Demo for usage the Business Object Document Generation
*&---------------------------------------------------------------------*
REPORT zbtocs_gui_demo_bod_gen.

PARAMETERS: p_bodt TYPE zbtocs_bod_type OBLIGATORY DEFAULT 'BUPA'.
PARAMETERS: p_boid TYPE zbtocs_bod_id   OBLIGATORY.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_proto AS CHECKBOX TYPE zbtocs_flag_protocol         DEFAULT 'X'.
PARAMETERS: p_trace AS CHECKBOX TYPE zbtocs_flag_display_trace    DEFAULT 'X'.


INITIALIZATION.

* ------ init tools
  DATA(lo_report) = zcl_btocs_factory=>create_gui_util( ).
  DATA(lo_logger) = lo_report->get_logger( ).

* ----- create a builder instance
  DATA(lo_bod_mgr) = zcl_btocs_factory=>create_bo_document_manager( ).
  lo_bod_mgr->set_logger( lo_logger ).

* ----- creare markdown util
  DATA(lo_md)      = zcl_btocs_factory=>create_markdown_util( ).
  lo_md->set_logger( lo_logger ).


START-OF-SELECTION.

* ------ get a renderer
  DATA(lo_bod_rnd) = lo_bod_mgr->get_renderer(
                   iv_type    = p_bodt
                   iv_id      = p_boid
*                   it_context =                  " Key value tab
                 ).
  IF lo_bod_rnd IS INITIAL.
    lo_logger->error( |no renderer found| ).
  ELSE.
* ------ render now
    DATA(lo_bod_doc) = lo_bod_rnd->render( ).
    IF lo_bod_doc IS INITIAL.
      lo_logger->error( |no document rendered| ).
    ELSE.
      DATA(lv_md)      = lo_bod_doc->get_content( ).
      IF lv_md IS INITIAL.
        lo_logger->error( |no document content rendered| ).
      ELSE.
* ----- transform to html
        lo_md->set_markdown( lv_md ).
        DATA(lv_html) = lo_md->to_html( ).
        cl_demo_output=>write_html( lv_html ).
      ENDIF.
    ENDIF.
  ENDIF.

END-OF-SELECTION.

* ------------ cleanup
  DATA(lt_msg) = lo_logger->get_messages(
    iv_no_trace = COND #( WHEN p_trace EQ abap_true
                          THEN abap_false
                          ELSE abap_true )
  ).

* ------------ display trace
  IF p_proto = abap_true
    AND lt_msg[] IS NOT INITIAL.
    cl_demo_output=>begin_section( title = |Protocol| ).
    cl_demo_output=>write_data(
      value   = lt_msg
      name    = 'Messages'
    ).
    cl_demo_output=>end_section( ).
  ENDIF.

* ------------ display data
  cl_demo_output=>display( ).
