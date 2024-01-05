*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZBTOCS_GUI_TAB
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZBTOCS_GUI_TAB     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
