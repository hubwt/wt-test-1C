
&НаКлиенте
Процедура МашинаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	УстановитьАтрибуты();
КонецПроцедуры

&НаСервере
Процедура УстановитьАтрибуты()
	Реквизит1.Параметры.УстановитьЗначениеПараметра("машина",Машина.Ссылка);
	Реквизит1.Параметры.УстановитьЗначениеПараметра("категория",Категория.Ссылка);
КонецПроцедуры


&НаКлиенте
Процедура КатегорияПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	УстановитьАтрибуты();
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	Машина = Справочники.Машины.НайтиПоКоду("000000001"); 
	Категория = Справочники.Категории.НайтиПоКоду("000000001");
	УстановитьАтрибуты();
КонецПроцедуры

&НаСервере
Функция ПолучитьМакет(название)
	Возврат  Отчеты.ПродажиСМашиныПоКатегориям.ПолучитьМакет(название);
КонецФункции

&НаСервере
Функция Категории()
	запрос = Новый Запрос;
	запрос.Текст = "ВЫБРАТЬ
	               |	Категории.Ссылка,
	               |	Категории.ВерсияДанных,
	               |	Категории.ПометкаУдаления,
	               |	Категории.Предопределенный,
	               |	Категории.Родитель,
	               |	Категории.Код,
	               |	Категории.Наименование
	               |ИЗ
	               |	Справочник.Категории КАК Категории";
	Возврат запрос.Выполнить().Выгрузить();
КонецФункции	

&НаСервере
Функция запчасти1(категория11)
	запрос = Новый Запрос;
	запрос.Текст = "ВЫБРАТЬ
	               |	ПродажаЗапчастейТаблица.Ссылка,
	               |	ПродажаЗапчастейТаблица.НомерСтроки,
	               |	ПродажаЗапчастейТаблица.Товар,
	               |	ПродажаЗапчастейТаблица.Количество,
	               |	ПродажаЗапчастейТаблица.Цена,
	               |	ПродажаЗапчастейТаблица.Скидка,
	               |	ПродажаЗапчастейТаблица.машина,
	               |	ПродажаЗапчастейТаблица.цена1,
	               |	ПродажаЗапчастейТаблица.Комментарий,
	               |	ПродажаЗапчастейТаблица.Сумма
	               |ИЗ
	               |	Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
	               |ГДЕ
	               |	ПродажаЗапчастейТаблица.машина = &машина
	               |	И ПродажаЗапчастейТаблица.Товар.Категория = &категория";
	запрос.УстановитьПараметр("машина",Машина.Ссылка);
	запрос.УстановитьПараметр("категория",категория11);
	Возврат запрос.Выполнить().Выгрузить();
КонецФункции

&НаКлиенте
Процедура РаспечататьРезультаты(Команда)
	ТабДокумент = ПечатьСервер();
	ТабДокумент.Показать();

КонецПроцедуры

&НаСервере
Функция ПечатьСервер()

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет       =   ПолучитьМакет("Макет");
	ОбластьМакета = Макет.ПолучитьОбласть("заголовок");
	ОбластьМакета.Параметры.машина=Машина;
	ТабДокумент.Вывести(ОбластьМакета);

	маш =  Макет.ПолучитьОбласть("табл");
	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
	сум = Макет.ПолучитьОбласть("сумма");
	общ = Макет.ПолучитьОбласть("общ");
	НомерСтроки = 0;
	
	Итого = 0;
	Скидка = 0;
	категории1 = Категории();
	Для Каждого категория1 Из категории1 Цикл
        маш.Параметры.категория = категория1.Наименование;
		ТабДокумент.Вывести(маш);
		НомерСтроки = 0;
		итогоМаш = 0;
		скидкаМаш = 0;
		запчасти = запчасти1(категория1.ссылка);
		Для Каждого СтрокаТабличнойЧасти Из запчасти Цикл
				НомерСтроки = НомерСтроки + 1;
				ОбластьСтроки.Параметры.н = НомерСтроки;
				ОбластьСтроки.Параметры.код = СтрокаТабличнойЧасти.Товар.Код; 
				ОбластьСтроки.Параметры.артикул = СтрокаТабличнойЧасти.Товар.Артикул;
		//ОбластьСтроки.Параметры.нпроизв = СтрокаТабличнойЧасти.Товар.НомерПроизводителя;
				
				ОбластьСтроки.Параметры.наименование = СтрокаТабличнойЧасти.Товар.Наименование;
				Скидка1 = 0;
				Если(СтрДлина(СтрокаТабличнойЧасти.Комментарий)>2) Тогда
					ОбластьСтроки.Параметры.наименование = ОбластьСтроки.Параметры.наименование + ", " + СтрокаТабличнойЧасти.Комментарий;
				КонецЕсли;
				
				ОбластьСтроки.Параметры.цена = СтрокаТабличнойЧасти.Цена;
				ОбластьСтроки.Параметры.колво = СтрокаТабличнойЧасти.Количество;
				итогоМаш = итогоМаш + СтрокаТабличнойЧасти.Цена*СтрокаТабличнойЧасти.Количество;
				Итого = Итого + СтрокаТабличнойЧасти.Цена*СтрокаТабличнойЧасти.Количество;
				Если СтрокаТабличнойЧасти.Скидка <> Null И СтрокаТабличнойЧасти.Скидка > 0 Тогда
					Скидка = Скидка + СтрокаТабличнойЧасти.Скидка;
					скидкаМаш = скидкаМаш + СтрокаТабличнойЧасти.Скидка;
					Скидка1 = СтрокаТабличнойЧасти.Скидка;
				КонецЕсли;
				ОбластьСтроки.Параметры.сумма = СтрокаТабличнойЧасти.Цена*СтрокаТабличнойЧасти.Количество - Скидка1;
				//ОбластьСтроки.Параметры.скидка = Скидка1; 
				
				ТабДокумент.Вывести(ОбластьСтроки);
		КонецЦикла;
		сум.Параметры.сумма = итогоМаш - скидкаМаш;
		ТабДокумент.Вывести(сум);
	КонецЦикла;

	общ.Параметры.сумма = Итого - Скидка;
	ТабДокумент.Вывести(общ);

	
	Возврат ТабДокумент;

КонецФункции // ПечатьСервер()


