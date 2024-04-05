class ZCL_BTOCS_BOD_RND_BUPA definition
  public
  inheriting from ZCL_BTOCS_BOD_RND
  create public .

public section.

  methods ZIF_BTOCS_BOD_RND~LOAD_DATA
    redefinition .
  methods ZIF_BTOCS_BOD_RND~RENDER
    redefinition .
  methods ZIF_BTOCS_BOD_RND~SET_CONTEXT
    redefinition .
protected section.

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
  data MV_VALID_DATE type BU_VALDT .
  data MS_BUPA type ZBTOCS_BOD_S_DOC_BUPA .
  data:
    mt_return TYPE TABLE OF bapiret2 .

  methods CHECK_ID
    returning
      value(RV_VALID) type ABAP_BOOL .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTOCS_BOD_RND_BUPA IMPLEMENTATION.


  METHOD zif_btocs_bod_rnd~render.

* ------- loaad data
    IF zif_btocs_bod_rnd~is_data_loaded( ) EQ abap_false.
      IF zif_btocs_bod_rnd~load_data(
         iv_detail_level = iv_detail_level
        ) EQ abap_false.
        get_logger( )->error( |loading data failed| ).
        RETURN.
      ENDIF.
    ENDIF.

* ------- check
    IF ms_bupa-partner IS INITIAL
      OR ms_bupa-descr_long IS INITIAL.
      get_logger( )->error( |wrong context for rendering business partner| ).
      RETURN.
    ENDIF.

* ------- set defaults
    DATA(lv_header_level) = iv_header_level + 1.
    DATA(lv_style)        = ||.
    DATA(lv_max_level)    = 3.


* ------- init markdown
    DATA(lo_md) = zif_btocs_bod_rnd~get_markdown_util( ).

    IF iv_structure_style IS NOT INITIAL.
      lo_md->set_style_structure( iv_structure_style ).
    ENDIF.

    IF iv_table_style IS NOT INITIAL.
      lo_md->set_style_table( iv_table_style ).
    ENDIF.


* ------- define texts
    DATA(lt_header) = VALUE zbtocs_t_key_value(
      ( key = '/cen'            value = 'Central data' )
      ( key = '/cen/EMAIL'      value = 'Private Email' )
      ( key = '/cen/TEL'        value = 'Private Telephone' )
      ( key = '/cen/FAX'        value = 'Private Fax' )
      ( key = '/cen/URI'        value = 'Private URI' )
      ( key = '/adr'            value = 'Address data' )
      ( key = '/adr/EMAIL'      value = 'Business Email' )
      ( key = '/adr/TEL'        value = 'Business Telephone' )
      ( key = '/adr/FAX'        value = 'Business Fax' )
      ( key = '/adr/URI'        value = 'Business URI' )
    ).


* ------- render
    IF iv_no_title EQ abap_false.
      DATA(lv_title) = zif_btocs_bod_rnd~get_title( ).
      lo_md->add_hx(
          iv_text       = lv_title
          iv_level      = lv_header_level
      ).
    ELSE.
      lo_md->set_last_header_level( lv_header_level ).
    ENDIF.

    IF iv_detail_level = zif_btocs_bod_rnd=>c_detail_level-abstract.
      lo_md->add_lines( zif_btocs_bod_rnd~get_abstract( ) ).
    ELSE.

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
    ENDIF.


* ------- set success
    ro_doc = transform_markdown_to_doc(
      io_markdown = lo_md
      io_doc      = io_doc
    ).

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
    IF iv_load_data EQ abap_true.
      IF ZIF_BTOCS_BOD_RND~load_data( ) EQ abap_false.
        RETURN.
      ENDIF.
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

      IF ms_bupa-descr_long IS NOT INITIAL.
        mv_title = |{ ms_bupa-partner } - { ms_bupa-descr_long }|.
      ELSE.
        mv_title = |{ mv_type }{ ms_bupa-partner }|.
      ENDIF.

      rv_valid        = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_bod_rnd~load_data.
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
      get_logger( )->warning( |loading bupa address data failed| ).
    ENDIF.


* ------ finally true
    mv_data_loaded  = abap_true.
    rv_success      = abap_true.
  ENDMETHOD.
ENDCLASS.
