FUNCTION z_btocs_core_utl_proxy_f4_get.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_TABLE) TYPE  TABNAME
*"     VALUE(IV_FIELD) TYPE  FIELDNAME
*"  EXPORTING
*"     VALUE(EV_ERROR) TYPE  STRING
*"     VALUE(EV_SUBRC) TYPE  SYSUBRC
*"     VALUE(ET_F4) TYPE  ZBTOCS_T_F4
*"----------------------------------------------------------------------

* ------ local data
  DATA: lt_results        TYPE TABLE OF ddshretval.
  DATA: ls_results        TYPE ddshretval.
  DATA: lv_old_recordpos  TYPE recordpos.
  DATA: lv_tabfld         TYPE string.
  DATA: lv_first          TYPE abap_bool.
  DATA: lv_filled         TYPE abap_bool.
  DATA: ls_f4             LIKE LINE OF et_f4.

* ------ call api
  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname             = iv_table
      fieldname           = iv_field
      display             = ' '
      suppress_recordlist = 'X'
    TABLES
      return_tab          = lt_results
    EXCEPTIONS
      field_not_found     = 1
      no_help_for_field   = 2
      inconsistent_help   = 3
      no_values_found     = 4
      OTHERS              = 5.

  ev_subrc = sy-subrc.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        ev_error = |field unknown { iv_field }|.
      WHEN 2.
        ev_error = |no standard search help found for { iv_table }/{ iv_field }|.
      WHEN 3.
        ev_error = |search help is wrong for { iv_table }/{ iv_field }|.
      WHEN 4.
        ev_error = |no values determined for { iv_table }/{ iv_field }|.
      WHEN OTHERS.
        ev_error = |unknown error calling search help for { iv_table }/{ iv_field }|.
    ENDCASE.
    RETURN.
  ENDIF.


* ------ loop
  lv_old_recordpos = 0000.
  lv_tabfld = |{ iv_table }-{ iv_field }|.

  DATA(lv_iso)     = VALUE laiso( ).
  CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
    EXPORTING
      input  = sy-langu
    IMPORTING
      output = lv_iso.
  ls_f4-lang = lv_iso.



  LOOP AT lt_results INTO ls_results.

    IF ls_results-recordpos NE lv_old_recordpos.
*     ignore additional fields
      IF ls_results-retfield NE lv_tabfld.
        CONTINUE.
      ENDIF.
*     check existing/filled entry
      IF lv_filled = 'X'.
        APPEND ls_f4 TO et_f4.
        CLEAR: ls_f4-text,
               ls_f4-code.
      ENDIF.
      lv_first = 'X'.
      lv_filled = 'X'.
      lv_old_recordpos = ls_results-recordpos.
      ls_f4-code = ls_results-fieldval.
    ELSE.
      IF NOT ls_results-fieldval IS INITIAL.
        ls_f4-text = ls_results-fieldval.
      ENDIF.
      CLEAR lv_first.
    ENDIF.
  ENDLOOP.

* ----- last append
  IF lv_filled = 'X'.
    APPEND ls_f4 TO et_f4.
  ENDIF.


ENDFUNCTION.
