CLASS zcl_btocs_util_logger DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_btocs_util_logger .
  PROTECTED SECTION.

    DATA c_msg_id TYPE symsgid VALUE 'ZBTOCS' ##NO_TEXT.
    DATA mv_snapshot_id TYPE i .
    DATA mt_msg TYPE bapiret2_tab.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_LOGGER IMPLEMENTATION.


  METHOD zif_btocs_util_logger~add_msg.
* fill in message table
    IF is_msg IS NOT INITIAL.
      APPEND is_msg TO mt_msg.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_logger~add.
* local data
    DATA: lv_msg TYPE bapi_msg.
    DATA: lv_len TYPE i.

* fill main fields
    rs_bapiret2-type     = iv_type.
    rs_bapiret2-id       = iv_id.
    rs_bapiret2-number   = iv_no.

* check text
    lv_msg = iv_msg.
    lv_len = strlen( lv_msg ).

* fill params
    rs_bapiret2-message_v1 = lv_msg.
    IF lv_len GT 50.
      rs_bapiret2-message_v2 = lv_msg+50.
    ENDIF.
    IF lv_len GT 100.
      rs_bapiret2-message_v3 = lv_msg+100.
    ENDIF.
    IF lv_len GT 150.
      rs_bapiret2-message_v4 = lv_msg+150.
    ENDIF.

* fill in message table
    zif_btocs_util_logger~add_msg( is_msg = rs_bapiret2 ).

  ENDMETHOD.


  METHOD zif_btocs_util_logger~abort.
    zif_btocs_util_logger~add(
         iv_type     = 'A'
         iv_id       = c_msg_id
         iv_no       = '005'
         iv_msg      = iv_msg
       ).
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_logger~debug.
    zif_btocs_util_logger~add(
         iv_type     = 'S'
         iv_id       = c_msg_id
         iv_no       = '004'
         iv_msg      = iv_msg
       ).
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_logger~destroy.
    " redefine
  ENDMETHOD.


  METHOD zif_btocs_util_logger~error.
    zif_btocs_util_logger~add(
         iv_type     = 'E'
         iv_id       = c_msg_id
         iv_no       = '001'
         iv_msg      = iv_msg
       ).
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_logger~exception.
    zif_btocs_util_logger~add(
         iv_type     = 'X'
         iv_id       = c_msg_id
         iv_no       = '006'
         iv_msg      = iv_msg
       ).
    ro_self = me.

  ENDMETHOD.


  METHOD zif_btocs_util_logger~get_messages.
* -------- get all msg
    DATA(lt_msg) = mt_msg.
    IF lt_msg[] IS INITIAL.
      RETURN.
    ENDIF.


* -------- snapshot handling
    DATA(lv_snapshot) = iv_snapshot_id.
    IF iv_only_snapshot EQ abap_true.
      lv_snapshot = mv_snapshot_id.
    ENDIF.


    LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<ls_msg>).
      IF lv_snapshot > 0
        AND sy-tabix <= lv_snapshot.
        CONTINUE.
      ENDIF.

      IF iv_no_trace EQ abap_true
        AND <ls_msg>-type = 'S'.
        CONTINUE.
      ENDIF.

      IF iv_no_framework EQ abap_true
        AND <ls_msg>-id = '/BAB/ATB'.
        CONTINUE.
      ENDIF.

      APPEND <ls_msg> TO rt_messages.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_btocs_util_logger~get_snapshot.
    rv_snapshot = lines( mt_msg ).
  ENDMETHOD.


  METHOD zif_btocs_util_logger~has_errors.
    LOOP AT mt_msg TRANSPORTING NO FIELDS
     WHERE type CA 'EAX'.
      rv_error = abap_true.
      RETURN.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_btocs_util_logger~info.
    zif_btocs_util_logger~add(
         iv_type     = 'I'
         iv_id       = c_msg_id
         iv_no       = '003'
         iv_msg      = iv_msg
       ).
    ro_self = me.

  ENDMETHOD.


  METHOD zif_btocs_util_logger~set_snapshot.
    mv_snapshot_id = lines( mt_msg ).
    rv_snapshot = mv_snapshot_id.
  ENDMETHOD.


  METHOD zif_btocs_util_logger~warning.
    zif_btocs_util_logger~add(
         iv_type     = 'W'
         iv_id       = c_msg_id
         iv_no       = '002'
         iv_msg      = iv_msg
       ).
    ro_self = me.
  ENDMETHOD.


  METHOD zif_btocs_util_logger~add_msgs.
    IF it_msg[] IS NOT INITIAL.
      APPEND LINES OF it_msg TO mt_msg.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
