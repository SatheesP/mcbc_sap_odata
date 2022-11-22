@AbapCatalog.sqlViewName: 'zvmeal_text'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Meal Text'

@ObjectModel.dataCategory: #TEXT  --Indicates a text provider view (Text Table)

define view ZMeal_Text 
  as select from smealt 
{
  key carrid      as AirlineID,

      @ObjectModel.text.element: ['text']
  key mealnumber  as MealNumber,

      @Semantics.language: true   --Identifies Language Field
      sprache     as Langu,

      @Semantics.text: true       --Identifies Language dependent Text field
      text        as Text         --Multiple could be defined, 1st one used by OData service
}
