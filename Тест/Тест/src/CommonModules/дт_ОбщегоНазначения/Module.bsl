
#Область ПрограммныйИнтерфейс
// <Описание Процедуры>
//
// Заполняет регистр сведений Показатели Клиентов
// КоличествоАктивных, КоличествоТеплых, КоличествоПотенциальных, КоличествоХолодных


Процедура ЗаполнитьПоказателиГруппКлиентов() Экспорт
	 // Комлев АА +++ 23/10/24 +++
	Данные = ПолучитьДанныеПоГруппамКлиентов(ТекущаяДата());
	МенеджерЗаписи = РегистрыСведений.ПоказателиКлиенскойБазы.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДата();
	МенеджерЗаписи.КоличествоАктивных = Данные.КоличествоАктивных;
	МенеджерЗаписи.КоличествоТеплых = Данные.КоличествоТеплых;
	МенеджерЗаписи.КоличествоПотенциальных = Данные.КоличествоПотенциальных;
	МенеджерЗаписи.КоличествоХолодных = Данные.КоличествоХолодных;
	МенеджерЗаписи.Записать();
	// Комлев АА --- 23/10/24 ---
КонецПроцедуры
// <Описание функции>
//
// Параметры:
//  ПараметрыДоговора  - Структура, СправочникОбъект - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция УникальныйНомерДоговора(Объект) Экспорт

	
	Если Не ЗначениеЗаполнено(Объект.Организация)
		ИЛИ Не ЗначениеЗаполнено(Объект.ДатаДоговора) Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	Спр.НомерДоговора КАК НомерДоговора
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК Спр
	|ГДЕ
	|	Спр.Ссылка <> &Ссылка
	|	И НЕ Спр.ПометкаУдаления
	|	И Спр.Организация = &Организация
	|	И НАЧАЛОПЕРИОДА(Спр.ДатаДоговора, ГОД) = &ГодДоговора
	|	И Спр.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПокупателем)
	|	И Спр.НомерДоговора ПОДОБНО &ШаблонНомера
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерДоговора УБЫВ";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ГодДоговора", НачалоГода(Объект.ДатаДоговора));
	Запрос.УстановитьПараметр("ШаблонНомера", "%[0-9]%"); // игнорируем номера, не содержащие цифр
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	МаксимальныйЗанятыйНомер = "0";
	
	Если Выборка.Следующий() Тогда
		
		МаксимальныйЗанятыйНомер = дт_ПрефиксацияКлиентСервер.НомерНаПечать(Выборка.НомерДоговора, Истина, Истина);	
		
	КонецЕсли;
	
	МаксимальныйЗанятыйНомерЧисло = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МаксимальныйЗанятыйНомер);
	Если МаксимальныйЗанятыйНомерЧисло = Неопределено Тогда
		МаксимальныйЗанятыйНомерЧисло = 0;
	КонецЕсли;
	
	Результат = ПрефиксОрганизации(Объект.Организация) + СтроковыеФункцииКлиентСервер.ДополнитьСтроку(МаксимальныйЗанятыйНомерЧисло + 1, 3, "0");
	
	Возврат Результат;
КонецФункции // УникальныйНомерДоговора()


// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция ПрефиксОрганизации(Организация, ДополнятьТире = Истина) Экспорт
	
	Префикс = "";

	Если ЗначениеЗаполнено(Организация) Тогда
		
		Префикс = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "БукваВНакладной");
		
		Если ДополнятьТире И Не ПустаяСтрока(Префикс) Тогда
			Префикс = Префикс + "-";	
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Префикс;
	
КонецФункции // ПрефиксОрганизации()

Процедура ИнициализироватьДополнительныеСвойстваДляПроведения(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	// В структуре "ДополнительныеСвойства" создаются свойства с ключами "ТаблицыДляДвижений", "ДляПроведения", "УчетнаяПолитика".
	
	// "ТаблицыДляДвижений" - структура, которая будет содержать таблицы значений с данными для выполнения движений.
	СтруктураДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
	
	// "ДляПроведения" - структура, содержащая свойства и реквизиты документа, необходимые для проведения.
	СтруктураДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
	
	// Структура, содержащая ключ с именем "МенеджерВременныхТаблиц", в значении которого хранится менеджер временных таблиц.
	// Содержит для каждой временной таблицы ключ (имя временной таблицы) и значение (признак наличия записей во временной таблице).
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("МетаданныеДокумента", ДокументСсылка.Метаданные());
	
		
	
	// Определение и установка значения момента, на который должен быть выполнен контроль документа.
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("МоментКонтроля", Дата('00010101'));
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ПериодКонтроля", Дата("39991231"));
		
КонецПроцедуры // ИнициализироватьДополнительныеСвойстваДляПроведения()

Функция СведенияОФизлице(Ссылка, НаДату = Неопределено, Организация = Неопределено) Экспорт

	Результат = Новый Структура();	
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		
		Результат.Вставить("ФИО", "");
		Результат.Вставить("Должность", "");
		Результат.Вставить("ФамилияИО", "");
		Возврат Результат;
		
	КонецЕсли;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ДанныеФизлица = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Фамилия,Имя,Отчество,Должность");
		Результат.Вставить("ФИО", ДанныеФизлица.Фамилия + " " + ДанныеФизлица.Имя + " " + ДанныеФизлица.Отчество);
		
		Результат.Вставить("Должность", ДанныеФизлица.Должность); 
	КонецЕсли;
	
	Результат.Вставить("ФамилияИО", ФизическиеЛицаКлиентСервер.ФамилияИнициалы(Результат.ФИО));
	
	Возврат Результат;

КонецФункции // СведенияОФизлице()

Процедура ДобавитьСсылкуВКоллекцию(Коллекция, ВидСправочника, ЗначениеПоля, ИмяПоля = Неопределено) Экспорт

	Если ИмяПоля = Неопределено Тогда
		Ссылка = Справочники[ВидСправочника].НайтиПоНаименованию(ЗначениеПоля, Истина);	
	Иначе
		Ссылка = Справочники[ВидСправочника].НайтиПоРеквизиту(ИмяПоля, ЗначениеПоля);
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Коллекция.Добавить(Ссылка);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьСуммуДокументов(Коллекция) Экспорт
	
	Результат = 0;
	Если Коллекция.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ТипЗнч(Коллекция[0]) = Тип("ДокументСсылка.ПоступлениеЗапчастей") Тогда
		ИмяПоля = "СуммаНакладной";
	ИначеЕсли ТипЗнч(Коллекция[0]) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
		ИмяПоля = "ИтогоРекв";
	Иначе
		ИмяПоля = "СуммаДокумента";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		СтрШаблон("ВЫБРАТЬ
		|	СУММА(Док.%1) КАК СуммаДокумента
		|ИЗ
		|	Документ.%2 КАК Док
		|ГДЕ
		|	Док.Ссылка В(&Ссылки)",
		ИмяПоля,
		Коллекция[0].Метаданные().Имя
	);
	
	Запрос.УстановитьПараметр("Ссылки", Коллекция);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = ВыборкаДетальныеЗаписи.СуммаДокумента;
	КонецЕсли;

	Возврат Результат;

КонецФункции // ПолучитьСуммуДокументов()


Функция ЕстьРеквизитТабличнойЧастиОбъекта(ИмяРеквизита, ИмяТЧ, МетаданныеОбъекта) Экспорт

	Возврат НЕ (МетаданныеОбъекта.ТабличныеЧасти[ИмяТЧ].Реквизиты.Найти(ИмяРеквизита) = Неопределено);

КонецФункции



#Область ФункцииJSON

Функция ПолучитьЗначениеИзJSONСтроки(ДанныеКакСтрока, ВидСобытия = "", Отказ = Ложь) Экспорт

	ЧтениеJSONПоток = Новый ЧтениеJSON();
	ЧтениеJSONПоток.УстановитьСтроку(ДанныеКакСтрока);
	Попытка
		Результат = ПрочитатьJSON(ЧтениеJSONПоток, Истина);
	Исключение
		Результат = Неопределено;
		ЗаписьВЛог(ВидСобытия, ОписаниеОшибки(), Истина,,,, Отказ);
	КонецПопытки;
	ЧтениеJSONПоток.Закрыть();
	
 	Возврат Результат;
	
КонецФункции // ПолучитьЗначениеИзJSONСтроки()

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
	
	

Функция ПолучитьСвойство(Имя) Экспорт

	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДополнительныеРеквизитыИСведения.Ссылка КАК Ссылка
		|ИЗ
		|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
		|ГДЕ
		|	ДополнительныеРеквизитыИСведения.Имя = &Имя
		|;";
	
	Запрос.УстановитьПараметр("Имя", Имя);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
	
Процедура УстановитьДопСведение(Объект, Знач Свойство, Значение) Экспорт
	
	Если ТипЗнч(Свойство) = Тип("Строка") Тогда
		Свойство = ПолучитьСвойство(Свойство);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Свойство) Тогда
		Возврат
	КонецЕсли;
	
	Запись = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Запись.Свойство = Свойство;
	Запись.Значение = Значение;
	
	Запись.Записать(Истина);
	
КонецПроцедуры
	
Процедура ЗаписьВЛог(ВидСобытия, ТекстЗаписи, ЭтоОшибка = ложь, МетаданныеОбъекта = Неопределено, Объект = Неопределено, ТолькоВРежимеОтладки = Ложь, Отказ = Ложь) Экспорт
	
	РежимОтладки = Истина;
	
	Если ТолькоВРежимеОтладки И НЕ РежимОтладки Тогда
		Возврат;	
	КонецЕсли;
	
	УровеньЗаписи = УровеньЖурналаРегистрации.Информация;
	Если ЭтоОшибка = Истина Тогда
		УровеньЗаписи = УровеньЖурналаРегистрации.Ошибка;
	ИначеЕсли ЭтоОшибка = Неопределено Тогда	
		УровеньЗаписи = УровеньЖурналаРегистрации.Предупреждение;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ВидСобытия, 
			УровеньЗаписи,
			МетаданныеОбъекта,
			Объект,
			ТекстЗаписи
	);
			
	Если ЭтоОшибка = Истина Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстЗаписи,,,, Отказ);
	КонецЕсли;
	
	
	
КонецПроцедуры

Функция ЭлементВИерархии(Элемент, Родитель) Экспорт

	Результат = (Элемент = Родитель);
	Если Результат Тогда
		Возврат Результат;
	КонецЕсли;
	
	ВидСправочника = Элемент.Метаданные().Имя;
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрШаблон(
		"ВЫБРАТЬ
		|	Спр.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ втИсточник
		|ИЗ
		|	Справочник.%1 КАК Спр
		|ГДЕ
		|	Спр.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втИсточник.Ссылка КАК Ссылка,
		|	втИсточник.Ссылка В ИЕРАРХИИ (&Родитель) КАК ВИерархии
		|ИЗ
		|	втИсточник КАК втИсточник",
		ВидСправочника
	);
	
	
	Запрос.УстановитьПараметр("Родитель", Родитель);
	Запрос.УстановитьПараметр("Ссылка", Элемент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = ВыборкаДетальныеЗаписи.ВИерархии;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ЭлементВИерархии()

Функция ИтоговаяСумма(ДокументОбъект, ИмяТЧ, ИмяПоляПризнакОтменено) Экспорт
	
	СтрокиАктивные = ДокументОбъект[ИмяТЧ].НайтиСтроки(Новый Структура(ИмяПоляПризнакОтменено, Ложь));
	Сумма = 0;
	Для каждого СтрокаТаблицы Из СтрокиАктивные Цикл
		Сумма = Сумма + СтрокаТаблицы.Сумма;
	КонецЦикла;
		
	Возврат Сумма;
	
КонецФункции
#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


Функция ПолучитьДанныеПоГруппамКлиентов(ДатаДиаграммыКлиенты)
	/// +++ Комлев 22/10/24 +++
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказКлиента.Клиент КАК КоличествоАктивных
	|ПОМЕСТИТЬ АКБ
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Дата МЕЖДУ &ДатаНачалаАКБ И &ДатаОкончанияАКБ
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Клиент
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ЗаказКлиента.Клиент) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(АКБ.КоличествоАктивных) КАК КоличествоАктивных
	|ИЗ
	|	АКБ КАК АКБ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказКлиента.Клиент КАК КоличествоТеплых
	|ПОМЕСТИТЬ ТЕПЛЫЕ
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Дата МЕЖДУ &ДатаНачалаТеплые И &ДатаОкончанияТеплые
	|	И НЕ ЗаказКлиента.Клиент В
	|		(ВЫБРАТЬ
	|			АКБ.КоличествоАктивных
	|		Из
	|			АКБ КАК АКБ)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Клиент
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ЗаказКлиента.Клиент) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ТЕПЛЫЕ.КоличествоТеплых) КАК КоличествоТеплых
	|ИЗ
	|	ТЕПЛЫЕ КАК ТЕПЛЫЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказКлиента.Клиент КАК КоличествоПотенциальных
	|ПОМЕСТИТЬ ПОТЕНЦ
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Дата МЕЖДУ &ДатаНачалаПотенциальные И &ДатаОкончанияПотенциальные
	|	И НЕ ЗаказКлиента.Клиент В
	|		(ВЫБРАТЬ
	|			АКБ.КоличествоАктивных
	|		ИЗ
	|			АКБ КАК АКБ)
	|	И НЕ ЗаказКлиента.Клиент В
	|		(ВЫБРАТЬ
	|			ТЕПЛЫЕ.КоличествоТеплых
	|		ИЗ
	|			ТЕПЛЫЕ КАК ТЕПЛЫЕ)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Клиент
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ЗаказКлиента.Клиент) = 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ПОТЕНЦ.КоличествоПотенциальных) КАК КоличествоПотенциальных
	|ИЗ
	|	ПОТЕНЦ КАК ПОТЕНЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Клиенты.Ссылка) КАК КоличествоХолодных
	|ИЗ
	|	Справочник.Клиенты КАК Клиенты
	|ГДЕ
	|	НЕ Клиенты.Ссылка В
	|		(ВЫБРАТЬ
	|			АКБ.КоличествоАктивных
	|		ИЗ
	|			АКБ КАК АКБ)
	|	И НЕ Клиенты.Ссылка В
	|		(ВЫБРАТЬ
	|			ТЕПЛЫЕ.КоличествоТеплых
	|		ИЗ
	|			ТЕПЛЫЕ КАК ТЕПЛЫЕ)
	|	И НЕ Клиенты.Ссылка В
	|		(ВЫБРАТЬ
	|			ПОТЕНЦ.КоличествоПотенциальных
	|		ИЗ
	|			ПОТЕНЦ КАК ПОТЕНЦ)";
	
	ДатаНачалаАКБ = НачалоДня(Дата(ДатаДиаграммыКлиенты) - (24 * 60 * 60) * 30);
	ДатаОкончанияАКБ = КонецДня(Дата(ДатаДиаграммыКлиенты));
	Запрос.УстановитьПараметр("ДатаНачалаАКБ", ДатаНачалаАКБ);
	Запрос.УстановитьПараметр("ДатаОкончанияАКБ", ДатаОкончанияАКБ);
	
	ДатаНачалаТеплые = НачалоДня(Дата(ДатаДиаграммыКлиенты) - (24 * 60 * 60) * 90);
	ДатаОкончанияТеплые = КонецДня(Дата(ДатаДиаграммыКлиенты) - (24 * 60 * 60) * 31);
	Запрос.УстановитьПараметр("ДатаНачалаТеплые", ДатаНачалаТеплые);
	Запрос.УстановитьПараметр("ДатаОкончанияТеплые", ДатаОкончанияТеплые);
	
	ДатаНачалаПотенциальные = НачалоДня(Дата(ДатаДиаграммыКлиенты) - (24 * 60 * 60) * 90);
	ДатаОкончанияПотенциальные = КонецДня(Дата(ДатаДиаграммыКлиенты));
	Запрос.УстановитьПараметр("ДатаНачалаПотенциальные", ДатаНачалаПотенциальные);
	Запрос.УстановитьПараметр("ДатаОкончанияПотенциальные", ДатаОкончанияПотенциальные);
	
	ДатаХолодные = НачалоДня(Дата(ДатаДиаграммыКлиенты) - (24 * 60 * 60) * 90);
	Запрос.УстановитьПараметр("ДатаХолодные", ДатаХолодные);
	Пакеты = Запрос.ВыполнитьПакет();
	
	
	ВыборкаАктивные = Пакеты[1].Выбрать();
	ВыборкаАктивные.Следующий();
	
	ВыборкаТеплые = Пакеты[3].Выбрать();
	ВыборкаТеплые.Следующий();
	
	ВыборкаПотенциальные = Пакеты[5].Выбрать();
	ВыборкаПотенциальные.Следующий();
	
	ВыборкаХолодные = Пакеты[6].Выбрать();
	ВыборкаХолодные.Следующий();
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("КоличествоАктивных", ВыборкаАктивные.КоличествоАктивных);
	СтруктураОтвета.Вставить("КоличествоТеплых", ВыборкаТеплые.КоличествоТеплых);
	СтруктураОтвета.Вставить("КоличествоПотенциальных", ВыборкаПотенциальные.КоличествоПотенциальных);
	СтруктураОтвета.Вставить("КоличествоХолодных", ВыборкаХолодные.КоличествоХолодных);
	Возврат СтруктураОтвета;
	/// --- Комлев 22/10/24 ---
КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти