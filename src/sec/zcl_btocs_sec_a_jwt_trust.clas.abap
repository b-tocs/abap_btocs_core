class ZCL_BTOCS_SEC_A_JWT_TRUST definition
  public
  inheriting from ZCL_BTOCS_SEC_A
  create public .

public section.

  methods ZIF_BTOCS_SEC_A~PREPARE_AUTH
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_A_JWT_TRUST IMPLEMENTATION.


  METHOD zif_btocs_sec_a~prepare_auth.

* ------ check
    IF iv_secret IS INITIAL.
      get_logger( )->error( |secret required in format text| ).
      RETURN.
    ENDIF.

* ------- generate
    ev_token = zif_btocs_sec_a~get_manager( )->generate_jwt_token_trusted(
      EXPORTING
        iv_user         = sy-uname         " User Name
        iv_secret       = iv_secret
        iv_roles_prefix = ms_config-roles_prefix
    ).
    IF ev_token IS INITIAL.
      get_logger( )->warning( |jwt token generation failed| ).
    ELSE.
      get_logger( )->debug( |jwt token generated| ).
    ENDIF.

    rv_success = abap_true.
  ENDMETHOD.
ENDCLASS.
