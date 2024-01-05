*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTC_BTOCS_PRF...................................*
DATA:  BEGIN OF STATUS_ZTC_BTOCS_PRF                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTC_BTOCS_PRF                 .
CONTROLS: TCTRL_ZTC_BTOCS_PRF
            TYPE TABLEVIEW USING SCREEN '2000'.
*...processing: ZTC_BTOCS_RFC...................................*
DATA:  BEGIN OF STATUS_ZTC_BTOCS_RFC                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTC_BTOCS_RFC                 .
CONTROLS: TCTRL_ZTC_BTOCS_RFC
            TYPE TABLEVIEW USING SCREEN '2010'.
*.........table declarations:.................................*
TABLES: *ZTC_BTOCS_PRF                 .
TABLES: *ZTC_BTOCS_RFC                 .
TABLES: ZTC_BTOCS_PRF                  .
TABLES: ZTC_BTOCS_RFC                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
