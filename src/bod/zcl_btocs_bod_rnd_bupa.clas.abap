class ZCL_BTOCS_BOD_RND_BUPA definition
  public
  inheriting from ZCL_BTOCS_BOD_RND
  create public .

public section.

  methods ZIF_BTOCS_BOD_RND~SET_CONTEXT
    redefinition .
  methods ZIF_BTOCS_BOD_RND~RENDER
    redefinition .
protected section.

  data MS_BUT000 type BUT000 .
  data MV_DESCRIPTION type BU_DESCRIP_NAME_LONG .
  data MV_PARTNER type BU_PARTNER .
  data MS_CEN_DATA type BAPIBUS1006_CENTRAL .
  data MS_CEN_PER type BAPIBUS1006_CENTRAL_PERSON .
  data MS_CEN_ORG type BAPIBUS1006_CENTRAL_ORGAN .
  data MS_CEN_GRP type BAPIBUS1006_CENTRAL_GROUP .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_BOD_RND_BUPA IMPLEMENTATION.


  METHOD zif_btocs_bod_rnd~render.

* ------- check
    IF mv_partner IS INITIAL
      OR mv_description IS INITIAL.
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
    lo_md->add_header( |Business Partner { mv_partner } - { mv_description }| ).


* ------- central
    lo_md->add_subheader( |Central data| ).
    lo_md->add_structure( ms_cen_data ).
    lo_md->add_structure( ms_cen_org ).
    lo_md->add_structure( ms_cen_per ).
    lo_md->add_structure( ms_cen_grp ).


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

* ------ prepare
    mv_partner = iv_id.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = mv_partner
      IMPORTING
        output = mv_partner.


* ------ check
    CALL FUNCTION 'BUPA_DESCRIPTION_GET'
      EXPORTING
        iv_partner           = mv_partner
*       IV_PARTNER_GUID      =
*       IV_VALDT             = SY-DATLO
      IMPORTING
*       EV_DESCRIPTION       =
*       EV_DESCRIPTION_NAME  =
        ev_descrip_name_long = mv_description
*       EV_DESCRIPTION_LONG  =
*       EV_NAME_CITY_LONG    =
      TABLES
        et_return            = lt_return.

    IF mv_description IS INITIAL.
      get_logger( )->error( |no a valid business partner: { mv_partner }| ).
      CLEAR: mv_partner.
      RETURN.
    ENDIF.

* ------ get infos
  CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
    EXPORTING
      businesspartner                    = mv_partner
*     VALID_DATE                         = SY-DATLO
*     IV_REQ_MASK                        = 'X'
   IMPORTING
     CENTRALDATA                        = ms_cen_data
     CENTRALDATAPERSON                  = ms_cen_per
     CENTRALDATAORGANIZATION            = ms_cen_org
     CENTRALDATAGROUP                   = ms_cen_grp
*     CENTRALDATAVALIDITY                =
*   TABLES
*     TELEFONDATANONADDRESS              =
*     FAXDATANONADDRESS                  =
*     TELETEXDATANONADDRESS              =
*     TELEXDATANONADDRESS                =
*     E_MAILDATANONADDRESS               =
*     RMLADDRESSDATANONADDRESS           =
*     X400ADDRESSDATANONADDRESS          =
*     RFCADDRESSDATANONADDRESS           =
*     PRTADDRESSDATANONADDRESS           =
*     SSFADDRESSDATANONADDRESS           =
*     URIADDRESSDATANONADDRESS           =
*     PAGADDRESSDATANONADDRESS           =
*     COMMUNICATIONNOTESNONADDRESS       =
*     COMMUNICATIONUSAGENONADDRESS       =
*     RETURN                             =
            .



* ------ set success
    rv_success = abap_true.

  ENDMETHOD.
ENDCLASS.
