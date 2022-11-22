@AbapCatalog.sqlViewName: 'zvmeals'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Meals'

define view ZMeals 
  with parameters 
    p_logon_langu : abap.lang,
    p_suppl_langu : abap.lang
    
  as select from smeal
    left outer join ZMeal_Text as _lgText
       on smeal.carrid      = _lgText.AirlineID
      and smeal.mealnumber  = _lgText.MealNumber
      and _lgText.Langu     = :p_logon_langu
       
    left outer join ZMeal_Text as _slText
       on smeal.carrid      = _slText.AirlineID
      and smeal.mealnumber  = _slText.MealNumber
      and _slText.Langu     = :p_suppl_langu 
{
  key smeal.carrid      as AirlineID,
  key smeal.mealnumber  as MealNumber,
      smeal.mealtype    as MealType,
      coalesce( _lgText.Text, _slText.Text ) as Text
}
