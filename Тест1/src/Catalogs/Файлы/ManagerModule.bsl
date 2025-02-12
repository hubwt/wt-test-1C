#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если Параметры.Количество() = 0 Тогда
		ВыбраннаяФорма = "Файлы"; // Т.к. не указан конкретный файл, то открываем список файлов.
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	Если ВидФормы = "ФормаСписка" Тогда
		ТекущаяСтрока = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ТекущаяСтрока");
		Если ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.Файлы") И Не ТекущаяСтрока.Пустая() Тогда
			СтандартнаяОбработка = Ложь;
			ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяСтрока, "ВладелецФайла");
			Если ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
				Параметры.Вставить("Папка", ВладелецФайла);
				ВыбраннаяФорма = "Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы";
			Иначе
				Параметры.Вставить("ВладелецФайла", ВладелецФайла);
				ВыбраннаяФорма = "Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ОтработаныВсеФайлы = Ложь;
	Ссылка = "";
	
	Пока Не ОтработаныВсеФайлы Цикл
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1000
			|	Файлы.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Файлы КАК Файлы
			|ГДЕ
			|	((Файлы.ДатаМодификацииУниверсальная = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
			|	И Файлы.ТекущаяВерсия <> ЗНАЧЕНИЕ(Справочник.ВерсииФайлов.ПустаяСсылка))
			|	ИЛИ Файлы.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ПустаяСсылка))
			|	И Файлы.Ссылка > &Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");

		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
		
		КоличествоСсылок = МассивСсылок.Количество();
		
		Если КоличествоСсылок < 1000 Тогда
			ОтработаныВсеФайлы = Истина;
		КонецЕсли;
		
		Если КоличествоСсылок > 0 Тогда
			Ссылка = МассивСсылок[КоличествоСсылок - 1];
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.Файлы");
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			ОбновляемыйФайл = Выборка.Ссылка.ПолучитьОбъект();
			ОбновляемыйФайл.ДатаМодификацииУниверсальная = ОбновляемыйФайл.ТекущаяВерсия.ДатаМодификацииУниверсальная;
			ОбновляемыйФайл.ТипХраненияФайла             = ОбновляемыйФайл.ТекущаяВерсия.ТипХраненияФайла;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбновляемыйФайл);
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать файл: %1 по причине:
				|%2'"), 
				Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Файлы") Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедуре Справочники.Файлы.ОбработатьДанныеДляПереходаНаНовуюВерсию.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать программы электронной подписи (пропущены): %1'"), 
		ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
		, ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедура Справочники.Файлы.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию программ электронной подписи: %1'"),
		ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
