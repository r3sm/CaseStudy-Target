@ObjectModel.query.implementedBy  : 'ABAP:YCL_PRODUCT_QUERY'
@EndUserText.label: 'Product Details'
define custom entity YProductDetails 
 {
 @EndUserText.label: 'Product ID'
  key productId     : abap.int8;
 @EndUserText.label: 'Product Name' 
      productName   : abap.char(100);
 @EndUserText.label: 'Product Price'
      @Semantics.amount.currencyCode : 'currencyCode' 
      productPrice  : abap.curr(15,2);
  @EndUserText.label: 'Currency Code'    
      currencyCode  : abap.cuky( 5 );
}
