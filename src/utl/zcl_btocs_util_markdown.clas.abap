class ZCL_BTOCS_UTIL_MARKDOWN definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_MARKDOWN .
  interfaces ZIF_BTOCS_EXIT_RENDER_HTML .
protected section.

  data MT_LINES type STRING_TABLE .
  data MV_LINE type STRING .
  data MV_END_OF_LINE type STRING value '\n' ##NO_TEXT.
  data MV_EMPTY_LINE_AFTER_HEADER type ABAP_BOOL value ABAP_TRUE ##NO_TEXT.
  data MO_PARAMS type ref to ZIF_BTOCS_VALUE_STRUCTURE .
  data MV_LAST_HEADER_LEVEL type I .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_MARKDOWN IMPLEMENTATION.


  method ZIF_BTOCS_UTIL_MARKDOWN~ADD.
    append mv_line to mt_lines.
    clear mv_line.
    ro_self = me.
  endmethod.


  method ZIF_BTOCS_UTIL_MARKDOWN~ADD_EMPTY_LINE.
    append || to mt_lines.
    ro_self = me.
  endmethod.


  METHOD zif_btocs_util_markdown~add_h1.
    ro_self = ZIF_BTOCS_UTIL_MARKDOWN~add_hx(
        iv_text  = iv_text
        iv_level = 1
    ).
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_MARKDOWN~ADD_H2.
    ro_self = ZIF_BTOCS_UTIL_MARKDOWN~add_hx(
        iv_text  = iv_text
        iv_level = 2
    ).
  endmethod.


  METHOD zif_btocs_util_markdown~add_h3.
    ro_self = zif_btocs_util_markdown~add_hx(
        iv_text  = iv_text
        iv_level = 3
    ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~add_h4.
    ro_self = ZIF_BTOCS_UTIL_MARKDOWN~add_hx(
        iv_text  = iv_text
        iv_level = 4
    ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~add_header.
    DATA(lv_len) = strlen( iv_text ).
    IF lv_len > 0.
      zif_btocs_util_markdown~add_empty_line( ).
      zif_btocs_util_markdown~add_text( iv_text ).
      DATA(lv_row_sep) = zif_btocs_util_markdown~get_row_separator(
        iv_text  = '='
        iv_count = lv_len
      ).
      zif_btocs_util_markdown~add_text( lv_row_sep ).
      IF mv_empty_line_after_header EQ abap_true.
        zif_btocs_util_markdown~add_empty_line( ).
      ENDIF.
      mv_last_header_level = 1.
    ENDIF.
    ro_self = me.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_MARKDOWN~ADD_LINES.
    append LINES OF it_lines to mt_lines.
    ro_self = me.
  endmethod.


  METHOD zif_btocs_util_markdown~add_row_separator.
    DATA(lv_sep) = zif_btocs_util_markdown~get_row_separator(
                                     iv_text      = iv_text
                                     iv_count     = iv_count
    ).

    zif_btocs_util_markdown~add_text( lv_sep ).
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~add_subheader.
    DATA(lv_len) = strlen( iv_text ).
    IF lv_len > 0.
      zif_btocs_util_markdown~add_empty_line( ).
      zif_btocs_util_markdown~add_text( iv_text ).
      DATA(lv_row_sep) = zif_btocs_util_markdown~get_row_separator(
        iv_text  = '-'
        iv_count = lv_len
      ).
      zif_btocs_util_markdown~add_text( lv_row_sep ).
      IF mv_empty_line_after_header EQ abap_true.
        zif_btocs_util_markdown~add_empty_line( ).
      ENDIF.
      mv_last_header_level = 2.
    ENDIF.
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~add_text.
* ---- prepare separator
    DATA(lt_lines) = VALUE string_table( ).
    DATA(lv_sep) = COND #( WHEN iv_line_separator IS NOT INITIAL
                           THEN iv_line_separator
                           ELSE mv_end_of_line ).

* ---- append
    IF NOT iv_text CS lv_sep.
      APPEND iv_text TO mt_lines.
    ELSE.
      SPLIT iv_text
         AT lv_sep
       INTO TABLE lt_lines.
      APPEND LINES OF lt_lines TO mt_lines.
    ENDIF.

* ----- return myself
    ro_self = me.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_MARKDOWN~GET_END_OF_LINE.
    rv_eol = mv_end_of_line.
  endmethod.


  method ZIF_BTOCS_UTIL_MARKDOWN~GET_LINE.
    rv_line = mv_line.
  endmethod.


  method ZIF_BTOCS_UTIL_MARKDOWN~GET_LINES.
    rt_lines = mt_lines.
  endmethod.


  METHOD zif_btocs_util_markdown~get_lines_count.
    rv_count = lines( mt_lines ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~get_line_count.
    rv_count = strlen( mv_line ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~get_markdown.

    DATA(lv_sep) = COND #( WHEN iv_line_separator IS NOT INITIAL
                           THEN iv_line_separator
                           ELSE mv_end_of_line ).

    LOOP AT mt_lines ASSIGNING FIELD-SYMBOL(<lv_line>).
      IF sy-tabix = 1.
        rv_markdown = <lv_line>.
      ELSE.
        rv_markdown = |{ rv_markdown }{ lv_sep }{ <lv_line> }|.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~get_row_separator.
    IF iv_count > 0.
      DO iv_count TIMES.
        rv_separator = |{ rv_separator }{ iv_text }|.
      ENDDO.
    ELSE.
      rv_separator = iv_text.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_MARKDOWN~RESET.
    clear: mt_lines,
           mv_line,
           mv_last_header_level.
  endmethod.


  METHOD zif_btocs_util_markdown~set_end_of_line.
    IF iv_eol IS NOT INITIAL.
      mv_end_of_line = iv_eol.
    ENDIF.
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~set_line.
    mv_line = iv_line.
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~set_markdown.
    zif_btocs_util_markdown~reset( ).
    zif_btocs_util_markdown~add_text( iv_markdown ).
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_exit_render_html~render.
* -------- top
    IF iv_complete EQ abap_true.
      rv_html = rv_html && |<html><body>|.
    ENDIF.

* -------- included scripts
    DATA(lv_input) = iv_input.

* -------- body
    rv_html = rv_html && |<div id="content"></div>|.
    rv_html = rv_html && |<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>|.
    rv_html = rv_html && |<script>|.
    rv_html = rv_html && |var sMarkdown = '{ lv_input }';|.
    rv_html = rv_html && |document.getElementById('content').innerHTML = marked.parse(sMarkdown);|.
    rv_html = rv_html && |</script>|.

* -------- bottom
    IF iv_complete EQ abap_true.
      rv_html = rv_html && |</body></html>|.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_util_markdown~add_code_lines.

    IF it_code IS NOT INITIAL OR iv_code_type IS NOT INITIAL.
      DATA(lt_lines) = VALUE string_table( ).
      APPEND |```{ iv_code_type }| TO lt_lines.
      APPEND LINES OF it_code TO lt_lines.
      APPEND |```| TO lt_lines.

      zif_btocs_util_markdown~add_lines( lt_lines ).
    ENDIF.
    ro_self = me.

  ENDMETHOD.


  METHOD zif_btocs_util_markdown~add_hx.
    DATA(lv_len) = strlen( iv_text ).
    IF lv_len > 0 AND iv_level > 0.
      zif_btocs_util_markdown~add_empty_line( ).
      DATA(lv_prefix) = zif_btocs_util_markdown~get_row_separator(
                          iv_text  = '#'
                          iv_count = iv_level
                        ).
      zif_btocs_util_markdown~add_text( |{ lv_prefix } { iv_text }| ).
      IF mv_empty_line_after_header EQ abap_true.
        zif_btocs_util_markdown~add_empty_line( ).
      ENDIF.

      IF iv_save_level = abap_true.
        mv_last_header_level = iv_level.
      ENDIF.
    ENDIF.
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~bold.
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = |**{ iv_text }**|
        iv_check_space_before = iv_check_space_before
        iv_add_space_after    = iv_add_space_after
    ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~bold_italic.
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = |***{ iv_text }***|
        iv_check_space_before = iv_check_space_before
        iv_add_space_after    = iv_add_space_after
    ).
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_MARKDOWN~CODE.
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = |`{ iv_text }`|
        iv_check_space_before = iv_check_space_before
        iv_add_space_after    = iv_add_space_after
    ).
  endmethod.


  METHOD zif_btocs_util_markdown~get_last_char.
    IF iv_in IS INITIAL.
      RETURN.
    ELSE.
      DATA(lv_off) = strlen( iv_in ) - 1.
      rv_last = iv_in+lv_off(1).
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~get_last_header_level.
    rv_level = mv_last_header_level.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~get_parameters.
    IF mo_params IS INITIAL.
      DATA(lo_mgr) = zcl_btocs_factory=>create_value_manager( ).
      lo_mgr->set_logger( get_logger( ) ).
      mo_params = lo_mgr->new_json_object( ).
    ENDIF.
    ro_params = mo_params.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~italic.
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = |*{ iv_text }*|
        iv_check_space_before = iv_check_space_before
        iv_add_space_after    = iv_add_space_after
    ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~set.
    IF iv_text IS NOT INITIAL.

* check before
      IF iv_check_space_before EQ abap_true
        AND mv_line IS NOT INITIAL.
        DATA(lv_last) = zif_btocs_util_markdown~get_last_char( mv_line ).
        IF lv_last IS NOT INITIAL AND lv_last NE | |.
          mv_line = mv_line && | |.
        ENDIF.
      ENDIF.

* append text
      mv_line = mv_line && iv_text.

* check after
      IF iv_add_space_after EQ abap_true
        AND mv_line IS NOT INITIAL.
        lv_last = zif_btocs_util_markdown~get_last_char( mv_line ).
        IF lv_last IS NOT INITIAL AND lv_last NE | |.
          mv_line = mv_line && | |.
        ENDIF.
      ENDIF.


    ENDIF.

    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~text.
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = iv_text
        iv_check_space_before = iv_check_space_before
        iv_add_space_after    = iv_add_space_after
    ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~to_html.

* ------ init exit
    DATA(lo_exit) = io_exit.
    IF lo_exit IS INITIAL
      AND iv_exit_name IS NOT INITIAL.
      lo_exit ?= zcl_btocs_factory=>create_instance( iv_exit_name ).
    ENDIF.
    IF lo_exit IS INITIAL.
      lo_exit ?= me.
    ENDIF.

* ------- render now
    DATA(lv_markdown) = zif_btocs_util_markdown~to_string(
*      iv_line_separator = |<br>|
    ).

    rv_html = lo_exit->render(
        iv_input    = lv_markdown
        io_params   = zif_btocs_util_markdown~get_parameters( )
        iv_complete = iv_complete
    ).

  ENDMETHOD.


  METHOD zif_btocs_util_markdown~to_string.
    rv_string = zif_btocs_util_markdown~get_markdown( iv_line_separator ).
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_MARKDOWN~ADD_IMAGE.
* ------ prepare
    DATA(lv_text) = COND #( WHEN iv_text IS NOT INITIAL
                            THEN iv_text
                            ELSE iv_url ).
    DATA(lv_line) = |{ iv_prefix }![{ lv_text }]({ iv_url })|.

* ------ append
    APPEND lv_line to mt_lines.

    ro_self = me.
  endmethod.


  METHOD zif_btocs_util_markdown~add_structure.

* ------ init and check
    DATA(lr_ut_struc) = zcl_btocs_factory=>create_ddic_structure_util( ).
    IF lr_ut_struc->set_data( is_data ) EQ abap_false.
      get_logger( )->error( |invalid structure for markdown add_structure| ).
    ELSE.
* ------ get fieldnames
      IF iv_no_empty EQ abap_false.
        DATA(lt_fields) = lr_ut_struc->get_fieldnames( ).
      ELSE.
        lt_fields = lr_ut_struc->get_fieldnames_not_empty( ).
      ENDIF.



      IF lt_fields[] IS INITIAL.
        get_logger( )->error( |no valid fields found in structure for markdown add_structure| ).
      ELSE.
* ------- preparations
        DATA(lv_prefix) =    COND #( WHEN iv_prefix IS INITIAL
                                  THEN ||
                                  ELSE |{ iv_prefix } | ).

        DATA(lv_separator) = COND #( WHEN iv_separator IS INITIAL
                                  THEN ||
                                  ELSE |{ iv_separator } | ).
* ------- loop all field
        CASE iv_style.
          WHEN OTHERS.
            LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<lv_fieldname>).
              DATA(lr_ut_field) = lr_ut_struc->get_field( <lv_fieldname> ).
              IF lr_ut_field IS INITIAL.
                get_logger( )->error( |field util for { <lv_fieldname> } not availabke for markdown add_structure| ).
              ELSE.
                DATA(lv_line) = lv_prefix.
                DATA(lv_label) = lr_ut_field->get_label( ).
                DATA(lv_value) = lr_ut_field->get_value( ).
                DATA(lv_desc)  = lr_ut_field->get_value_text( ).
                IF lv_desc IS NOT INITIAL.
                  lv_line = lv_line && lv_label && lv_separator && lv_desc && ' (' && lv_value && ')'.
                ELSE.
                  lv_line = lv_line && lv_label && lv_separator && lv_value.
                ENDIF.
                zif_btocs_util_markdown~add_text( lv_line ).
              ENDIF.
            ENDLOOP.
        ENDCASE.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD zif_btocs_util_markdown~close.
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = |{ iv_char }|
        iv_check_space_before = abap_false
        iv_add_space_after    = abap_false
    ).
  ENDMETHOD.


  METHOD zif_btocs_util_markdown~image.

* ------ prepare
    DATA(lv_text) = COND #( WHEN iv_text IS NOT INITIAL
                            THEN iv_text
                            ELSE iv_url ).
    DATA(lv_line) = |![{ lv_text }]({ iv_url })|.

* ------ insert
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = lv_line
        iv_check_space_before = iv_check_space_before
        iv_add_space_after    = iv_add_space_after
    ).

    ro_self = me.

  ENDMETHOD.


  METHOD zif_btocs_util_markdown~link.
* ------ prepare
    DATA(lv_text) = COND #( WHEN iv_text IS NOT INITIAL
                            THEN iv_text
                            ELSE iv_url ).
    DATA(lv_line) = |[{ lv_text }]({ iv_url }|.
    IF iv_desc IS NOT INITIAL.
      lv_line = lv_line && | "{ iv_desc }"|.
    ENDIF.
    lv_line = lv_line && ')'.

* ------ insert
    ro_self = zif_btocs_util_markdown~set(
        iv_text               = lv_line
        iv_check_space_before = iv_check_space_before
        iv_add_space_after    = iv_add_space_after
    ).

    ro_self = me.
  ENDMETHOD.
ENDCLASS.
