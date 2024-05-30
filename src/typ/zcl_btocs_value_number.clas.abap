CLASS zcl_btocs_value_number DEFINITION
  PUBLIC
  INHERITING FROM zcl_btocs_value
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_btocs_value_number .
  PROTECTED SECTION.

    METHODS render_string
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE_NUMBER IMPLEMENTATION.


  METHOD render_string.

* ----- render
    IF mr_data IS NOT INITIAL.
      ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_data>).
      rv_string = CONV string( <lv_data> ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_value_number~set_number.
    CLEAR mo_object.
    CREATE DATA mr_data LIKE iv_number.
    ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_data>).
    <lv_data> = iv_number.
  ENDMETHOD.


  METHOD zif_btocs_value_number~get_as.
    TRY.
        IF zif_btocs_value_number~is_null( ) EQ abap_false.
          ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_value>).
          cv_value = <lv_value>.
          rv_success = abap_true.
        ENDIF.
      CATCH cx_root INTO DATA(lx_exc).
        get_logger( )->error( |Exception in GET_AS: { lx_exc->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_btocs_value_number~get_float.
    TRY.
        IF zif_btocs_value_number~is_null( ) EQ abap_false.
          ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_value>).
          rv_value = <lv_value>.
        ENDIF.
      CATCH cx_root INTO DATA(lx_exc).
        get_logger( )->error( |Exception in GET_FLOAT: { lx_exc->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_btocs_value_number~get_integer.
    TRY.
        IF zif_btocs_value_number~is_null( ) EQ abap_false.
          ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_value>).
          rv_value = <lv_value>.
        ENDIF.
      CATCH cx_root INTO DATA(lx_exc).
        get_logger( )->error( |Exception in GET_INTEGER: { lx_exc->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
