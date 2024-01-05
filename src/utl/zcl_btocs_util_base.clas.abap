class ZCL_BTOCS_UTIL_BASE definition
  public
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_BASE .
protected section.
private section.

  data MO_LOGGER type ref to ZIF_BTOCS_UTIL_LOGGER .
  data MV_LOGGER_EXTERNAL type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_BASE IMPLEMENTATION.


  METHOD zif_btocs_util_base~destroy.

* ------ check logger is internal
    IF mo_logger IS NOT INITIAL.
      IF mv_logger_external = abap_false.
        mo_logger->destroy( ).
      ENDIF.

      CLEAR: mo_logger,
             mv_logger_external.

    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_util_base~get_logger.
    IF mo_logger IS INITIAL.
      mo_logger = zcl_btocs_factory=>create_logger( ).
      CLEAR mv_logger_external.
    ENDIF.
    ro_logger = mo_logger.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_BASE~IS_LOGGER_EXTERNAL.
    rv_external = mv_logger_external.
  endmethod.


  METHOD zif_btocs_util_base~set_logger.
    mo_logger = io_logger.
    IF mo_logger IS NOT INITIAL.
      mv_logger_external = abap_true.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
