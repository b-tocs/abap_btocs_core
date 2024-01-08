class ZCL_BTOCS_VALUE_STRING definition
  public
  inheriting from ZCL_BTOCS_VALUE
  create public .

public section.

  interfaces ZIF_BTOCS_VALUE_STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE_STRING IMPLEMENTATION.


  METHOD zif_btocs_value_string~set_string.
    zif_btocs_value~set_string( iv_string ).
  ENDMETHOD.
ENDCLASS.
