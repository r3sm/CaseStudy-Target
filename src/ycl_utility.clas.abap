"#autoformat
CLASS ycl_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*// Constants used in Building URL
    CONSTANTS:
*// Target
      c_target_url    TYPE string VALUE 'https://redsky.target.com/v3/pdp/tcin/',
      c_target_param1 TYPE string VALUE '?excludes=available_to_promise_network,taxonomy,price,promotion,bulk_ship,rating_and_review_reviews,',
      c_target_param2 TYPE string VALUE 'rating_and_review_statistics,question_answer_statistics&key=candidate',
*// BONSAI
      c_nosql_url     TYPE string VALUE 'https://smgjycre7c:k9l3guowbp@product-price-4294755319.us-east-1.bonsaisearch.net:443/currentvalue/productid/'.


    CLASS-METHODS:
*// Method to create Web CLient
      create_client     IMPORTING url              TYPE string
                        RETURNING VALUE(ro_client) TYPE REF TO if_web_http_client
                        RAISING   cx_static_check,
*//Method to make a http GET call
      http_get          IMPORTING io_client      TYPE REF TO if_web_http_client
                        RETURNING VALUE(ro_data) TYPE REF TO data
                        RAISING   ycx_rap_query_provider,
*//Used to raise Custom Exception
      raise_exception   IMPORTING im_attr1 TYPE scx_attrname
                        RAISING   ycx_rap_query_provider.
  PRIVATE SECTION.
*// Common Message for both Get Calls
    CONSTANTS:
       product_not_found TYPE scx_attrname VALUE 'Product Not Found'.

ENDCLASS.

CLASS ycl_utility IMPLEMENTATION.

  METHOD create_client.

    TRY.
        ro_client = cl_web_http_client_manager=>create_by_http_destination( cl_http_destination_provider=>create_by_url( url ) ).
      CATCH cx_web_http_client_error.
    ENDTRY.

  ENDMETHOD.

  METHOD http_get.

    TRY.
        DATA(lo_response) = io_client->execute( if_web_http_client=>get ).

*// Successful Response - We are not handling all possible errors
*// Any Error is interpreted as -> Not Found
        IF lo_response->get_status( )-code = 200.

          CALL METHOD /ui2/cl_json=>deserialize
            EXPORTING
              json         = lo_response->get_text( )
              pretty_name  = /ui2/cl_json=>pretty_mode-user
              assoc_arrays = abap_true
            CHANGING
              data         = ro_data.

        ELSE.
          raise_exception( product_not_found ).
        ENDIF.

      CATCH cx_web_message_error.
      CATCH  cx_web_http_client_error.
    ENDTRY.


  ENDMETHOD.
  METHOD raise_exception.

    DATA:
    ls_textid LIKE if_t100_message=>t100key .

*// Standard template used for any error
    ls_textid-msgid = 'SY'.
    ls_textid-msgno = '499'.
    ls_textid-attr1 = im_attr1.
    ls_textid-attr2 = space.
    ls_textid-attr3 = space.
    ls_textid-attr4 = space.

    DATA(lo_exp) = NEW  ycx_rap_query_provider( textid = ls_textid ).

    RAISE EXCEPTION lo_exp.

  ENDMETHOD.
ENDCLASS.
