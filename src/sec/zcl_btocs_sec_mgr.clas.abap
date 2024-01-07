class ZCL_BTOCS_SEC_MGR definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_SEC_MGR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_SEC_MGR IMPLEMENTATION.


  METHOD zif_btocs_sec_mgr~create_auth_method.

* ------- local data
    DATA lv_class TYPE seoclsname.
    DATA lo_method TYPE REF TO zif_btocs_sec_met.


* ------- prepare class
    IF iv_method = zif_btocs_sec_mgr=>c_custom_class.
      lv_class = iv_param.
    ELSE.
      lv_class = |ZCL_BTOCS_SEC_A_{ iv_method }|.
    ENDIF.

* ------- create instance
    lo_method ?= zcl_btocs_factory=>create_instance( lv_class ).
    IF lo_method IS INITIAL.
      get_logger( )->error( |wrong method class { lv_class }| ).
      RETURN.
    ELSE.
* ------- set context
      DATA(lr_parent) = COND #( WHEN ir_parent IS NOT INITIAL
                                THEN ir_parent
                                ELSE me ).

      lo_method->set_context(
        iv_method = iv_method
        iv_param  = iv_param
        ir_parent = lr_parent
        is_config = is_config
      ).
* ------- cast to output type
      ro_instance ?= lo_method.
    ENDIF.


  ENDMETHOD.


  method ZIF_BTOCS_SEC_MGR~CREATE_SECRET_METHOD.

* ------- local data
    DATA lv_class TYPE seoclsname.
    DATA lo_method TYPE REF TO zif_btocs_sec_met.


* ------- prepare class
    IF iv_method = zif_btocs_sec_mgr=>c_custom_class.
      lv_class = iv_param.
    ELSE.
      lv_class = |ZCL_BTOCS_SEC_S_{ iv_method }|.
    ENDIF.

* ------- create instance
    lo_method ?= zcl_btocs_factory=>create_instance( lv_class ).
    IF lo_method IS INITIAL.
      get_logger( )->error( |wrong method class { lv_class }| ).
      RETURN.
    ELSE.
* ------- set context
      DATA(lr_parent) = COND #( WHEN ir_parent IS NOT INITIAL
                                THEN ir_parent
                                ELSE me ).

      lo_method->set_context(
        iv_method = iv_method
        iv_param  = iv_param
        ir_parent = lr_parent
        is_config = is_config
      ).
* ------- cast to output type
      ro_instance ?= lo_method.
    ENDIF.

  endmethod.


  method ZIF_BTOCS_SEC_MGR~CREATE_TOKEN_METHOD.
* ------- local data
    DATA lv_class TYPE seoclsname.
    DATA lo_method TYPE REF TO zif_btocs_sec_met.


* ------- prepare class
    IF iv_method = zif_btocs_sec_mgr=>c_custom_class.
      lv_class = iv_param.
    ELSE.
      lv_class = |ZCL_BTOCS_SEC_T_{ iv_method }|.
    ENDIF.

* ------- create instance
    lo_method ?= zcl_btocs_factory=>create_instance( lv_class ).
    IF lo_method IS INITIAL.
      get_logger( )->error( |wrong method class { lv_class }| ).
      RETURN.
    ELSE.
* ------- set context
      DATA(lr_parent) = COND #( WHEN ir_parent IS NOT INITIAL
                                THEN ir_parent
                                ELSE me ).

      lo_method->set_context(
        iv_method = iv_method
        iv_param  = iv_param
        ir_parent = lr_parent
        is_config = is_config
      ).
* ------- cast to output type
      ro_instance ?= lo_method.
    ENDIF.
  endmethod.
ENDCLASS.
