class ZCL_BTOCS_RWS_CONNECTOR definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_RWS_CONNECTOR .
protected section.

  data MO_CLIENT type ref to ZIF_BTOCS_RWS_CLIENT .
  data MV_RFCDEST type RFCDEST .
  data MV_PROFILE type ZBTOCS_RWS_PROFILE .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_RWS_CONNECTOR IMPLEMENTATION.


  METHOD zif_btocs_rws_connector~execute.

* -------- prepare response
    ro_response = COND #( WHEN io_response IS NOT INITIAL
                          THEN io_response
                          ELSE zif_btocs_rws_connector~new_response( ) ).

* -------- prepare client
    DATA(lo_client) = COND #( WHEN io_client IS NOT INITIAL
                              THEN io_client
                              ELSE zif_btocs_rws_connector~get_client( ) ).
    IF lo_client IS INITIAL.
      ro_response->set_reason( |no client available for connector execute| ).
      RETURN.
    ENDIF.

* -------- set api path
    IF iv_api_path IS NOT INITIAL.
      IF lo_client->set_endpoint_path( iv_api_path ) EQ abap_false.
        ro_response->set_reason( |set api path to { iv_api_path } failed| ).
        RETURN.
      ELSE.
        get_logger( )->debug( |connector api path set to { iv_api_path }| ).
      ENDIF.
    ENDIF.


* -------- execute
    ro_response = lo_client->execute(
     iv_method   = iv_method
      io_response = ro_response
    ).

  ENDMETHOD.


  METHOD zif_btocs_rws_connector~get_client.

* -------- set client
    IF mo_client IS INITIAL.
      get_logger( )->error( |no client available - not initialized| ).
    ELSE.
      IF iv_duplicate EQ abap_false.
        ro_client = mo_client.
      ELSE.
        get_logger( )->error( |duplicate client not implemented yet| ).
      ENDIF.
    ENDIF.

* -------- check?
    IF iv_check_initialized EQ abap_true.
      IF ro_client IS NOT INITIAL
        AND ro_client->is_client_initialized( ) EQ abap_false.
        get_logger( )->error( |client is not initialized| ).
        CLEAR ro_client.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_rws_connector~is_initialized.
    IF mv_rfcdest IS NOT INITIAL
      AND mo_client IS NOT INITIAL
      AND mo_client->is_client_initialized( ).
      rv_initialized = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_rws_connector~new_request.
    IF mo_client IS INITIAL.
      get_logger( )->error( |unable to create new request - client is not initialized| ).
    ELSE.
      ro_request = mo_client->new_request( ).
      get_logger( )->error( |new request for connector created from current client| ).
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_RWS_CONNECTOR~NEW_RESPONSE.
    ro_response ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_RWS_RESPONSE' ).
  endmethod.


  METHOD zif_btocs_rws_connector~set_endpoint.

* ------- check clean instance
    IF mv_rfcdest IS NOT INITIAL
      OR mo_client IS NOT INITIAL.
      get_logger( )->error( |set endpoint failed. clean instance first| ).
      RETURN.
    ENDIF.

* -------- create new instance
    DATA(lo_client) = zcl_btocs_factory=>create_web_service_client( ).
    lo_client->set_logger( get_logger( ) ).
    IF lo_client->set_endpoint_by_rfc_dest( iv_rfc ) EQ abap_false.
      get_logger( )->error( |init connector client for destination { iv_rfc } failed| ).
      RETURN.
    ENDIF.

* --------- set different profile
    IF iv_profile IS NOT INITIAL.
      IF lo_client->set_config_by_profile( iv_profile  ) EQ abap_false.
        get_logger( )->error( |set connector config by profile { iv_profile } failed| ).
        RETURN.
      ENDIF.
    ENDIF.

* --------- last check
    IF lo_client->is_client_initialized( ) EQ abap_false.
      get_logger( )->error( |client is invalid after initialization| ).
      lo_client->destroy( ).
      RETURN.
    ELSE.
* --------- prepare result
      mo_client  = lo_client.
      mv_profile = iv_profile.
      mv_rfcdest = iv_rfc.
      rv_success = abap_true.
      get_logger( )->debug( |connector initialized for destination '{ iv_rfc }' profile '{ iv_profile }'| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
