class ZCL_BTOCS_UTIL_DDIC definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_DDIC .
protected section.

  class-data GT_F4_CACHE type ZBTOCS_T_F4_CACHE .
  data MO_UTIL_TABLE type ref to ZIF_BTOCS_UTIL_TABLE .
  data MO_UTIL_STRUCTURE type ref to ZIF_BTOCS_UTIL_STRUCTURE .
  data MV_LANG type SYLANGU .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_DDIC IMPLEMENTATION.


  METHOD zif_btocs_util_ddic~f4_cache_delete.
    IF zif_btocs_util_ddic~f4_cache_exists(
         iv_type   = iv_type
         iv_object = iv_object
         iv_subobj = iv_subobj
       ) EQ abap_true.

      DELETE gt_f4_cache
        WHERE f4_type    = iv_type
          AND f4_object  = iv_object
          AND f4_subobj  = iv_subobj.

      rv_success = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_util_ddic~f4_cache_delete_all.

* ------- check full table mode
    IF iv_type IS INITIAL
      AND iv_object IS INITIAL
      AND iv_subobj IS INITIAL.
      CLEAR gt_f4_cache.
      rv_success = abap_true.
    ELSE.
      get_logger( )->error( |not implemented yet| ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_util_ddic~f4_cache_exists.
    READ TABLE gt_f4_cache
      ASSIGNING FIELD-SYMBOL(<ls_cache>)
      WITH KEY f4_type    = iv_type
               f4_object  = iv_object
               f4_subobj  = iv_subobj.
    IF sy-subrc EQ 0.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_ddic~f4_cache_get.
    READ TABLE gt_f4_cache
      ASSIGNING FIELD-SYMBOL(<ls_cache>)
      WITH KEY f4_type    = iv_type
               f4_object  = iv_object
               f4_subobj  = iv_subobj.
    IF sy-subrc EQ 0.
      rt_f4 = <ls_cache>-translations.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_ddic~f4_cache_set.

* ---- delete first
    IF zif_btocs_util_ddic~f4_cache_exists(
         iv_type   = iv_type
         iv_object = iv_object
         iv_subobj = iv_subobj
       ) EQ abap_true.
      zif_btocs_util_ddic~f4_cache_delete(
         iv_type   = iv_type
         iv_object = iv_object
         iv_subobj = iv_subobj
      ).
    ENDIF.


* ---- set new
    IF it_f4[] IS NOT INITIAL.
      DATA ls_cache LIKE LINE OF gt_f4_cache.
      ls_cache-f4_type      = iv_type.
      ls_cache-f4_object    = iv_object.
      ls_cache-f4_subobj    = iv_subobj.
      ls_cache-translations = it_f4.

      INSERT ls_cache INTO TABLE gt_f4_cache.
      rv_success = abap_true.
    ENDIF.


  ENDMETHOD.


  METHOD zif_btocs_util_ddic~f4_get_best_text.

* ------ prepare
    et_f4 = it_f4.
    DELETE et_f4 WHERE code NE iv_code.

* ------ check values available
    IF et_f4[] IS INITIAL.
      rv_text = iv_default.
      RETURN.
    ENDIF.

* ------ 1) check with given language
    ev_language = zif_btocs_util_ddic~lang_sap_to_iso( iv_lang ).
    READ TABLE et_f4 ASSIGNING FIELD-SYMBOL(<ls_f4>)
      WITH KEY lang = ev_language.
    IF sy-subrc EQ 0 AND <ls_f4>-text IS NOT INITIAL.
      RETURN.
    ENDIF.

* ------ 2) check with language 2
    IF iv_lang2 IS NOT INITIAL.
      ev_language = zif_btocs_util_ddic~lang_sap_to_iso( iv_lang2 ).
      READ TABLE et_f4 ASSIGNING <ls_f4>
        WITH KEY lang = ev_language.
      IF sy-subrc EQ 0 AND <ls_f4>-text IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.

* -------check try other
    IF iv_try_others EQ abap_false.
      get_logger( )->error( |no best text found for { iv_code }| ).
      CLEAR ev_language.
      RETURN.
    ENDIF.


* ------ 3) check with logon language
    ev_language = zif_btocs_util_ddic~lang_sap_to_iso( sy-langu ).
    READ TABLE et_f4 ASSIGNING <ls_f4>
      WITH KEY lang = ev_language.
    IF sy-subrc EQ 0 AND <ls_f4>-text IS NOT INITIAL.
      RETURN.
    ENDIF.

* ------ 4) check with flipflop DE/EN language
    IF ev_language = 'DE'.
      ev_language = 'EN'.
    ELSE.
      ev_language = 'DE'.
    ENDIF.

    READ TABLE et_f4 ASSIGNING <ls_f4>
      WITH KEY lang = ev_language.
    IF sy-subrc EQ 0 AND <ls_f4>-text IS NOT INITIAL.
      RETURN.
    ENDIF.


* ------ 5) take the first at et_f4
    READ TABLE et_f4 ASSIGNING <ls_f4>
      INDEX 1.
    ev_language = <ls_f4>-lang.
    rv_text     = <ls_f4>-text.

  ENDMETHOD.


  METHOD zif_btocs_util_ddic~f4_table_field_get_tab.

* ------- local data
*    DATA: lt_results        TYPE TABLE OF ddshretval.
*    DATA: ls_results        TYPE ddshretval.
*    DATA: lv_old_recordpos  TYPE recordpos.
*    DATA: lv_tabfld         TYPE string.
*    DATA: lv_first          TYPE abap_bool.
*    DATA: lv_filled         TYPE abap_bool.
*    DATA: ls_f4             LIKE LINE OF rt_f4.

    DATA: lv_subrc TYPE sysubrc.
    DATA: lv_error TYPE string.


* ------ check cache
    IF iv_no_cache EQ abap_false.
      rt_f4 = zif_btocs_util_ddic~f4_cache_get(
                 iv_type   = 'TABF'
                 iv_object = CONV zbtocs_f4_object( iv_table )
                 iv_subobj = CONV zbtocs_f4_subobject( iv_field )
      ).
      IF rt_f4[] IS NOT INITIAL.
        get_logger( )->debug( |f4 table field values from cache: { iv_table }-{ iv_field }| ).
        RETURN.
      ENDIF.
    ENDIF.


* ----- call f4 api (tunnel against popups)
    CALL FUNCTION 'Z_BTOCS_CORE_UTL_PROXY_F4_GET'
      DESTINATION 'NONE'
      EXPORTING
        iv_table = CONV tabname( iv_table )
        iv_field = CONV fieldname( iv_field )
      IMPORTING
        ev_error = lv_error
        ev_subrc = lv_subrc
        et_f4    = rt_f4.

    IF sy-subrc NE 0 AND lv_error IS NOT INITIAL.
      get_logger( )->error( lv_error ).
    ENDIF.

*    CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
*      EXPORTING
*        tabname             = iv_table
*        fieldname           = iv_field
*        display             = ' '
*        suppress_recordlist = 'X'
*      TABLES
*        return_tab          = lt_results
*      EXCEPTIONS
*        field_not_found     = 1
*        no_help_for_field   = 2
*        inconsistent_help   = 3
*        no_values_found     = 4
*        OTHERS              = 5.
*    IF sy-subrc <> 0.
*      CASE sy-subrc.
*        WHEN 1.
*          get_logger( )->error( |field unknown { iv_field }| ).
*        WHEN 2.
*          get_logger( )->error( |no standard search help found for { iv_table }/{ iv_field }| ).
*        WHEN 3.
*          get_logger( )->error( |search help is wrong for { iv_table }/{ iv_field }| ).
*        WHEN 4.
*          get_logger( )->error( |no values determined for { iv_table }/{ iv_field }| ).
*        WHEN OTHERS.
*          get_logger( )->error( |unknown error calling search help for { iv_table }/{ iv_field }| ).
*      ENDCASE.
*      RETURN.
*    ENDIF.
*
*
** ------ convert
** ------ loop
*    lv_old_recordpos = 0000.
*    DATA(lv_iso)     = zif_btocs_util_ddic~lang_sap_to_iso( sy-langu ).
*    LOOP AT lt_results INTO ls_results.
*
*      IF ls_results-recordpos NE lv_old_recordpos.
**     ignore additional fields
*        IF ls_results-retfield NE lv_tabfld.
*          CONTINUE.
*        ENDIF.
**     check existing/filled entry
*        IF lv_filled = 'X'.
*          ls_f4-lang = lv_iso.
*          APPEND ls_f4 TO rt_f4.
*          CLEAR ls_f4.
*        ENDIF.
*        lv_first = 'X'.
*        lv_filled = 'X'.
*        lv_old_recordpos = ls_results-recordpos.
*        ls_f4-code = ls_results-fieldval.
*      ELSE.
*        IF NOT ls_results-fieldval IS INITIAL.
*          ls_f4-text = ls_results-fieldval.
*        ENDIF.
*        CLEAR lv_first.
*      ENDIF.
*    ENDLOOP.
*
** ----- last append
*    IF lv_filled = 'X'.
*      APPEND ls_f4 TO rt_f4.
*    ENDIF.


* ------ set cache
    IF rt_f4[] IS NOT INITIAL
      AND iv_no_cache = abap_false.
      IF zif_btocs_util_ddic~f4_cache_set(
         iv_type    = 'TABF'
         iv_object  = CONV zbtocs_f4_object( iv_table )
         iv_subobj  = CONV zbtocs_f4_subobject( iv_field )
         it_f4      = rt_f4
      ) EQ abap_true.
        get_logger( )->debug( |f4 table field values saved to cache: { iv_table }-{ iv_field }| ).
      ELSE.
        get_logger( )->error( |f4 table field values not saved to cache: { iv_table }-{ iv_field }| ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_util_ddic~f4_table_field_get_text.

* ------ get all
    et_f4 = zif_btocs_util_ddic~f4_table_field_get_tab(
        iv_table = iv_table
        iv_field = iv_field
       iv_no_cache = abap_false
    ).

    DELETE et_f4 WHERE code NE iv_code.

* ------ check empty
    IF et_f4[] IS INITIAL.
      IF iv_default IS NOT INITIAL.
        rv_text = iv_default.
        get_logger( )->debug( |no text found for { iv_table }-{ iv_field } code { iv_code }. set default: { iv_default }| ).
      ELSE.
        get_logger( )->debug( |no text found for { iv_table }-{ iv_field } code { iv_code }| ).
      ENDIF.
      RETURN.
    ENDIF.


* ------


  ENDMETHOD.


  METHOD zif_btocs_util_ddic~get_util_structure.
* ------ check singleton
    IF iv_singleton EQ abap_true
      AND mo_util_structure IS NOT INITIAL.
      ro_util = mo_util_structure.
      RETURN.
    ENDIF.

* ------ create instance
    ro_util = zcl_btocs_factory=>create_ddic_structure_util( ).
    ro_util->set_logger( get_logger( ) ).
    ro_util->set_ddic_util( me ).


* ------ save singleton for later use
    IF iv_singleton EQ abap_true.
      mo_util_structure = ro_util.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_util_ddic~get_util_table.
* ------ check singleton
    IF iv_singleton EQ abap_true
      AND mo_util_table IS NOT INITIAL.
      ro_util = mo_util_table.
      RETURN.
    ENDIF.

* ------ create instance
    ro_util = zcl_btocs_factory=>create_ddic_table_util( ).
    ro_util->set_logger( get_logger( ) ).
    ro_util->set_ddic_util( me ).


* ------ save singleton for later use
    IF iv_singleton EQ abap_true.
      mo_util_table = ro_util.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_ddic~lang_get_default.
    IF mv_lang IS INITIAL.
      rv_lang = sy-langu.
    ELSE.
      rv_lang = mv_lang.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_ddic~lang_iso_to_sap.

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
      EXPORTING
        input  = iv_iso
      IMPORTING
        output = rv_sap.

  ENDMETHOD.


  METHOD zif_btocs_util_ddic~lang_sap_to_iso.
    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = iv_sap
      IMPORTING
        output = rv_iso.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_DDIC~LANG_SET_DEFAULT.
    mv_lang = iv_lang.
  endmethod.
ENDCLASS.
