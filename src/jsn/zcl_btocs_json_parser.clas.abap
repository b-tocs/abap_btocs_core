CLASS zcl_btocs_json_parser DEFINITION
  PUBLIC
  INHERITING FROM zcl_btocs_util_base
  CREATE PUBLIC .


  PUBLIC SECTION.
    INTERFACES zif_btocs_json_parser.

  PROTECTED SECTION.
    DATA extension TYPE REF TO zif_btocs_json_extension .

private section.

  methods GET_ANY
    importing
      !IV_JSON type STRING
    exporting
      !EV_FOUND type FLAG
      !ES_DATA type TS_JSON_DATA
    changing
      !CV_POS type I .
  methods GET_ARRAY
    importing
      !IV_JSON type STRING
      !IO_JSON type ref to ZIF_BTOCS_VALUE_ARRAY
    exporting
      !EV_FOUND type FLAG
      !ET_ARRAY type TT_ARRAY_TAB
    changing
      !CV_POS type I .
  methods GET_BOOLEAN
    importing
      !IV_JSON type STRING
    exporting
      !EV_FOUND type FLAG
      !EV_BOOLEAN type FLAG
    changing
      !CV_POS type I .
  methods GET_ELEMENT
    importing
      !IV_JSON type STRING
    exporting
      !ES_ELEMENT type TS_HASHED_ELEMENT
      !EV_FOUND type FLAG
    changing
      !CV_POS type I .
  methods GET_HASH
    importing
      !IV_JSON type STRING
      !IO_JSON type ref to ZIF_BTOCS_VALUE_STRUCTURE
    exporting
      !ET_HASH type TT_HASHED_TAB
      !EV_FOUND type FLAG
    changing
      !CV_POS type I .
  methods GET_KEY
    importing
      !IV_JSON type STRING
    exporting
      !EV_KEY type STRING
      !EV_FOUND type FLAG
    changing
      !CV_POS type I .
  methods GET_NAME
    importing
      !IV_JSON type STRING
    exporting
      !EV_NAME type STRING
      !EV_FOUND type FLAG
    changing
      !CV_POS type I .
  methods GET_NULL
    importing
      !IV_JSON type STRING
    exporting
      !EV_FOUND type FLAG
    changing
      !CV_POS type I .
  methods GET_NUMBER
    importing
      !IV_JSON type STRING
    exporting
      !EV_FOUND type FLAG
      !EV_NUMBER type ref to DATA
      !EV_INTEGER type FLAG
    changing
      !CV_POS type I .
  methods GET_STRING
    importing
      !IV_JSON type STRING
      !IV_DELIMITER type CHAR01 optional
    exporting
      !EV_FOUND type FLAG
      !EV_STRING type STRING
    changing
      !CV_POS type I .
  methods GET_SYMBOL
    importing
      !IV_JSON type STRING
      !IV_SYMBOL type CSEQUENCE
    exporting
      !EV_FOUND type FLAG
    changing
      !CV_POS type I .
  methods MAP_CHAR
    importing
      !IV_CHAR type CSEQUENCE
    returning
      value(EV_MAPPED_CHAR) type CHAR01 .
  methods SKIP_WHITESPACE
    importing
      !IV_JSON type STRING
    changing
      !CV_POS type I .
ENDCLASS.



CLASS ZCL_BTOCS_JSON_PARSER IMPLEMENTATION.


  METHOD get_any.

* ------- local data
    DATA: ls_data TYPE ts_json_data,
          lv_pos  TYPE i.

    FIELD-SYMBOLS: <lv_boolean> TYPE flag,
                   <lv_string>  TYPE string,
                   <lt_hash>    TYPE tt_hashed_tab,
                   <lt_array>   TYPE tt_array_tab.

* -------- init
    ev_found = space.
    lv_pos = cv_pos.

    skip_whitespace( EXPORTING iv_json = iv_json
                     CHANGING  cv_pos  = lv_pos ).
    IF NOT lv_pos < strlen( iv_json ).
      get_logger( )->error( |wrong pos offset while parsing json data| ).
      RETURN.
    ENDIF.

* ---------- prepare json data manager
    DATA(lo_json) = zcl_btocs_factory=>create_value_manager( ).

    CASE iv_json+lv_pos(1).
* ---------- string
      WHEN '"' OR `'`.
        CREATE DATA ls_data-data TYPE string.
        ASSIGN ls_data-data->* TO <lv_string>.
        ls_data-type = 'S'.

        CALL METHOD get_string
          EXPORTING
            iv_json   = iv_json
          IMPORTING
            ev_string = <lv_string>
            ev_found  = ev_found
          CHANGING
            cv_pos    = lv_pos.


        ls_data-json ?= lo_json->new_string( <lv_string> ).
* ------------ object
      WHEN '{'.
        DATA(lo_object) = lo_json->new_json_object( ).
        ls_data-json ?= lo_object.

        CREATE DATA ls_data-data TYPE tt_hashed_tab.
        ASSIGN ls_data-data->* TO <lt_hash>.
        ls_data-type = 'h'.

        CALL METHOD get_hash
          EXPORTING
            iv_json  = iv_json
            io_json  = lo_object
          IMPORTING
            et_hash  = <lt_hash>
            ev_found = ev_found
          CHANGING
            cv_pos   = lv_pos.
      WHEN '['.
        DATA(lo_array) = lo_json->new_json_array( ).
        ls_data-json ?= lo_array.

        CREATE DATA ls_data-data TYPE tt_array_tab.
        ASSIGN ls_data-data->* TO <lt_array>.
        ls_data-type = 'a'.

        CALL METHOD get_array
          EXPORTING
            iv_json  = iv_json
            io_json  = lo_array
          IMPORTING
            et_array = <lt_array>
            ev_found = ev_found
          CHANGING
            cv_pos   = lv_pos.


      WHEN 't' OR 'f'.
        CREATE DATA ls_data-data TYPE flag.
        ASSIGN ls_data-data->* TO <lv_boolean>.
        ls_data-type = 'B'.
        CALL METHOD get_boolean
          EXPORTING
            iv_json    = iv_json
          IMPORTING
            ev_boolean = <lv_boolean>
            ev_found   = ev_found
          CHANGING
            cv_pos     = lv_pos.

        ls_data-json ?= lo_json->new_boolean( <lv_boolean> ).
      WHEN 'n'.
        CLEAR ls_data-data.
        ls_data-type = 'N'.
        CALL METHOD get_null
          EXPORTING
            iv_json  = iv_json
          IMPORTING
            ev_found = ev_found
          CHANGING
            cv_pos   = lv_pos.

        ls_data-json ?= lo_json->new_null( ).
      WHEN OTHERS.
        DATA: lv_integer          TYPE abap_bool.
        FIELD-SYMBOLS: <integer>  TYPE zbtocs_json_integer.
        FIELD-SYMBOLS: <double>   TYPE zbtocs_json_decimal.
        FIELD-SYMBOLS: <bigint>   TYPE zbtocs_json_bigint.

        IF iv_json+lv_pos(1) CA '0123456789-'.
          ls_data-type = 'N'.


          CALL METHOD get_number
            EXPORTING
              iv_json    = iv_json
            IMPORTING
              ev_number  = ls_data-data
              ev_found   = ev_found
              ev_integer = lv_integer
            CHANGING
              cv_pos     = lv_pos.

          IF ev_found EQ abap_true.
            IF lv_integer EQ 'B'.  " workaround BIGINT
              ASSIGN ls_data-data->* TO <bigint>.
              ls_data-json ?= lo_json->new_number( <bigint> ).
            ELSEIF lv_integer EQ abap_true.
              ASSIGN ls_data-data->* TO <integer>.
              ls_data-json ?= lo_json->new_number( <integer> ).
            ELSE.
              ASSIGN ls_data-data->* TO <double>.
              ls_data-json ?= lo_json->new_number( <double> ).
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.

    IF ev_found = 'X'.
      cv_pos  = lv_pos.
      es_data = ls_data.
    ENDIF.

  ENDMETHOD.


  METHOD get_array.

* --------- local data
    DATA: ls_element TYPE ts_json_data,
          lv_pos     TYPE i,
          lv_found   TYPE flag,
          lv_key     TYPE string.


* --------- init & check
    CLEAR ev_found.
    lv_pos = cv_pos.

    get_symbol( EXPORTING iv_json = iv_json
                          iv_symbol = '['
                IMPORTING ev_found = lv_found
                CHANGING  cv_pos  = lv_pos ).
    IF lv_found NE abap_true.
      RETURN.
    ENDIF.


* --------- loop and found
    WHILE lv_found EQ 'X'.

      CALL METHOD get_any
        EXPORTING
          iv_json  = iv_json
        IMPORTING
          es_data  = ls_element
          ev_found = lv_found
        CHANGING
          cv_pos   = lv_pos.

      IF lv_found = abap_true.

        INSERT ls_element INTO TABLE et_array.

        IF io_json IS NOT INITIAL
          AND ls_element-json IS NOT INITIAL.
          DATA(lo_value) = CAST zif_btocs_value( ls_element-json ).
          io_json->add( lo_value ).
        ENDIF.

        CALL METHOD get_symbol
          EXPORTING
            iv_json   = iv_json
            iv_symbol = ','
          IMPORTING
            ev_found  = lv_found
          CHANGING
            cv_pos    = lv_pos.

      ENDIF.
    ENDWHILE.


    get_symbol( EXPORTING iv_json = iv_json
                          iv_symbol = ']'
                IMPORTING ev_found = lv_found
                CHANGING  cv_pos  = lv_pos ).
    IF lv_found NE abap_true.
      RETURN.
    ENDIF.

    ev_found = abap_true.
    cv_pos = lv_pos.
  ENDMETHOD.


  METHOD get_boolean.
    DATA: lv_symbol  TYPE string,
          lv_boolean TYPE flag.


    CHECK cv_pos < strlen( iv_json ).

    CASE iv_json+cv_pos(1).
      WHEN 't'.
        lv_symbol = 'true'.
        lv_boolean = 'X'.
      WHEN 'f'.
        lv_symbol = 'false'.
        lv_boolean = space.
    ENDCASE.

    CALL METHOD get_symbol
      EXPORTING
        iv_json   = iv_json
        iv_symbol = lv_symbol
      IMPORTING
        ev_found  = ev_found
      CHANGING
        cv_pos    = cv_pos.

    IF ev_found = 'X'.
      ev_boolean = lv_boolean.
    ENDIF.
  ENDMETHOD.


  METHOD get_element.
    DATA: lv_pos     TYPE i,
          lv_found   TYPE flag,
          ls_element TYPE ts_hashed_element.

    CLEAR: ev_found, es_element.

    lv_pos = cv_pos.

* Schlüssel
    CALL METHOD get_key
      EXPORTING
        iv_json  = iv_json
      IMPORTING
        ev_key   = ls_element-key
        ev_found = lv_found
      CHANGING
        cv_pos   = lv_pos.
    CHECK lv_found EQ 'X'.

* Doppelpunkt
    get_symbol( EXPORTING iv_json = iv_json
                          iv_symbol = ':'
                IMPORTING ev_found = lv_found
                CHANGING  cv_pos  = lv_pos ).
    CHECK lv_found = 'X'.

* Wert
    CALL METHOD get_any
      EXPORTING
        iv_json  = iv_json
      IMPORTING
        es_data  = ls_element-value
        ev_found = lv_found
      CHANGING
        cv_pos   = lv_pos.

    IF lv_found = 'X'.
      ev_found   = 'X'.
      cv_pos     = lv_pos.
      es_element = ls_element.
    ENDIF.
  ENDMETHOD.


  METHOD get_hash.

    DATA: ls_element TYPE ts_hashed_element,
          lv_pos     TYPE i,
          lv_found   TYPE flag,
          lv_key     TYPE string.

    CLEAR ev_found.
    lv_pos = cv_pos.


    get_symbol( EXPORTING iv_json = iv_json
                          iv_symbol = '{'
                IMPORTING ev_found = lv_found
                CHANGING  cv_pos  = lv_pos ).
    CHECK lv_found = 'X'.

    WHILE lv_found EQ 'X'.

      CALL METHOD get_element
        EXPORTING
          iv_json    = iv_json
        IMPORTING
          es_element = ls_element
          ev_found   = lv_found
        CHANGING
          cv_pos     = lv_pos.

      IF lv_found = 'X'.

        INSERT ls_element INTO TABLE et_hash.

        IF io_json IS NOT INITIAL
          AND ls_element-json IS NOT INITIAL.
          DATA(lo_value) = CAST zif_btocs_value( ls_element-json ).
          io_json->set(
              iv_name      = ls_element-key
              io_value     = lo_value                 " B-Tocs Value Holder Interface
          ).
        ENDIF.


        CALL METHOD get_symbol
          EXPORTING
            iv_json   = iv_json
            iv_symbol = ','
          IMPORTING
            ev_found  = lv_found
          CHANGING
            cv_pos    = lv_pos.

      ENDIF.

    ENDWHILE.


    get_symbol( EXPORTING iv_json = iv_json
                          iv_symbol = '}'
                IMPORTING ev_found = lv_found
                CHANGING  cv_pos  = lv_pos ).
    CHECK lv_found = 'X'.

    ev_found = 'X'.
    cv_pos = lv_pos.
  ENDMETHOD.


  METHOD get_key.

    DATA: lv_pos   TYPE i,
          lv_found TYPE flag.

    ev_found = space.
    CHECK cv_pos < strlen( iv_json ).

    lv_pos = cv_pos.

* Ist der Key als String notiert?
    CALL METHOD get_string
      EXPORTING
        iv_json   = iv_json
      IMPORTING
        ev_string = ev_key
        ev_found  = lv_found
      CHANGING
        cv_pos    = lv_pos.

    IF lv_found = space.
* Zweiter Versuch: Symbolischer Name
      CALL METHOD get_name
        EXPORTING
          iv_json  = iv_json
        IMPORTING
          ev_name  = ev_key
          ev_found = lv_found
        CHANGING
          cv_pos   = lv_pos.
    ENDIF.

    IF lv_found = 'X'.
      ev_found = lv_found.
      cv_pos   = lv_pos.
    ENDIF.
  ENDMETHOD.


  METHOD get_name.
    DATA: lv_name   TYPE string,
          lv_length TYPE i.

    ev_found = ev_name = space.
    CHECK cv_pos < strlen( iv_json ).

    FIND REGEX '^\s*([a-z_]\w*)' IN SECTION OFFSET cv_pos OF iv_json
                             SUBMATCHES lv_name
                             MATCH LENGTH lv_length.
    IF sy-subrc EQ 0.
      ev_found = 'X'.
      cv_pos   = cv_pos + lv_length.
      ev_name  = lv_name.
    ENDIF.
  ENDMETHOD.


  METHOD get_null.
    DATA: lv_symbol TYPE string.

    CHECK cv_pos < strlen( iv_json ).

    lv_symbol = 'null'.

    CALL METHOD get_symbol
      EXPORTING
        iv_json   = iv_json
        iv_symbol = lv_symbol
      IMPORTING
        ev_found  = ev_found
      CHANGING
        cv_pos    = cv_pos.

  ENDMETHOD.


  METHOD get_number.

    DATA: lv_pos    TYPE i,
          lv_exp    TYPE string,
          lv_length TYPE i.

    FIELD-SYMBOLS: <lv_number> TYPE numeric.

    CLEAR ev_number.
    ev_found = space.
    lv_pos = cv_pos.

    FIND REGEX '^\s*([\d.-]+(e-?\d+)?)' IN iv_json+lv_pos SUBMATCHES lv_exp MATCH LENGTH lv_length.
    IF sy-subrc EQ 0.
      ADD lv_length TO lv_pos.
* Ganze Zahl?
      IF lv_exp CO '-0123456789'.
        CREATE DATA ev_number TYPE zbtocs_json_integer.
        ev_integer = abap_true.
      ELSE.
        FIND REGEX '^\d*\.\d+|\d+\.\d*$' IN lv_exp.
        IF sy-subrc EQ 0.
          CREATE DATA ev_number TYPE zbtocs_json_decimal.
          ev_integer = abap_false.
        ENDIF.
      ENDIF.

      IF ev_number IS BOUND.
* Hier überlassen wir die Feinheiten des Parsings dem ABAP-Befehl MOVE:
        TRY.
            ASSIGN ev_number->* TO <lv_number>.
            <lv_number> = lv_exp.
          CATCH cx_sy_conversion_overflow.
            CREATE DATA ev_number TYPE zbtocs_json_bigint.
            ASSIGN ev_number->* TO <lv_number>.
            <lv_number> = lv_exp.
            ev_integer = 'B'.
        ENDTRY.


        ev_found = 'X'.
      ENDIF.

    ENDIF.


    IF ev_found = 'X'.
      cv_pos = lv_pos.
    ENDIF.
  ENDMETHOD.


  METHOD get_string.
    DATA: lv_pos            TYPE i,
          lv_delimiter(1)   TYPE c,
          lv_char(1)        TYPE c,
          lv_mapped_char(1) TYPE c.

    DATA: lv_data_pos TYPE i.
    DATA: lv_data_out TYPE string.
    DATA: lv_data_beg TYPE i.
    DATA: lv_new_pos TYPE i.

    ev_found = space.

    lv_pos = cv_pos.
    CALL METHOD skip_whitespace
      EXPORTING
        iv_json = iv_json
      CHANGING
        cv_pos  = lv_pos.

    CHECK lv_pos < strlen( iv_json ).

    IF iv_delimiter IS NOT INITIAL.
      lv_delimiter = iv_delimiter.
      CHECK iv_json+lv_pos(1) EQ lv_delimiter.
    ELSE.
      lv_delimiter = iv_json+lv_pos(1).
      CHECK lv_delimiter CA `'"`.
    ENDIF.


    DO.

      ADD 1 TO lv_pos.

      IF strlen( iv_json ) <= lv_pos.
        EXIT.
      ENDIF.

* Escaped sequences finden und auflösen
      FIND REGEX `^\\(['"/bfnrt\\])` IN SECTION OFFSET lv_pos OF iv_json SUBMATCHES lv_char.
      IF sy-subrc EQ 0.
        IF lv_char CA `bfnrt`.
          lv_mapped_char = map_char( iv_char = lv_char ).
        ELSE.
          lv_mapped_char = lv_char.  " Else auch hier, wg. Performance
        ENDIF.
        CONCATENATE ev_string lv_mapped_char INTO ev_string.
        ADD 1 TO lv_pos.
        CONTINUE.
      ENDIF.

      IF iv_json+lv_pos(1) EQ lv_delimiter.
        ev_found = 'X'.
        EXIT.
      ENDIF.

      CONCATENATE ev_string iv_json+lv_pos(1) INTO ev_string.

*   special performant processing of data strings
      IF ev_string EQ 'data:'.
        lv_data_beg = lv_pos + 1.
        IF iv_json+lv_data_beg CS '"'.
          lv_data_pos = sy-fdpos.
          IF lv_data_pos GT 0.
            CONCATENATE ev_string
                        iv_json+lv_data_beg(lv_data_pos)
                        INTO ev_string.
            lv_pos = lv_pos + lv_data_pos + 1.
            REPLACE ALL  OCCURRENCES OF '\\' IN ev_string WITH ''.
            ev_found = 'X'.
            EXIT. " from do
          ENDIF.
        ENDIF.
      ENDIF.
    ENDDO.

*  check for unicode unescaping
    IF extension IS NOT INITIAL AND ev_string CS '\u'.
      me->extension->unescape_external_string( CHANGING cv_string = ev_string ).
    ENDIF.

    IF ev_found = 'X'.
      ADD 1 TO lv_pos.
      cv_pos = lv_pos.
    ENDIF.
  ENDMETHOD.


  METHOD get_symbol.
    CLEAR ev_found.

    skip_whitespace(
      EXPORTING iv_json = iv_json
      CHANGING  cv_pos  = cv_pos ).

    CHECK cv_pos < strlen( iv_json ).

    IF iv_json+cv_pos CS iv_symbol AND sy-fdpos = 0.
      ev_found = 'X'.
      cv_pos = cv_pos + strlen( iv_symbol ).
    ENDIF.
  ENDMETHOD.


  METHOD map_char.

    CASE iv_char.
      WHEN 'b'.
        ev_mapped_char = cl_abap_char_utilities=>backspace.
      WHEN 'f'.
        ev_mapped_char = cl_abap_char_utilities=>form_feed.
      WHEN 'n'.
        ev_mapped_char = cl_abap_char_utilities=>newline.
      WHEN 'r'.
        ev_mapped_char = cl_abap_char_utilities=>cr_lf(1).
      WHEN 't'.
        ev_mapped_char = cl_abap_char_utilities=>horizontal_tab.
      WHEN OTHERS.
        ev_mapped_char = iv_char.
    ENDCASE.

  ENDMETHOD.


  METHOD skip_whitespace.
    DATA: lv_pos TYPE i.

    FIND REGEX '(\S|\Z)' IN SECTION OFFSET cv_pos OF iv_json MATCH OFFSET lv_pos.
    IF sy-subrc EQ 0.
      cv_pos = lv_pos.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_json_parser~parse.

* --------- local data
    DATA: lv_pos   TYPE i,
          lv_found TYPE flag.
    DATA: ls_data TYPE ts_json_data.


* ---------- init & check
    CLEAR ls_data.
    IF iv_json IS INITIAL.
      get_logger( )->error( |no json data to parse| ).
      RETURN.
    ELSE.
      me->extension = ir_extension.
    ENDIF.

* ---------- parse main level
    get_any( EXPORTING iv_json = iv_json
             IMPORTING es_data = ls_data
                       ev_found = lv_found
             CHANGING  cv_pos  = lv_pos ).

    IF lv_found EQ space
    OR lv_pos < strlen( iv_json ).
      FIND REGEX '\S' IN SECTION OFFSET lv_pos OF iv_json.
      IF sy-subrc EQ 0.
        get_logger( )->error( |parse json payload failed| ).
        RETURN.
      ENDIF.
    ENDIF.

* ----------- return result
    ro_json = ls_data-json.
    get_logger( )->debug( |parse json data finished| ).

  ENDMETHOD.
ENDCLASS.
