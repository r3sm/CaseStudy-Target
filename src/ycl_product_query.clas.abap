"#autoformat
CLASS ycl_product_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*// Interface for Query
    INTERFACES  if_rap_query_provider .

  PRIVATE SECTION.
    CONSTANTS:

      no_data_requested TYPE scx_attrname VALUE 'Data Not requested',
      no_single_id      TYPE scx_attrname VALUE 'Please provide unique Product ID'.



    METHODS :
*// Get Product Name for Target End point
      get_product_name IMPORTING im_product_id   TYPE yproductdetails-id
                       EXPORTING ex_Product_name TYPE yproductdetails-name
                       RAISING   ycx_rap_query_provider,
      get_title_from_response IMPORTING io_data         TYPE REF TO data
                              EXPORTING ex_Product_name TYPE yproductdetails-name,

*// Static method Used for Read as well during the update of price
      get_product_price IMPORTING im_product_id    TYPE yproductdetails-id
                        EXPORTING ex_product_price TYPE yproductdetails-value
                                  ex_currency_code TYPE yproductdetails-currencycode
                        RAISING   ycx_rap_query_provider,
      get_price_from_response IMPORTING io_data          TYPE REF TO data
                              EXPORTING ex_product_price TYPE yproductdetails-value
                                        ex_currency_code TYPE yproductdetails-currencycode.

ENDCLASS.


CLASS ycl_product_query IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

*// Data Declaration
    DATA: lt_product_details TYPE TABLE OF YProductDetails,
          ls_product_details TYPE  YProductDetails,
          lo_exp             TYPE REF TO ycx_rap_query_provider.

*// If Data is requested
    IF io_request->is_data_requested( ).

      io_request->get_paging( ).

      TRY.
*// Get Filters
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).

*// Check if the request is a single read
          READ TABLE lt_filter_cond WITH KEY name = 'ID' INTO DATA(ls_productid_filter_key).
          IF sy-subrc = 0 AND lines( ls_productid_filter_key-range ) = 1.
            READ TABLE ls_productid_filter_key-range INTO DATA(ls_id_option) INDEX 1.
            IF sy-subrc = 0 AND ls_id_option-sign = 'I' AND ls_id_option-option = 'EQ' AND ls_id_option-low IS NOT INITIAL.
*// Single read
              DATA(is_key_filter) = abap_true.
            ENDIF.
          ENDIF.

*// Raise Exception if Query is not made with Unique Product ID
          IF is_key_filter  <> abap_true.
            ycl_utility=>raise_exception( im_attr1 = no_single_id  ).
          ENDIF.

*// Product ID
          ls_product_details-id = ls_id_option-low.

*/ Product Name
          get_product_name(
           EXPORTING
             im_product_id =  ls_product_details-id
           IMPORTING
            ex_Product_name = ls_product_details-name ).

          TRY.
*// Product Price
              get_product_price(
                EXPORTING
                   im_product_id =  ls_product_details-id
                IMPORTING
                    ex_product_price  =  ls_product_details-value
                    ex_currency_code  =  ls_product_details-currencycode ).
            CATCH ycx_rap_query_provider.
*// Not Need to propagate the exception in the context
          ENDTRY.

          APPEND ls_product_details TO lt_product_details.


          io_response->set_data( lt_product_details ).
          io_response->set_total_number_of_records( lines( lt_product_details ) ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).

          ycl_utility=>raise_exception( im_attr1 = no_single_id  ).
      ENDTRY.
    ELSE.
      ycl_utility=>raise_exception( im_attr1 = no_data_requested  ).


    ENDIF.


  ENDMETHOD.
  METHOD get_product_name.

    DATA(lv_url) = ycl_utility=>c_target_url && im_product_id && ycl_utility=>c_target_param1 && ycl_utility=>c_target_param2.

    TRY.
        DATA(lv_response) = ycl_utility=>http_get( io_client =  ycl_utility=>create_client( url = lv_url  ) ).

        get_title_from_response( EXPORTING io_data   =  lv_response
                                  IMPORTING ex_Product_name = ex_Product_name ).
      CATCH ycx_rap_query_provider INTO DATA(lo_exp).
        RAISE EXCEPTION lo_exp.
      CATCH cx_static_check.
    ENDTRY.
  ENDMETHOD.
  METHOD get_title_from_response.

* Format JSON file which was converted to a string
* and get the product title from converted string.
    FIELD-SYMBOLS:  <ls_data>  TYPE any.
    ASSIGN io_data->* TO FIELD-SYMBOL(<lfs_data>).
    IF <lfs_data> IS ASSIGNED.
      ASSIGN COMPONENT `PRODUCT` OF STRUCTURE  <lfs_data> TO FIELD-SYMBOL(<lfs_product>).
      IF sy-subrc = 0.
        ASSIGN <lfs_product>->* TO <ls_data>.
        ASSIGN COMPONENT `ITEM` OF STRUCTURE  <ls_data> TO FIELD-SYMBOL(<lfs_item>).
        IF sy-subrc = 0.
          ASSIGN <lfs_item>->* TO <ls_data>.
          ASSIGN COMPONENT `PRODUCT_DESCRIPTION` OF STRUCTURE  <ls_data> TO FIELD-SYMBOL(<lfs_prod_desc>).
          IF sy-subrc = 0.
            ASSIGN <lfs_prod_desc>->* TO <ls_data>.
            ASSIGN COMPONENT `TITLE` OF STRUCTURE  <ls_data> TO FIELD-SYMBOL(<lfs_title>).
            IF sy-subrc = 0.
              ASSIGN <lfs_title>->* TO <ls_data>.
              IF <ls_data> IS ASSIGNED.
                ex_Product_name = <ls_data>.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD  get_product_price.


    DATA(lv_url) = ycl_utility=>c_nosql_url && im_product_id .


    TRY.
        DATA(lo_client) = ycl_utility=>create_client( url = lv_url  ).

        DATA(lo_request) = lo_client->get_http_request( ).

        get_price_from_response( EXPORTING io_data   = ycl_utility=>http_get( io_client =  lo_client )
                                  IMPORTING ex_product_price = ex_product_price
                                            ex_currency_code = ex_currency_code ).
      CATCH cx_web_http_client_error INTO DATA(lo_WEB_HTTP_CLIENT_ERROR).
      CATCH cx_static_check.
    ENDTRY.

  ENDMETHOD.
  METHOD  get_price_from_response.

* Format JSON file which was converted to a string
* and get the product title from converted string.
    FIELD-SYMBOLS:  <ls_data>  TYPE any.
    ASSIGN io_data->* TO FIELD-SYMBOL(<lfs_data>).
    IF <lfs_data> IS ASSIGNED.
      ASSIGN COMPONENT `_SOURCE` OF STRUCTURE  <lfs_data> TO FIELD-SYMBOL(<lfs_source>).
      IF sy-subrc = 0.
        ASSIGN <lfs_source>->* TO FIELD-SYMBOL(<ls_source>).
        IF <ls_source> IS ASSIGNED.
          ASSIGN COMPONENT `PRODUCTVALUE` OF STRUCTURE  <ls_source> TO FIELD-SYMBOL(<lfs_PRODUCTVALUE>).
          IF <lfs_PRODUCTVALUE> IS ASSIGNED.
            UNASSIGN <ls_data>.
            ASSIGN <lfs_PRODUCTVALUE>->* TO <ls_data>.
            IF <ls_data> IS ASSIGNED.
              ex_product_price = <ls_data> .
            ENDIF.

          ENDIF.

          ASSIGN COMPONENT `CURRENCYCODE` OF STRUCTURE  <ls_source> TO FIELD-SYMBOL(<LFS_currencycode>).
          IF <LFS_currencycode> IS ASSIGNED.
            UNASSIGN <ls_data>.
            ASSIGN <LFS_currencycode>->* TO <ls_data>.
            IF <ls_data> IS ASSIGNED.
              ex_currency_code =  <ls_data>.
            ENDIF.

          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
