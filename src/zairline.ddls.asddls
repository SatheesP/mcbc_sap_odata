@AbapCatalog.sqlViewName: 'zvairline'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airlines'
define view ZAirline 
  as select from scarr

    association [0..*] to ZMeals as _meals
      on $projection.AirlineID = _meals.AirlineID 
{
  key scarr.carrid    as AirlineID,
      scarr.carrname  as Name,

      @Semantics.currencyCode: true
      scarr.currcode  as CurrencyCode,
      
      @Semantics.url: { mimeType: 'url' }
      scarr.url       as Url,
       
      _meals // Make association public
}
