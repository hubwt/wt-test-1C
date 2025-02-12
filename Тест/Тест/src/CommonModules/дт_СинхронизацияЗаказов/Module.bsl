#Область ПрограммныйИнтерфейс

Функция ПолучитьСвойствоОбъектаJSON(ДанныеJSON, ИмяСвойства) Экспорт
	
	Результат = Неопределено;
	
	Если ТипЗнч(ДанныеJSON) = Тип("Структура") Тогда
		Если НЕ ДанныеJSON.Свойство(ИмяСвойства, Результат) Тогда
			ВызватьИсключение "Ошибка чтения JSON. Не найдено свойство " + ИмяСвойства;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеJSON) = Тип("Соответствие") Тогда
		
		Результат = ДанныеJSON.Получить(ИмяСвойства);
		
	Иначе
		
		ВызватьИсключение "Ошибка чтения JSON. Неизвестный тип: " + ТипЗнч(ДанныеJSON);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьJSONСтроку(Значение) Экспорт

	ЗаписьJSONПоток = Новый ЗаписьJSON;
	ЗаписьJSONПоток.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSONПоток, Значение);
			
	Возврат ЗаписьJSONПоток.Закрыть();

КонецФункции // ПолучитьJSONСтроку()

Функция ПолучитьЗначениеИзJSONСтроки(ДанныеКакСтрока, ВидСобытия = "", Отказ = Ложь) Экспорт

	ЧтениеJSONПоток = Новый ЧтениеJSON();
	ЧтениеJSONПоток.УстановитьСтроку(ДанныеКакСтрока);
	Попытка
		Результат = ПрочитатьJSON(ЧтениеJSONПоток);
	Исключение
		Результат = Неопределено;
		ЗаписьВЛог(ВидСобытия, ОписаниеОшибки(), Истина,,,, Отказ);
	КонецПопытки;
	ЧтениеJSONПоток.Закрыть();
	
 	Возврат Результат;
	
КонецФункции // ПолучитьЗначениеИзJSONСтроки()



#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаписьВЛог(ВидСобытия, ТекстЗаписи, ЭтоОшибка = ложь, МетаданныеОбъекта = Неопределено, Объект = Неопределено, ТолькоВРежимеОтладки = Ложь, Отказ = Ложь) Экспорт
	
	РежимОтладки = Истина;
	
	Если ТолькоВРежимеОтладки И НЕ РежимОтладки Тогда
		Возврат;	
	КонецЕсли;
	
	УровеньЗаписи = УровеньЖурналаРегистрации.Информация;
	Если ЭтоОшибка Тогда
		УровеньЗаписи = УровеньЖурналаРегистрации.Ошибка;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ВидСобытия, 
			УровеньЗаписи,
			МетаданныеОбъекта,
			Объект,
			ТекстЗаписи);
			
	Если ЭтоОшибка Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстЗаписи,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти