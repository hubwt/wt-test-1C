
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДиапазонПриИзменении(Элемент)
	// Комлев АА 19/12/24 ++++
	ЗаполнитьПодвалВостановленныеДетали();
	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачала", Диапазон.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", Диапазон.ДатаОкончания);
	ЗаполнитьПодвалВостановленныеДетали();
	// Комлев АА 19/12/24 ----
КонецПроцедуры


&НаКлиенте
Процедура ПериодОтчетаПриИзменении(Элемент)
	Аналитика.Параметры.УстановитьЗначениеПараметра("ДатаНачала", 		ПериодОтчета.ДатаНачала);
	Аналитика.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", 	ПериодОтчета.ДатаОкончания);
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаАналитика Тогда
	Аналитика.Параметры.УстановитьЗначениеПараметра("ДатаНачала", 		ПериодОтчета.ДатаНачала);
	Аналитика.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", 	ПериодОтчета.ДатаОкончания);
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура ИнформацияОПроданныхИВостановленныхДеталях(Команда)
	ИнформацияОПроданныхИВостановленныхДеталяхНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИнформацияОПроданныхИВостановленныхДеталяхНаСервере()
	//TODO: Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПодвалПроданныеДетали();
	
	// Комлев АА 19/12/24 ++++
	ЗаполнитьПодвалВостановленныеДетали();
	// Комлев АА 19/12/24 ----
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	///+ТатарМА 27.12.2024
	ТекСтрока = Элементы.Аналитика.ТекущиеДанные;
	Если Поле = Элементы.АналитикаСсылка Тогда
		
		СсылкаДляОткрытия    = ТекСтрока.Ссылка;
		ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
		
		ФормаДокумента 		 = ПолучитьФорму("Документ.Рас_Комплектовка.Форма.ФормаДокумента", ПараметрыФормы);
		ФормаДокумента.Открыть();
	КонецЕсли;
	///-ТатарМА 27.12.2024
	
КонецПроцедуры
 

&НаКлиенте
Процедура ПроданныеДеталиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	///+ТатарМА 19.09.2024
	ТекСтрока = Элементы.ПроданныеДетали.ТекущиеДанные;
	Если Поле = Элементы.ПроданныеДеталиЗаказНарядНаВосстановление Тогда
		
		СсылкаДляОткрытия    = ТекСтрока.ЗаказНарядНаВосстановление;
		ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
		
		ФормаДокумента 		 = ПолучитьФорму("Документ.Рас_Комплектовка.Форма.ФормаДокумента", ПараметрыФормы);
		ФормаДокумента.Открыть();
	ИначеЕсли Поле = Элементы.ПроданныеДеталиПродажа Тогда
		
		СсылкаДляОткрытия    = ТекСтрока.Продажа;
		ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
		
		ФормаДокумента 		 = ПолучитьФорму("Документ.ПродажаЗапчастей.Форма.ФормаДокумента", ПараметрыФормы);
		ФормаДокумента.Открыть();
	КонецЕсли;
	///-ТатарМА 19.09.2024

КонецПроцедуры

&НаКлиенте
Процедура ПериодВосстановлениеПриИзменении(Элемент)
	ПериодВосстановлениеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодПродажиПриИзменении(Элемент)
	ПериодПродажиПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПериодВосстановлениеПриИзмененииНаСервере()
	
	///+ТатарМА 30.10.2024
	Если ПериодВосстановление.ДатаНачала = '00010101' Тогда

		ПроданныеДетали.ТекстЗапроса = "ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка КАК ЗаказНарядНаВосстановление,
		|	Рас_Комплектовка.Дата КАК ДатаВосстановления,
		|	Рас_Комплектовка.Инкод КАК Инкод,
		|	Рас_Комплектовка.Номенклатура КАК Товар,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена КАК РекомендованаяЦена,
		|	ПродажаЗапчастейТаблица.Ссылка.Ссылка КАК Продажа,
		|	ПродажаЗапчастейТаблица.Ссылка.Дата КАК ДатаПродажи,
		|	ПродажаЗапчастейТаблица.Сумма КАК СуммаПродажи
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
		|		ПО (Рас_Комплектовка.Инкод = ПродажаЗапчастейТаблица.Партия)
		|ГДЕ
		|	НЕ Рас_Комплектовка.Инкод = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ПродажаЗапчастейТаблица.СтатусТовара
		|	И НЕ ПродажаЗапчастейТаблица.Отменено
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка,
		|	Рас_Комплектовка.Дата,
		|	Рас_Комплектовка.Инкод,
		|	Рас_Комплектовка.Номенклатура,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена,
		|	ЗаказНарядТовары.Ссылка.Ссылка,
		|	ЗаказНарядТовары.Ссылка.Дата,
		|	ЗаказНарядТовары.Цена
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
		|		ПО (Рас_Комплектовка.Инкод = ЗаказНарядТовары.Партия)
		|ГДЕ
		|	НЕ ЗаказНарядТовары.Партия = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ЗаказНарядТовары.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказНаряда.Выполнен)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаВосстановления УБЫВ";

	Иначе
		
		ПроданныеДетали.ТекстЗапроса = "ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка КАК ЗаказНарядНаВосстановление,
		|	Рас_Комплектовка.Дата КАК ДатаВосстановления,
		|	Рас_Комплектовка.Инкод КАК Инкод,
		|	Рас_Комплектовка.Номенклатура КАК Товар,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена КАК РекомендованаяЦена,
		|	ПродажаЗапчастейТаблица.Ссылка.Ссылка КАК Продажа,
		|	ПродажаЗапчастейТаблица.Ссылка.Дата КАК ДатаПродажи,
		|	ПродажаЗапчастейТаблица.Сумма КАК СуммаПродажи
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
		|		ПО (Рас_Комплектовка.Инкод = ПродажаЗапчастейТаблица.Партия)
		|ГДЕ
		|	НЕ Рас_Комплектовка.Инкод = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ПродажаЗапчастейТаблица.СтатусТовара
		|	И НЕ ПродажаЗапчастейТаблица.Отменено
		|	И Рас_Комплектовка.Дата МЕЖДУ &ДатаНачалаВос И &ДатаОкончанияВос
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка,
		|	Рас_Комплектовка.Дата,
		|	Рас_Комплектовка.Инкод,
		|	Рас_Комплектовка.Номенклатура,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена,
		|	ЗаказНарядТовары.Ссылка.Ссылка,
		|	ЗаказНарядТовары.Ссылка.Дата,
		|	ЗаказНарядТовары.Цена
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
		|		ПО (Рас_Комплектовка.Инкод = ЗаказНарядТовары.Партия)
		|ГДЕ
		|	НЕ ЗаказНарядТовары.Партия = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ЗаказНарядТовары.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказНаряда.Выполнен)
		|	И Рас_Комплектовка.Дата МЕЖДУ &ДатаНачалаВос И &ДатаОкончанияВос
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаВосстановления УБЫВ";
		
		ПроданныеДетали.Параметры.УстановитьЗначениеПараметра("ДатаНачалаВос", ПериодВосстановление.ДатаНачала);
		ПроданныеДетали.Параметры.УстановитьЗначениеПараметра("ДатаОкончанияВос", ПериодВосстановление.ДатаОкончания);
	КонецЕсли;

	ЗаполнитьПодвалПроданныеДетали();

	Элементы.Список.Обновить();
	///-ТатарМА 30.10.1024
	
КонецПроцедуры

&НаСервере
Процедура ПериодПродажиПриИзмененииНаСервере()
	
	///+ТатарМА 30.10.2024
	Если ПериодПродажи.ДатаНачала = '00010101' Тогда

		ПроданныеДетали.ТекстЗапроса = "ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка КАК ЗаказНарядНаВосстановление,
		|	Рас_Комплектовка.Дата КАК ДатаВосстановления,
		|	Рас_Комплектовка.Инкод КАК Инкод,
		|	Рас_Комплектовка.Номенклатура КАК Товар,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена КАК РекомендованаяЦена,
		|	ПродажаЗапчастейТаблица.Ссылка.Ссылка КАК Продажа,
		|	ПродажаЗапчастейТаблица.Ссылка.Дата КАК ДатаПродажи,
		|	ПродажаЗапчастейТаблица.Сумма КАК СуммаПродажи
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
		|		ПО (Рас_Комплектовка.Инкод = ПродажаЗапчастейТаблица.Партия)
		|ГДЕ
		|	НЕ Рас_Комплектовка.Инкод = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ПродажаЗапчастейТаблица.СтатусТовара
		|	И НЕ ПродажаЗапчастейТаблица.Отменено
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка,
		|	Рас_Комплектовка.Дата,
		|	Рас_Комплектовка.Инкод,
		|	Рас_Комплектовка.Номенклатура,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена,
		|	ЗаказНарядТовары.Ссылка.Ссылка,
		|	ЗаказНарядТовары.Ссылка.Дата,
		|	ЗаказНарядТовары.Цена
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
		|		ПО (Рас_Комплектовка.Инкод = ЗаказНарядТовары.Партия)
		|ГДЕ
		|	НЕ ЗаказНарядТовары.Партия = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ЗаказНарядТовары.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказНаряда.Выполнен)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаВосстановления УБЫВ";

	Иначе
		ПроданныеДетали.ТекстЗапроса = "ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка КАК ЗаказНарядНаВосстановление,
		|	Рас_Комплектовка.Дата КАК ДатаВосстановления,
		|	Рас_Комплектовка.Инкод КАК Инкод,
		|	Рас_Комплектовка.Номенклатура КАК Товар,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена КАК РекомендованаяЦена,
		|	ПродажаЗапчастейТаблица.Ссылка.Ссылка КАК Продажа,
		|	ПродажаЗапчастейТаблица.Ссылка.Дата КАК ДатаПродажи,
		|	ПродажаЗапчастейТаблица.Сумма КАК СуммаПродажи
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
		|		ПО (Рас_Комплектовка.Инкод = ПродажаЗапчастейТаблица.Партия)
		|ГДЕ
		|	НЕ Рас_Комплектовка.Инкод = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ПродажаЗапчастейТаблица.СтатусТовара
		|	И НЕ ПродажаЗапчастейТаблица.Отменено
		|	И ПродажаЗапчастейТаблица.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Рас_Комплектовка.Ссылка,
		|	Рас_Комплектовка.Дата,
		|	Рас_Комплектовка.Инкод,
		|	Рас_Комплектовка.Номенклатура,
		|	Рас_Комплектовка.Номенклатура.РекомендованаяЦена,
		|	ЗаказНарядТовары.Ссылка.Ссылка,
		|	ЗаказНарядТовары.Ссылка.Дата,
		|	ЗаказНарядТовары.Цена
		|ИЗ
		|	Документ.Рас_Комплектовка КАК Рас_Комплектовка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
		|		ПО (Рас_Комплектовка.Инкод = ЗаказНарядТовары.Партия)
		|ГДЕ
		|	НЕ ЗаказНарядТовары.Партия = ЗНАЧЕНИЕ(Справочник.ИндКод.ПустаяСсылка)
		|	И ЗаказНарядТовары.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказНаряда.Выполнен)
		|	И ЗаказНарядТовары.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаВосстановления УБЫВ";
		
		ПроданныеДетали.Параметры.УстановитьЗначениеПараметра("ДатаНачала", ПериодПродажи.ДатаНачала);
		ПроданныеДетали.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", ПериодПродажи.ДатаОкончания);
	КонецЕсли;

	ЗаполнитьПодвалПроданныеДетали();

	Элементы.Список.Обновить();
	///-ТатарМА 30.10.2024
	
	
	
КонецПроцедуры



&НаКлиенте
Процедура СписокПриАктивизацииСтроки1(Элемент)

КонецПроцедуры





&НаКлиенте
Процедура РаботыПоПроданнымДеталямВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	///+ГомзМА 15.08.2023
	ТекСтрока = Элементы.РаботыПоПроданнымДеталям.ТекущиеДанные;
	Если Поле = Элементы.РаботыПоПроданнымДеталямДокумент Тогда
		
		СсылкаДляОткрытия    = ТекСтрока.Документ;
		ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
		
		ФормаДокумента 		= ПолучитьФорму("Документ.Рас_Комплектовка.ФормаОбъекта", ПараметрыФормы);
		ФормаДокумента.Открыть();
	КонецЕсли;
	///+ГомзМА 15.08.2023
	
КонецПроцедуры

Процедура ЗаполнитьПодвалПроданныеДетали()
	
	///+ТатарМА 19.09.2024
	Схема = Элементы.ПроданныеДетали.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.ПроданныеДетали.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.ПроданныеДеталиРекомендованаяЦена.ГоризонтальноеПоложениеВПодвале 	= ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.ПроданныеДеталиСуммаПродажи.ГоризонтальноеПоложениеВПодвале      	= ГоризонтальноеПоложениеЭлемента.Право;
	
	ЭтотОбъект.ЭтаФорма.Элементы.ПроданныеДеталиРекомендованаяЦена.ТекстПодвала = Формат(Результат.Итог("РекомендованаяЦена"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.ПроданныеДеталиСуммаПродажи.ТекстПодвала      	= Формат(Результат.Итог("СуммаПродажи"),"ЧДЦ=0; ЧН=-"); 
	///-ТатарМА 19.09.2024
	
КонецПроцедуры

Процедура ЗаполнитьПодвалВостановленныеДетали()
	/// Комлев АА +++ 19/12/24 +++++
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип(
		"ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	ЭтотОбъект.ЭтаФорма.Элементы.РекомендованнаяЦена.ГоризонтальноеПоложениеВПодвале 	= ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.РекомендованнаяЦена.ТекстПодвала = Формат(Результат.Итог("РекомендованнаяЦена"),"ЧДЦ=0; ЧН=-");
		/// Комлев АА  19/12/24----- 
КонецПроцедуры