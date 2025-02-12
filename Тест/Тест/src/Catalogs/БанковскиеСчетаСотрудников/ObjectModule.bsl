#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерБанковскойКарты)
		И Не ЗначениеЗаполнено(НомерТелефонаДляПлатежей) Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Необходимо заполнить номер карты или номер телефона",
			,
			"НомерБанковскойКарты",
			"Объект",
			Отказ
		);

	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытий



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли