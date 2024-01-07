class ZCL_BTOCS_FACTORY definition
  public
  create public .

public section.

  interfaces ZIF_BTOCS_C .

  class-methods CREATE_LOGGER
    returning
      value(RO_LOGGER) type ref to ZIF_BTOCS_UTIL_LOGGER .
  class-methods CREATE_CONFIG_MANAGER
    returning
      value(RO_LOGGER) type ref to ZIF_BTOCS_UTIL_CFG_MGR .
  class-methods CREATE_SECRET_MANAGER
    returning
      value(RO_LOGGER) type ref to ZIF_BTOCS_SEC_MGR .
  class-methods CREATE_WEB_SERVICE_CLIENT
    returning
      value(RO_LOGGER) type ref to ZIF_BTOCS_RWS_CLIENT .
  class-methods CREATE_WEB_SERVICE_REQUEST
    returning
      value(RO_LOGGER) type ref to ZIF_BTOCS_RWS_REQUEST .
  class-methods CREATE_WEB_SERVICE_RESPONSE
    returning
      value(RO_LOGGER) type ref to ZIF_BTOCS_RWS_RESPONSE .
  class-methods CREATE_INSTANCE
    importing
      !IV_INTERFACE type DATA
    returning
      value(RO_INSTANCE) type ref to OBJECT .
protected section.
private section.
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
    ro_logger ?= create_instance( 'ZIF_BTOCS_UTIL_LOGGER' ).
  ENDMETHOD.


  METHOD create_web_service_client.
    ro_logger ?= create_instance( 'ZIF_BTOCS_RWS_CLIENT' ).
  ENDMETHOD.


  METHOD create_web_service_request.
    ro_logger ?= create_instance( 'ZIF_BTOCS_RWS_REQUEST' ).
  ENDMETHOD.


  METHOD create_web_service_response.
    ro_logger ?= create_instance( 'ZIF_BTOCS_RWS_RESPONSE' ).
  ENDMETHOD.


  METHOD CREATE_CONFIG_MANAGER.
    ro_logger ?= create_instance( 'ZIF_BTOCS_UTIL_CFG_MGR' ).
  ENDMETHOD.


  METHOD CREATE_SECRET_MANAGER.
    ro_logger ?= create_instance( 'ZIF_BTOCS_SEC_MGR' ).
  ENDMETHOD.
ENDCLASS.