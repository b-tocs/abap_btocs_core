class ZCL_BTOCS_BOD_DOC definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_BOD_DOC .
protected section.

  data MS_DATA type ZBTOCS_BOD_S_DOC_DATA .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_BOD_DOC IMPLEMENTATION.


  method ZIF_BTOCS_BOD_DOC~GET_CONTENT.
    rv_content = ms_data-content.
  endmethod.


  method ZIF_BTOCS_BOD_DOC~GET_CONTENT_SIZE.
    rv_size = strlen( ms_data-content ).
  endmethod.


  method ZIF_BTOCS_BOD_DOC~GET_DATA.
    rs_data = ms_data.
  endmethod.


  METHOD zif_btocs_bod_doc~set_content.
    ms_data-content         = iv_content.
    ms_data-content_type    = iv_content_type.

    IF iv_chunk IS NOT INITIAL.
      ms_data-chunk = iv_chunk.
    ENDIF.

    IF iv_page IS NOT INITIAL.
      ms_data-page = iv_page.
    ENDIF.

    IF iv_offset IS NOT INITIAL.
      ms_data-offset = iv_offset.
    ENDIF.

  ENDMETHOD.


  method ZIF_BTOCS_BOD_DOC~SET_DATA.
    ms_data = is_data.
  endmethod.
ENDCLASS.
