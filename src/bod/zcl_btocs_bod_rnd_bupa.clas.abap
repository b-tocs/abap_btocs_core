CLASS zcl_btocs_bod_rnd_bupa DEFINITION
  PUBLIC
  INHERITING FROM zcl_btocs_bod_rnd
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zif_btocs_bod_rnd~set_context
        REDEFINITION .
    METHODS zif_btocs_bod_rnd~render
        REDEFINITION .
  PROTECTED SECTION.

*    TYPES: tt_bapiadtel TYPE TABLE OF bapiadtel WITH NON-UNIQUE DEFAULT KEY.
*    TYPES: tt_bapiadfax TYPE TABLE OF bapiadfax.
*    TYPES: tt_bapiadsmtp TYPE TABLE OF bapiadsmtp.
*    TYPES: tt_bapiaduri TYPE TABLE OF bapiaduri.
*
*    TYPES:
*      BEGIN OF ts_bupa_data_cen,
*        central TYPE bapibus1006_central,
*        per     TYPE bapibus1006_central_person,
*        org     TYPE bapibus1006_central_organ,
*        grp     TYPE bapibus1006_central_group,
*        tel     TYPE com_bupa_bapiadtel,
*        fax     TYPE com_bupa_bapiadfax,
*        email   TYPE com_bupa_bapiadsmtp,
*        uri     TYPE com_bupa_bapiaduri,
*      END OF ts_bupa_data_cen.
*
*    TYPES:
*      BEGIN OF ts_bupa_data_adr,
*        address TYPE bapibus1006_address,
*        per     TYPE bapibus1006_central_person,
*        org     TYPE bapibus1006_central_organ,
*        grp     TYPE bapibus1006_central_group,
*        tel     TYPE com_bupa_bapiadtel,
*        fax     TYPE com_bupa_bapiadfax,
*        email   TYPE com_bupa_bapiadsmtp,
*        uri     TYPE com_bupa_bapiaduri,
*      END OF ts_bupa_data_adr.

*"  EXPORTING
*"     VALUE(ADDRESSDATA) LIKE  BAPIBUS1006_ADDRESS STRUCTURE
*"        BAPIBUS1006_ADDRESS
*"     VALUE(ADDRESS_DEP_ATTR_DATA) LIKE  BAPIBUS1006_ADDR_DEP_ATT
*"       STRUCTURE  BAPIBUS1006_ADDR_DEP_ATT
*"  TABLES
*"      BAPIADTEL STRUCTURE  BAPIADTEL OPTIONAL
*"      BAPIADFAX STRUCTURE  BAPIADFAX OPTIONAL
*"      BAPIADTTX STRUCTURE  BAPIADTTX OPTIONAL
*"      BAPIADTLX STRUCTURE  BAPIADTLX OPTIONAL
*"      BAPIADSMTP STRUCTURE  BAPIADSMTP OPTIONAL
*"      BAPIADRML STRUCTURE  BAPIADRML OPTIONAL
*"      BAPIADX400 STRUCTURE  BAPIADX400 OPTIONAL
*"      BAPIADRFC STRUCTURE  BAPIADRFC OPTIONAL
*"      BAPIADPRT STRUCTURE  BAPIADPRT OPTIONAL
*"      BAPIADSSF STRUCTURE  BAPIADSSF OPTIONAL
*"      BAPIADURI STRUCTURE  BAPIADURI OPTIONAL
*"      BAPIADPAG STRUCTURE  BAPIADPAG OPTIONAL
*"      BAPIAD_REM STRUCTURE  BAPIAD_REM OPTIONAL
*"      BAPICOMREM STRUCTURE  BAPICOMREM OPTIONAL
*"      ADDRESSUSAGE STRUCTURE  BAPIBUS1006_ADDRESSUSAGE OPTIONAL
*"      BAPIADVERSORG STRUCTURE  BAPIAD1VD OPTIONAL
*"      BAPIADVERSPERS STRUCTURE  BAPIAD2VD OPTIONAL
*"      BAPIADUSE STRUCTURE  BAPIADUSE OPTIONAL
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL


*    TYPES:
*      BEGIN OF ts_bupa_data,
*        partner    TYPE bu_partner,
*        descr_long TYPE bu_descrip_name_long,
*        cen        TYPE ts_bupa_data_cen,
*        adr        TYPE ts_bupa_data_adr,
*      END OF ts_bupa_data .

    DATA mv_valid_date TYPE bu_valdt.
    DATA ms_bupa TYPE zbtocs_bod_s_doc_bupa.
    DATA mt_return TYPE TABLE OF bapiret2 .


    METHODS check_id
      RETURNING
        VALUE(rv_valid) TYPE abap_bool .
    METHODS load_data
      RETURNING
        VALUE(rv_success) TYPE abap_bool .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTOCS_BOD_RND_BUPA IMPLEMENTATION.


  METHOD zif_btocs_bod_rnd~render.

* ------- check
    IF ms_bupa-partner IS INITIAL
      OR ms_bupa-descr_long IS INITIAL.
      get_logger( )->error( |wrong context for rendering business partner| ).
      RETURN.
    ENDIF.


* ------- init tools
    DATA(lo_doc) = io_doc.
    IF lo_doc IS INITIAL.
      lo_doc = zcl_btocs_factory=>create_bo_document_manager( )->new_document( ).
      lo_doc->set_logger( get_logger( ) ).
    ENDIF.

    DATA(lo_md) = zcl_btocs_factory=>create_markdown_util( ).
    lo_md->set_logger( get_logger( ) ).


* ------- render
    lo_md->add_header( |Business Partner { ms_bupa-partner } - { ms_bupa-descr_long }| ).

    DATA(lv_style)     = ||.
    DATA(lv_max_level) = 3.

    DATA(lt_header) = VALUE zbtocs_t_key_value(
      ( key = '/cen' value = 'Central data' )
      ( key = '/adr' value = 'Address data' )
    ).

* ------- central
    lo_md->add_structure(
        is_data          = ms_bupa-central                 " Table of Strings
        iv_style         = lv_style
        iv_no_empty      = abap_true
        iv_prefix        = '-'
*        iv_separator     = ':'
        iv_path          = '/cen'
        iv_current_level = 1
        iv_max_level     = iv_detail_level
        it_headers       = lt_header                 " Key value tab
    ).

    lo_md->add_structure(
        is_data          = ms_bupa-address                 " Table of Strings
        iv_style         = lv_style
        iv_no_empty      = abap_true
        iv_prefix        = '-'
*        iv_separator     = ':'
        iv_path          = '/adr'
        iv_current_level = 1
        iv_max_level     = iv_detail_level
        it_headers       = lt_header                 " Key value tab
    ).



* ------- get content
    DATA(lv_md) = lo_md->to_string( ).
    lo_doc->set_content(
      iv_content      = lv_md
      iv_content_type = 'text/markdown'
*    iv_chunk        =
*    iv_page         =
*    iv_offset       =
    ).


* ------- set success
    ro_doc = lo_doc.



  ENDMETHOD.


  METHOD zif_btocs_bod_rnd~set_context.

* ------ local data
    DATA lt_return TYPE bapiret2_tab.

* ------ call super
    super->zif_btocs_bod_rnd~set_context(
        iv_type    = iv_type
        iv_id      = iv_id
        it_context = it_context                 " Key value tab
    ).

* ------- check id is valid
    IF check_id( ) EQ abap_false.
      RETURN.
    ENDIF.

* ------- load data
    IF load_data( ) EQ abap_false.
      RETURN.
    ENDIF.


* ------ set success
    rv_success = abap_true.

  ENDMETHOD.


  METHOD check_id.

* ------- check
    IF mv_id IS INITIAL.
      get_logger( )->error( |id required| ).
      RETURN.
    ENDIF.


* ------ prepare
    CLEAR ms_bupa.
    DATA(lv_partner) = VALUE bu_partner( ).
    lv_partner = mv_id.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_partner
      IMPORTING
        output = lv_partner.

    IF mv_valid_date IS INITIAL.
      mv_valid_date = sy-datlo.
    ENDIF.


* ------ check
    CLEAR mt_return.
    CALL FUNCTION 'BUPA_DESCRIPTION_GET'
      EXPORTING
        iv_partner           = lv_partner
*       IV_PARTNER_GUID      =
        iv_valdt             = mv_valid_date
      IMPORTING
*       EV_DESCRIPTION       =
*       EV_DESCRIPTION_NAME  =
        ev_descrip_name_long = ms_bupa-descr_long
*       EV_DESCRIPTION_LONG  =
*       EV_NAME_CITY_LONG    =
      TABLES
        et_return            = mt_return.

    get_logger( )->add_msgs( mt_return ).

    IF ms_bupa IS INITIAL.
      get_logger( )->error( |no a valid business partner: { lv_partner }| ).
    ELSE.
      ms_bupa-partner = lv_partner.
      rv_valid        = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD load_data.

* ------ check
    IF ms_bupa-partner IS INITIAL.
      get_logger( )->error( |no partner id initialized| ).
      RETURN.
    ENDIF.

* ------ get central data
    CLEAR mt_return.
    CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
      EXPORTING
        businesspartner          = ms_bupa-partner
        valid_date               = mv_valid_date
*       IV_REQ_MASK              = 'X'
      IMPORTING
        centraldata              = ms_bupa-central-central
        centraldataperson        = ms_bupa-central-per
        centraldataorganization  = ms_bupa-central-org
        centraldatagroup         = ms_bupa-central-grp
      TABLES
        telefondatanonaddress    = ms_bupa-central-tel
        faxdatanonaddress        = ms_bupa-central-fax
        e_maildatanonaddress     = ms_bupa-central-email
        uriaddressdatanonaddress = ms_bupa-central-uri
        return                   = mt_return.

    get_logger( )->add_msgs( mt_return ).
    IF get_logger( )->has_errors( mt_return ).
      get_logger( )->error( |loading bupa central data failed| ).
      RETURN.
    ENDIF.

* ------ get address data
    CLEAR mt_return.
    CALL FUNCTION 'BAPI_BUPA_ADDRESS_GETDETAIL'
      EXPORTING
        businesspartner = ms_bupa-partner
*       ADDRESSGUID     =
        valid_date      = mv_valid_date
*       RESET_BUFFER    =
      IMPORTING
        addressdata     = ms_bupa-address-address
*       ADDRESS_DEP_ATTR_DATA       =
      TABLES
        bapiadtel       = ms_bupa-address-tel
        bapiadfax       = ms_bupa-address-fax
        bapiadsmtp      = ms_bupa-address-email
        bapiaduri       = ms_bupa-address-uri
*       BAPIAD_REM      =
*       BAPICOMREM      =
        return          = mt_return.

    get_logger( )->add_msgs( mt_return ).
    IF get_logger( )->has_errors( mt_return ).
      get_logger( )->error( |loading bupa address data failed| ).
      RETURN.
    ENDIF.


* ------ finally true
    rv_success = abap_true.
  ENDMETHOD.
ENDCLASS.
