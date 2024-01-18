INTERFACE zif_btocs_json
  PUBLIC .


  DATA data_type TYPE zbtocs_json_type .

  METHODS get_data_type
    RETURNING
      VALUE(rv_type) TYPE zbtocs_json_type .
  METHODS to_string
    IMPORTING
      !iv_enclosing    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rv_string) TYPE string .
  METHODS is_null
    RETURNING
      VALUE(rv_null) TYPE abap_bool .
  METHODS get_data
    RETURNING
      VALUE(lr_data) TYPE REF TO data .
ENDINTERFACE.
