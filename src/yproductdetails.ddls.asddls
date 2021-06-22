@ObjectModel.query.implementedBy  : 'ABAP:YCL_PRODUCT_QUERY'
@EndUserText.label: 'Product Details'
define root custom entity YProductDetails 
 {
 @EndUserText.label: 'Product ID'
  key id     : abap.int8;
 @EndUserText.label: 'Product Name' 
      name   : abap.char(100);
 @EndUserText.label: 'Product Price'
      @Semantics.amount.currencyCode : 'currencyCode' 
      value  : abap.curr(15,2);
  @EndUserText.label: 'Currency Code'    
      currencyCode  : abap.cuky( 5 );
}
