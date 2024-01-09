INTERFACE zif_btocs_value_number
  PUBLIC .


  INTERFACES zif_btocs_util_base .
  INTERFACES zif_btocs_value .

  ALIASES destroy
    FOR zif_btocs_value~destroy .
  ALIASES get_data_ref
    FOR zif_btocs_value~get_data_ref .
  ALIASES get_logger
    FOR zif_btocs_value~get_logger .
  ALIASES get_manager
    FOR zif_btocs_value~get_manager .
  ALIASES get_object_ref
    FOR zif_btocs_value~get_object_ref .
  ALIASES get_options
    FOR zif_btocs_value~get_options .
  ALIASES is_data
    FOR zif_btocs_value~is_data .
  ALIASES is_logger_external
    FOR zif_btocs_value~is_logger_external .
  ALIASES is_object
    FOR zif_btocs_value~is_object .
  ALIASES is_options
    FOR zif_btocs_value~is_options .
  ALIASES render
    FOR zif_btocs_value~render .
  ALIASES set_data_ref
    FOR zif_btocs_value~set_data_ref .
  ALIASES set_logger
    FOR zif_btocs_value~set_logger .
  ALIASES set_manager
    FOR zif_btocs_value~set_manager .
  ALIASES set_object_ref
    FOR zif_btocs_value~set_object_ref .
  ALIASES set_options
    FOR zif_btocs_value~set_options .
  ALIASES set_string
    FOR zif_btocs_value~set_string .


  METHODS set_number
    IMPORTING
      !iv_number TYPE data .
ENDINTERFACE.
