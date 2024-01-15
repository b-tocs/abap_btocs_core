class ZCL_BTOCS_GUI_UTILS definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_GUI_UTILS .
protected section.

  data MV_ENCODING type ABAP_ENCODING .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_GUI_UTILS IMPLEMENTATION.


  METHOD zif_btocs_gui_utils~clipboard_export_string.

* --------- local data
    DATA: lv_table(32768).
    DATA: lt_table LIKE TABLE OF lv_table.
    DATA: lv_len   TYPE i.
    DATA: lv_rc    TYPE i.
    FIELD-SYMBOLS: <lt_data> TYPE table.

* -------- check input
    lv_len = strlen( iv_string ).
    IF iv_string IS INITIAL.
      get_logger( )->error( |no data for clipboard export| ).
      RETURN.
    ENDIF.


* -------- check line separator found
    SPLIT iv_string AT iv_line_separator INTO TABLE lt_table.
    ASSIGN lt_table TO <lt_data>.


* -------- get clipboard
    cl_gui_frontend_services=>clipboard_export(
*      EXPORTING
*        no_auth_check        = space            " Switch off Check for Access Rights
      IMPORTING
        data                 = <lt_data>                  " Data
      CHANGING
        rc                   = lv_rc                 " Return Code
      EXCEPTIONS
        cntl_error           = 1                " Control error
        error_no_gui         = 2                " No GUI available
        not_supported_by_gui = 3                " GUI does not support this
        no_authority         = 4                " Authorization check failed
        OTHERS               = 5
    ).
    IF sy-subrc <> 0.
      get_logger( )->error( |clipboard import failed (subrc { sy-subrc }| ).
    ELSE.
      get_logger( )->debug( |{ lv_len } bytes exported to clipboard| ).
      rv_success = abap_true.
    ENDIF.


  ENDMETHOD.


  METHOD zif_btocs_gui_utils~clipboard_import_string.

* --------- local data
    DATA: lv_table(32768).
    DATA: lt_table LIKE TABLE OF lv_table.
    DATA: lv_len   TYPE i.

* -------- get clipboard
    cl_gui_frontend_services=>clipboard_import(
      IMPORTING
        data                 = lt_table                 " Data Table
        length               = lv_len                 " Data length
      EXCEPTIONS
        cntl_error           = 1                " Control error
        error_no_gui         = 2                " No GUI available
        not_supported_by_gui = 3                " GUI does not support this
        OTHERS               = 4
    ).
    IF sy-subrc <> 0.
      get_logger( )->error( |clipboard import failed (subrc { sy-subrc }| ).
    ELSE.
* --------- convert to string
      DATA lv_line TYPE string.
      LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<lv_line>).
*       prepare line
        lv_line = <lv_line>.
        CONDENSE lv_line.
        " TODO space handling at begin of line

        IF sy-tabix = 1.
          rv_string = lv_line.
        ELSE.
          rv_string = rv_string && iv_line_separator && lv_line.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_gui_utils~f4_get_filename_open.
* ---------- local data
    DATA: lt_files      TYPE filetable.
    DATA: lv_rc         TYPE i.
    DATA: lv_action     TYPE i.

    " '',*.*,*.*.''

* ---------- call api
    CLEAR mv_encoding.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title            = CONV string( iv_title )
        default_extension       = CONV string( iv_def_ext )
        default_filename        = CONV string( iv_def_filename )
        file_filter             = CONV string( iv_mask )
        with_encoding           = iv_encoding
        initial_directory       = CONV string( iv_initial_dir )
        multiselection          = abap_false
      CHANGING
        file_table              = lt_files
        rc                      = lv_rc
        user_action             = lv_action
        file_encoding           = mv_encoding
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.
    IF sy-subrc EQ 0
      AND lt_files[] IS NOT INITIAL
      "and lv_rc = 0
      AND lv_action NE cl_gui_frontend_services=>action_cancel.
      READ TABLE lt_files INDEX 1 ASSIGNING FIELD-SYMBOL(<lv_file>).
      IF <lv_file> IS ASSIGNED.
        cv_filename = <lv_file>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_gui_utils~f4_get_filename_save.
* ---------- local data
    DATA: lv_file       TYPE string.
    DATA: lv_path       TYPE string.
    DATA: lv_full       TYPE string.
    DATA: lv_rc         TYPE i.
    DATA: lv_action     TYPE i.

    " '',*.*,*.*.''

* ---------- call api
    CLEAR mv_encoding.

    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        window_title              = CONV string( iv_title )
        default_extension         = CONV string( iv_def_ext )
        default_file_name         = CONV string( iv_def_filename )
        file_filter               = CONV string( iv_mask )
        with_encoding             = iv_encoding
        initial_directory         = CONV string( iv_initial_dir )
        prompt_on_overwrite       = iv_prompt_overwrite
      CHANGING
        filename                  = lv_file
        path                      = lv_path
        fullpath                  = lv_full
        user_action               = lv_action
        file_encoding             = mv_encoding
      EXCEPTIONS
        cntl_error                = 1                " Control error
        error_no_gui              = 2                " No GUI available
        not_supported_by_gui      = 3                " GUI does not support this
        invalid_default_file_name = 4                " Invalid default file name
        OTHERS                    = 5.
    IF sy-subrc EQ 0
      AND lv_action NE cl_gui_frontend_services=>action_cancel.
      cv_filename = lv_full.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_gui_utils~f4_help_from_table.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
*       DDIC_STRUCTURE  = ' '
        retfield        = iv_retfield
        pvalkey         = CONV ddshpvkey( iv_valfield )
        dynpprog        = iv_repid
        dynpnr          = iv_dynnr
        dynprofield     = iv_dynfld
*       STEPL           = 0
*       WINDOW_TITLE    =
*       VALUE           = ' '
        value_org       = 'S'
*       MULTIPLE_CHOICE = ' '
*       DISPLAY         = ' '
*       CALLBACK_PROGRAM       = ' '
*       CALLBACK_FORM   = ' '
*       CALLBACK_METHOD =
*       MARK_TAB        =
*   IMPORTING
*       USER_RESET      =
      TABLES
        value_tab       = it_data
*       FIELD_TAB       =
*       RETURN_TAB      =
*       DYNPFLD_MAPPING =
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.

    rv_success = COND #( WHEN sy-subrc EQ 0
                       THEN abap_true
                       ELSE abap_false ).
  ENDMETHOD.


  METHOD zif_btocs_gui_utils~get_mimetype_from_filename.
    DATA lv_mimetype TYPE skwf_mime.

    IF iv_filename IS NOT INITIAL.
      CALL FUNCTION 'SKWF_MIMETYPE_OF_FILE_GET'
        EXPORTING
          filename = CONV skwf_filnm( iv_filename )
*         X_USE_LOCAL_REGISTRY       =
        IMPORTING
          mimetype = lv_mimetype.
      rv_mimetype = lv_mimetype.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_gui_utils~gui_download_bin.

* ------ local data
    DATA: lv_len TYPE i.

* ------- transfer to table
    DATA(lo_conv) = zcl_btocs_factory=>create_convert_util( ).
    DATA(lt_bin) = lo_conv->convert_xstring_to_bintab(
    EXPORTING
      iv_xstring = iv_file
    IMPORTING
      ev_len     = lv_len
      ).
    IF lt_bin[] IS INITIAL
      OR lv_len = 0.
      get_logger( )->error( |error while transforming to binary tab| ).
      RETURN.
    ENDIF.


* ------- download
    cl_gui_frontend_services=>gui_download(
      EXPORTING
        bin_filesize              = lv_len                     " File length for binary files
        filename                  = CONV string( iv_filename )                     " Name of file
        filetype                  = 'BIN'                " File type (ASCII, binary ...)
*        append                    = space                " Character Field of Length 1
*        write_field_separator     = space                " Separate Columns by Tabs in Case of ASCII Download
*        header                    = '00'                 " Byte Chain Written to Beginning of File in Binary Mode
*        trunc_trailing_blanks     = space                " Do not Write Blank at the End of Char Fields
*        write_lf                  = 'X'                  " Insert CR/LF at End of Line in Case of Char Download
*        col_select                = space                " Copy Only Selected Columns of the Table
*        col_select_mask           = space                " Vector Containing an 'X' for the Column To Be Copied
*        dat_mode                  = space                " Numeric and date fields are in DAT format in WS_DOWNLOAD
*        confirm_overwrite         = space                " Overwrite File Only After Confirmation
*        no_auth_check             = space                " Switch off Check for Access Rights
*        codepage                  =                      " Character Representation for Output
*        ignore_cerr               = abap_true            " Ignore character set conversion errors?
*        replacement               = '#'                  " Replacement Character for Non-Convertible Characters
*        write_bom                 = space                " If set, writes a Unicode byte order mark
*        trunc_trailing_blanks_eol = 'X'                  " Remove Trailing Blanks in Last Column
*        wk1_n_format              = space
*        wk1_n_size                = space
*        wk1_t_format              = space
*        wk1_t_size                = space
*        show_transfer_status      = 'X'                  " Enables suppression of transfer status message
*        fieldnames                =                      " Table Field Names
*        write_lf_after_last_line  = 'X'                  " Writes a CR/LF after final data record
*        virus_scan_profile        = '/SCET/GUI_DOWNLOAD' " Virus Scan Profile
      IMPORTING
        filelength                = lv_len                     " Number of bytes transferred
      CHANGING
        data_tab                  = lt_bin                     " Transfer table
      EXCEPTIONS
        file_write_error          = 1                    " Cannot write to file
        no_batch                  = 2                    " Cannot execute front-end function in background
        gui_refuse_filetransfer   = 3                    " Incorrect Front End
        invalid_type              = 4                    " Invalid value for parameter FILETYPE
        no_authority              = 5                    " No Download Authorization
        unknown_error             = 6                    " Unknown error
        header_not_allowed        = 7                    " Invalid header
        separator_not_allowed     = 8                    " Invalid separator
        filesize_not_allowed      = 9                    " Invalid file size
        header_too_long           = 10                   " Header information currently restricted to 1023 bytes
        dp_error_create           = 11                   " Cannot create DataProvider
        dp_error_send             = 12                   " Error Sending Data with DataProvider
        dp_error_write            = 13                   " Error Writing Data with DataProvider
        unknown_dp_error          = 14                   " Error when calling data provider
        access_denied             = 15                   " Access to file denied.
        dp_out_of_memory          = 16                   " Not enough memory in data provider
        disk_full                 = 17                   " Storage medium is full.
        dp_timeout                = 18                   " Data provider timeout
        file_not_found            = 19                   " Could not find file
        dataprovider_exception    = 20                   " General Exception Error in DataProvider
        control_flush_error       = 21                   " Error in Control Framework
        not_supported_by_gui      = 22                   " GUI does not support this
        error_no_gui              = 23                   " GUI not available
        OTHERS                    = 24
    ).
    IF sy-subrc <> 0.
      get_logger( )->error( |error while trigger binary download to gui - subrc { sy-subrc }| ).
    ELSE.
      rv_success = abap_true.
    ENDIF.


  ENDMETHOD.


  METHOD zif_btocs_gui_utils~gui_download_string.
* ------ convert
    DATA(lo_conv) = zcl_btocs_factory=>create_convert_util( ).
    DATA(lv_xfile) = lo_conv->convert_string_to_xstring(
         iv_string   = iv_file
         iv_encoding = iv_encoding
     ).
    IF lv_xfile IS INITIAL.
      get_logger( )->error( |error while converting text data to binary| ).
      RETURN.
    ENDIF.

* ------- save binary
    rv_success = zif_btocs_gui_utils~gui_download_bin(
          iv_filename = iv_filename
          iv_file     = lv_xfile
      ).
  ENDMETHOD.


  METHOD zif_btocs_gui_utils~gui_upload_bin.

* ------ local data
    DATA: lv_len TYPE i.
    DATA: lt_bin TYPE TABLE OF solix.


* ------- upload from client
    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = CONV string( iv_filename )
        filetype                = 'BIN'
*       has_field_separator     = SPACE
*       header_length           = 0
        read_by_line            = ' '
*       dat_mode                = SPACE
        codepage                = iv_encoding
*       ignore_cerr             = ABAP_TRUE
*       replacement             = '#'
*       virus_scan_profile      =
      IMPORTING
        filelength              = lv_len
*       header                  = lv_xheader
      CHANGING
        data_tab                = lt_bin
*       isscanperformed         = SPACE
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

* ---------- transform to xstring
    DATA(lo_conv) = zcl_btocs_factory=>create_convert_util( ).
    rv_file  = lo_conv->convert_bintab_to_xstring(
        it_bin     = lt_bin
        iv_len     = lv_len
    ).

    IF rv_file IS INITIAL.
      RETURN.
    ENDIF.


* ---------- spit filename
    ZIF_BTOCS_GUI_UTILS~split_filename(
      EXPORTING
        iv_full      = CONV string( iv_filename )
      IMPORTING
        ev_path      = ev_path
        ev_filename  = ev_filename
        ev_extension = ev_extension
        ev_name      = ev_name
    ).

  ENDMETHOD.


  METHOD zif_btocs_gui_utils~gui_upload_string.
* -------- local binary
    DATA(lv_xfile) = zif_btocs_gui_utils~gui_upload_bin(
    EXPORTING
     iv_filename = iv_filename
     iv_encoding = iv_encoding
    IMPORTING
     ev_path     = ev_path
     ev_filename = ev_filename
     ev_extension = ev_extension
     ev_name     = ev_name
     ).

* -------- convert to string
    DATA(lo_conv) = zcl_btocs_factory=>create_convert_util( ).
    IF lv_xfile IS NOT INITIAL.
      rv_file = lo_conv->convert_xstring_to_string(
          iv_xstring = lv_xfile
         iv_encoding = iv_encoding
      ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_gui_utils~split_filename.
    TRY.
        cl_bcs_utilities=>split_path(
          EXPORTING
            iv_path = CONV string( iv_full )
          IMPORTING
            ev_path = ev_path
            ev_name = ev_filename
        ).

        IF ev_filename IS INITIAL
          AND ev_path CS '.'.
          ev_filename = ev_path.
          CLEAR ev_path.
        ENDIF.

      CATCH cx_bcs. " BCS: General Exceptions
        ev_filename = iv_full. " workaround for full = filename
    ENDTRY.


    cl_bcs_utilities=>split_name(
      EXPORTING
        iv_name      = ev_filename
*    iv_delimiter = gc_dot
      IMPORTING
        ev_name      = ev_name
        ev_extension = ev_extension
    ).
  ENDMETHOD.


  METHOD zif_btocs_gui_utils~get_input_with_clipboard.
    rv_input = iv_current.
    IF rv_input IS INITIAL.
      IF iv_clipboard EQ abap_true.
        rv_input = zif_btocs_gui_utils~clipboard_import_string( ).
      ENDIF.

      IF iv_longtext EQ abap_true AND rv_input IS INITIAL.
        " TODO
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_gui_utils~get_upload.

    ev_binary = zif_btocs_gui_utils~gui_upload_bin(
      EXPORTING
        iv_filename  = iv_filename
      IMPORTING
        ev_filename  = ev_filename
    ).

    IF ev_binary IS INITIAL.
      get_logger( )->error( |upload from gui client failed: { iv_filename }| ).
      RETURN.
    ENDIF.

*   mimetype
    ev_content_type = zif_btocs_gui_utils~get_mimetype_from_filename( ev_filename ).
    rv_success = abap_true.

  ENDMETHOD.
ENDCLASS.
