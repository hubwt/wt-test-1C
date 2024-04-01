#Область ПрограммныйИнтерфейс

// Добавляет в справочник валют валюты из классификатора.
//
// Параметры:
//   Коды - Массив - цифровые коды добавляемых валют.
//
// Возвращаемое значение:
//   Массив, СправочникСсылка.Валюты - ссылки созданных валют.
//
Функция ДобавитьВалютыПоКоду(Знач Коды) Экспорт
	
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено Тогда
		Результат = Обработки["ЗагрузкаКурсовВалют"].ДобавитьВалютыПоКоду(Коды);
	Иначе
		Результат = Новый Массив();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает курс валюты на дату.
//
// Параметры:
//   Валюта    - СправочникСсылка.Валюты - Валюта, для которой получается курс.
//   ДатаКурса - Дата - Дата, на которую получается курс.
//
// Возвращаемое значение: 
//   Структура - Параметры курса.
//       * Курс      - Число - Курс валюты на указанную дату.
//       * Кратность - Число - Кратность валюты на указанную дату.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка валюты.
//       * ДатаКурса - Дата - Дата получения курса.
//
Функция ПолучитьКурсВалюты(Валюта, ДатаКурса) Экспорт
	
	Результат = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта", Валюта));
	
	Результат.Вставить("Валюта",    Валюта);
	Результат.Вставить("ДатаКурса", ДатаКурса);
	
	Возврат Результат;
	
КонецФункции

// Формирует представление суммы прописью в указанной валюте.
//
// Параметры:
//   СуммаЧислом - Число - сумма, которую надо представить прописью.
//   Валюта - СправочникСсылка.Валюты - валюта, в которой нужно представить сумму.
//   ВыводитьСуммуБезКопеек - Булево - признак представления суммы без копеек.
//
// Возвращаемое значение:
//   Строка - сумма прописью.
//
Функция СформироватьСуммуПрописью(СуммаЧислом, Валюта, ВыводитьСуммуБезКопеек = Ложь) Экспорт
	
	Сумма             = ?(СуммаЧислом < 0, -СуммаЧислом, СуммаЧислом);
	ПараметрыПрописи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Валюта, "ПараметрыПрописи");
	
	Результат = ЧислоПрописью(Сумма, "Л=ru_RU;ДП=Ложь", ПараметрыПрописи);
	
	Если ВыводитьСуммуБезКопеек И Цел(Сумма) = Сумма Тогда
		Результат = Лев(Результат, СтрНайти(Результат, "0") - 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Пересчитывает сумму из одной валюты в другую.
//
// Параметры:
//  Сумма          - Число - сумма, которую необходимо пересчитать;
//  ИсходнаяВалюта - СправочникСсылка.Валюты - пересчитываемая валюта;
//  НоваяВалюта    - СправочникСсылка.Валюты - валюта, в которую необходимо пересчитать;
//  Дата           - Дата - дата курсов валют.
//
// Возвращаемое значение:
//  Число - пересчитанная сумма.
//
Функция ПересчитатьВВалюту(Сумма, ИсходнаяВалюта, НоваяВалюта, Дата) Экспорт
	
	Возврат РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(Сумма,
		ПолучитьКурсВалюты(ИсходнаяВалюта, Дата),
		ПолучитьКурсВалюты(НоваяВалюта, Дата));
		
КонецФункции

// Загружает курсы валют на текущую дату.
//
// Параметры:
//  ПараметрыЗагрузки - Структура - детали загрузки:
//   * НачалоПериода - Дата - начало периода загрузки;
//   * КонецПериода - Дата - конец периода загрузки;
//   * СписокВалют - ТаблицаЗначений - загружаемые валюты:
//     ** Валюта - СправочникСсылка.Валюты;
//     ** КодВалюты - Строка.
//  АдресРезультата - Строка - адрес во временном хранилище для помещения результатов загрузки.
//
Процедура ЗагрузитьАктуальныйКурс(ПараметрыЗагрузки = Неопределено, АдресРезультата = Неопределено) Экспорт
	
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено Тогда
		Обработки["ЗагрузкаКурсовВалют"].ЗагрузитьАктуальныйКурс(ПараметрыЗагрузки, АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") = Неопределено Тогда
		Возврат;
	КонецЕсли;

	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Если ОбщегоНазначения.РазделениеВключено() // В модели сервиса обновляется автоматически.
		Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто()
		Или Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.КурсыВалют)
		Или МодульТекущиеДелаСервер.ДелоОтключено("КлассификаторВалют") Тогда
		Возврат;
	КонецЕсли;
	
	КурсыАктуальны = КурсыАктуальны();
	
	// Процедура вызывается только при наличии подсистемы "Текущие дела", поэтому здесь
	// не делается проверка существования подсистемы.
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Справочники.Валюты.ПолноеИмя());
	
	Для Каждого Раздел Из Разделы Цикл
		
		ИдентификаторВалюты = "КлассификаторВалют" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИдентификаторВалюты;
		Дело.ЕстьДела       = Не КурсыАктуальны;
		Дело.Представление  = НСтр("ru = 'Курсы валют устарели'");
		Дело.Важное         = Истина;
		Дело.Форма          = "Обработка.ЗагрузкаКурсовВалют.Форма";
		Дело.ПараметрыФормы = Новый Структура("ОткрытиеИзСписка", Истина);
		Дело.Владелец       = Раздел;
		
	КонецЦикла;
	
КонецПроцедуры

// См. ЗагрузкаДанныхИзФайлаПереопределяемый.ПриОпределенииСправочниковДляЗагрузкиДанных.
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
	// Загрузка в классификатор валюты запрещена.
	СтрокаТаблицы = ЗагружаемыеСправочники.Найти(Метаданные.Справочники.Валюты.ПолноеИмя(), "ПолноеИмя");
	Если СтрокаТаблицы <> Неопределено Тогда 
		ЗагружаемыеСправочники.Удалить(СтрокаТаблицы);
	КонецЕсли;
	
КонецПроцедуры

// См. ГрупповоеИзменениеОбъектовПереопределяемый.ПриОпределенииОбъектовСРедактируемымиРеквизитами.
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	Объекты.Вставить(Метаданные.Справочники.Валюты.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Зависимости) Экспорт
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено Тогда
		Обработки["ЗагрузкаКурсовВалют"].ПриОпределенииНастроекРегламентныхЗаданий(Зависимости);
	КонецЕсли;
КонецПроцедуры

// См. ПользователиПереопределяемый.ПриОпределенииНазначенияРолей.
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	// СовместноДляПользователейИВнешнихПользователей.
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ЧтениеКурсовВалют.Имя);
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиентаПриЗапуске.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		КурсыОбновляютсяОтветственными = Ложь; // В модели сервиса обновляются автоматически.
	ИначеЕсли НЕ ПравоДоступа("Изменение", Метаданные.РегистрыСведений.КурсыВалют) Тогда
		КурсыОбновляютсяОтветственными = Ложь; // Пользователь не может обновлять курсы валют.
	Иначе
		КурсыОбновляютсяОтветственными = КурсыЗагружаютсяИзИнтернета(); // Есть валюты, для которых можно загружать курсы.
	КонецЕсли;
	
	ВключитьОповещение = Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела");
	РаботаСКурсамиВалютПереопределяемый.ПриОпределенииНеобходимостиПоказаПредупрежденияОбУстаревшихКурсахВалют(ВключитьОповещение);
	
	Параметры.Вставить("Валюты", Новый ФиксированнаяСтруктура("КурсыОбновляютсяОтветственными", (КурсыОбновляютсяОтветственными И ВключитьОповещение)));
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииИсключенийПоискаСсылок.
Процедура ПриДобавленииИсключенийПоискаСсылок(Массив) Экспорт
	
	Массив.Добавить(Метаданные.РегистрыСведений.КурсыВалют.ПолноеИмя());
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	ЗапросыРазрешений.Добавить(
		МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения()));
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.4.4";
	Обработчик.Процедура = "РаботаСКурсамиВалют.ОбновитьСведенияОВалюте937";
	Обработчик.РежимВыполнения = "Монопольно";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.3.10";
	Обработчик.Процедура = "РаботаСКурсамиВалют.ЗаполнитьСпособУстановкиКурсаВалют";
	Обработчик.РежимВыполнения = "Монопольно";
	
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено Тогда
		Обработки["ЗагрузкаКурсовВалют"].ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПреобразованиеСвязейВалют() Экспорт
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено Тогда
		Обработки["ЗагрузкаКурсовВалют"].ПреобразованиеСвязейВалют();
	КонецЕсли;
КонецПроцедуры

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки.
Процедура ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки(ДанныеПользователя) Экспорт
	
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено Тогда
		Обработки["ЗагрузкаКурсовВалют"].ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки(ДанныеПользователя);
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки.
Процедура ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки() Экспорт
	
	Если Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено Тогда
		Обработки["ЗагрузкаКурсовВалют"].ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает список разрешений для загрузки курсов валют с сайта 1С.
//
// Возвращаемое значение:
//  Массив.
//
Функция Разрешения()
	
	Разрешения = Новый Массив;
	ИмяОбработки = "ЗагрузкаКурсовВалют";
	Если Метаданные.Обработки.Найти(ИмяОбработки) <> Неопределено Тогда
		Обработки[ИмяОбработки].ДобавитьРазрешения(Разрешения);
	КонецЕсли;
	
	Возврат Разрешения;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Проверяет наличие установленного курса и кратности валюты на 1 января 1980 года.
// В случае отсутствия устанавливает курс и кратность равными единице.
//
// Параметры:
//  Валюта - ссылка на элемент справочника Валют.
//
Процедура ПроверитьКорректностьКурсаНа01_01_1980(Валюта) Экспорт
	
	ДатаКурса = Дата("19800101");
	СтруктураКурса = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта", Валюта));
	
	Если (СтруктураКурса.Курс = 0) Или (СтруктураКурса.Кратность = 0) Тогда
		НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Валюта.Установить(Валюта);
		НаборЗаписей.Отбор.Период.Установить(ДатаКурса);
		Запись = НаборЗаписей.Добавить();
		Запись.Валюта = Валюта;
		Запись.Период = ДатаКурса;
		Запись.Курс = 1;
		Запись.Кратность = 1;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив валют, курсы которых загружаются с сайта 1С.
//
Функция ЗагружаемыеВалюты() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
	|	И НЕ Валюты.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюты.НаименованиеПолное";

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает информацию о курсе валюты на основе ссылки на валюту.
// Данные возвращаются в виде структуры.
//
// Параметры:
// ВыбраннаяВалюта - Справочник.Валюты / Ссылка - ссылка на валюту, информацию
//                  о курсе которой необходимо получить.
//
// Возвращаемое значение:
// ДанныеКурса   - структура, содержащая информацию о последней доступной 
//                 записи курса.
//
Функция ЗаполнитьДанныеКурсаДляВалюты(ВыбраннаяВалюта) Экспорт
	
	ДанныеКурса = Новый Структура("ДатаКурса, Курс, Кратность");
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РегКурсы.Период, РегКурсы.Курс, РегКурсы.Кратность
	              | ИЗ РегистрСведений.КурсыВалют.СрезПоследних(&ОкончаниеПериодаЗагрузки, Валюта = &ВыбраннаяВалюта) КАК РегКурсы";
	Запрос.УстановитьПараметр("ВыбраннаяВалюта", ВыбраннаяВалюта);
	Запрос.УстановитьПараметр("ОкончаниеПериодаЗагрузки", ТекущаяДатаСеанса());
	
	ВыборкаКурс = Запрос.Выполнить().Выбрать();
	ВыборкаКурс.Следующий();
	
	ДанныеКурса.ДатаКурса = ВыборкаКурс.Период;
	ДанныеКурса.Курс      = ВыборкаКурс.Курс;
	ДанныеКурса.Кратность = ВыборкаКурс.Кратность;
	
	Возврат ДанныеКурса;
	
КонецФункции

// Возвращает таблицу значений - валюты, зависящие от переданной
// в качестве параметра.
// Возвращаемое значение
// ТаблицаЗначений
// колонка "Ссылка" - СправочникСсылка.Валюты
// колонка "Наценка" - число.
//
Функция СписокЗависимыхВалют(ВалютаБазовая, ДополнительныеСвойства = Неопределено) Экспорт
	
	Кэшировать = (ТипЗнч(ДополнительныеСвойства) = Тип("Структура"));
	
	Если Кэшировать Тогда
		
		ЗависимыеВалюты = ДополнительныеСвойства.ЗависимыеВалюты.Получить(ВалютаБазовая);
		
		Если ТипЗнч(ЗависимыеВалюты) = Тип("ТаблицаЗначений") Тогда
			Возврат ЗависимыеВалюты;
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрВалюты.Ссылка,
	|	СпрВалюты.Наценка,
	|	СпрВалюты.СпособУстановкиКурса,
	|	СпрВалюты.ФормулаРасчетаКурса
	|ИЗ
	|	Справочник.Валюты КАК СпрВалюты
	|ГДЕ
	|	СпрВалюты.ОсновнаяВалюта = &ВалютаБазовая
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СпрВалюты.Ссылка,
	|	СпрВалюты.Наценка,
	|	СпрВалюты.СпособУстановкиКурса,
	|	СпрВалюты.ФормулаРасчетаКурса
	|ИЗ
	|	Справочник.Валюты КАК СпрВалюты
	|ГДЕ
	|	СпрВалюты.ФормулаРасчетаКурса ПОДОБНО &СимвольныйКод";
	
	Запрос.УстановитьПараметр("ВалютаБазовая", ВалютаБазовая);
	Запрос.УстановитьПараметр("СимвольныйКод", "%" + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВалютаБазовая, "Наименование") + "%");
	
	ЗависимыеВалюты = Запрос.Выполнить().Выгрузить();
	
	Если Кэшировать Тогда
		
		ДополнительныеСвойства.ЗависимыеВалюты.Вставить(ВалютаБазовая, ЗависимыеВалюты);
		
	КонецЕсли;
	
	Возврат ЗависимыеВалюты;
	
КонецФункции

Процедура ОбновитьКурсВалюты(Параметры, АдресРезультата) Экспорт
	
	ПодчиненнаяВалюта    = Параметры.ПодчиненнаяВалюта;
	СпособУстановкиКурса = Параметры.СпособУстановкиКурса;
	
	Если СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.НаценкаНаКурсДругойВалюты Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КурсыВалют.Период,
		|	КурсыВалют.Валюта,
		|	КурсыВалют.Курс,
		|	КурсыВалют.Кратность
		|ИЗ
		|	РегистрСведений.КурсыВалют КАК КурсыВалют
		|ГДЕ
		|	КурсыВалют.Валюта = &ВалютаИсточник";
		Запрос.УстановитьПараметр("ВалютаИсточник", ПодчиненнаяВалюта.ОсновнаяВалюта);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Валюта.Установить(ПодчиненнаяВалюта.Ссылка);
		
		Наценка = ПодчиненнаяВалюта.Наценка;
		
		Пока Выборка.Следующий() Цикл
			
			НоваяЗаписьНабораКурсов = НаборЗаписей.Добавить();
			НоваяЗаписьНабораКурсов.Валюта    = ПодчиненнаяВалюта.Ссылка;
			НоваяЗаписьНабораКурсов.Кратность = Выборка.Кратность;
			НоваяЗаписьНабораКурсов.Курс      = Выборка.Курс + Выборка.Курс * Наценка / 100;
			НоваяЗаписьНабораКурсов.Период    = Выборка.Период;
			
		КонецЦикла;
		
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьКонтрольПодчиненныхВалют");
		Если ПодчиненнаяВалюта.ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
			НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
		КонецЕсли;

		НаборЗаписей.Записать();
		
	ИначеЕсли СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РасчетПоФормуле Тогда
		
		// Получить основные валюты для ПодчиненнаяВалюта.
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Валюты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Валюты КАК Валюты
		|ГДЕ
		|	&ФормулаРасчетаКурса ПОДОБНО ""%"" + Валюты.Наименование + ""%""";
		
		Запрос.УстановитьПараметр("ФормулаРасчетаКурса", ПодчиненнаяВалюта.ФормулаРасчетаКурса);
		ОсновныеВалюты = Запрос.Выполнить().Выгрузить();
		
		Если ОсновныеВалюты.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru = 'В формуле должна быть использована хотя бы одна основная валюта.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Объект.ФормулаРасчетаКурса");
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ОбновленныеПериоды = Новый Соответствие; // Кэш для однократного пересчета курса за один и тот же период.
		// Перезаписать курсы основных валют для обновления курса валюты ПодчиненнаяВалюта.
		Для каждого ЗаписьОсновнойВалюты Из ОсновныеВалюты Цикл
			НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Валюта.Установить(ЗаписьОсновнойВалюты.Ссылка);
			НаборЗаписей.Прочитать();
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОбновитьКурсЗависимойВалюты", ПодчиненнаяВалюта.Ссылка);
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОбновленныеПериоды", ОбновленныеПериоды);
			
			Если ПодчиненнаяВалюта.ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
				НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
			КонецЕсли;
			
			НаборЗаписей.Записать();
		КонецЦикла
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Обновляет сведения о валюте, согласно документу "Изменение 33/2012 ОКВ Общероссийский классификатор валют.
// ОК (МК (ИСО 4217) 003-97) 014-2000" (принято и введено в действие Приказом Росстандарта от 12.12.2012 N 1883-ст).
//
Процедура ОбновитьСведенияОВалюте937() Экспорт
	Валюта = Справочники.Валюты.НайтиПоКоду("937");
	Если Не Валюта.Пустая() Тогда
		Валюта = Валюта.ПолучитьОбъект();
		Валюта.Наименование = "VEF";
		Валюта.НаименованиеПолное = НСтр("ru = 'Боливар'");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Валюта);
	КонецЕсли;
КонецПроцедуры

// Заполняет реквизит СпособУстановкиКурса у элементов справочника Валюты.
Процедура ЗаполнитьСпособУстановкиКурсаВалют() Экспорт
	Выборка = Справочники.Валюты.Выбрать();
	Пока Выборка.Следующий() Цикл
		Валюта = Выборка.Ссылка.ПолучитьОбъект();
		Если Валюта.ЗагружаетсяИзИнтернета Тогда
			Валюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		ИначеЕсли Не Валюта.ОсновнаяВалюта.Пустая() Тогда
			Валюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.НаценкаНаКурсДругойВалюты;
		Иначе
			Валюта.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
		КонецЕсли;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Валюта);
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление курсов валют

// Проверяет актуальность курсов всех валют.
//
Функция КурсыАктуальны() Экспорт
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ втВалюты
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
	|	И Валюты.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	втВалюты КАК Валюты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО Валюты.Ссылка = КурсыВалют.Валюта
	|			И (КурсыВалют.Период = &ТекущаяДата)
	|ГДЕ
	|	КурсыВалют.Валюта ЕСТЬ NULL ";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Пустой();
КонецФункции

// Определяет есть ли хоть одна валюта, курс которой может загружаться из сети Интернет.
//
Функция КурсыЗагружаютсяИзИнтернета()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
	|	И Валюты.ПометкаУдаления = ЛОЖЬ";
	Возврат НЕ Запрос.Выполнить().Пустой();
КонецФункции

#КонецОбласти
