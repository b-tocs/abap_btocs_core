class ZCL_BTOCS_BOD_MGR definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_BOD_MGR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_BOD_MGR IMPLEMENTATION.


  METHOD zif_btocs_bod_mgr~get_renderer.
    DATA(lv_class) = ||.
    CASE iv_type.
      WHEN 'BUPA'.
        lv_class = 'ZCL_BTOCS_BOD_RND_BUPA'.
      WHEN OTHERS.
    ENDCASE.

    IF lv_class IS INITIAL.
      get_logger( )->error( |no rendering available for type '{ iv_type }'| ).
      RETURN.
    ENDIF.

* -------- create
    ro_renderer ?= zcl_btocs_factory=>create_instance( lv_class ).
    IF ro_renderer IS INITIAL.
      get_logger( )->error( |no rendering available for class '{ lv_class }'| ).
    ELSE.
      ro_renderer->set_logger( get_logger( ) ).
      IF ro_renderer->set_context(
           iv_type    = iv_type
           iv_id      = iv_id
           it_context = it_context                 " Key value tab
         ) EQ abap_false.
        CLEAR ro_renderer.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_bod_mgr~new_document.
    DATA(lv_impl) = COND #( WHEN iv_impl IS INITIAL
                            THEN 'ZIF_BTOCS_BOD_DOC'
                            ELSE iv_impl ).
    ro_doc ?= zcl_btocs_factory=>create_instance( lv_impl ).
    IF ro_doc IS NOT INITIAL.
      ro_doc->set_logger( get_logger( ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
