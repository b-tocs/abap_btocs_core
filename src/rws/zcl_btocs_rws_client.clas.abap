class ZCL_BTOCS_RWS_CLIENT definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_RWS_CLIENT .

  methods ZIF_BTOCS_UTIL_BASE~DESTROY
    redefinition .
protected section.

  data MO_CLIENT type ref to IF_HTTP_CLIENT .
  data MV_TIMEOUT type I value 0 ##NO_TEXT.
  data MV_NO_CLOSE type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.
  data MO_REQUEST type ref to ZIF_BTOCS_RWS_REQUEST .
  data MO_LAST_RESPONSE type ref to ZIF_BTOCS_RWS_RESPONSE .
  data MV_HTTP_VERSION type I value 1001 ##NO_TEXT.
  data MO_CONFIG_MGR type ref to ZIF_BTOCS_UTIL_CFG_MGR .
  data MS_RWS_CONFIG type ZBTOCS_CFG_S_RFC_REC .
  data MV_API_KEY type STRING .

  methods CLIENT_PREPARE_AUTH
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods CLIENT_PREPARE_BEFORE_SEND
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_RWS_CLIENT IMPLEMENTATION.


  METHOD client_prepare_before_send.

* ----- set standard params
    mo_client->request->set_version( mv_http_version ).

* ----- check request
    IF mo_request IS INITIAL.
      zif_btocs_rws_client~new_request( ).
      get_logger( )->debug( |empty request created| ).
    ENDIF.

* ----- set auth methods
    IF ms_rws_config-auth_method IS NOT INITIAL.
      IF client_prepare_auth( ) EQ abap_false.
        get_logger( )->warning( |set authentification failed| ).
      ENDIF.
    ENDIF.

* ----- fill content
    IF mo_request IS NOT INITIAL.
      IF mo_request->set_client( mo_client ) EQ abap_false.
        get_logger( )->error( |prepare client data failed| ).
        RETURN.
      ENDIF.
    ENDIF.

* ----- finally success
    rv_success = abap_true.

  ENDMETHOD.


  method ZIF_BTOCS_RWS_CLIENT~CLEAR.
    clear: mo_request.
    get_logger( )->debug( |client data cleared| ).
  endmethod.


  METHOD zif_btocs_rws_client~close.
* ----- close client
    IF mo_client IS NOT INITIAL.
      mo_client->close( ).
      CLEAR mo_client.
      get_logger( )->debug( |client closed| ).
    ENDIF.

* ----- clear others
    zif_btocs_rws_client~clear( ).
  ENDMETHOD.


  METHOD zif_btocs_rws_client~execute.

* -------- local macro
    DEFINE mc_return.
      IF mv_no_close EQ abap_false.
        zif_btocs_rws_client~close( ).
        RETURN.
      ENDIF.
    END-OF-DEFINITION.

* -------- prepare response
    CLEAR mo_last_response.
    IF io_response IS NOT INITIAL.
      ro_response = io_response.
      IF ro_response->is_logger_external( ) EQ abap_false.
        ro_response->set_logger( get_logger( ) ).
      ENDIF.
      ro_response->set_status_code( 500 ).
      ro_response->set_reason(
        iv_reason       = |unknown error|
        iv_no_formward  = abap_true
      ).
      get_logger( )->debug( |external response object was used| ).
    ELSE.
      ro_response = zcl_btocs_factory=>create_web_service_response( ).
      ro_response->set_logger( get_logger( ) ).
    ENDIF.
    mo_last_response = ro_response.


* -------- check client and set client method
    IF mo_client IS INITIAL.
      ro_response->set_reason( |client is not initialized| ).
      RETURN.
    ENDIF.

    mo_client->request->set_method( CONV string( iv_method ) ).
    IF client_prepare_before_send( ) EQ abap_false.
      ro_response->set_reason( |client preparation failed| ).
      mc_return.
    ENDIF.

* -------- send
    mo_client->send(
      EXPORTING
        timeout                    = mv_timeout
      EXCEPTIONS
        http_communication_failure = 1                  " Communication Error
        http_invalid_state         = 2                  " Invalid state
        http_processing_failed     = 3                  " Error when processing method
        http_invalid_timeout       = 4                  " Invalid Time Entry
        OTHERS                     = 5
    ).
    IF sy-subrc <> 0.
      ro_response->set_reason( |error while sending: subrc { sy-subrc }| ).
      mc_return.
    ENDIF.

* -------- receive
    mo_client->receive(
      EXCEPTIONS
        http_communication_failure = 1                " Communication Error
        http_invalid_state         = 2                " Invalid state
        http_processing_failed     = 3                " Error when processing method
        OTHERS                     = 4
    ).
    IF sy-subrc <> 0.
      ro_response->set_reason( |error while receiving data: subrc { sy-subrc }| ).
      mc_return.
    ELSE.
* --------- set data from response
      IF ro_response->set_from_client( mo_client ) EQ abap_false.
        get_logger( )->error( |set response from client failed| ).
      ENDIF.
    ENDIF.

* --------- cleanup
    IF mv_no_close EQ abap_false.
      zif_btocs_rws_client~close( ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_rws_client~is_client_initialized.
    rv_initialized = COND #( WHEN mo_client IS NOT INITIAL
                             THEN abap_true
                             ELSE abap_false ).
  ENDMETHOD.


  METHOD zif_btocs_rws_client~post.

* ------ check raw input and set as request
    IF iv_content_type IS NOT INITIAL.
      DATA(lo_request) = zif_btocs_rws_client~new_request( ).
      lo_request->set_data(
          iv_content_type = iv_content_type
          iv_content      = iv_content
          iv_binary       = iv_binary
      ).
    ENDIF.

* ------ call execute
    ro_response =  zif_btocs_rws_client~execute(
      iv_method   = 'POST'
      io_response = io_response
    ).

  ENDMETHOD.


  METHOD zif_btocs_rws_client~set_endpoint_by_rfc_dest.

* ------ check is initialized
    IF mo_client IS NOT INITIAL.
      get_logger( )->error( |client initialized already| ).
      RETURN.
    ENDIF.


* ------ create new client
    cl_http_client=>create_by_destination(
      EXPORTING
        destination                = iv_rfc                 " Logical destination (specified in function call)
      IMPORTING
        client                     = mo_client                " HTTP Client Abstraction
      EXCEPTIONS
        argument_not_found         = 1                " Connection parameter (destination) not available
        destination_not_found      = 2                " Destination was not found
        destination_no_authority   = 3                " No Authorization to Use HTTP Destination
        plugin_not_active          = 4                " HTTP/HTTPS communication not available
        internal_error             = 5                " Internal error (e.g. name too long)
        oa2c_set_token_error       = 6                " General error when setting the OAuth token
        oa2c_missing_authorization = 7
        oa2c_invalid_config        = 8
        oa2c_invalid_parameters    = 9
        oa2c_invalid_scope         = 10
        oa2c_invalid_grant         = 11
        OTHERS                     = 12
    ).
    IF sy-subrc <> 0.
      get_logger( )->error( |error while initializing client for rfc { iv_rfc }| ).
      RETURN.
    ENDIF.

* -------- check config
    IF zif_btocs_rws_client~is_config( ) EQ abap_false.
      ms_rws_config = zif_btocs_rws_client~get_config_manager( )->read_rws_config_rfcdest(
                                                                 iv_rfcdest      = iv_rfc                 " Remote Web Service Profile
                                                                 iv_read_profile = abap_true
         	                                                      ).
      IF ms_rws_config IS NOT INITIAL.
        get_logger( )->debug( |RFC destination { iv_rfc } is configured| ).
      ENDIF.
    ENDIF.


* -------- finally success
    get_logger( )->debug( |client initialized by rfc { iv_rfc }| ).
    rv_success = abap_true.

  ENDMETHOD.


  METHOD zif_btocs_rws_client~set_endpoint_by_url.


* ------ check is initialized
    IF mo_client IS NOT INITIAL.
      get_logger( )->error( |client initialized already| ).
      RETURN.
    ENDIF.


* ------ create new client
    cl_http_client=>create_by_url(
      EXPORTING
        url                        =  iv_url                 " URL
*        proxy_host                 =                  " Logical destination (specified in function call)
*        proxy_service              =                  " Port Number
*        ssl_id                     =                  " SSL Identity
*        sap_username               =                  " ABAP System, User Logon Name
*        sap_client                 =                  " R/3 system (client number from logon)
*        proxy_user                 =                  " Proxy user
*        proxy_passwd               =                  " Proxy password
*        do_not_use_client_cert     = abap_false       " SSL identity not used for logon
*        use_scc                    = abap_false       " Connection needed for SAP Cloud Connector
*        scc_location_id            =                  " Location ID for SAP Cloud Connector
*        oauth_profile              =                  " OAuth 2.0 client profile
*        oauth_config               =                  " OAuth 2.0 client configuration
      IMPORTING
        client                     = mo_client                  " HTTP Client Abstraction
      EXCEPTIONS
*        argument_not_found         = 1                " Communication parameter (host or service) not available
*        plugin_not_active          = 2                " HTTP/HTTPS communication not available
*        internal_error             = 3                " Internal error (e.g. name too long)
*        pse_not_found              = 4                " PSE not found
*        pse_not_distrib            = 5                " PSE not distributed
*        pse_errors                 = 6                " General PSE error
*        oa2c_set_token_error       = 7                " General error when setting OAuth token
*        oa2c_missing_authorization = 8
*        oa2c_invalid_config        = 9
*        oa2c_invalid_parameters    = 10
*        oa2c_invalid_scope         = 11
*        oa2c_invalid_grant         = 12
        OTHERS                     = 13
    ).
    IF sy-subrc <> 0.
      get_logger( )->error( |error while initializing client for url { iv_url }| ).
      RETURN.
    ENDIF.

* -------- check config
    IF iv_profile IS NOT INITIAL.
      zif_btocs_rws_client~set_config_by_profile( iv_profile ).
    ENDIF.


* -------- finally success
    get_logger( )->debug( |client initialized by rfc { iv_url }| ).
    rv_success = abap_true.
  ENDMETHOD.


  METHOD zif_btocs_rws_client~new_request.
    mo_request = zcl_btocs_factory=>create_web_service_request( ).
    mo_request->set_logger( get_logger( ) ).
    ro_request = mo_request.
    get_logger( )->debug( |new request created for client| ).
  ENDMETHOD.


  METHOD zif_btocs_rws_client~set_endpoint_path.

* ----- check
    IF mo_client IS INITIAL.
      get_logger( )->error( |error setting path - missing client| ).
      RETURN.
    ENDIF.

* ----- set path
    cl_http_utility=>set_request_uri(
      EXPORTING
        request    = mo_client->request                  " HTTP Framework (iHTTP) HTTP Request
        uri        = iv_path                 " URI-String (in Form von /path?query-string)
*      multivalue = 0                " mehrwertige Form-Felder
    ).

    get_logger( )->debug( |set path { iv_path } to request| ).
    rv_success = abap_true.
  ENDMETHOD.


  METHOD zif_btocs_util_base~destroy.
* ------ close client
    zif_btocs_rws_client~close( ).

* ------ call super
    super->zif_btocs_util_base~destroy( ).
  ENDMETHOD.


  method ZIF_BTOCS_RWS_CLIENT~GET_CONFIG.
    rs_config = ms_rws_config.
  endmethod.


  METHOD zif_btocs_rws_client~get_config_manager.
    IF mo_config_mgr IS INITIAL.
      mo_config_mgr = zcl_btocs_factory=>create_config_manager( ).
      mo_config_mgr->set_logger( get_logger( ) ).
    ENDIF.
    ro_mgr = mo_config_mgr.
  ENDMETHOD.


  METHOD zif_btocs_rws_client~is_config.
    rv_config = COND #( WHEN ms_rws_config IS NOT INITIAL
                        THEN abap_true
                        ELSE abap_false ).
  ENDMETHOD.


  METHOD zif_btocs_rws_client~set_config.
    ms_rws_config = is_config.
  ENDMETHOD.


  METHOD zif_btocs_rws_client~set_config_by_profile.
    CLEAR ms_rws_config.
    DATA(ls_prf_cfg) = zif_btocs_rws_client~get_config_manager( )->read_rws_config_profile( iv_profile ).
    MOVE-CORRESPONDING ls_prf_cfg TO ms_rws_config.

    IF ms_rws_config IS NOT INITIAL.
      get_logger( )->debug( |Profile { iv_profile } is configured| ).
      rv_success = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD client_prepare_auth.

* ----- local data
    DATA lv_secret      TYPE string.
    DATA lv_secret_bin  TYPE xstring.
    DATA lv_is_sec_bin  TYPE abap_bool.
    DATA lv_token       TYPE string.


* ----- prepare manager
    DATA(lo_sec_mgr) = zcl_btocs_factory=>create_secret_manager( ).
    lo_sec_mgr->set_logger( get_logger( ) ).

* ----- get secret
    IF ms_rws_config-secret_method IS NOT INITIAL.
      DATA(lo_sec_met) = lo_sec_mgr->create_secret_method(
          iv_method   = ms_rws_config-secret_method
          iv_param    = ms_rws_config-secret_param
          ir_parent   = me
          is_config   = ms_rws_config
      ).
      IF lo_sec_met IS INITIAL.
        get_logger( )->error( |preparing secret failed. config error| ).
        RETURN.
      ELSE.
        IF lo_sec_met->get_secret(
                      IMPORTING
                        ev_bin_secret = lv_secret_bin
                        ev_secret     = lv_secret
                        ev_is_binary  = lv_is_sec_bin
         ) EQ abap_false.
          get_logger( )->error( |secret not found| ).
          RETURN.
        ELSE.
          get_logger( )->debug( |secret prepared| ).
        ENDIF.
      ENDIF.
    ENDIF.

* ----- get auth method
    IF ms_rws_config-auth_method IS NOT INITIAL.
      DATA(lo_auth_met) = lo_sec_mgr->create_auth_method(
          iv_method   = ms_rws_config-auth_method
          iv_param    = ms_rws_config-auth_param
          ir_parent   = me
          is_config   = ms_rws_config
      ).
      IF lo_auth_met IS INITIAL.
        get_logger( )->error( |preparing authentification failed. config error| ).
        RETURN.
      ELSE.
        IF lo_auth_met->prepare_auth(
          EXPORTING
            ir_client     = me
            iv_secret     = lv_secret
            iv_secret_bin = lv_secret_bin
          IMPORTING
            ev_token      = lv_token
         ) EQ abap_false.
          get_logger( )->error( |prepare authentification failed| ).
          RETURN.
        ELSE.
          get_logger( )->debug( |authentification prepared| ).
        ENDIF.
      ENDIF.
    ENDIF.


* ----- token method
    IF lv_token IS NOT INITIAL
      AND ms_rws_config-token_method IS NOT INITIAL.
      DATA(lo_token_met) = lo_sec_mgr->create_token_method(
          iv_method   = ms_rws_config-token_method
          iv_param    = ms_rws_config-token_param
          ir_parent   = me
          is_config   = ms_rws_config
      ).
      IF lo_token_met IS INITIAL.
        get_logger( )->error( |preparing token failed. config error| ).
        RETURN.
      ELSE.
        IF lo_token_met->set_token_to_request(
            iv_token   = lv_token
            ir_request = mo_request
         ) EQ abap_false.
          get_logger( )->error( |prepare token failed| ).
          RETURN.
        ELSE.
          get_logger( )->debug( |token prepared| ).
        ENDIF.
      ENDIF.
    ENDIF.


* ----- finally success
    rv_success = abap_true.

  ENDMETHOD.


  METHOD zif_btocs_rws_client~get_api_key.

* ----- prio 1 - get the manually set
    IF mv_api_key IS NOT INITIAL.
      rv_key = mv_api_key.
      get_logger( )->debug( |manually set api key is used| ).
      RETURN.
    ENDIF.

* ----- prio 2 - get the api key from current config
    IF ms_rws_config-api_key IS NOT INITIAL.
      rv_key = ms_rws_config-api_key.
      get_logger( )->debug( |api key from config is used| ).
      RETURN.
    ENDIF.

* ----- prio 3 - get it from secret
    IF ms_rws_config-secret_method IS NOT INITIAL.
      rv_key = zif_btocs_rws_client~get_secret(
         iv_method = ms_rws_config-secret_method
         iv_param  = ms_rws_config-secret_param
         is_config = ms_rws_config
      ).

      IF rv_key IS NOT INITIAL.
        get_logger( )->debug( |api key from secret config is used| ).
      ENDIF.
    ENDIF.

* ------ final result
    IF rv_key IS INITIAL.
      get_logger( )->warning( |api key is not available| ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_rws_client~get_secret.

* ---- check & prepare
    IF iv_method IS INITIAL.
      get_logger( )->error( |invalid secret method| ).
      RETURN.
    ENDIF.

    DATA(ls_config) = ms_rws_config.
    IF is_config IS NOT INITIAL.
      MOVE-CORRESPONDING is_config TO ls_config.
    ENDIF.

* ----- prepare manager
    DATA(lo_sec_mgr) = zcl_btocs_factory=>create_secret_manager( ).
    lo_sec_mgr->set_logger( get_logger( ) ).


* ----- get secret
    DATA(lo_sec_met) = lo_sec_mgr->create_secret_method(
        iv_method   = iv_method
        iv_param    = iv_param
        ir_parent   = me
        is_config   = ls_config
    ).
    IF lo_sec_met IS INITIAL.
      get_logger( )->error( |preparing secret failed. config error| ).
      RETURN.
    ELSE.
      IF lo_sec_met->get_secret(
                    IMPORTING
                      ev_bin_secret = ev_binary
                      ev_secret     = rv_secret
                      ev_is_binary  = ev_is_binary
       ) EQ abap_false.
        get_logger( )->error( |secret not found| ).
        RETURN.
      ELSE.
        get_logger( )->debug( |secret prepared| ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method ZIF_BTOCS_RWS_CLIENT~SET_API_KEY.
    mv_api_key = iv_key.
    get_logger( )->debug( |api key set manually| ).
  endmethod.
ENDCLASS.
