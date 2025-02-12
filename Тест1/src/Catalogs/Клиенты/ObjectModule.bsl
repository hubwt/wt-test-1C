#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий



Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ТипКлиентаИП = ТипКлиента = ПредопределенноеЗначение("Перечисление.дт_ТипыКлиентов.ИП");
	ТипКлиентаФизлицо  = ТипКлиента = ПредопределенноеЗначение("Перечисление.дт_ТипыКлиентов.ФизЛицо");
	ТипКлиентаЮрлицо  = ТипКлиента = ПредопределенноеЗначение("Перечисление.дт_ТипыКлиентов.ЮрЛицо");
	
	ТипКлиентаЧастноеЛицо = ТипКлиентаФизлицо ИЛИ ТипКлиентаИП;
	ТипКлиентаБизнес = ТипКлиентаЮрлицо ИЛИ ТипКлиентаИП;
	
	Если Не ЗначениеЗаполнено(ПолноеНаименование) Тогда
		Если ТипКлиентаИП И ЗначениеЗаполнено(ФИО) Тогда
			ПолноеНаименование = "Индивидуальный предприниматель " + ФИО;
		ИначеЕсли ТипКлиентаФизлицо И ЗначениеЗаполнено(ФИО) Тогда	
			ПолноеНаименование = ФИО;
		Иначе	
			ПолноеНаименование = Наименование;
		КонецЕсли;	
	КонецЕсли;
	
	Если ТипКлиентаЧастноеЛицо 
		И Не ЗначениеЗаполнено(ФИО) Тогда
		
		ФИО = Наименование;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаСоздания)
		И ЭтоНовый() Тогда
			
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;


	// ТелефонПоиск
	ТелефонПоиск = Справочники.Клиенты.ПолучитьТелефоныДляПоиска(Телефон);
	Если ПроверкаИНН тогда
		дт_Нумерация.ПроверитьУникальностьЭлементаСправочника(ЭтотОбъект, "ИНН", Истина, Истина, Истина, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("строка") Тогда
		
	Телефон = ДанныеЗаполнения;
	
	КонецЕсли;
	
	ДатаСоздания = ТекущаяДата();
	ПроверкаИНН = Ложь;
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли



