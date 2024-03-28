#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчика, ПодтверждениеЗакрытияФормы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыбора 
		Или ПодтверждениеЗакрытияФормы = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗакрытиеФормыЗавершение", ЭтотОбъект);
	Текст = НСтр("ru = 'Отказаться от обновления данных классификатора?'");
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если ВариантыАктуализации = 0 Тогда
		Закрыть();
		// Переход на ветку загрузки из интернета - подставим в параметры все ранее загруженные регионы.
		ПараметрыЗагрузки = Новый Структура;
		ПараметрыЗагрузки.Вставить("КодРегионаДляЗагрузки", НеобработанныеРегионыКЛАДР());
		АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор(ПараметрыЗагрузки);
	Иначе
		Элементы.ОК.Доступность = Ложь;
		// Запуск переноса данных
		АктуализироватьАдресныйКлассификаторКлиент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		ФоновоеЗаданиеОтменить(ИдентификаторФоновогоЗадания);
		ПоказатьОповещениеПользователя(,, НСтр("ru = 'Обновление адресного классификатора не завершено.'"));
	КонецЕсли;
	
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытиеФормыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПодтверждениеЗакрытияФормы = Истина;
		Закрыть();
	Иначе 
		ПодтверждениеЗакрытияФормы = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьАдресныйКлассификаторКлиент()

	ФоновоеЗадание = Ложь;
	Результат = "Выполняется";
	АктуализироватьАдресныйКлассификатор(Результат, ФоновоеЗадание);
	
	Если ФоновоеЗадание = Истина Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДлительнойОперации;
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ПараметрыОбработчика.МаксимальныйИнтервал = 5;
	Иначе 
		Если Результат = "Выполнено" Тогда
			ОбновитьПовторноИспользуемыеЗначения(); 
			Оповестить("АдресныйКлассификаторАктуализирован", , ЭтотОбъект);
			ПоказатьОповещениеПользователя(,, НСтр("ru = 'Обновление адресного классификатора успешно завершено.'"));
		Иначе
			ПоказатьОповещениеПользователя(,, НСтр("ru = 'Обновление адресного классификатора не завершено.'"));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	ЗаданиеВыполнено = Неопределено;
	Попытка
		ЗаданиеВыполнено = ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
	Исключение
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Обновление адресного классификатора'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			"Ошибка", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), , Истина);
		ТекстОбОшибке = НСтр("ru = 'Обновление адресного классификатора прервана.|Подробности см. в журнале регистрации.'");
		ПоказатьПредупреждение(, ТекстОбОшибке);
		
		Элементы.ОК.Доступность = Истина;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыбора;
		Возврат;
	КонецПопытки;
		
	Если ЗаданиеВыполнено Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Обновление адресного классификатора'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			"Информация", НСтр("ru = 'Обновление адресного классификатора успешно завершено.'"), , Истина);
		ПоказатьОповещениеПользователя(,, НСтр("ru = 'Обновление адресного классификатора успешно завершено.'"));
		ОбновитьПовторноИспользуемыеЗначения(); 
		Оповестить("АдресныйКлассификаторАктуализирован", , ЭтотОбъект);
		ПодтверждениеЗакрытияФормы = Истина;
		ЭтотОбъект.Закрыть();
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчика.ТекущийИнтервал, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаСервереБезКонтекста
Процедура ФоновоеЗаданиеОтменить(Идентификатор)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(Идентификатор);
КонецПроцедуры

&НаСервере
Процедура АктуализироватьАдресныйКлассификатор(Результат, ФоновоеЗадание = Ложь)
	
	ИдентификаторФоновогоЗадания = Неопределено;
	
	ПараметрыВызоваСервера = Новый Структура();
	ПараметрыВызоваСервера.Вставить("Результат", Результат);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Подсистема Адресный классификатор: актуализация данных'");
	
	ПроцессФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("АдресныйКлассификаторСлужебный.ФоновыйПереносДанныхУстаревшегоКлассификатора",
		ПараметрыВызоваСервера, ПараметрыВыполнения);
		
	Если ПроцессФоновоеЗадание.Статус <> "Выполняется" Тогда
		Результат = "Выполнено";
	Иначе
		ФоновоеЗадание = Истина;
		ИдентификаторФоновогоЗадания = ПроцессФоновоеЗадание.ИдентификаторЗадания;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НеобработанныеРегионыКЛАДР() 
	
	Возврат АдресныйКлассификаторСлужебный.ЗаполненныеРегионыУстаревшегоКлассификатора().Количество();
	
КонецФункции

#КонецОбласти
