*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

TYPES: BEGIN OF ts_json_data,
         type TYPE c LENGTH 1,
         data TYPE REF TO data,
         json TYPE REF TO zif_btocs_json,
       END OF ts_json_data.

TYPES: tt_array_tab
  TYPE STANDARD TABLE OF ts_json_data.


TYPES: BEGIN OF ts_hashed_element,
         key TYPE string.
         INCLUDE TYPE ts_json_data AS value.
TYPES: END OF ts_hashed_element.

TYPES: tt_hashed_tab TYPE HASHED TABLE OF ts_hashed_element WITH UNIQUE KEY key.
