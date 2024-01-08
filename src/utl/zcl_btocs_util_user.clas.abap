class ZCL_BTOCS_UTIL_USER definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_USER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_USER IMPLEMENTATION.


  METHOD zif_btocs_util_user~get_user_detail.

* -------- local data
    DATA lt_return TYPE bapiret2_tab.


* -------- call bapi
    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username       = iv_username
        cache_results  = iv_cache
      IMPORTING
        address        = es_address
      TABLES
        parameter      = et_params
        activitygroups = et_roles
        return         = lt_return.

    get_logger( )->add_msgs( lt_return ).
    IF es_address IS INITIAL.
      get_logger( )->error( |no user details available| ).
      RETURN.
    ENDIF.

* ----- check roles
    IF et_roles[] IS NOT INITIAL.
      IF iv_role_prefix IS NOT INITIAL.
        DATA(lv_role_prefix) = |{ iv_role_prefix }*|.
        DELETE et_roles WHERE NOT agr_name CP lv_role_prefix.
      ENDIF.

      IF iv_valid_at IS NOT INITIAL.
        DELETE et_roles WHERE from_dat > iv_valid_at OR to_dat < iv_valid_at.
      ENDIF.
    ENDIF.


* ----- check params
    IF iv_param_prefix IS NOT INITIAL.
      DATA(lv_param_prefix) = |{ iv_param_prefix }*|.
      DELETE et_params WHERE NOT parid CP lv_param_prefix.
    ENDIF.

* ------ finally success
    rv_success = abap_true.

  ENDMETHOD.
ENDCLASS.
