"#autoformat
CLASS ycl_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      c_target_url TYPE string VALUE '',
      c_nosql_url  TYPE string VALUE ''.


    CLASS-METHODS:  create_client
      IMPORTING url              TYPE string
      RETURNING VALUE(ro_client) TYPE REF TO if_web_http_client
      RAISING   cx_static_check.

    METHODS http_get IMPORTING io_client      TYPE REF TO if_web_http_client
                     RETURNING VALUE(rv_data) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_utility IMPLEMENTATION.

  METHOD create_client.
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    TRY.
        ro_client = cl_web_http_client_manager=>create_by_http_destination( dest ).
      CATCH cx_web_http_client_error.
    ENDTRY.
  ENDMETHOD.

  METHOD http_get.

    TRY.
        DATA(lo_response) = io_client->execute( if_web_http_client=>get ).

        IF lo_response->get_status( )-code = 200.
          rv_data = lo_response->get_text(  ).
        ENDIF.
      CATCH cx_web_message_error.
      CATCH  cx_web_http_client_error.
    ENDTRY.


  ENDMETHOD.

ENDCLASS.
