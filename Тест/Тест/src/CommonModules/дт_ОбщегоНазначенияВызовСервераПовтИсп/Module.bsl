	// Возвращает валюту регламентированного учета
// Если переданная в качестве параметра валюта уже заполнена - возвращает ее.
// Если валюта не передана в качестве параметра или передан пустой,
// валюту рег. учета. Если валюта рег. учета не заполнена - возвращает пустую ссылку на валюту
//
// Параметры:
// Валюта - СправочникСсылка.Валюты - Валюта, которую нужно заполнить
//
// Возвращаемое значение:
// СправочникСсылка.Валюты
//
Функция ПолучитьВалютуРегламентированногоУчета() Экспорт

	Возврат Справочники.Валюты.Рубль;

КонецФункции

Функция ПолучитьОсновнойСклад() Экспорт

	Результат = Константы.дт_ОсновнойСклад.Получить(); //Справочники.Склады.ПустаяСсылка();

	Если ЗначениеЗаполнено(Результат) Тогда
		Возврат Результат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Склады.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	НЕ Склады.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склады.Код";

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ПолучитьОсновнойГород() Экспорт

	Результат = Неопределено;

	Подразделение = дт_ПраваДоступа.ТекущееПодразделение();

	Если ЗначениеЗаполнено(Подразделение) Тогда
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Подразделение, "Город");
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция СтавкаНДСПоУмолчанию(ДатаСтавки = Неопределено) Экспорт

	Результат = 20;

	Если ДатаСтавки <> Неопределено Тогда
		Если ДатаСтавки < ДатаНачалаИспользованияОсновнойСтавкиНДС() Тогда
			Результат = 18;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ДатаНачалаИспользованияОсновнойСтавкиНДС() Экспорт

	Возврат '20190101';

КонецФункции // ДатаНачалаИспользованияОсновнойСтавкиНДС()
Функция ТекстРазделителяЗапросовПакета() Экспорт

	ТекстРазделителя =
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстРазделителя;

КонецФункции

Функция ДатаНачалаВеденияСкладскогоУчета() Экспорт

	Возврат '20180904';

КонецФункции // ДатаНачалаВеденияСкладскогоУчета()

Функция ПолучитьОсновнуюОрганизацию() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Спр.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организация КАК Спр
	|ГДЕ
	|	НЕ Спр.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Спр.Ссылка";

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Результат = Справочники.Организация.ПустаяСсылка();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ПолучитьОсновноеОтветственноеЛицоОрганизации(Организация, Дата = Неопределено) Экспорт

	Результат = Неопределено;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтветственныеЛицаОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|ГДЕ
	|	НЕ ОтветственныеЛицаОрганизаций.ПометкаУдаления
	|	И (ОтветственныеЛицаОрганизаций.ДатаОкончания >= &ТекДата
	|	ИЛИ ОтветственныеЛицаОрганизаций.ДатаОкончания = &ПустаяДата)
	|	И ОтветственныеЛицаОрганизаций.ДатаНачала <= &ТекДата
	|	И (ОтветственныеЛицаОрганизаций.ДатаДокументаПраваПодписи <= &ТекДата
	|	ИЛИ ОтветственныеЛицаОрганизаций.ДатаДокументаПраваПодписи = &ПустаяДата)
	|	И ОтветственныеЛицаОрганизаций.Владелец = &Организация
	|	И ОтветственныеЛицаОрганизаций.ОтветственноеЛицо = &ОтветственноеЛицо
	|УПОРЯДОЧИТЬ ПО
	|	ОтветственныеЛицаОрганизаций.ПравоПодписиПоДоверенности";

	Запрос.УстановитьПараметр("ТекДата", ?(Дата = Неопределено, ТекущаяДата(), Дата));
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ПрефиксИБ() Экспорт

	Возврат дт_ОбщегоНазначенияПовтИсп.ПрефиксИБ();

КонецФункции // ПрефиксИБ()

Функция ДатаНачалаУчетаНаименованийПоставщиков() Экспорт

	Возврат Константы.дт_ДатаНачалаУчетаНаименованийПоставщиков.Получить();

КонецФункции // ДатаНачала()

Функция ПолучитьОсновнойВидРасхода(ВидОперации) Экспорт

	Результат = Неопределено;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВидыРасходов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыРасходов КАК ВидыРасходов
	|ГДЕ
	|	ВидыРасходов.ВидОперацииСписаниеДенежныхСредств = &ВидОперации
	|	И НЕ ВидыРасходов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";

	Запрос.УстановитьПараметр("ВидОперации", ВидОперации);
	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Если Выборка.Следующий() Тогда
		Результат = ВЫборка.Ссылка;
	КонецЕсли;

	Возврат Результат;

КонецФункции // ПолучитьОсновнойВидРасхода()

Функция ПолучитьРасширенияКартинок() Экспорт
	Расширения = "jpg,jpeg,png,gif,tiff,bmp";
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Расширения, ",");
КонецФункции

// Функция - Получить цену инд кода
//
// Параметры:
//  ИндКод	 - СправочникСсылка.ИндКод - Ссылка на ИндКод
// 
// Возвращаемое значение:
//   - Число - Цена детали
//   - Неопределено
//
Функция ПолучитьЦенуИндКода(ИндКод) Экспорт
	// Комлев АА 13/01/25 +++
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ Первые 1
	|	ИндНомер.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ИндНомер КАК ИндНомер
	|ГДЕ
	|	ИндНомер.индкод = &индкод";

	Запрос.УстановитьПараметр("индкод", индкод);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	ВыборкаДетальныеЗаписи.Следующий();
	Возврат ВыборкаДетальныеЗаписи.Цена;
	// Комлев АА 13/01/25 ---
КонецФункции


// Функция - Получить Рекомендованную цену Номенклатуры
//
// Параметры:
//  Номенклатура	 - СправочникСсылка.Номенклатура - Ссылка на Номенклатуру
//  Дата - Дата - На какую дату получить цену
// 
// Возвращаемое значение:
//   - Число - Цена детали
//   - Неопределено
//
Функция ПолучитьРекомендованнуюЦену(Номенклатура, Дата) Экспорт
	// Комлев АА 13/01/25 +++
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	дт_ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.дт_ЦеныНоменклатуры.СрезПоследних(&Дата, Номенклатура = &Номенклатура) КАК дт_ЦеныНоменклатурыСрезПоследних
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ";

	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	ВыборкаДетальныеЗаписи.Следующий();
	Возврат ВыборкаДетальныеЗаписи.Цена;
	// Комлев АА 13/01/25 ---
КонецФункции


// Функция - Проверяет текущего пользователя на полные права
//
// Возвращаемое значение:
//   - Булево - 
//
Функция ЭтоПолноправныйПользователь() Экспорт
	// Комлев АА 13/01/25 +++
	ТекушийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	Если ТекушийПользователь.Роли.Содержит(Метаданные.Роли.Найти("дт_ПолныеПрава")) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	// Комлев АА 13/01/25 ---
КонецФункции

// Функция - ЭтоПользовательИмя Проверяет текущего пользователя по полному имени
//
// Параметры:
//  ИмяПользователя	 - Строка - Польное имя как в справочнике Пользователи

// Возвращаемое значение:
//   - Булево - Цена детали
Функция ЭтоПользовательИмя(ИмяПользователя) Экспорт
	// Комлев АА 13/01/25 +++
	ТекушийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	Если ТекушийПользователь.ПолноеИмя = ИмяПользователя Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	// Комлев АА 13/01/25 ---
КонецФункции


// Функция - ПолучитьПользователяПоИмени 
//
// Параметры:
//  ПолноеИмя	 - Строка - Польное имя как в справочнике Пользователи

// Возвращаемое значение:
//   - СправочникСсылка.Пользователи - Ссылка на пользователя
Функция ПолучитьПользователяПоИмени(ПолноеИмя) Экспорт
	Возврат Справочники.Пользователи.НайтиПоНаименованию(ПолноеИмя);
КонецФункции
Функция НомерСчетаФактурыНаПечать(Номер, ИндексПодразделения, УдалитьПользовательскийПрефикс = Истина)
	//Комлев АА 11/12/24 +++
	НомерНаПечать = "";

	Если Номер <> Неопределено Тогда

		НомерНаПечать = дт_ПрефиксацияКлиентСервер.НомерНаПечать(Номер, Ложь, УдалитьПользовательскийПрефикс);

		ПозицияРазделителя = СтрНайти(НомерНаПечать, "-");
		Префикс = Лев(НомерНаПечать, ПозицияРазделителя);
		НомерБезПрефикса = Сред(НомерНаПечать, ПозицияРазделителя + 1);

		Если Лев(НомерБезПрефикса, 1) = "И" Тогда
			НомерНаПечать = Префикс + Сред(НомерБезПрефикса, 2);
		КонецЕсли;
		Если ЗначениеЗаполнено(ИндексПодразделения) Тогда
			НомерНаПечать = НомерНаПечать + "/" + ИндексПодразделения;
		КонецЕсли;

	КонецЕсли;

	Возврат НомерНаПечать;
	//Комлев АА 11/12/24 +++

КонецФункции
Функция СоздатьXMLФайл(Каталог, СсылкаНаДокумент, Менеджер) Экспорт
	//Комлев АА 11/12/24 +++ 
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(СсылкаНаДокумент);
	Результат = Документы[Менеджер].ПолучитьДанныеДляПечатнойФормыУПД(Новый Структура, МассивСсылок);

	ДанныеПечати        = Результат.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = Результат.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ДанныеПечати.Следующий() Цикл
		ЗаписьXML = Новый ЗаписьXML;
		ИмяВремФайла = ПолучитьИмяВременногоФайла("xml");

		ЗаписьXML.ОткрытьФайл(ИмяВремФайла, "UTF-8");
		ЗаписьXML.ЗаписатьОбъявлениеXML();
		// Начало документа
		ЗаписьXML.ЗаписатьНачалоЭлемента("Файл");
		ЗаписьXML.ЗаписатьАтрибут("ИдФайл", "ON_NSCHFDOPPR_2HE-Rec_2HE-Sen_20200101_12345");
		ЗаписьXML.ЗаписатьАтрибут("ВерсПрог", "hedo");
		ЗаписьXML.ЗаписатьАтрибут("ВерсФорм", "5.01");
		
		// Элемент СвУчДокОбор
		ЗаписьXML.ЗаписатьНачалоЭлемента("СвУчДокОбор");
		ЗаписьXML.ЗаписатьАтрибут("ИдОтпр", "2HE-Sen");
		ЗаписьXML.ЗаписатьАтрибут("ИдПол", "2HE-Rec");
		
		// Элемент СвОЭДОтпр
		ЗаписьXML.ЗаписатьНачалоЭлемента("СвОЭДОтпр");
		ЗаписьXML.ЗаписатьАтрибут("НаимОрг", "АО ПФ СКБ Контур");
		ЗаписьXML.ЗаписатьАтрибут("ИННЮЛ", "6663003127");
		ЗаписьXML.ЗаписатьАтрибут("ИдЭДО", "2HE");
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвОЭДОтпр

		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвУчДокОбор
		
		// Элемент Документ
		ЗаписьXML.ЗаписатьНачалоЭлемента("Документ");
		ЗаписьXML.ЗаписатьАтрибут("КНД", "1115131");
		ЗаписьXML.ЗаписатьАтрибут("ВремИнфПр", "00.00.00");
		ЗаписьXML.ЗаписатьАтрибут("ДатаИнфПр", СтрРазделить(ДанныеПечати.Дата, " ")[0]);
		ЗаписьXML.ЗаписатьАтрибут("НаимЭконСубСост", ДанныеПечати.Грузоотправитель.ПолноеНаименование);
		ЗаписьXML.ЗаписатьАтрибут("Функция", "СЧФДОП");
		ЗаписьXML.ЗаписатьАтрибут("ПоФактХЖ",
			"Документ об отгрузке товаров (выполнении работ), передачe имущественных прав (документ об оказании услуг)");
		ЗаписьXML.ЗаписатьАтрибут("НаимДокОпр",
			"Счет-фактура и документ об отгрузке товаров (выполнении работ), передачe имущественных прав (документ об оказании услуг)");
		
		// Элемент СвСчФакт
		ЗаписьXML.ЗаписатьНачалоЭлемента("СвСчФакт");
		ЗаписьXML.ЗаписатьАтрибут("НомерСчФ", НомерСчетаФактурыНаПечать(ДанныеПечати.Номер,
			ДанныеПечати.ИндексПодразделения));
		ЗаписьXML.ЗаписатьАтрибут("ДатаСчФ", СтрРазделить(ДанныеПечати.Дата, " ")[0]);
		ЗаписьXML.ЗаписатьАтрибут("КодОКВ", ДанныеПечати.ВалютаКод);
		
		// Элемент СвПрод
		ЗаписьXML.ЗаписатьНачалоЭлемента("СвПрод");
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИдСв");
		Если ДанныеПечати.Грузоотправитель.ЮрФизЛицо = Перечисления.дт_ТипыКлиентов.ЮрЛицо Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("СвЮЛУч"); 
			ЗаписьXML.ЗаписатьАтрибут("НаимОрг", ДанныеПечати.Грузоотправитель.ПолноеНаименование);
			ЗаписьXML.ЗаписатьАтрибут("ИННЮЛ", ДанныеПечати.Грузоотправитель.ИНН);
			ЗаписьXML.ЗаписатьАтрибут("КПП", ДанныеПечати.Грузоотправитель.КПП);
		Иначе 
			ЗаписьXML.ЗаписатьНачалоЭлемента("СвИП");
			ЗаписьXML.ЗаписатьАтрибут("ИННФЛ", ДанныеПечати.Грузоотправитель.ИНН);
			ЗаписьXML.ЗаписатьНачалоЭлемента("ФИО");
			ЗаписьXML.ЗаписатьАтрибут("Фамилия", "Индивидуальный");
			ЗаписьXML.ЗаписатьАтрибут("Имя", "предприниматель");
			МассивСлов = СтрРазделить(ДанныеПечати.Грузоотправитель.ПолноеНаименование, " ");
			КрайнийИндексМассива  = МассивСлов.ВГраница();
			ЗаписьXML.ЗаписатьАтрибут("Отчество", МассивСлов[КрайнийИндексМассива - 2] + " " 
																+ МассивСлов[КрайнийИндексМассива - 1] + " " 
																+ МассивСлов[КрайнийИндексМассива]);
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ФИО
		КонецЕсли;
		
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвЮЛУч / СвИП
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ИдСв
		
		// Элемент Адрес
		ЗаписьXML.ЗаписатьНачалоЭлемента("Адрес");
		ЗаписьXML.ЗаписатьНачалоЭлемента("АдрИнф");
		ЗаписьXML.ЗаписатьАтрибут("КодСтр", ДанныеПечати.СтранаРегистрации.Код);
		ЗаписьXML.ЗаписатьАтрибут("АдрТекст", ДанныеПечати.Грузоотправитель.Адрес);
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем АдрИнф
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем Адрес
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвПрод
		
		// Элемент ГрузОт
		ЗаписьXML.ЗаписатьНачалоЭлемента("ГрузОт");
		ЗаписьXML.ЗаписатьНачалоЭлемента("ОнЖе");
		ЗаписьXML.ЗаписатьТекст("он же");
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ОнЖе
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ГрузОт
		
		// Элемент ГрузПолуч
		ЗаписьXML.ЗаписатьНачалоЭлемента("ГрузПолуч");
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИдСв");
		
		Если ДанныеПечати.Грузополучатель.ТипКлиента = Перечисления.дт_ТипыКлиентов.ЮрЛицо Тогда 
			ЗаписьXML.ЗаписатьНачалоЭлемента("СвЮЛУч"); 
			ЗаписьXML.ЗаписатьАтрибут("НаимОрг", ДанныеПечати.Грузополучатель.ПолноеНаименование);
			ЗаписьXML.ЗаписатьАтрибут("ИННЮЛ", ДанныеПечати.Грузополучатель.ИНН);
		Иначе
			ЗаписьXML.ЗаписатьНачалоЭлемента("СвИП");
			ЗаписьXML.ЗаписатьАтрибут("ИННФЛ", ДанныеПечати.Грузополучатель.ИНН);
			ЗаписьXML.ЗаписатьНачалоЭлемента("ФИО");
			ЗаписьXML.ЗаписатьАтрибут("Фамилия", "Индивидуальный");
			ЗаписьXML.ЗаписатьАтрибут("Имя", "предприниматель");
			МассивСловПолучатель = СтрРазделить(ДанныеПечати.Грузополучатель.ПолноеНаименование, " ");
			КрайнийИндексМассива  = МассивСловПолучатель.ВГраница();
			ЗаписьXML.ЗаписатьАтрибут("Отчество", МассивСловПолучатель[КрайнийИндексМассива - 2] + " " 
																+ МассивСловПолучатель[КрайнийИндексМассива - 1] + " " 
																+ МассивСловПолучатель[КрайнийИндексМассива]); 
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ФИО
		КонецЕсли;
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвЮЛУч / СвИП
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ИдСв
		
		// Элемент Адрес
		ЗаписьXML.ЗаписатьНачалоЭлемента("Адрес");
		ЗаписьXML.ЗаписатьНачалоЭлемента("АдрИнф");
		ЗаписьXML.ЗаписатьАтрибут("КодСтр", ДанныеПечати.СтранаРегистрации.Код);
		ЗаписьXML.ЗаписатьАтрибут("АдрТекст", ДанныеПечати.Грузополучатель.ФактическийАдрес);
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем АдрИнф
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем Адрес
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ГрузПолуч
		
		// Элемент СвПокуп
		ЗаписьXML.ЗаписатьНачалоЭлемента("СвПокуп");
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИдСв");
		
		Если ДанныеПечати.Грузополучатель.ТипКлиента = Перечисления.дт_ТипыКлиентов.ЮрЛицо Тогда
			
        Иначе
			
		КонецЕсли;
		
		Если ДанныеПечати.Грузополучатель.ТипКлиента = Перечисления.дт_ТипыКлиентов.ЮрЛицо Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("СвЮЛУч");
			ЗаписьXML.ЗаписатьАтрибут("НаимОрг", ДанныеПечати.Грузополучатель.ПолноеНаименование); 
			ЗаписьXML.ЗаписатьАтрибут("ИННЮЛ", ДанныеПечати.Грузополучатель.ИНН);
			ЗаписьXML.ЗаписатьАтрибут("КПП", ДанныеПечати.Грузополучатель.КПП);
		Иначе 
			ЗаписьXML.ЗаписатьНачалоЭлемента("СвИП");
			ЗаписьXML.ЗаписатьАтрибут("ИННФЛ", ДанныеПечати.Грузополучатель.ИНН);
			ЗаписьXML.ЗаписатьНачалоЭлемента("ФИО");
			ЗаписьXML.ЗаписатьАтрибут("Фамилия", "Индивидуальный");
			ЗаписьXML.ЗаписатьАтрибут("Имя", "предприниматель");
			ЗаписьXML.ЗаписатьАтрибут("Отчество", МассивСлов[КрайнийИндексМассива - 2] + " " 
																+ МассивСлов[КрайнийИндексМассива - 1] + " " 
																+ МассивСлов[КрайнийИндексМассива]);
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ФИО
		КонецЕсли;  
		 
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвЮЛУч / СвИП
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ИдСв
		
		// Элемент Адрес
		ЗаписьXML.ЗаписатьНачалоЭлемента("Адрес");
		ЗаписьXML.ЗаписатьНачалоЭлемента("АдрИнф");
		ЗаписьXML.ЗаписатьАтрибут("КодСтр", ДанныеПечати.СтранаРегистрации.Код);
		ЗаписьXML.ЗаписатьАтрибут("АдрТекст", ДанныеПечати.Грузополучатель.ЮридическийАдрес);
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем АдрИнф
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем Адрес
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвПокуп
		
		// Элемент ДокПодтвОтгр
		ЗаписьXML.ЗаписатьНачалоЭлемента("ДокПодтвОтгр");
		ЗаписьXML.ЗаписатьАтрибут("НаимДокОтгр", "УПД");   // Лев(ДанныеПечати.ПредставлениеСтроки5а, 7)
		ЗаписьXML.ЗаписатьАтрибут("НомДокОтгр", НомерСчетаФактурыНаПечать(ДанныеПечати.Номер,
			ДанныеПечати.ИндексПодразделения));
		ЗаписьXML.ЗаписатьАтрибут("ДатаДокОтгр", СтрРазделить(ДанныеПечати.Дата, " ")[0]);
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ДокПодтвОтгр

		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвСчФакт
		
		// Элемент ТаблСчФакт
		ЗаписьXML.ЗаписатьНачалоЭлемента("ТаблСчФакт");   
		////////////////////////////////////////////////////////////////////////////////////////////////////// Тч Товары   
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);

		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		СуммаСНДСВсего = 0.00;
		СуммаБезНДСВсего = 0.00;
		СуммаНалогаВсего = 0.00;
		СтавкаНДС = "";
		СуммаНДС = "";
		Если ДанныеПечати.Грузополучатель.ТипКлиента = Перечисления.дт_ТипыКлиентов.ЮрЛицо Тогда
			СтавкаНДС = Строка(ДанныеПечати.Грузоотправитель.Налог) + "%";
			СуммаНДС = Строка(СтрокаТовары.СуммаНДС);
		Иначе
			СтавкаНДС  = "без НДС";
			СуммаНДС = "без НДС";
		КонецЕсли;

		Пока СтрокаТовары.Следующий() Цикл
			ЗаписьXML.ЗаписатьНачалоЭлемента("СведТов");
			ЗаписьXML.ЗаписатьАтрибут("НомСтр", Строка(СтрокаТовары.НомерСтроки));
			ЗаписьXML.ЗаписатьАтрибут("НаимТов", СтрокаТовары.НоменклатураНаименование);
			ЗаписьXML.ЗаписатьАтрибут("ОКЕИ_Тов", СтрокаТовары.ЕдиницаИзмеренияКод);
			ЗаписьXML.ЗаписатьАтрибут("КолТов", Строка(СтрокаТовары.Количество));
			ЗаписьXML.ЗаписатьАтрибут("ЦенаТов", СтрЗаменить(Формат(СтрокаТовары.Цена, "ЧДЦ=2; ЧРГ=.; ЧГ=0"), ",", "."));
			ЗаписьXML.ЗаписатьАтрибут("СтТовБезНДС", СтрЗаменить(Формат(СтрокаТовары.СуммаБезНДС,
				"ЧДЦ=2; ЧРГ=.; ЧГ=0"), ",", "."));
			ЗаписьXML.ЗаписатьАтрибут("НалСт", СтавкаНДС);
			ЗаписьXML.ЗаписатьАтрибут("СтТовУчНал", СтрЗаменить(Формат(СтрокаТовары.СуммаСНДС, "ЧДЦ=2; ЧРГ=.; ЧГ=0"),
				",", "."));
			
			// Элемент Акциз
			ЗаписьXML.ЗаписатьНачалоЭлемента("Акциз");
			ЗаписьXML.ЗаписатьНачалоЭлемента("БезАкциз");
			ЗаписьXML.ЗаписатьТекст("без акциза");
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем БезАкциз
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем Акциз
			
			// Элемент СумНал
			ЗаписьXML.ЗаписатьНачалоЭлемента("СумНал");
			ЗаписьXML.ЗаписатьНачалоЭлемента("СумНал");
			ЗаписьXML.ЗаписатьТекст(СуммаНДС);
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СумНал
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СумНал
			
			// Элемент ДопСведТов
			ЗаписьXML.ЗаписатьНачалоЭлемента("ДопСведТов");
			ЗаписьXML.ЗаписатьАтрибут("КодТов", СтрокаТовары.НоменклатураКод);
			ЗаписьXML.ЗаписатьАтрибут("НаимЕдИзм", СтрокаТовары.ЕдиницаИзмеренияНаименование);
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ДопСведТов

			ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СведТов
			СуммаСНДСВсего = СуммаСНДСВсего + СтрокаТовары.СуммаСНДС;
			СуммаБезНДСВсего = СуммаБезНДСВсего + СтрокаТовары.СуммаБезНДС;
			СуммаНалогаВсего = СуммаНалогаВсего + СтрокаТовары.СуммаНДС;
		КонецЦикла;    
		// КоецЦиклаТовары
		
		// Элемент ВсегоОпл
		ЗаписьXML.ЗаписатьНачалоЭлемента("ВсегоОпл");
		ЗаписьXML.ЗаписатьАтрибут("СтТовБезНДСВсего", СтрЗаменить(Формат(СуммаБезНДСВсего, "ЧДЦ=2; ЧРГ=.; ЧГ=0"), ",",
			"."));
		ЗаписьXML.ЗаписатьАтрибут("СтТовУчНалВсего", СтрЗаменить(Формат(СуммаСНДСВсего, "ЧДЦ=2; ЧРГ=.; ЧГ=0"), ",",
			"."));
		
		// Элемент СумНалВсего
		ЗаписьXML.ЗаписатьНачалоЭлемента("СумНалВсего");
		ЗаписьXML.ЗаписатьНачалоЭлемента("СумНал");
		ЗаписьXML.ЗаписатьТекст(?(СтрЗаменить(Формат(СуммаНалогаВсего, "ЧДЦ=2; ЧРГ=.; ЧГ=0"), ",", ".") <> "",
			СтрЗаменить(Формат(СуммаНалогаВсего, "ЧДЦ=2; ЧРГ=.; ЧГ=0"), ",", "."), "без НДС"));
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СумНал
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СумНалВсего

		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ВсегоОпл
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ТаблСчФакт
		
		// Элемент СвПродПер
		ЗаписьXML.ЗаписатьНачалоЭлемента("СвПродПер");
		ЗаписьXML.ЗаписатьНачалоЭлемента("СвПер");
		ЗаписьXML.ЗаписатьАтрибут("СодОпер", "Товары переданы, работы выполнены, услуги оказаны в полном объеме");
		ЗаписьXML.ЗаписатьАтрибут("ДатаПер", СтрРазделить(ДанныеПечати.Дата, " ")[0]);
		
		// Элемент ОснПер
		ЗаписьXML.ЗаписатьНачалоЭлемента("ОснПер");
		ЗаписьXML.ЗаписатьАтрибут("НаимОсн", "Без документа-основания");
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ОснПер
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвПер
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем СвПродПер
		
		// Элемент Подписант
		ЗаписьXML.ЗаписатьНачалоЭлемента("Подписант");
		ЗаписьXML.ЗаписатьАтрибут("ОблПолн", "6");
		ЗаписьXML.ЗаписатьАтрибут("Статус", "4");
		ЗаписьXML.ЗаписатьАтрибут("ОснПолн", "Должностные обязанности");
		
		
		Должность = "";
		Если ДанныеПечати.Грузоотправитель = Справочники.Организация.НайтиПоКоду("000000004") Тогда
			Должность = "Генеральный директор";
		ИначеЕсли ДанныеПечати.Грузоотправитель.ЮрФизЛицо = Перечисления.дт_ТипыКлиентов.ЮрЛицо
			И Не ДанныеПечати.Грузоотправитель = Справочники.Организация.НайтиПоКоду("000000004") Тогда
			Должность = "Директор";
		КонецЕсли;
		// Элемент ЮЛ  ИЛИ ИП 
		Если ДанныеПечати.Грузоотправитель.ЮрФизЛицо = Перечисления.дт_ТипыКлиентов.ЮрЛицо Тогда 
			ЗаписьXML.ЗаписатьНачалоЭлемента("ЮЛ");
			ЗаписьXML.ЗаписатьАтрибут("ИННЮЛ", ДанныеПечати.Грузоотправитель.ИНН);
			ЗаписьXML.ЗаписатьАтрибут("Должн", Должность);
		Иначе
			ЗаписьXML.ЗаписатьНачалоЭлемента("ИП");
			ЗаписьXML.ЗаписатьАтрибут("ИННФЛ", ДанныеПечати.Грузоотправитель.ИНН);
		КонецЕсли;

		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОтветственныеЛицаОрганизаций.ФизическоеЛицо.Фамилия КАК Фамилия,
		|	ОтветственныеЛицаОрганизаций.ФизическоеЛицо.Имя КАК Имя,
		|	ОтветственныеЛицаОрганизаций.ФизическоеЛицо.Отчество КАК Отчество
		|ИЗ
		|	Справочник.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
		|ГДЕ
		|	ОтветственныеЛицаОрганизаций.Владелец.Ссылка = &Ссылка
		|	И ОтветственныеЛицаОрганизаций.ЭтоРуководитель";

		Запрос.УстановитьПараметр("Ссылка", ДанныеПечати.Грузоотправитель);

		РезультатЗапроса = Запрос.Выполнить();

		Выборка = РезультатЗапроса.Выбрать();

		Выборка.Следующий();
		
		// Элемент ФИО
		ЗаписьXML.ЗаписатьНачалоЭлемента("ФИО");
		ЗаписьXML.ЗаписатьАтрибут("Фамилия", Строка(Выборка.Фамилия));
		ЗаписьXML.ЗаписатьАтрибут("Имя", Строка(Выборка.Имя));
		ЗаписьXML.ЗаписатьАтрибут("Отчество", Строка(Выборка.Отчество));
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ФИО
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем ЮЛ
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем Подписант

		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем Документ
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Закрываем Файл  

		ЗаписьXML.Закрыть(); // Закрываем файл  
	КонецЦикла;
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВремФайла);
	УдалитьФайлы(ИмяВремФайла);
	Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, Новый УникальныйИдентификатор);
	Возврат Адрес;
	//Комлев АА 11/12/24 +++
КонецФункции

Функция НомерУПДЗаполнен(Ссылка) Экспорт
//Комлев АА 11/12/24 +++ 
	Если ЗначениеЗаполнено(Ссылка.НомерУПД) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

//Комлев АА 11/12/24 ---
КонецФункции
Функция СформироватьНазваниеФайла(Ссылка, НазваниеДокумента) Экспорт
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Номер,Дата");
	Возврат НазваниеДокумента + "_" + Реквизиты.Номер + "_" + СтрРазделить(Реквизиты.Дата, " ")[0];
КонецФункции
