#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	дт_Нумерация.ПроверитьУникальностьЭлементаСправочника(ЭтотОбъект, "Наименование", Истина, Истина, Истина, Отказ);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытий



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли