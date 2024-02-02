class ZCL_BTOCS_UTIL_TEXT definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_TEXT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_TEXT IMPLEMENTATION.


  METHOD zif_btocs_util_text~detect_line_separator.

* ----- check input
    IF iv_text IS INITIAL.
      RETURN.
    ENDIF.

    IF iv_text CS cl_abap_char_utilities=>cr_lf.
      rv_sep = cl_abap_char_utilities=>cr_lf.
    ELSEIF iv_text CS cl_abap_char_utilities=>newline.
      rv_sep = cl_abap_char_utilities=>newline.
    ELSEIF iv_text CS |\n|.
      rv_sep = |\n|.
    ENDIF.

  ENDMETHOD.


  METHOD zif_btocs_util_text~replace_eol_with_esc_n.
    IF cv_text IS NOT INITIAL.
      REPLACE ALL OCCURRENCES
        OF cl_abap_char_utilities=>cr_lf " x0D0A
        IN cv_text
      WITH '\n'.

      REPLACE ALL OCCURRENCES
        OF cl_abap_char_utilities=>newline "x0A
        IN cv_text
      WITH '\n'.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_text~replace_eol_with_html_br.
    IF cv_text IS NOT INITIAL.
      REPLACE ALL OCCURRENCES
        OF cl_abap_char_utilities=>cr_lf " x0D0A
        IN cv_text
      WITH '<br>'.

      REPLACE ALL OCCURRENCES
        OF cl_abap_char_utilities=>newline "x0A
        IN cv_text
      WITH '<br>'.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_text~replace_tab_with_esc_t.
    IF cv_text IS NOT INITIAL.
      REPLACE ALL OCCURRENCES
        OF cl_abap_char_utilities=>horizontal_tab
        IN cv_text
      WITH '\t'.

      REPLACE ALL OCCURRENCES
        OF cl_abap_char_utilities=>horizontal_tab
        IN cv_text
      WITH '\t'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
