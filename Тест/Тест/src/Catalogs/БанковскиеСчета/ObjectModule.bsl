#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	КоличествоСчетов = 0;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		КоличествоСчетов = Справочники.БанковскиеСчета.КоличествоБанковскихСчетов(ДанныеЗаполнения.Владелец);
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеЗаполнения, "Клиент") Тогда
		КоличествоСчетов = Справочники.БанковскиеСчета.КоличествоБанковскихСчетов(ДанныеЗаполнения.Клиент);
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеЗаполнения, "Контрагент") Тогда
		КоличествоСчетов = Справочники.БанковскиеСчета.КоличествоБанковскихСчетов(ДанныеЗаполнения.Контрагент);
	КонецЕсли;
	
	
	Если КоличествоСчетов = 0 Тогда
		Наименование = "Основной";
	Иначе
		Наименование = СтрШаблон("Дополнительный %1", КоличествоСчетов);
	КонецЕсли;

		 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли