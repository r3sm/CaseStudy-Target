"#autoformat
CLASS ycl_product_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*// Interface for Query
    INTERFACES  if_rap_query_provider .

*// Static method Used for Read as well during the update of price
    CLASS-METHODS get_product_price IMPORTING im_product_id    TYPE yproductdetails-productid
                                    EXPORTING ex_product_price TYPE yproductdetails-productprice
                                              ex_currency_code TYPE yproductdetails-currencycode
                                    RAISING   ycx_rap_query_provider.
PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF no_data_requested,
        msgid TYPE symsgid VALUE 'SY',
        msgno TYPE symsgno VALUE '499',
        attr1 TYPE scx_attrname VALUE 'Data Not requested',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_data_requested,
      BEGIN OF no_single_id,
        msgid TYPE symsgid VALUE 'SY',
        msgno TYPE symsgno VALUE '499',
        attr1 TYPE scx_attrname VALUE 'Please provide unique Product ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_single_id,
      BEGIN OF product_not_found,
        msgid TYPE symsgid VALUE 'SY',
        msgno TYPE symsgno VALUE '499',
        attr1 TYPE scx_attrname VALUE 'Product Not Found',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF product_not_found.


    METHODS :
*// Get Product Name for Target End point
      get_product_name IMPORTING im_product_id   TYPE yproductdetails-productid
                       EXPORTING ex_Product_name TYPE yproductdetails-productname
                       RAISING   ycx_rap_query_provider.
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
          READ TABLE lt_filter_cond WITH KEY name = 'PRODUCTID' INTO DATA(ls_productid_filter_key).
          IF sy-subrc = 0 AND lines( ls_productid_filter_key-range ) = 1.
            READ TABLE ls_productid_filter_key-range INTO DATA(ls_id_option) INDEX 1.
            IF sy-subrc = 0 AND ls_id_option-sign = 'I' AND ls_id_option-option = 'EQ' AND ls_id_option-low IS NOT INITIAL.
*// Single read
              DATA(is_key_filter) = abap_true.
            ENDIF.
          ENDIF.

*// Raise Exception if Query is not made with Unique Product ID
          IF is_key_filter  <> abap_true.
            lo_exp = NEW #( textid =  no_single_id  ).
            RAISE EXCEPTION lo_exp.
          ENDIF.

*// Product ID
          ls_product_details-productid = ls_id_option-low.

*/ Product Name
          get_product_name(
           EXPORTING
             im_product_id =  ls_product_details-productid
           IMPORTING
            ex_Product_name = ls_product_details-productname ).

          TRY.
*// Product Price
              get_product_price(
                EXPORTING
                   im_product_id =  ls_product_details-productid
                IMPORTING
                    ex_product_price  =  ls_product_details-productprice
                    ex_currency_code  =  ls_product_details-currencycode ).
            CATCH ycx_rap_query_provider.
*// Not Need to propagate the exception in the context
          ENDTRY.

          APPEND ls_product_details TO lt_product_details.


          io_response->set_data( lt_product_details ).
          io_response->set_total_number_of_records( lines( lt_product_details ) ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
          lo_exp = NEW #( textid =  no_single_id previous = lx_no_sel_option ).
          RAISE EXCEPTION lo_exp.

      ENDTRY.
    ELSE.
      lo_exp = NEW #( textid =  no_data_requested ).
      RAISE EXCEPTION lo_exp.
    ENDIF.


  ENDMETHOD.
  METHOD get_product_name.
  ENDMETHOD.
  METHOD  get_product_price.
  ENDMETHOD.
ENDCLASS.
