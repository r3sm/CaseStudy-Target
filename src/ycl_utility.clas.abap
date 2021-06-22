"#autoformat
CLASS ycl_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      c_target_url    TYPE string VALUE 'https://redsky.target.com/v3/pdp/tcin/',
      c_target_param1 TYPE string VALUE '?excludes=available_to_promise_network,taxonomy,price,promotion,bulk_ship,rating_and_review_reviews,',
      c_target_param2 TYPE string VALUE 'rating_and_review_statistics,question_answer_statistics&key=candidate',
      c_nosql_url     TYPE string VALUE 'https://smgjycre7c:k9l3guowbp@product-price-4294755319.us-east-1.bonsaisearch.net:443/currentvalue/productid/'.


    CLASS-METHODS:  create_client
      IMPORTING url              TYPE string
      RETURNING VALUE(ro_client) TYPE REF TO if_web_http_client
      RAISING   cx_static_check.

    CLASS-METHODS http_get IMPORTING io_client      TYPE REF TO if_web_http_client
                           RETURNING VALUE(ro_data) TYPE REF TO data.
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

          CALL METHOD /ui2/cl_json=>deserialize
            EXPORTING
              json         = lo_response->get_text( )
              pretty_name  = /ui2/cl_json=>pretty_mode-user
              assoc_arrays = abap_true
            CHANGING
              data         = ro_data.
        ENDIF.
      CATCH cx_web_message_error.
      CATCH  cx_web_http_client_error.
    ENDTRY.


  ENDMETHOD.

ENDCLASS.
