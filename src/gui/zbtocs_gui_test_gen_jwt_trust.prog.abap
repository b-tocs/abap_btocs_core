*&---------------------------------------------------------------------*
*& Report ZBTOCS_SEC_TEST_GEN_JWT_TRUST
*&---------------------------------------------------------------------*
*& test program to generate trusted jwt tokens
*&---------------------------------------------------------------------*
REPORT zbtocs_gui_test_gen_jwt_trust.

* -------- interface
PARAMETERS: p_usr TYPE uname OBLIGATORY DEFAULT sy-uname.
PARAMETERS: p_sec TYPE zbtocs_secret_string LOWER CASE OBLIGATORY.


INITIALIZATION.
  DATA(lr_sec_mgr)  = zcl_btocs_factory=>create_secret_manager( ).
  DATA(lr_logger)   = lr_sec_mgr->get_logger( ).


START-OF-SELECTION.
  DATA(lv_jwt) = lr_sec_mgr->generate_jwt_token_trusted(
      iv_secret = p_sec
  ).

  IF lv_jwt IS NOT INITIAL.
    cl_demo_output=>write(
      data    = lv_jwt
      name    = 'JWT Token'
    ).
  ELSE.
    lr_logger->error( |no token generated| ).
  ENDIF.

END-OF-SELECTION.
* ------ output
  cl_demo_output=>write_data(
    value   = lr_logger->get_messages( )
    name    = 'Protocol'
  ).
  cl_demo_output=>display( ).
