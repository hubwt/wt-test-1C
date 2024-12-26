

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий


Процедура ОбработкаПроведения(Отказ, Режим)
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	
	Префикс = дт_ОбщегоНазначения.ПрефиксОрганизации(Организация);
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Дата < '20180101' Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
	

	Если БезДоговора Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Основание) Тогда
		
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказНаДоставку") Тогда
		
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Товар");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.Номенклатура");
			
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказНаряд") Тогда	
			
		Иначе
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.Номенклатура");
		КонецЕсли;
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.Номенклатура");
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Док.Ссылка КАК Основание,
		|	Док.Клиент КАК Клиент,
		|	Док.Комментарий КАК Комментарий,
		|	Док.Доставка КАК Доставка,
		|	Док.Расход КАК Расход,
		|	Док.СрокПроверки КАК СрокПроверки,
		|	Док.Организация КАК Организация,
		|	Док.ИтогоРекв КАК ИтогоРекв,
		|	Док.Оплачено КАК Оплачено,
		|	Док.УжеОплачено КАК УжеОплачено,
		|	Док.Откат КАК Откат,
		|	Док.КомуОткат КАК КомуОткат,
		|	Док.ОтданоМарату КАК ОтданоМарату,
		|	Док.ИтогоБезнал КАК ИтогоБезнал,
		|	Док.АртикулВНазвании КАК АртикулВНазвании,
		|	Док.ВычитатьИзСуммы КАК ВычитатьИзСуммы,
		|	Док.ПотеряНаОбналичку КАК ПотеряНаОбналичку,
		|	Док.ОстатокДенег КАК ОстатокДенег,
		|	Док.ВозвратТовара КАК ВозвратТовара,
		|	Док.СуммаВозврат КАК СуммаВозврат,
		|	Док.ТранспортнаяКомпания КАК ТранспортнаяКомпания,
		|	Док.Вес КАК Вес,
		|	Док.Объем КАК Объем,
		|	Док.КоличествоМест КАК КоличествоМест,
		|	Док.ГородОтправки КАК ГородОтправки,
		|	Док.РегионПолучения КАК РегионПолучения,
		|	Док.ГородПолучения КАК ГородПолучения,
		|	Док.СтоимостьДоставки КАК СтоимостьДоставки,
		|	Док.ЕстьДоставка КАК ЕстьДоставка,
		|	Док.ДоставкаНеЗаполнена КАК ДоставкаНеЗаполнена,
		|	Док.Самовывоз КАК Самовывоз,
		|	Док.СтранаПолучения КАК СтранаПолучения,
		|	Док.Новые КАК Новые,
		|	Док.Скидка КАК Скидка,
		|	Док.КоммДост КАК КоммДост,
		|	Док.НомерПП КАК НомерПП,
		|	Док.TipOplati КАК TipOplati,
		|	Док.доставкаКлиент КАК доставкаКлиент,
		|	Док.частный КАК частный,
		|	Док.НаименованиеИлиФИО КАК НаименованиеИлиФИО,
		|	Док.ИНН КАК ИНН,
		|	Док.Телефон КАК Телефон,
		|	Док.Паспорт КАК Паспорт,
		|	Док.Прописка КАК Прописка,
		|	Док.СтатусДоставки КАК СтатусДоставки,
		|	Док.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	Док.БезДоговора КАК БезДоговора,
		|	Док.КтоПродал,
		|	Док.Проект,
		|	Док.УслугиДоствка.(
		|		Услуга КАК Услуга,
		|		Цена КАК Цена) КАК УслугиДоствка
		|ИЗ
		|	Документ.ПродажаЗапчастей КАК Док
		|ГДЕ
		|	Док.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПродажаЗапчастейТаблица.Товар,
		|	ПродажаЗапчастейТаблица.Количество,
		|	ПродажаЗапчастейТаблица.Цена КАК Цена11111,
		|	ПродажаЗапчастейТаблица.Скидка КАК Скидка,
		|	ПродажаЗапчастейТаблица.машина КАК машина,
		|	ПродажаЗапчастейТаблица.цена1 КАК цена1,
		|	ПродажаЗапчастейТаблица.Комментарий КАК Комментарий,
		|	ПродажаЗапчастейТаблица.Сумма КАК Цена
		|ИЗ
		|	Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
		|ГДЕ
		|	ПродажаЗапчастейТаблица.Ссылка = &Ссылка
		|	И НЕ ПродажаЗапчастейТаблица.Отменено
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПродажаЗапчастейТаблица.НомерСтроки";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса[0].Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ТабличнаяЧастьУслуги = ВыборкаДетальныеЗаписи.УслугиДоствка.Выгрузить();
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаДетальныеЗаписи, , "УслугиДоствка");
			
			УслугиДоствка.Загрузить(ТабличнаяЧастьУслуги);
		КонецЦикла;

		Таблица.Загрузить(РезультатЗапроса[1].Выгрузить());
		
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаДоставку") Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЗаказНаДоставку.Организация КАК Организация,
			|	ЗаказНаДоставку.Клиент КАК Клиент,
			|	ЗаказНаДоставку.ДоговорКонтрагента КАК ДоговорКонтрагента,
			|	ЗаказНаДоставку.БезДоговора КАК БезДоговора,
			|	ЗаказНаДоставку.ПунктОтправления КАК ГородОтправки,
			|	ЗаказНаДоставку.ПунктНазначения КАК ГородПолучения,
			|	ЗаказНаДоставку.Груз КАК Груз,
			|	ЗаказНаДоставку.СуммаДокумента КАК СуммаДокумента,
			|	ЗаказНаДоставку.ПунктОтправленияАдрес КАК ПунктОтправленияАдрес,
			|	ЗаказНаДоставку.ПунктНазначенияАдрес КАК ПунктНазначенияАдрес,
			|	ЗаказНаДоставку.Ответственный КАК КтоПродал,
			|	ЗаказНаДоставку.ДатаНачала КАК ДатаНачала,
			|	ЗаказНаДоставку.ДатаОкончания КАК ДатаОкончания,
			|	ЗаказНаДоставку.Водитель КАК Водитель,
			|	ЗаказНаДоставку.Автомобиль.ГосНомер КАК АвтомобильГосНомер,
			|	ЗаказНаДоставку.Автомобиль.МаркаТС КАК АвтомобильМодель,
			|	ЗаказНаДоставку.ПунктОтправления КАК ПунктОтправления,
			|	ЗаказНаДоставку.ПунктНазначения КАК ПунктНазначения,
			|	ЗаказНаДоставку.ДоговорКонтрагента.НомерДоговора КАК НомерДоговора,
			|	ЗаказНаДоставку.ДоговорКонтрагента.ДатаДоговора КАК ДатаДоговора,
			|	&Ссылка КАК Основание
			|ИЗ
			|	Документ.ЗаказНаДоставку КАК ЗаказНаДоставку
			|ГДЕ
			|	ЗаказНаДоставку.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Возврат
		КонецЕсли;
		
		
		ДанныеЗаполнения = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса.Выгрузить()[0]);
		
	    ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
		
		ЭтотОбъект.Таблица.Очистить();
		
		НоваяСтрока  = Услуги.Добавить();
		//НоваяСтрока.Содержание = СтрШаблон("Транспортные услуги %1 - %2", 
		//	Строка(ДанныеЗаполнения.ГородОтправки),
		//	Строка(ДанныеЗаполнения.ГородПолучения)
		//	
		//);
		НоваяСтрока.Содержание = Документы.ЗаказНаДоставку.ПолучитьНаименование(ДанныеЗаполнения);
		НоваяСтрока.Количество = 1;
		НоваяСтрока.Цена = ДанныеЗаполнения.СуммаДокумента;
		НоваяСтрока.Сумма = ДанныеЗаполнения.СуммаДокумента;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаряд") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЗаказНаряд.Организация КАК Организация,
			|	ЗаказНаряд.Клиент КАК Клиент,
			|	&Ссылка КАК Основание,
			|	ЗаказНаряд.ДоговорКонтрагента КАК ДоговорКонтрагента,
			|	ЗаказНаряд.БезДоговора КАК БезДоговора,
			|	ЗаказНаряд.Проект
			|ИЗ
			|	Документ.ЗаказНаряд КАК ЗаказНаряд
			|ГДЕ
			|	ЗаказНаряд.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.Номенклатура КАК Товар,
			|	Товары.Количество КАК Количество,
			|	Товары.СуммаВсего КАК Сумма,
			|	ВЫБОР
			|		КОГДА Товары.Количество = 0
			|			ТОГДА 0
			|		ИНАЧЕ Товары.СуммаВсего / Товары.Количество
			|	КОНЕЦ КАК Цена
			|ИЗ
			|	Документ.ЗаказНаряд.Товары КАК Товары
			|ГДЕ
			|	Товары.Ссылка = &Ссылка
			|УПОРЯДОЧИТЬ ПО
			|	Товары.НомерСтроки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Работы.Количество КАК Количество,
			|	Работы.СуммаВсего КАК Сумма,
			|	ВЫБОР
			|		КОГДА Работы.Количество = 0
			|			ТОГДА 0
			|		ИНАЧЕ Работы.СуммаВсего / Работы.Количество
			|	КОНЕЦ КАК Цена,
			|	Работы.Работа КАК Номенклатура,
			|	Работы.Содержание КАК Содержание
			|ИЗ
			|	Документ.ЗаказНаряд.Работы КАК Работы
			|ГДЕ
			|	Работы.Ссылка = &Ссылка
			|УПОРЯДОЧИТЬ ПО
			|	Работы.НомерСтроки";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Если РезультатЗапроса[0].Пустой() Тогда
			Возврат
		КонецЕсли;
		
		
		ДанныеЗаполнения = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса[0].Выгрузить()[0]);
		
	    ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
		
		
		Таблица.Загрузить(РезультатЗапроса[1].Выгрузить());
		Услуги.Загрузить(РезультатЗапроса[2].Выгрузить());
	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Док.Комментарий КАК Комментарий,
			|	Док.Проект КАК Проект,
			|	Док.Клиент КАК Клиент,
			|	Док.Ссылка КАК Основание
			|ИЗ
			|	Документ.ЗаказКлиента КАК Док
			|ГДЕ
			|	Док.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.НомерСтроки КАК НомерСтроки,
			|	Товары.Номенклатура КАК Товар,
			|	Товары.ЦенаСоСкидкойНаценкой КАК Цена,
			|	Товары.Количество КАК Количество,
			|	Товары.Сумма КАК Сумма,
			|	Товары.Партия КАК Партия
			|ИЗ
			|	Документ.ЗаказКлиента.Товары КАК Товары
			|ГДЕ
			|	Товары.Ссылка = &Ссылка
			|	И НЕ Товары.Отменено
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
		
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Шапка = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса[0].Выгрузить()[0]);
		
		ЗаполнениеДокументов.Заполнить(ЭтотОбъект, Шапка, Ложь);
		
		ТоварыИсточник = РезультатЗапроса[1].Выгрузить();
		Таблица.Загрузить(ТоварыИсточник);
		
		///+ГомзМА 11.08.2023
		Таблица.Очистить();
		НачисляетсяНДС = ДанныеЗаполнения.НачислятьНДС;
		Для каждого ТекСтрокаТЧ Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Таблица.Добавить();
			НоваяСтрока.Товар = ТекСтрокаТЧ.Номенклатура;
			НоваяСтрока.Количество = ТекСтрокаТЧ.Количество;
			Если ДанныеЗаполнения.НачислятьНДС Тогда
				//НоваяСтрока.Цена = (ТекСтрокаТЧ.Сумма - ТекСтрокаТЧ.СуммаНДС) / ТекСтрокаТЧ.Количество;
				НоваяСтрока.Цена = ТекСтрокаТЧ.Цена;
				НоваяСтрока.Сумма = ТекСтрокаТЧ.Сумма;
				НоваяСтрока.Партия = ТекСтрокаТЧ.Партия;
				
			Иначе
				НоваяСтрока.Цена = ТекСтрокаТЧ.Сумма / ТекСтрокаТЧ.Количество;	
				НоваяСтрока.Партия = ТекСтрокаТЧ.Партия;
			КонецЕсли;
		КонецЦикла;
		///-ГомзМА 11.08.2023
		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, , Ложь); // в счете по умолчанию не заполняем организацию
	Если Не ЗначениеЗаполнено(КтоПродал) Тогда
		КтоПродал = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	
	
	///+ГомзМА 09.08.2023
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("МенеджерПоПродажам")) И
		(НЕ ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ПолныеПрава")) ИЛИ
		 НЕ ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("дт_ПолныеПрава"))) Тогда
			Если Организация = Справочники.Организация.НайтиПоКоду("000000005") Тогда
				Организация = Справочники.Организация.ПустаяСсылка();
				Сообщить("Не использовать ООО ""Ворктрак"", выберите другую организацию!");
			КонецЕсли;
	КонецЕсли;
///-ГомзМА 09.08.2023
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ИтогоРекв = Таблица.Итог("Сумма") - Таблица.Итог("Скидка") + Услуги.Итог("Сумма");
	
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли