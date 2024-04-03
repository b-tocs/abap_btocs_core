*&---------------------------------------------------------------------*
*& Report ZBTOCS_GUI_DEMO_MARKDOWN
*&---------------------------------------------------------------------*
*& Demo for usage the markdown builder util
*&---------------------------------------------------------------------*
REPORT zbtocs_gui_demo_markdown.

INITIALIZATION.

* ----- create a builder instance
  DATA(lo_md) = zcl_btocs_factory=>create_markdown_util( ).


START-OF-SELECTION.

* ----- simple usage with main headers and text adding
  lo_md->add_header( |B-Tocs Markdown Demo| ).
  lo_md->add_subheader( |Overview| ).
  lo_md->add_text( |This is a demo for using the **B-Tocs Markdown Builder Util** to render user and machine readable documents in markdown format.| ).
  lo_md->add_text( |See [Markdown Guide](https://www.markdownguide.org/) for more information.| ).

* ----- add headers with level and using builder pattern
  lo_md->add_subheader( 'Header generation header 1..4' ).
  lo_md->add_h1( 'Header 1' )->add_text( 'add_h1 example'
  )->add_h2( 'Header 1' )->add_text( 'add_h2 example'
  )->add_h3( 'Header 3' )->add_text( 'add_h3 example'
  )->add_h4( 'Header 4' )->add_text( 'add_h4 example' ).

* ---- add headers with level
  lo_md->add_subheader( 'Header generation with given level' ).
  DO 6 TIMES.
    DATA(lv_level) = sy-index.
    lo_md->add_hx(
      iv_level = lv_level
      iv_text  = |Header { lv_level }|
    ).
    lo_md->add_text( |add_hx with level { lv_level } example| ).
  ENDDO.
  lo_md->add( ).

* ----- use line generation and formatting
  lo_md->add_subheader( 'Line generation and formatting features' ).
  lo_md->text( |This is a single line with formatting options inline: |
  )->bold( 'bold text,'
  )->italic( |italic text,|
  )->bold_italic( |bold italic text,|
  )->code( |as code|
  )->text( |.|
  )->add( ).

* ----- use code
  lo_md->add_subheader( 'Code embedding' ).
  lo_md->text( |This is a code example: |
  )->text( |.|
  )->add( ).

  DATA(lt_python) = VALUE string_table(
    ( |import requests| )
    ( || )
    ( |print("Hello python code")| )
  ).

  lo_md->add_code_lines(
      it_code      = lt_python                 " Table of Strings
      iv_code_type = 'python'
  ).


END-OF-SELECTION.
* ------ render output as html
  DATA(lv_html) = lo_md->to_html( ).
  cl_demo_output=>write_html( lv_html ).
  cl_demo_output=>display( ).
