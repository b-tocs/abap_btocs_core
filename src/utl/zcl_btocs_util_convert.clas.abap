class ZCL_BTOCS_UTIL_CONVERT definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_CONVERT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_CONVERT IMPLEMENTATION.


  method ZIF_BTOCS_UTIL_CONVERT~CONVERT_BINTAB_TO_XSTRING.
    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = iv_len
*       FIRST_LINE   = 0
*       LAST_LINE    = 0
      IMPORTING
        buffer       = rv_xstring
      TABLES
        binary_tab   = it_bin
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
  endmethod.


  method ZIF_BTOCS_UTIL_CONVERT~CONVERT_STRING_TO_TXTTAB.
    CALL FUNCTION 'SCMS_STRING_TO_FTEXT'
      EXPORTING
        text      = iv_string
      IMPORTING
        length    = ev_len
      TABLES
        ftext_tab = rt_txttab.
  endmethod.


  method ZIF_BTOCS_UTIL_CONVERT~CONVERT_STRING_TO_XSTRING.
* ------ local data
    DATA: lv_len TYPE i.
    DATA: lt_asc TYPE TABLE OF soli.


* ------ transform to asc tab
    CALL FUNCTION 'SCMS_STRING_TO_FTEXT'
      EXPORTING
        text      = iv_string
      IMPORTING
        length    = lv_len
      TABLES
        ftext_tab = lt_asc.
* ------- convert xstring
    CALL FUNCTION 'SCMS_FTEXT_TO_XSTRING'
      EXPORTING
        input_length = lv_len
*       FIRST_LINE   = 0
*       LAST_LINE    = 0
*       MIMETYPE     = ' '
        encoding     = iv_encoding
      IMPORTING
        buffer       = rv_xstring
      TABLES
        ftext_tab    = lt_asc
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.

  endmethod.


  method ZIF_BTOCS_UTIL_CONVERT~CONVERT_TXTTAB_TO_STRING.
    CALL FUNCTION 'SCMS_FTEXT_TO_STRING'
      EXPORTING
*       FIRST_LINE       = -1
*       LAST_LINE = -1
        length    = iv_len
      IMPORTING
        ftext     = rv_string
      TABLES
        ftext_tab = it_txttab.
  endmethod.


  METHOD zif_btocs_util_convert~convert_xstring_to_base64.

* ------- checks
    IF iv_binary IS INITIAL.
      get_logger( )->error( |missing binary data| ).
      RETURN.
    ENDIF.

    DATA(lv_mimetype) = iv_mimetype.
    IF lv_mimetype IS INITIAL.
      lv_mimetype = 'application/octed_stream'.
    ENDIF.

    DATA(lv_filename) = iv_filename.

    IF lv_filename IS INITIAL.
      lv_filename = 'file.bin'.
    ENDIF.


* ------ transform
    DATA(lv_data) = zif_btocs_util_convert~encode_xstring_to_base64( iv_binary ).
    IF lv_data IS INITIAL.
      get_logger( )->error( |error while encoding base64 data| ).
      RETURN.
    ENDIF.


* ------ build
    CONCATENATE 'data:'
                lv_mimetype
                ';base64,'
                lv_data
                INTO lv_data.
    IF lv_filename NE space.
      CONCATENATE lv_data
                  ';'
                  lv_filename
                  INTO lv_data.
    ENDIF.

* ----- result
    rv_base64 = lv_data.

  ENDMETHOD.


  METHOD zif_btocs_util_convert~convert_xstring_to_bintab.
    IF ct_bintab IS SUPPLIED.
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = iv_xstring
*         APPEND_TO_TABLE       = ' '
        IMPORTING
          output_length = ev_len
        TABLES
          binary_tab    = ct_bintab.
    ENDIF.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = iv_xstring
*       APPEND_TO_TABLE       = ' '
      IMPORTING
        output_length = ev_len
      TABLES
        binary_tab    = rt_bintab.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_CONVERT~CONVERT_XSTRING_TO_STRING.
* ----- local data
    DATA: lt_bin      TYPE TABLE OF solix.
    DATA: lv_len      TYPE i.


* -------- transform to bin tab
    IF iv_xstring IS NOT INITIAL.
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = iv_xstring
*         APPEND_TO_TABLE       = ' '
        IMPORTING
          output_length = lv_len
        TABLES
          binary_tab    = lt_bin.

* --------- transform to string
      CALL FUNCTION 'SCMS_BINARY_TO_STRING'
        EXPORTING
          input_length = lv_len
*         FIRST_LINE   = 0
*         LAST_LINE    = 0
*         MIMETYPE     = ' '
          encoding     = iv_encoding
        IMPORTING
          text_buffer  = rv_string
*         OUTPUT_LENGTH       =
        TABLES
          binary_tab   = lt_bin
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.
    ENDIF.              .

  endmethod.


  METHOD zif_btocs_util_convert~decode_base64_to_string.
*   get binary
    DATA(lv_xstring) = zif_btocs_util_convert~decode_base64_to_xstring( iv_base64 ).
    IF lv_xstring IS INITIAL.
      RETURN.
    ENDIF.

*   get as string
    zif_btocs_util_convert~convert_xstring_to_string(
      iv_xstring = lv_xstring
      iv_encoding = iv_encoding
    ).
  ENDMETHOD.


  METHOD zif_btocs_util_convert~decode_base64_to_xstring.
    CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
      EXPORTING
        input  = iv_base64
*       UNESCAPE       = 'X'
      IMPORTING
        output = rv_xstring
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
      get_logger( )->error( |error while base64 decode (subrc: { sy-subrc })| ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_convert~encode_string_to_base64.
    DATA(lv_xstring) = zif_btocs_util_convert~convert_string_to_xstring(
      iv_string = iv_string
      iv_encoding = iv_encoding ).
    IF lv_xstring IS INITIAL.
      RETURN.
    ENDIF.

    rv_base64 = zif_btocs_util_convert~encode_xstring_to_base64( lv_xstring ).
  ENDMETHOD.


  METHOD zif_btocs_util_convert~encode_xstring_to_base64.
    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = iv_xstring
      IMPORTING
        output = rv_base64.
  ENDMETHOD.
ENDCLASS.
