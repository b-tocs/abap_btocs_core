class ZCL_BTOCS_BOD_RND definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_BOD_RND .
protected section.

  data MV_TYPE type STRING .
  data MV_ID type STRING .
  data MT_CONTEXT type ZBTOCS_T_KEY_VALUE .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_BOD_RND IMPLEMENTATION.


  method ZIF_BTOCS_BOD_RND~GET_CONTEXT.
    rt_context = mt_context.
  endmethod.


  method ZIF_BTOCS_BOD_RND~GET_ID.
    rv_id = mv_id.
  endmethod.


  method ZIF_BTOCS_BOD_RND~GET_TYPE.
    rv_type = mv_type.
  endmethod.


  method ZIF_BTOCS_BOD_RND~RENDER.
    get_logger( )->error( |Render Base class called. Redefine RENDER| ).
  endmethod.


  METHOD zif_btocs_bod_rnd~set_context.
    mv_id       = iv_id.
    mv_type     = iv_type.
    mt_context  = it_context.
  ENDMETHOD.
ENDCLASS.
