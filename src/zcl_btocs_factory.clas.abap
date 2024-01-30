CLASS zcl_btocs_factory DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_btocs_c .

    CLASS-METHODS create_convert_util
      RETURNING
        VALUE(rr_instance) TYPE REF TO zif_btocs_util_convert .
    CLASS-METHODS create_gui_util
      RETURNING
        VALUE(rr_instance) TYPE REF TO zif_btocs_gui_utils .
    CLASS-METHODS create_logger
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_util_logger .
    CLASS-METHODS create_config_manager
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_util_cfg_mgr .
    CLASS-METHODS create_json_util
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_util_json .
    CLASS-METHODS create_secret_manager
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_sec_mgr .
    CLASS-METHODS create_text_util
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_util_text .
    CLASS-METHODS create_user_util
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_util_user .
    CLASS-METHODS create_value_manager
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_value_mgr .
    CLASS-METHODS create_web_service_client
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_rws_client .
    CLASS-METHODS create_web_service_request
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_rws_request .
    CLASS-METHODS create_web_service_response
      RETURNING
        VALUE(ro_instance) TYPE REF TO zif_btocs_rws_response .
    CLASS-METHODS create_instance
      IMPORTING
        !iv_interface      TYPE data
      RETURNING
        VALUE(ro_instance) TYPE REF TO object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTOCS_FACTORY IMPLEMENTATION.


  METHOD create_instance.

* ------- prepare type
    DATA(lv_name) = CONV seoclsname( iv_interface ).

    IF lv_name CP 'ZIF_*'.
      REPLACE 'ZIF_' IN lv_name WITH 'ZCL_'.
    ELSEIF lv_name CP '/*/IF'.
      REPLACE '/IF' IN lv_name WITH '/CL'.
    ENDIF.


* -------- create type
    TRY.
        CREATE OBJECT ro_instance TYPE (lv_name).
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD create_logger.
    ro_instance ?= create_instance( 'ZIF_BTOCS_UTIL_LOGGER' ).
  ENDMETHOD.


  METHOD create_web_service_client.
    ro_instance ?= create_instance( 'ZIF_BTOCS_RWS_CLIENT' ).
  ENDMETHOD.


  METHOD create_web_service_request.
    ro_instance ?= create_instance( 'ZIF_BTOCS_RWS_REQUEST' ).
  ENDMETHOD.


  METHOD create_web_service_response.
    ro_instance ?= create_instance( 'ZIF_BTOCS_RWS_RESPONSE' ).
  ENDMETHOD.


  METHOD create_config_manager.
    ro_instance ?= create_instance( 'ZIF_BTOCS_UTIL_CFG_MGR' ).
  ENDMETHOD.


  METHOD create_secret_manager.
    ro_instance ?= create_instance( 'ZIF_BTOCS_SEC_MGR' ).
  ENDMETHOD.


  METHOD create_user_util.
    ro_instance ?= create_instance( 'ZIF_BTOCS_UTIL_USER' ).
  ENDMETHOD.


  METHOD create_value_manager.
    ro_instance ?= create_instance( 'ZIF_BTOCS_VALUE_MGR' ).
  ENDMETHOD.


  METHOD create_convert_util.
    rr_instance ?= create_instance( 'ZIF_BTOCS_UTIL_CONVERT' ).
  ENDMETHOD.


  METHOD create_gui_util.
    rr_instance ?= create_instance( 'ZIF_BTOCS_GUI_UTILS' ).
  ENDMETHOD.


  METHOD create_json_util.
    ro_instance ?= create_instance( 'ZIF_BTOCS_UTIL_JSON' ).
  ENDMETHOD.


  METHOD create_text_util.
    ro_instance ?= create_instance( 'ZIF_BTOCS_UTIL_TEXT' ).
  ENDMETHOD.
ENDCLASS.
