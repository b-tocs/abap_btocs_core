INTERFACE zif_btocs_gui_utils
  PUBLIC .


  INTERFACES zif_btocs_util_base .

  ALIASES destroy
    FOR zif_btocs_util_base~destroy .
  ALIASES get_logger
    FOR zif_btocs_util_base~get_logger .
  ALIASES is_logger_external
    FOR zif_btocs_util_base~is_logger_external .
  ALIASES set_logger
    FOR zif_btocs_util_base~set_logger .

* =========== Files: Up/Download
  METHODS gui_upload_string
    IMPORTING
      !iv_filename   TYPE data
      !iv_encoding   TYPE abap_encoding OPTIONAL
    EXPORTING
      !ev_path       TYPE string
      !ev_filename   TYPE string
      !ev_extension  TYPE string
      !ev_name       TYPE string
    RETURNING
      VALUE(rv_file) TYPE string .
  METHODS gui_upload_bin
    IMPORTING
      !iv_filename   TYPE data
      !iv_encoding   TYPE abap_encoding OPTIONAL
    EXPORTING
      !ev_path       TYPE string
      !ev_filename   TYPE string
      !ev_extension  TYPE string
      !ev_name       TYPE string
    RETURNING
      VALUE(rv_file) TYPE xstring .
  METHODS gui_download_bin
    IMPORTING
      !iv_filename      TYPE data
      !iv_file          TYPE xstring
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS gui_download_string
    IMPORTING
      !iv_filename      TYPE data
      !iv_encoding      TYPE abap_encoding OPTIONAL
      !iv_file          TYPE string
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
* ============== clipboard
  METHODS clipboard_import_string
    IMPORTING
      !iv_line_separator TYPE string DEFAULT zif_btocs_c=>c_default_sep_line
    RETURNING
      VALUE(rv_string)   TYPE string .
  METHODS clipboard_export_string
    IMPORTING
      !iv_line_separator TYPE string DEFAULT zif_btocs_c=>c_default_sep_line
      !iv_string         TYPE string
    RETURNING
      VALUE(rv_success)  TYPE abap_bool .
* ============== F4 Utils
  METHODS f4_get_filename_open
    IMPORTING
      !iv_title        TYPE data OPTIONAL
      !iv_mask         TYPE string OPTIONAL
      !iv_encoding     TYPE abap_bool OPTIONAL
      !iv_initial_dir  TYPE data OPTIONAL
      !iv_def_filename TYPE data OPTIONAL
      !iv_def_ext      TYPE data OPTIONAL
    CHANGING
      !cv_filename     TYPE data .
  METHODS f4_get_filename_save
    IMPORTING
      !iv_title            TYPE data OPTIONAL
      !iv_mask             TYPE string OPTIONAL
      !iv_encoding         TYPE abap_bool OPTIONAL
      !iv_initial_dir      TYPE data OPTIONAL
      !iv_def_filename     TYPE data OPTIONAL
      !iv_def_ext          TYPE data OPTIONAL
      !iv_prompt_overwrite TYPE abap_bool DEFAULT abap_true
    CHANGING
      !cv_filename         TYPE data .
  METHODS f4_help_from_table
    IMPORTING
      !it_data          TYPE table
      !iv_retfield      TYPE data
      !iv_valfield      TYPE data OPTIONAL
      !iv_repid         TYPE syrepid
      !iv_dynnr         TYPE sydynnr
      !iv_dynfld        TYPE data
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS get_input_with_clipboard
    IMPORTING
      !iv_current     TYPE data
      !iv_clipboard   TYPE abap_bool DEFAULT abap_true
      !iv_longtext    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rv_input) TYPE string .
  METHODS get_upload
    IMPORTING
      !iv_filename      TYPE data
    EXPORTING
      !ev_filename      TYPE string
      !ev_content_type  TYPE string
      VALUE(ev_binary)  TYPE xstring
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS gui_execute_file_locally
    IMPORTING
      !is_file_data       TYPE zbtocs_s_file_data
      !iv_wait_and_delete TYPE abap_bool DEFAULT abap_true
      !iv_workdir         TYPE abap_bool DEFAULT abap_false
      !iv_maximized       TYPE abap_bool DEFAULT abap_false
      !iv_with_timestamp  TYPE abap_bool DEFAULT abap_true
    EXPORTING
      !ev_filename        TYPE string
    RETURNING
      VALUE(rv_success)   TYPE abap_bool .
ENDINTERFACE.
