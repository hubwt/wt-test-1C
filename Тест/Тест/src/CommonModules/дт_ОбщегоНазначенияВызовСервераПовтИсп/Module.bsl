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
	
	Запрос = Новый Запрос();
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
	Если  ТекушийПользователь.Роли.Содержит(Метаданные.Роли.Найти("дт_ПолныеПрава")) Тогда
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