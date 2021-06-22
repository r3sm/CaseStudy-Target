@ObjectModel.query.implementedBy  : 'ABAP:YCL_PRODUCT_QUERY'
@EndUserText.label: 'Product Details'
define custom entity YProductDetails 
 {
  key productId     : abap.int8;
      productName   : abap.char(100);
      @Semantics.amount.currencyCode : 'currencyCode' 
      productPrice  : abap.curr(15,2);
      currencyCode  : abap.cuky( 5 );
}
