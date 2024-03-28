
Перем мПустойЦвет;
Перем мЦветШапки;
Перем мЦветОсобогоЗначения;
Перем мШиринаКолонокПоУмолчанию;
Перем мДляСсылокВыводитьГУИД;
Перем мМакет;
Перем мТипВсеСсылки;
Перем мТипЧисло;
Перем мТипСтрока;
Перем мТипДата;
Перем мТипБулево;
Перем мТипРезультатЗапроса;
Перем мТипОписаниеТипов;

Процедура ПолучитьДеревоИзФайла(АдресХранилища, ДеревоЗапросов, ШиринаКолонокПоУмолчанию) Экспорт
	мШиринаКолонокПоУмолчанию = ШиринаКолонокПоУмолчанию;
	ДеревоИзФайла = ПолучитьДеревоИзХранилища(АдресХранилища);
	Элементы = ДеревоЗапросов.ПолучитьЭлементы();
	Элементы.Очистить();
	ИмеетсяШиринаКолонок = (ДеревоИзФайла.Колонки.Найти("ШиринаКолонок") <> Неопределено);
	ЗаполнитьУровеньПроксиДерева(Элементы, ДеревоИзФайла.Строки, ИмеетсяШиринаКолонок);
	УдалитьИзВременногоХранилища(АдресХранилища);
КонецПроцедуры

Функция ВыполнитьЗапрос(ТекстЗапроса, ПараметрыЗапроса, СпособВыгрузки, СоставРезультатов, ДляСсылокВыводитьГУИД) Экспорт
	мДляСсылокВыводитьГУИД = ДляСсылокВыводитьГУИД;
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	ИмяПараметраТип = "";
	Для каждого ОписаниеПараметра из ПараметрыЗапроса Цикл
		Значение = ОписаниеПараметра.ЗначениеПараметра;
		Если ТипЗнч(Значение) = мТипОписаниеТипов Тогда
			ЗаданныеТипы = Значение.Типы();
			Если ЗаданныеТипы.Количество() > 0 Тогда
				Запрос.УстановитьПараметр(ОписаниеПараметра.ИмяПараметра, ЗаданныеТипы[0]);	
			Иначе
				ИмяПараметраТип = ОписаниеПараметра.ИмяПараметра;
				Прервать;
			КонецЕсли;
		Иначе
			Запрос.УстановитьПараметр(ОписаниеПараметра.ИмяПараметра, Значение);
		КонецЕсли;
	КонецЦикла;
	Если НЕ ПустаяСтрока(ИмяПараметраТип) Тогда
		Возврат "Для параметра """ + ИмяПараметраТип + """ не задано значение типа";
	КонецЕсли;
	Попытка
		МассивРезультатов = Запрос.ВыполнитьПакет();
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки;
	Если ДляСсылокВыводитьГУИД Тогда
		мТипВсеСсылки = ПолучитьВсеСсылки();
	КонецЕсли;
	Если СоставРезультатов = 1 Тогда // только запросы
		Моксель = ПолучитьРезультатыЗапросов(МассивРезультатов, СпособВыгрузки);
	ИначеЕсли СоставРезультатов = 2 Тогда // запросы и временные таблицы
		Моксель = ПолучитьРезультатыЗапросов(МассивРезультатов, СпособВыгрузки);
		Моксель.Вывести(ПолучитьРезультатыВременыхТаблиц(Запрос));
	ИначеЕсли СоставРезультатов = 3 Тогда // только временные таблицы
		Моксель = ПолучитьРезультатыВременыхТаблиц(Запрос);
	КонецЕсли;
	Запрос.МенеджерВременныхТаблиц.Закрыть();
	Возврат Моксель;
КонецФункции

Функция ПреобразоватьДерево(ДеревоЗапросов) Экспорт
	Путь = ГенерироватьПуть();
	ЗначениеВФайл(Путь, ПолучитьДеревоЗначенийИзПрокси(ДеревоЗапросов));
	АдресХранилища = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Путь));
	УдалитьФайлы(Путь);
	Возврат АдресХранилища;
КонецФункции

Функция ЗаполнитьПараметрыЗапроса(ДеревоЗапросов, ИдентификаторТекущихДанных) Экспорт
	ТекущиеДанные = ДеревоЗапросов.НайтиПоИдентификатору(ИдентификаторТекущихДанных);
	СтруктураПараметров = Новый Структура();
	ТекстЗапроса = ТекущиеДанные.ТекстЗапроса;
	Если  НЕ ПустаяСтрока(ТекстЗапроса) Тогда
		Запрос = Новый Запрос(ТекстЗапроса);
		Попытка
			НайденныеПараметры = Запрос.НайтиПараметры();
		Исключение
			Возврат ОписаниеОшибки();
		КонецПопытки;
		Для каждого ПараметрЗапроса из НайденныеПараметры Цикл
			СтруктураПараметров.Вставить(ПараметрЗапроса.Имя, ПараметрЗапроса.ТипЗначения);
		КонецЦикла;
	КонецЕсли;
	Возврат СтруктураПараметров;
КонецФункции

Функция ПолучитьВсеСсылки() Экспорт
	Имена = 
	"Справочники
	|Документы
	|Перечисления
	|ПланыВидовХарактеристик
	|ПланыСчетов
	|ПланыВидовРасчета
	|ПланыОбмена
	|БизнесПроцессы
	|Задачи";
	ЧислоИмен = СтрЧислоСтрок(Имена);
	ВсеСсылки = Новый ОписаниеТипов(Новый Массив());
	Для Номер = 1 по ЧислоИмен Цикл
		ВсеСсылки = Новый ОписаниеТипов(ВсеСсылки, Вычислить(СтрПолучитьСтроку(Имена, Номер)).ТипВсеСсылки().Типы());
	КонецЦикла;
	ВсеСсылки = Новый ОписаниеТипов(ВсеСсылки, БизнесПроцессы.ТипВсеСсылкиТочекМаршрутаБизнесПроцессов().Типы());
	Возврат ВсеСсылки;
КонецФункции

// -----------------------------

Функция ПолучитьДеревоИзХранилища(АдресХранилища)
	Путь = ГенерироватьПуть();
	ПолучитьИзВременногоХранилища(АдресХранилища).Записать(Путь);
	Дерево = ЗначениеИзФайла(Путь);
	УдалитьФайлы(Путь);
	Возврат Дерево;
КонецФункции

Функция ГенерироватьПуть()
	Возврат КаталогВременныхФайлов() + "QLst-" + Строка(Новый УникальныйИдентификатор()) + ".tmp";
КонецФункции

Функция ПолучитьРезультатыЗапросов(МассивРезультатов, СпособВыгрузки)
	Если МассивРезультатов.Количество() > 1 Тогда
		Моксель = ЗаполнитьМоксельПакета(МассивРезультатов, СпособВыгрузки);
	Иначе
		Моксель = ЗаполнитьМоксель(МассивРезультатов[0], СпособВыгрузки);
	КонецЕсли;
	Возврат Моксель;
КонецФункции

Функция ПолучитьРезультатыВременыхТаблиц(Запрос)
	Моксель = Новый ТабличныйДокумент();
	ОбластьИмяТаблицы = мМакет.ПолучитьОбласть("НазваниеВременнойТаблицы");
	ОбластьСообщение = мМакет.ПолучитьОбласть("ОшибкаВыполнения");
	Моксель.Вывести(мМакет.ПолучитьОбласть("ЗаголовокВременныхТаблиц"));
	МассивВременыхТаблиц = НайтиВременныеТаблицы(Запрос.Текст);
	Если МассивВременыхТаблиц.Количество() > 0 Тогда
		Для Каждого ИмяТаблицы из МассивВременыхТаблиц Цикл
			ОбластьИмяТаблицы.Параметры.ИмяТаблицы = ИмяТаблицы;
			Моксель.Вывести(ОбластьИмяТаблицы);
			Запрос.Текст = "ВЫБРАТЬ * ИЗ " + ИмяТаблицы;
			Попытка
				Результат = Запрос.Выполнить();
			Исключение
				ОбластьСообщение.Параметры.ТекстОшибки = ИнформацияОбОшибке().Описание;
				Моксель.Вывести(ОбластьСообщение);
				Продолжить;
			КонецПопытки;
			Моксель.НачатьГруппуСтрок(ИмяТаблицы, Ложь);
			Моксель.Вывести(ЗаполнитьМоксель(Результат, 1));
			Моксель.ЗакончитьГруппуСтрок();
		КонецЦикла;
	Иначе
		ОбластьСообщение.Параметры.ТекстОшибки = "(нет временных таблиц)";
		Моксель.Вывести(ОбластьСообщение);
	КонецЕсли;
	Возврат Моксель;
КонецФункции

Функция ЗаполнитьМоксельПакета(МассивРезультатов, СпособВыгрузки)
	СловоЗапрос = "Запрос";
	Моксель = Новый ТабличныйДокумент();
	ЗаголовокЗапроса = мМакет.ПолучитьОбласть("ЗаголовокЗапроса");
	ЗапросНаУдаление = мМакет.ПолучитьОбласть("ЗапросНаУдаление");
	ВерхняяГраница = МассивРезультатов.Количество() - 1;
	Для Индекс = 0 по ВерхняяГраница Цикл
		Результат = МассивРезультатов[Индекс];
		НомерЗапроса = Индекс + 1;
		ЗаголовокЗапроса.Параметры.НомерЗапроса = НомерЗапроса;
		Если Результат = Неопределено Тогда
			Моксель.Вывести(ЗаголовокЗапроса);
			Моксель.Вывести(ЗапросНаУдаление);
		Иначе
			Моксель.Вывести(ЗаголовокЗапроса);
			Моксель.НачатьГруппуСтрок(СловоЗапрос + Строка(НомерЗапроса), Ложь);
			Моксель.Вывести(ЗаполнитьМоксель(Результат, СпособВыгрузки));
			Моксель.ЗакончитьГруппуСтрок();
		КонецЕсли;
	КонецЦикла;
	Возврат Моксель;
КонецФункции

Функция ЗаполнитьМоксель(Результат, СпособВыгрузки)
	КолонкиРезультата = Результат.Колонки;
	КоличествоКолонок = КолонкиРезультата.Количество();
	Моксель           = Новый ТабличныйДокумент(); 
	Заголовок         = Новый ТабличныйДокумент();
	Ячейка            = мМакет.ПолучитьОбласть("ЯчейкаРезультата");
	Для каждого Колонка из КолонкиРезультата Цикл
		Ячейка.Параметры.Содержание = Колонка.Имя;
		Заголовок.Присоединить(Ячейка);
	КонецЦикла;
	ОбластьЗаголовка = Заголовок.Область(1, 1, 1, КоличествоКолонок);
	ОбластьЗаголовка.Шрифт = Новый Шрифт(ОбластьЗаголовка.Шрифт, , , Истина);
	ОбластьЗаголовка.ЦветФона = мЦветШапки;
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 3);
	ОбластьЗаголовка.Обвести(Линия, Линия, Линия, Линия);
	Моксель.Вывести(Заголовок);
	Если СпособВыгрузки = 1 Тогда // список
		Моксель.Вывести(ВывестиПлоско(Результат.Выбрать(ОбходРезультатаЗапроса.Прямой), Ячейка, КоличествоКолонок - 1));
	ИначеЕсли СпособВыгрузки = 2 Тогда // дерево
		ВыгрузкаВДерево = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Таблица = Новый ТабличныйДокумент();
		Таблица.НачатьАвтогруппировкуСтрок();
		ВывестиИерархически(ВыгрузкаВДерево.Строки, Ячейка, КоличествоКолонок - 1, Таблица);
		Таблица.ЗакончитьАвтогруппировкуСтрок();
		Таблица.Область(, 1, ,1).АвтоОтступ = 2;
		Моксель.Вывести(Таблица);
	КонецЕсли;
	Моксель.ФиксацияСверху = 1;
	Возврат Моксель;
КонецФункции

Процедура ЗаполнитьУровеньПроксиДерева(КоллекцияПриемник, КоллекцияИсточник, ИмеетсяШиринаКолонок)
	Для каждого СтрокаИсточник из КоллекцияИсточник Цикл
		НоваяСтрока = КоллекцияПриемник.Добавить();
		НоваяСтрока.Запрос         = СтрокаИсточник.Запрос;
		НоваяСтрока.ТекстЗапроса   = СтрокаИсточник.ТекстЗапроса;
		НоваяСтрока.СпособВыгрузки = СтрокаИсточник.СпособВыгрузки;
		НоваяСтрока.ШиринаКолонок  = ?(ИмеетсяШиринаКолонок, СтрокаИсточник.ШиринаКолонок, мШиринаКолонокПоУмолчанию);
		ЗаполнитьПараметры(НоваяСтрока.ПараметрыЗапроса, СтрокаИсточник.ПараметрыЗапроса);
		ЗаполнитьУровеньПроксиДерева(НоваяСтрока.ПолучитьЭлементы(), СтрокаИсточник.Строки, ИмеетсяШиринаКолонок);
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьПараметры(ТаблицаПриемник, ТаблицаИсточник)
	Для каждого СтрокаИсточник из ТаблицаИсточник Цикл
		НоваяСтрока = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник);
	КонецЦикла;
КонецПроцедуры

Функция ВывестиПлоско(Выборка, Ячейка, ГраничныйИндекс)
	Таблица = Новый ТабличныйДокумент();
	Пока Выборка.Следующий() Цикл
		Запись = Новый ТабличныйДокумент();
		Для Индекс = 0 по ГраничныйИндекс Цикл
			ФорматироватьЯчейку(Ячейка, Выборка[Индекс]);
			Запись.Присоединить(Ячейка);
		КонецЦикла;
		Таблица.Вывести(Запись);
	КонецЦикла;
	Возврат Таблица;
КонецФункции

Функция ПолучитьДеревоЗначенийИзПрокси(ДеревоЗапросов)
	ДеревоИзПрокси    = Новый ДеревоЗначений();
	ОписаниеТипСтрока = Новый ОписаниеТипов("Строка");
	ОписаниеТипЧисло  = Новый ОписаниеТипов("Число");
	ДеревоИзПрокси.Колонки.Добавить("Запрос", ОписаниеТипСтрока);
	ДеревоИзПрокси.Колонки.Добавить("ТекстЗапроса", ОписаниеТипСтрока);
	ДеревоИзПрокси.Колонки.Добавить("ПараметрыЗапроса", Новый ОписаниеТипов("ТаблицаЗначений"));
	ДеревоИзПрокси.Колонки.Добавить("СпособВыгрузки", ОписаниеТипЧисло);
	ДеревоИзПрокси.Колонки.Добавить("ШиринаКолонок", ОписаниеТипЧисло);
	ЗаполнитьУровеньДереваЗначений(ДеревоИзПрокси.Строки, ДеревоЗапросов.ПолучитьЭлементы());
	Возврат ДеревоИзПрокси;
КонецФункции

Процедура ЗаполнитьУровеньДереваЗначений(КоллекцияПриемник, КоллекцияИсточник)
	Для каждого СтрокаИсточник из КоллекцияИсточник Цикл
		НоваяСтрока = КоллекцияПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник, ,"ПараметрыЗапроса");
		ТаблицаПараметров = НоваяСтрока.ПараметрыЗапроса;
		ТаблицаПараметров.Колонки.Добавить("ИмяПараметра", Новый ОписаниеТипов("Строка"));
		ТаблицаПараметров.Колонки.Добавить("ЗначениеПараметра");
		ТаблицаПараметров.Колонки.Добавить("ЭтоВыражение", Новый ОписаниеТипов("Булево"));
		ЗаполнитьПараметры(ТаблицаПараметров, СтрокаИсточник.ПараметрыЗапроса);
		ЗаполнитьУровеньДереваЗначений(НоваяСтрока.Строки, СтрокаИсточник.ПолучитьЭлементы());
	КонецЦикла;
КонецПроцедуры

Процедура ВывестиИерархически(ТекущийУровеньДерева, Ячейка, ГраничныйИндекс, Таблица)
	Для каждого ТекущаяСтрока из ТекущийУровеньДерева Цикл
		Запись = Новый ТабличныйДокумент();
		Для Индекс = 0 по ГраничныйИндекс Цикл
			ФорматироватьЯчейку(Ячейка, ТекущаяСтрока[Индекс]);
			Запись.Присоединить(Ячейка);
		КонецЦикла;
		Таблица.Вывести(Запись, ТекущаяСтрока.Уровень(), ,Ложь);
		Запись = Неопределено;
		ВывестиИерархически(ТекущаяСтрока.Строки, Ячейка, ГраничныйИндекс, Таблица);
	КонецЦикла;
КонецПроцедуры

Процедура ФорматироватьЯчейку(Ячейка, Значение)
	Область = Ячейка.Область();
	Область.ЦветТекста = мПустойЦвет;
	Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Ячейка;
	Если Значение = Null Тогда
		Ячейка.Параметры.Содержание      = "NULL";
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста               = мЦветОсобогоЗначения;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипЧисло Тогда 
		Ячейка.Параметры.Содержание      = ?(Значение = 0, "0", Значение);
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Право;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипСтрока Тогда
		Ячейка.Параметры.Содержание      = Значение;
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Лево;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипБулево Тогда
		Ячейка.Параметры.Содержание      = Значение;
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Центр;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
	ИначеЕсли ТипЗнч(Значение) = мТипРезультатЗапроса Тогда
		Ячейка.Параметры.Содержание     = "<РЕЗУЛЬТАТ ЗАПРОСА>";
		Ячейка.Параметры.Расшифровка    = ЗаполнитьМоксель(Значение, 1);
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста              = мЦветОсобогоЗначения;
	ИначеЕсли мДляСсылокВыводитьГУИД Тогда
		Если мТипВсеСсылки.СодержитТип(ТипЗнч(Значение)) Тогда
			Ячейка.Параметры.Содержание     = Строка(Значение.УникальныйИдентификатор());
			Ячейка.Параметры.Расшифровка    = Значение;
			Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
		Иначе
			Ячейка.Параметры.Содержание     = Строка(Значение);
			Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
		КонецЕсли;
	Иначе
		Ячейка.Параметры.Содержание     = Строка(Значение);
		Ячейка.Параметры.Расшифровка    = Значение;
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	КонецЕсли;
КонецПроцедуры

Функция НайтиВременныеТаблицы(ТекстЗапроса)
	МассивВременыхТаблиц = Новый Массив();
	Текст = ВРег(ТекстЗапроса);
	ПОМЕСТИТЬ = "ПОМЕСТИТЬ";
	ДлинаПоместить = СтрДлина(ПОМЕСТИТЬ);
	Искать = Истина;
	Пока Искать Цикл
		ПозицияПоместить = Найти(Текст, ПОМЕСТИТЬ);
		Если ПозицияПоместить > 0 Тогда
			Текст = Сред(Текст, ПозицияПоместить + ДлинаПоместить);
			ДлинаТекста = СтрДлина(Текст);
			Для Позиция = 1 по ДлинаТекста Цикл
				Если НЕ ПустаяСтрока(Сред(Текст, Позиция, 1)) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Текст = Сред(Текст, Позиция);
			ИмяВременнойТаблицы = "";
			ДлинаТекста = СтрДлина(Текст);
			Для Позиция = 1 по ДлинаТекста Цикл
				ОчереднойСимвол = Сред(Текст, Позиция, 1);
				Если ПустаяСтрока(ОчереднойСимвол) Тогда
					Прервать;
				Иначе
					ИмяВременнойТаблицы = ИмяВременнойТаблицы + ОчереднойСимвол;
				КонецЕсли;
			КонецЦикла;
			МассивВременыхТаблиц.Добавить(ТРег(ИмяВременнойТаблицы));
		Иначе
			Искать = Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат МассивВременыхТаблиц;
КонецФункции
// -----------------------------
мПустойЦвет          = Новый Цвет();
мЦветШапки           = WebЦвета.СеребристоСерый; 
мЦветОсобогоЗначения = WebЦвета.ЦианНейтральный;
мМакет               = ПолучитьМакет("МакетРезультата");
мТипЧисло            = Тип("Число");
мТипСтрока           = Тип("Строка");
мТипДата             = Тип("Дата");
мТипБулево           = Тип("Булево");
мТипРезультатЗапроса = Тип("РезультатЗапроса");
мТипОписаниеТипов    = Тип("ОписаниеТипов");
