*&---------------------------------------------------------------------*
*& Report ZBTOCS_SEC_TEST_GEN_JWT_TRUST
*&---------------------------------------------------------------------*
*& test program to generate trusted jwt tokens
*&---------------------------------------------------------------------*
REPORT zbtocs_gui_test_gen_jwt_trust.

* -------- interface
PARAMETERS: p_usr TYPE uname OBLIGATORY DEFAULT sy-uname.
PARAMETERS: p_sec TYPE zbtocs_secret_string LOWER CASE OBLIGATORY.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_rec TYPE zbtocs_token_receipient.
PARAMETERS: p_exp TYPE zbtocs_token_expiration_sec.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_rol TYPE zbtocs_token_basic_roles.
PARAMETERS: p_pfx TYPE zbtocs_roles_prefix.

INITIALIZATION.
  DATA(lo_sec_mgr)  = zcl_btocs_factory=>create_secret_manager( ).
  DATA(lo_logger)   = lo_sec_mgr->get_logger( ).


START-OF-SELECTION.

* ------- trusted info
  DATA(lv_issuer) = lo_sec_mgr->get_system_id( ).
  cl_demo_output=>write_data(
    value   = lv_issuer
    name    = 'Trusted Sender ID'                 " Name
  ).


* ------ generate token
  DATA(lv_jwt) = ||.
  data(lv_payload) = ||.

  lv_jwt = lo_sec_mgr->generate_jwt_token_trusted(
  EXPORTING
     iv_user          = p_usr
     iv_secret        = p_sec
     iv_recipient     = CONV string( p_rec )
     iv_basic_roles   = CONV string( p_rol )
     iv_roles_prefix  = p_pfx
     iv_expire_in_sec = p_exp
  IMPORTING
     ev_payload       = lv_payload
 ).

* ------- result in output
  if lv_payload is NOT INITIAL.
    cl_demo_output=>write(
      data    = lv_payload
      name    = 'JWT Payload'
    ).
  ENDIF.

  IF lv_jwt IS NOT INITIAL.
    cl_demo_output=>write(
      data    = lv_jwt
      name    = 'JWT Token (check with https://jwt.io/)'
    ).
  ELSE.
    lo_logger->error( |no token generated| ).
  ENDIF.

END-OF-SELECTION.
* ------ output
  DATA(lt_msg) = lo_logger->get_messages( ).
  IF lt_msg[] IS NOT INITIAL.
    cl_demo_output=>write_data(
      value   = lt_msg
      name    = 'Protocol'
    ).
  ENDIF.
  cl_demo_output=>display( ).
