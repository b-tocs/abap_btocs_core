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
  data MV_PATH_SEPARATOR type STRING value '/' ##NO_TEXT.
  data MV_TABLE_STYLE type STRING value 'table' ##NO_TEXT.
  data MV_STRUC_STYLE type STRING value 'list' ##NO_TEXT.
  data MV_TABLE_SEPARATOR type STRING value ',' ##NO_TEXT.
  data MV_STRUC_LIST_PREFIX type STRING value '-' ##NO_TEXT.
  data MO_DDIC_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .

  methods FORMAT_TEXT
    importing
      !IV_TEXT type STRING
      !IV_ALIGN type STRING default 'L'
      !IV_MAX_LEN type I
      !IV_ADD_SPACE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_TEXT) type STRING .
  methods RENDER_TABLE_CSV
    importing
      !IV_START_ROW type I default 1
      !IV_STOP_ROW type I
      !IO_TABLE_UTIL type ref to ZIF_BTOCS_UTIL_TABLE
      !IT_FIELDS type STRING_TABLE
    returning
      value(RT_LINES) type STRING_TABLE .
  methods RENDER_TABLE_MD
    importing
      !IV_START_ROW type I default 1
      !IV_STOP_ROW type I
      !IO_TABLE_UTIL type ref to ZIF_BTOCS_UTIL_TABLE
      !IT_FIELDS type STRING_TABLE
    returning
      value(RT_LINES) type STRING_TABLE .
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

* ------ init
    ro_self = me.


* ------ check level
    IF iv_max_level > 0
      AND iv_max_level < iv_current_level.
      get_logger( )->debug( |markdown add structure: max level { iv_max_level } reached| ).
      RETURN.
    ENDIF.


* ------ init and check
    DATA(lr_ut_struc) = zif_btocs_util_markdown~get_ddic_util( )->get_util_structure( ).
    IF lr_ut_struc->set_data(
      is_data = is_data
      iv_complex_mode = abap_false
    ) EQ abap_false.
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
* ------- check for header
        IF it_headers[] IS NOT INITIAL.
          READ TABLE it_headers ASSIGNING FIELD-SYMBOL(<ls_header>)
            WITH KEY key = iv_path.
          IF sy-subrc EQ 0 AND <ls_header>-value IS NOT INITIAL.
            zif_btocs_util_markdown~add_header_relative(
                iv_delta = iv_current_level
                iv_text  = <ls_header>-value
            ).
          ENDIF.
        ENDIF.


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
* ------- prepare
              DATA(lv_path) = iv_path.
              IF lv_path IS INITIAL.
                lv_path = <lv_fieldname>.
              ELSE.
                lv_path = |{ lv_path }{ mv_path_separator }{ <lv_fieldname> }|.
              ENDIF.

              DATA(lv_next_level) = iv_current_level + 1.

              DATA(lr_ut_field) = lr_ut_struc->get_field( <lv_fieldname> ).
              IF lr_ut_field IS INITIAL.
                get_logger( )->error( |field util for { <lv_fieldname> } not availabke for markdown add_structure| ).
              ELSE.
* ------- render field depending on general type
                IF lr_ut_field->is_structure( ) EQ abap_true.
                  ASSIGN COMPONENT <lv_fieldname> OF STRUCTURE is_data TO FIELD-SYMBOL(<ls_struc>).

                  zif_btocs_util_markdown~add_structure(
                    EXPORTING
                      is_data          = <ls_struc>                 " Table of Strings
                      iv_style         = iv_style
                      iv_no_empty      = iv_no_empty
                      iv_prefix        = iv_prefix
                      iv_separator     = iv_separator
                      iv_path          = lv_path
                      iv_current_level = lv_next_level
                      iv_max_level     = iv_max_level
                      it_headers       = it_headers                 " Key value tab
                  ).
                ELSEIF lr_ut_field->is_table( ) EQ abap_true.
                  FIELD-SYMBOLS: <lt_table> TYPE table.
                  ASSIGN COMPONENT <lv_fieldname> OF STRUCTURE is_data TO <lt_table>.
                  IF <lt_table> IS NOT INITIAL.
                    zif_btocs_util_markdown~add_table(
                        it_data          = <lt_table>
*                      iv_style         =
                        iv_no_empty      = iv_no_empty
                        iv_path          = lv_path
                        iv_current_level = lv_next_level
                        iv_max_level     = iv_max_level
                        it_headers       = it_headers
                    ).
                  ENDIF.
                ELSEIF lr_ut_field->is_not_printable( ) EQ abap_true.
                  get_logger( )->debug( |unprintable field { <lv_fieldname> } skipped| ).
                ELSE.
* -------- standard field printable
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


  METHOD zif_btocs_util_markdown~add_header_relative.

    DATA(lv_level) = mv_last_header_level + iv_delta.
    IF lv_level <= 0.
      lv_level = 1.
    ENDIF.

    ro_self = zif_btocs_util_markdown~add_hx(
          iv_text  = iv_text
          iv_level = lv_level
         iv_save_level = abap_false
    ).
  ENDMETHOD.


  METHOD format_text.

* ----- prepare
    rv_text = iv_text.
    DATA(lv_len) = strlen( rv_text ).
    DATA(lv_max) = COND #( WHEN iv_add_space EQ abap_false
                           THEN iv_max_len
                           ELSE iv_max_len - 2 ).
    IF lv_max <= 0.
      RETURN.
    ENDIF.

* ----- check max len
    IF lv_len > lv_max.
      rv_text = rv_text(lv_max).
    ENDIF.

* ----- check borders
    IF iv_add_space EQ abap_true.
      rv_text = | { rv_text } |.
    ENDIF.


* ------ alignment
    CASE iv_align.
      WHEN 'L'.
        DO.
          lv_len = strlen( rv_text ).
          IF lv_len >= iv_max_len.
            EXIT.
          ELSE.
            rv_text = |{ rv_text } |.
          ENDIF.
        ENDDO.

      WHEN 'R'.
        DO.
          lv_len = strlen( rv_text ).
          IF lv_len >= iv_max_len.
            EXIT.
          ELSE.
            rv_text = | { rv_text }|.
          ENDIF.
        ENDDO.
    ENDCASE.



  ENDMETHOD.


  METHOD render_table_csv.

* ---- open csv code section
    APPEND |```csv| TO rt_lines.
    DATA(lv_sep) = ','.

* ---- append header
    DATA(lv_header) = ||.
    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<lv_fieldname>).
      IF lv_header IS INITIAL.
        lv_header = <lv_fieldname>.
      ELSE.
        lv_header = |{ lv_header }{ lv_sep }{ <lv_fieldname> }|.
      ENDIF.
    ENDLOOP.
    APPEND lv_header TO rt_lines.


* ---- append rows
    DATA(lv_row) = iv_start_row.
    DO.
      IF lv_row > iv_stop_row.
        EXIT.
      ENDIF.

      DATA(lv_content) = ||.
      DATA(lt_content) = io_table_util->get_parsed_content_row( lv_row ).

      LOOP AT it_fields ASSIGNING <lv_fieldname>.
        DATA(lv_value) = ||.
        READ TABLE lt_content ASSIGNING FIELD-SYMBOL(<ls_cell>)
          WITH KEY fieldname = <lv_fieldname>.
        IF sy-subrc EQ 0.
          lv_value = <ls_cell>-value.
        ENDIF.

        IF lv_content IS INITIAL.
          lv_content = lv_value.
        ELSE.
          lv_content = |{ lv_content }{ lv_sep }{ lv_value }|.
        ENDIF.
      ENDLOOP.

      APPEND lv_content TO rt_lines.
      ADD 1 TO lv_row.
    ENDDO.


* ---- close csv code section
    APPEND |```| TO rt_lines.


  ENDMETHOD.


  METHOD render_table_md.


* ---- append header
    DATA(lv_sep) = '|'.
    DATA(lv_sep_line) = '-'.
    DATA(lv_header) = |{ lv_sep }|.
    DATA(lv_seprow) = |{ lv_sep }|.
    DATA(lt_meta) = io_table_util->get_parsed_metainfo( ).
    DATA lt_cols LIKE lt_meta.

    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<lv_fieldname>).

      READ TABLE lt_meta ASSIGNING FIELD-SYMBOL(<ls_meta>)
        WITH KEY fieldname = <lv_fieldname>.
      IF sy-subrc EQ 0.

*       get header text
        DATA(lv_text) = CONV string( <ls_meta>-scrtext_s ).
        IF lv_text IS INITIAL.
          lv_text = <ls_meta>-fieldname.
        ENDIF.

*       calc cell space
        DATA(lv_len) = strlen( lv_text ).
        IF <ls_meta>-max_text_len_all < lv_len.
          <ls_meta>-max_text_len_all = lv_len.
        ENDIF.
        ADD 2 TO <ls_meta>-max_text_len_all.

        APPEND <ls_meta> TO lt_cols.

*       format header and append
        lv_text = format_text(
                     iv_text    = lv_text
                     iv_align   = 'L'
                     iv_max_len = <ls_meta>-max_text_len_all
                     iv_add_space = abap_true
        ).
        lv_header = |{ lv_header }{ lv_text }{ lv_sep }|.

*       append header separator line
        DATA(lv_rsep) = ||.
        DO <ls_meta>-max_text_len_all TIMES.
          lv_rsep = |{ lv_rsep }{ lv_sep_line }|.
        ENDDO.
        lv_seprow = |{ lv_seprow }{ lv_rsep }{ lv_sep }|.

      ENDIF.
    ENDLOOP.
    APPEND lv_header TO rt_lines.
    APPEND lv_seprow TO rt_lines.


* ---- append rows
    DATA(lv_row) = iv_start_row.
    DO.
      IF lv_row > iv_stop_row.
        EXIT.
      ENDIF.

      DATA(lv_content) = |{ lv_sep }|.
      DATA(lt_content) = io_table_util->get_parsed_content_row( lv_row ).

      LOOP AT lt_cols ASSIGNING FIELD-SYMBOL(<ls_col>).
        DATA(lv_value) = ||.
        READ TABLE lt_content ASSIGNING FIELD-SYMBOL(<ls_cell>)
          WITH KEY fieldname = <ls_col>-fieldname.
        IF sy-subrc EQ 0.
          lv_value = <ls_cell>-value.
        ENDIF.

        lv_value = format_text(
                     iv_text    = lv_value
                     iv_align   = 'L'
                     iv_max_len = <ls_meta>-max_text_len_all
                     iv_add_space = abap_true
        ).


        lv_content = |{ lv_content }{ lv_value }{ lv_sep }|.
      ENDLOOP.

      APPEND lv_content TO rt_lines.
      ADD 1 TO lv_row.
    ENDDO.


  ENDMETHOD.


  METHOD zif_btocs_util_markdown~add_table.

* ----- init
    ro_self = me.
    IF it_data[] IS INITIAL.
      RETURN.
    ENDIF.

* ------ check level
    IF iv_max_level > 0
      AND iv_max_level < iv_current_level.
      get_logger( )->debug( |markdown add table: max level { iv_max_level } reached| ).
      RETURN.
    ENDIF.

* ------- parse table via util
    DATA(lr_util) = zif_btocs_util_markdown~get_ddic_util( )->get_util_table( ).
    IF lr_util->set_data(
      EXPORTING
        it_data       = it_data
        iv_store_data = abap_true
    ) EQ abap_false.
      get_logger( )->error( |markdown add table: no valid table format| ).
      RETURN.
    ENDIF.

    IF lr_util->parse( ) EQ abap_false.
      get_logger( )->error( |markdown add table: parse data failed| ).
      RETURN.
    ENDIF.

    DATA(lt_fields) = lr_util->get_fieldnames_not_empty( ).
    IF lt_fields[] IS INITIAL.
      get_logger( )->debug( |markdown add table: no filled columns| ).
      RETURN.
    ENDIF.

    DATA(lv_style) = COND #( WHEN iv_style IS NOT INITIAL
                             THEN iv_style
                             ELSE mv_table_style ).

* -------- render table
    DATA(lv_max)    = lines( it_data ).
    DATA(lt_lines)  = VALUE string_table( ).
    CASE lv_style.
      WHEN 'csv'.
        lt_lines = render_table_csv(
            iv_start_row  = 1
            iv_stop_row   = lv_max
            io_table_util = lr_util
            it_fields     = lt_fields
         ).
      WHEN 'table'.
        lt_lines = render_table_md(
            iv_start_row  = 1
            iv_stop_row   = lv_max
            io_table_util = lr_util
            it_fields     = lt_fields
         ).
      WHEN OTHERS.
        get_logger( )->error( |unknown or empty table style: { lv_style }| ).
    ENDCASE.


    IF lt_lines[] IS INITIAL.
      get_logger( )->error( |markdown add table: no table data rendered| ).
      RETURN.
    ENDIF.


* ------- check for header
    IF it_headers[] IS NOT INITIAL.
      READ TABLE it_headers ASSIGNING FIELD-SYMBOL(<ls_header>)
        WITH KEY key = iv_path.
      IF sy-subrc EQ 0 AND <ls_header>-value IS NOT INITIAL.
        zif_btocs_util_markdown~add_header_relative(
            iv_delta = iv_current_level
            iv_text  = <ls_header>-value
        ).
      ELSE.
        get_logger( )->debug( |Table header not found for path: { iv_path }| ).
        zif_btocs_util_markdown~add_empty_line( ).
      ENDIF.
    ENDIF.


* ------- insert table data
    zif_btocs_util_markdown~add_lines( lt_lines ).


  ENDMETHOD.


  METHOD zif_btocs_util_markdown~get_ddic_util.
    IF mo_ddic_util IS INITIAL.
      mo_ddic_util = zcl_btocs_factory=>create_ddic_util( ).
      mo_ddic_util->set_logger( get_logger( ) ).
    ENDIF.
    ro_util = mo_ddic_util.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_MARKDOWN~SET_DDIC_UTIL.
    mo_ddic_util = io_util.
  endmethod.


  method ZIF_BTOCS_UTIL_MARKDOWN~SET_LAST_HEADER_LEVEL.
    mv_last_header_level = iv_level.
    ro_self = me.
  endmethod.


  method ZIF_BTOCS_UTIL_MARKDOWN~SET_STYLE_STRUCTURE.
    mv_struc_style = iv_style.
    ro_self = me.
  endmethod.


  METHOD zif_btocs_util_markdown~set_style_table.
    mv_table_style = iv_style.
    ro_self = me.
  ENDMETHOD.
ENDCLASS.
