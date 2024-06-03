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
ENDCLASS.
