
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	///+ГомзМА 06.10.2023
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаСпискаТоварыДляПополнения", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	///-ГомзМА 06.10.2023
	
КонецПроцедуры
