CLASS zcl_btocs_sec_mgr DEFINITION
  PUBLIC
  INHERITING FROM zcl_btocs_util_base
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_btocs_sec_mgr .
  PROTECTED SECTION.

    DATA mv_sign_alg_int TYPE string VALUE 'SHA256' ##NO_TEXT.
    DATA mv_sign_alg_ext TYPE string VALUE 'HS256' ##NO_TEXT.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_MGR IMPLEMENTATION.


  METHOD zif_btocs_sec_mgr~create_auth_method.

* ------- local data
    DATA lv_class TYPE seoclsname.
    DATA lo_method TYPE REF TO zif_btocs_sec_met.


* ------- prepare class
    IF iv_method = zif_btocs_sec_mgr=>c_custom_class.
      lv_class = iv_param.
    ELSE.
      lv_class = |ZCL_BTOCS_SEC_A_{ iv_method }|.
    ENDIF.

* ------- create instance
    lo_method ?= zcl_btocs_factory=>create_instance( lv_class ).
    IF lo_method IS INITIAL.
      get_logger( )->error( |wrong method class { lv_class }| ).
      RETURN.
    ELSE.
* ------- set context
      DATA(lr_parent) = COND #( WHEN ir_parent IS NOT INITIAL
                                THEN ir_parent
                                ELSE me ).

      lo_method->set_context(
        iv_method = iv_method
        iv_param  = iv_param
        ir_parent = lr_parent
        ir_mgr    = me
        is_config = is_config
      ).
* ------- cast to output type
      ro_instance ?= lo_method.
    ENDIF.


  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~create_secret_method.

* ------- local data
    DATA lv_class TYPE seoclsname.
    DATA lo_method TYPE REF TO zif_btocs_sec_met.


* ------- prepare class
    IF iv_method = zif_btocs_sec_mgr=>c_custom_class.
      lv_class = iv_param.
    ELSE.
      lv_class = |ZCL_BTOCS_SEC_S_{ iv_method }|.
    ENDIF.

* ------- create instance
    lo_method ?= zcl_btocs_factory=>create_instance( lv_class ).
    IF lo_method IS INITIAL.
      get_logger( )->error( |wrong method class { lv_class }| ).
      RETURN.
    ELSE.
* ------- set context
      DATA(lr_parent) = COND #( WHEN ir_parent IS NOT INITIAL
                                THEN ir_parent
                                ELSE me ).

      lo_method->set_context(
        iv_method = iv_method
        iv_param  = iv_param
        ir_parent = lr_parent
        ir_mgr    = me
        is_config = is_config
      ).
* ------- cast to output type
      ro_instance ?= lo_method.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~create_token_method.
* ------- local data
    DATA lv_class TYPE seoclsname.
    DATA lo_method TYPE REF TO zif_btocs_sec_met.


* ------- prepare class
    IF iv_method = zif_btocs_sec_mgr=>c_custom_class.
      lv_class = iv_param.
    ELSE.
      lv_class = |ZCL_BTOCS_SEC_T_{ iv_method }|.
    ENDIF.

* ------- create instance
    lo_method ?= zcl_btocs_factory=>create_instance( lv_class ).
    IF lo_method IS INITIAL.
      get_logger( )->error( |wrong method class { lv_class }| ).
      RETURN.
    ELSE.
* ------- set context
      DATA(lr_parent) = COND #( WHEN ir_parent IS NOT INITIAL
                                THEN ir_parent
                                ELSE me ).

      lo_method->set_context(
        iv_method = iv_method
        iv_param  = iv_param
        ir_parent = lr_parent
        ir_mgr    = me
        is_config = is_config
      ).
* ------- cast to output type
      ro_instance ?= lo_method.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~generate_jwt_token_trusted.

* ------ local data
    DATA: lt_roles  TYPE  suid_tt_bapiagr.
    DATA: ls_address  TYPE  bapiaddr3.

* ------ get user context
    DATA(lo_usr_util) = zcl_btocs_factory=>create_user_util( ).
    IF lo_usr_util->get_user_detail(
      EXPORTING
        iv_username     = iv_user
        iv_role_prefix  = CONV string( iv_roles_prefix )
      IMPORTING
        et_roles        = lt_roles
        es_address      = ls_address
    ) EQ abap_false.
      get_logger( )->error( |wrong user context| ).
      RETURN.
    ENDIF.

* ------ fill payload
    DATA(lo_data_mgr) = zcl_btocs_factory=>create_value_manager( ).
    lo_data_mgr->set_logger( get_logger( ) ).
    DATA(lv_sap_id) = zif_btocs_sec_mgr~get_system_id( ).

    DATA(lo_payload) = lo_data_mgr->new_json_object( ).

    lo_payload->set(
        iv_name      = zif_btocs_sec_mgr=>c_jwt-issuer
        io_value     = lo_data_mgr->new_string( lv_sap_id )
    ).

    lo_payload->set(
        iv_name      = zif_btocs_sec_mgr=>c_jwt-subject
        io_value     = lo_data_mgr->new_string( |{ sy-uname }| )
    ).

    lo_payload->set(
        iv_name      = zif_btocs_sec_mgr=>c_jwt-name
        io_value     = lo_data_mgr->new_string( |{ ls_address-fullname }| )
    ).

    IF ls_address-e_mail IS NOT INITIAL.
      lo_payload->set(
          iv_name      = zif_btocs_sec_mgr=>c_jwt-email
          io_value     = lo_data_mgr->new_string( |{ ls_address-e_mail }| )
      ).
    ENDIF.

    DATA(lv_unix_now) = zif_btocs_sec_mgr~get_unix_timestamp( ).
    lo_payload->set(
        iv_name      = zif_btocs_sec_mgr=>c_jwt-created_at
        io_value     = lo_data_mgr->new_number( lv_unix_now )
    ).

    IF iv_expire_in_sec <> 0.
      DATA(lv_unix_exp) = zif_btocs_sec_mgr~get_unix_timestamp( iv_delta_sec = iv_expire_in_sec ).
      lo_payload->set(
          iv_name      = zif_btocs_sec_mgr=>c_jwt-expire_at
          io_value     = lo_data_mgr->new_number( lv_unix_exp )
      ).
    ENDIF.

    IF iv_recipient IS NOT INITIAL.
      lo_payload->set(
          iv_name      = zif_btocs_sec_mgr=>c_jwt-audience
          io_value     = lo_data_mgr->new_string( |{ iv_recipient }| )
      ).
    ENDIF.

* ------ fill roles
    IF iv_roles_prefix IS NOT INITIAL.
*   prepare
      DATA(lo_roles) = lo_data_mgr->new_json_array( ).
      DATA(lv_len_prefix) = strlen( iv_roles_prefix ).

*   check basic roles
      IF iv_basic_roles IS NOT INITIAL.
        SPLIT iv_basic_roles AT ',' INTO TABLE DATA(lt_basic_roles).
        LOOP AT lt_basic_roles ASSIGNING FIELD-SYMBOL(<lv_basic_role>).
          DATA(lv_index) = sy-tabix.
          CONDENSE <lv_basic_role>.
          TRANSLATE <lv_basic_role> TO LOWER CASE.
          lo_roles->add(
           io_value  = lo_data_mgr->new_string( <lv_basic_role> )                 " B-Tocs Value Holder Interface
           iv_ref_id = |basic role index { lv_index }|
       ).
        ENDLOOP.
      ENDIF.

*   check roles from pfcg
      LOOP AT lt_roles ASSIGNING FIELD-SYMBOL(<ls_role>).
        DATA(lv_role) = to_lower( <ls_role>-agr_name+lv_len_prefix ).
        lo_roles->add(
            io_value  = lo_data_mgr->new_string( lv_role )                 " B-Tocs Value Holder Interface
            iv_ref_id = CONV string( <ls_role>-agr_name )
        ).
      ENDLOOP.

*   set to payload
      IF lo_roles->count( ) > 0.
        lo_payload->set(
            iv_name      = zif_btocs_sec_mgr=>c_jwt-roles
            io_value     = lo_roles                 " B-Tocs Value Holder Interface
        ).
      ENDIF.
    ENDIF.


* --------- generate payload
    DATA(lv_payload) = lo_payload->render( ).
    ev_payload = lv_payload.

    rv_jwt = zif_btocs_sec_mgr~generate_jwt_token(
               iv_payload = lv_payload
               iv_secret  = iv_secret
             ).
  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~base64_check_string.
    rv_out = iv_in.
    REPLACE ALL OCCURRENCES OF '=' IN rv_out WITH ''.
    REPLACE ALL OCCURRENCES OF '+' IN rv_out WITH '-'.
    REPLACE ALL OCCURRENCES OF '/' IN rv_out WITH '_'.
  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~generate_jwt_token.


* ------- prepare signing
    DATA(lv_header)     = zif_btocs_sec_mgr~generate_jwt_token_header( ).
    DATA(lv_header_b64) = zif_btocs_sec_mgr~to_base64( lv_header ).

    DATA(lv_payload)    = zif_btocs_sec_mgr~to_utf8( iv_payload ).
    DATA(lv_payload_b64) = zif_btocs_sec_mgr~to_base64( lv_payload ).

    DATA(lv_to_sign) = |{ lv_header_b64 }.{ lv_payload_b64 }|.


* -------- sign
    DATA(lv_secret) = iv_secret.
*    DATA(lv_secret) = zif_btocs_sec_mgr~to_base64( iv_secret ).

    DATA(lv_signature) = zif_btocs_sec_mgr~sign_hmac(
      iv_alg       = mv_sign_alg_int
      iv_secret    = lv_secret
      iv_data      = lv_to_sign
    ).

* -------- build all together
    rv_jwt = |{ lv_to_sign }.{ lv_signature }|.


  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~generate_jwt_token_header.
* ------- create header
    DATA(lo_data_mgr) = zcl_btocs_factory=>create_value_manager( ).
    DATA(lo_header)     = lo_data_mgr->new_json_object( ).

    lo_header->set(
        iv_name      = 'alg'
        io_value     = lo_data_mgr->new_string( mv_sign_alg_ext )
    ).

    lo_header->set(
        iv_name      = 'typ'
        io_value     = lo_data_mgr->new_string( 'JWT' )
    ).

    rv_header = lo_header->render( ).
    rv_header = zif_btocs_sec_mgr~to_utf8( rv_header ).

  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~sign_hmac.

* ------- sign
    DATA(lv_sign_str) = ||.
    TRY.
        cl_abap_hmac=>calculate_hmac_for_char(
           EXPORTING
             if_algorithm     = iv_alg
             if_key           = cl_abap_hmac=>string_to_xstring( iv_secret )
             if_data          = iv_data
           IMPORTING
             ef_hmacb64string = lv_sign_str
         ).

        rv_signature = zif_btocs_sec_mgr~base64_check_string( lv_sign_str ).

      CATCH cx_abap_message_digest INTO DATA(lxc).
        DATA(lv_error) = lxc->get_text( ).
        get_logger( )->error( |error while signing data: { lv_error }| ).
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~to_base64.

* ----- local data
    DATA lv_buf TYPE xstring.
    DATA lv_b64 TYPE string.
    DATA(lv_text) = iv_in.

* ----- convert
*    rv_b64 = cl_http_utility=>encode_base64( unencoded = lv_text ).

*   workaround specical chars
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text     = lv_text
        encoding = iv_encoding
      IMPORTING
        buffer   = lv_buf
      EXCEPTIONS
        failed   = 1
        OTHERS   = 2.
    IF lv_buf IS INITIAL.
      rv_b64 = cl_http_utility=>encode_base64( unencoded = lv_text ).
    ELSE.
      CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
        EXPORTING
          input  = lv_buf
        IMPORTING
          output = rv_b64.
    ENDIF.

    rv_b64 = zif_btocs_sec_mgr~base64_check_string( rv_b64 ).


  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~to_utf8.

* ------- prepare
    DATA lv_buf TYPE xstring.
    DATA lt_buf TYPE solix_tab.
    DATA lv_len TYPE i.

    rv_utf8 = iv_string.



* ------- convert binary with codepage translation
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text     = iv_string
*       MIMETYPE = ' '
        encoding = '4110'
      IMPORTING
        buffer   = lv_buf
      EXCEPTIONS
        failed   = 1
        OTHERS   = 2.
    IF sy-subrc <> 0.
      get_logger( )->error( |converting to utf8 failed| ).
    ELSE.
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = lv_buf
*         APPEND_TO_TABLE       = ' '
        IMPORTING
          output_length = lv_len
        TABLES
          binary_tab    = lt_buf.

      CALL FUNCTION 'SCMS_BINARY_TO_STRING'
        EXPORTING
          input_length = lv_len
*         FIRST_LINE   = 0
*         LAST_LINE    = 0
*         MIMETYPE     = ' '
*         encoding     = '4110'
        IMPORTING
          text_buffer  = rv_utf8
*         OUTPUT_LENGTH       =
        TABLES
          binary_tab   = lt_buf
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.
      IF sy-subrc <> 0.
        get_logger( )->error( |converting to utf8 failed| ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~from_base64.
    CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
      EXPORTING
        input  = iv_b64
*       UNESCAPE       = 'X'
      IMPORTING
        output = rv_string
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
      get_logger( )->error( |unable to map from base64| ).
      rv_string = iv_b64.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~get_system_id.

    DATA: lv_lic_number(10) TYPE c.

    CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
      IMPORTING
        license_number = lv_lic_number.

    rv_id = |SAP_{ lv_lic_number }_{ sy-sysid }{ sy-mandt }|.
  ENDMETHOD.


  METHOD zif_btocs_sec_mgr~get_unix_timestamp.

* ----- prepare timestamp
    DATA(lv_timestamp) = iv_timestamp.
    IF lv_timestamp IS INITIAL.
      GET TIME STAMP FIELD lv_timestamp.
    ENDIF.

* ----- delta?
    IF iv_delta_sec <> 0.
      lv_timestamp = cl_abap_tstmp=>add_to_short(
                       tstmp = lv_timestamp                  " UTC Time Stamp
                       secs  = iv_delta_sec                 " Time Interval in Seconds
                     ).
    ENDIF.


* ----- convert
    CONVERT TIME STAMP lv_timestamp
      TIME ZONE 'UTC'
      INTO DATE DATA(lv_date)
      TIME DATA(lv_time).

* ------ map
    cl_pco_utility=>convert_abap_timestamp_to_java(
        EXPORTING
            iv_date = lv_date
            iv_time = lv_time
        IMPORTING
            ev_timestamp = rv_unix
    ).

* ------- workaround 000
    DATA(lv_len) = strlen( rv_unix ).
    IF lv_len > 12 AND rv_unix CP '*000'.
      DATA(lv_len_wa) = lv_len - 3.
      rv_unix = rv_unix(lv_len_wa).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
