
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	///+ГомзМА 17.11.2023
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаСпискаДляПеремещения", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	///-ГомзМА 17.11.2023
	
КонецПроцедуры
