class ZCL_BTOCS_BOD_RND definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_BOD_RND .
protected section.

  data MV_TYPE type STRING .
  data MV_ID type STRING .
  data MT_CONTEXT type ZBTOCS_T_KEY_VALUE .
  data MV_DATA_LOADED type ABAP_BOOL .
  data MO_DDIC_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .
  data MO_MARKDOWN_UTIL type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  data MV_MEANING type STRING .
  data MV_TITLE type STRING .

  methods CHECK_DETAIL_LEVEL
    importing
      !IV_CURRENT type I
      !IV_REQUIRED type I
    returning
      value(RV_VALID) type ABAP_BOOL .
  methods TRANSFORM_MARKDOWN_TO_DOC
    importing
      !IO_MARKDOWN type ref to ZIF_BTOCS_UTIL_MARKDOWN
      !IO_DOC type ref to ZIF_BTOCS_BOD_DOC optional
    returning
      value(RO_DOC) type ref to ZIF_BTOCS_BOD_DOC .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_BOD_RND IMPLEMENTATION.


  method ZIF_BTOCS_BOD_RND~GET_CONTEXT.
    rt_context = mt_context.
  endmethod.


  method ZIF_BTOCS_BOD_RND~GET_ID.
    rv_id = mv_id.
  endmethod.


  method ZIF_BTOCS_BOD_RND~GET_TYPE.
    rv_type = mv_type.
  endmethod.


  method ZIF_BTOCS_BOD_RND~RENDER.
    get_logger( )->error( |Render Base class called. Redefine RENDER| ).
  endmethod.


  METHOD zif_btocs_bod_rnd~set_context.
    mv_id       = iv_id.
    mv_type     = iv_type.
    mt_context  = it_context.
  ENDMETHOD.


  METHOD check_detail_level.

* ----- exclude abstract
    IF iv_current = zif_btocs_bod_rnd=>c_detail_level-abstract
      AND iv_required NE zif_btocs_bod_rnd=>c_detail_level-abstract.
      RETURN.
    ENDIF.

* ----- full or > xlarge
    IF iv_current = zif_btocs_bod_rnd=>c_detail_level-default
      OR iv_current >= zif_btocs_bod_rnd=>c_detail_level-extra_large.
      rv_valid = abap_true.
    ELSE.
      IF iv_current >= iv_required.
        rv_valid = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD transform_markdown_to_doc.
* ------- prepare doc
    DATA(lo_doc) = io_doc.
    IF lo_doc IS INITIAL.
      lo_doc = zcl_btocs_factory=>create_bo_document_manager( )->new_document( ).
      lo_doc->set_logger( get_logger( ) ).
    ENDIF.

* ------- get content
    DATA(lv_md) = io_markdown->to_string( ).
    lo_doc->set_content(
      iv_content      = lv_md
      iv_content_type = 'text/markdown'
    ).
    ro_doc = lo_doc.
  ENDMETHOD.


  METHOD zif_btocs_bod_rnd~get_abstract.
  ENDMETHOD.


  METHOD zif_btocs_bod_rnd~get_ddic_util.
    IF mo_ddic_util IS INITIAL.
      mo_ddic_util = zcl_btocs_factory=>create_ddic_util( ).
      mo_ddic_util->set_logger( get_logger( ) ).
    ENDIF.
    ro_util = mo_ddic_util.
  ENDMETHOD.


  METHOD zif_btocs_bod_rnd~get_markdown_util.

    IF mo_markdown_util IS INITIAL.
      mo_markdown_util = zcl_btocs_factory=>create_markdown_util( ).
      mo_markdown_util->set_logger( get_logger( ) ).
      mo_markdown_util->set_ddic_util( zif_btocs_bod_rnd~get_ddic_util( ) ).
    ENDIF.
    ro_util = mo_markdown_util.

  ENDMETHOD.


  method ZIF_BTOCS_BOD_RND~GET_MEANING.
    rv_meaning = mv_meaning.
  endmethod.


  METHOD zif_btocs_bod_rnd~get_title.
* ----- check if title is initialized
    IF mv_title IS INITIAL.
      RETURN.
    ELSE.
      rv_title = mv_title.
    ENDIF.

* ----- meaning
    IF iv_with_meaning EQ abap_true.
      DATA(lv_meaning) = zif_btocs_bod_rnd~get_meaning( ).
      IF lv_meaning IS NOT INITIAL.
        rv_title = |{ lv_meaning } { rv_title }|.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method ZIF_BTOCS_BOD_RND~IS_DATA_LOADED.
    rv_loaded = mv_data_loaded.
  endmethod.


  method ZIF_BTOCS_BOD_RND~LOAD_DATA.
  endmethod.
ENDCLASS.
