

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	ГосНомер = ВРЕГ(ГосНомер);
КонецПроцедуры



Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	ИспользоватьРазборку = ПолучитьФункциональнуюОпцию("дт_ИспользоватьРазборку");
	
	Если ИспользоватьРазборку Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГосНомер");
	Иначе		
		МассивНепроверяемыхРеквизитов.Добавить("VIN");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	
	
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли