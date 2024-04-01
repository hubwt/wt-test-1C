

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	НепроверяемыеРеквизиты = Новый Массив();
	
	Если НЕ ПолучитьФункциональнуюОпцию("дт_ИспользоватьПроекты") Тогда
		НепроверяемыеРеквизиты.Добавить("Проект");	
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	//Если НЕ ПолучитьФункциональнуюОпцию("дт_ИспользоватьПроекты")
	//	И Не ЗначениеЗаполнено(Проект) Тогда
	//	
	//	Проект = Справочники.ПроектыРазвития.ОсновнойПроект;
	//	
	//КонецЕсли;
	Статус = Перечисления.СтатусыЗадачРуководителей.Создана;
	СтатусАвтора = перечисления.СтатусыЗадачАвтора.Ожидание;
	Проект       = Справочники.ПроектыРазвития1.НайтиПоКоду("000000001");
	ДатаНачалаПлан = ТекущаяДата();
	
КонецПроцедуры

#КонецОбласти



#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли