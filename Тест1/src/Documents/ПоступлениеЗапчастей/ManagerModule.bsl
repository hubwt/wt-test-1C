#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс




#Область Печать
// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПоступлениеЗапчастей";
	КомандаПечати.Представление = НСтр("ru = 'Накладная'");
	КомандаПечати.Порядок = 10;
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПоступлениеЗапчастей") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПоступлениеЗапчастей", "Накладная", 
			ПечатьПоступлениеЗапчастей(МассивОбъектов, ОбъектыПечати),,"Документ.ПоступлениеЗапчастей.ПФ_MXL_ПриходнаяНакладная");
	КонецЕсли;
	
КонецПроцедуры


// Процедура печати документа.
//
// Параметры:
//  МассивОбъектов - Массив - объекты, по которым требуется сформировать печатную форму;
//  ОбъектыПечати  - СписокЗначений - разметка табличных документов по печатаемым объектам:
//   * Значение      - ЛюбаяСсылка - печатаемый объект;
//   * Представление - Строка - имя области, соответствующее объекту.
//  ИмяМакета      - Строка - "Счет" или "Заказ".
//  ВыводитьПлатежныеРеквизиты - Булево - если Истина, выводит шапку с платежными реквизитами в счете.
//
// Возвращаемое значение:
//  ТабличныйДокумент - печатная форма.
//
Функция ПечатьПоступлениеЗапчастей(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ДанныеПечати = ПолучитьДанныеПечати(МассивОбъектов);
	
	Шапка      	= ДанныеПечати.Шапка;
	ВыборкаПоТоварам = ДанныеПечати.Товары;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПоступлениеЗапчастей_Основной";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПоступлениеЗапчастей.ПФ_MXL_ПриходнаяНакладная");
	ФорматДаты = "ДФ=dd.MM.yyyy";
	
	Пока Шапка.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура("Ссылка", Шапка.Ссылка);
		ВыборкаПоТоварам.Сбросить();
		Если НЕ ВыборкаПоТоварам.НайтиСледующий(СтруктураПоиска) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 отсутствуют товары. Печать не требуется'"),
				Шапка.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				Шапка.Ссылка);
			Продолжить;
		КонецЕсли;
		
		
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОПоставщике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.ДатаДокумента);
		
		ДанныеПечатиДоп = Новый Структура();
		ДанныеПечатиДоп.Вставить("ДатаДокумента", Формат(Шапка.ДатаДокумента, ФорматДаты));
		ДанныеПечатиДоп.Вставить("ТекстЗаголовка", СтрШаблон("Поступление запчастей №%1 от %2", Шапка.НомерДокумента, Формат(Шапка.ДатаДокумента, ФорматДаты)));
		ДанныеПечатиДоп.Вставить("ПоставщикПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "НаименованиеДляПечатныхФорм,ИНН,ФактическийАдрес,Телефоны"));
		//ДанныеПечатиДоп.Вставить("Ответственный", ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Ответственный));
		//ДанныеПечатиДоп.Вставить("Проверяющий", ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Проверяющий));
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Заполнить(ДанныеПечатиДоп);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		
		// Таблица
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		СтрокаТовары = ВыборкаПоТоварам.Выбрать();
		Пока СтрокаТовары.Следующий() Цикл
			
			ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Заполнить(ДанныеПечатиДоп);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции


Функция ПолучитьДанныеПечати(МассивОбъектов)

	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Док.Ссылка КАК Ссылка,
	|	Док.Номер КАК НомерДокумента,
	|	Док.Дата КАК ДатаДокумента,
	|	Док.Склад КАК Склад,
	|	Док.Контрагенты КАК Поставщик,
	|	"""" КАК Ответственный
	|ИЗ
	|	Документ.ПоступлениеЗапчастей КАК Док
	|ГДЕ
	|	Док.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Док.МоментВремени
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТЧТовары.НомерСтроки КАК НомерСтроки,
	|	ТЧТовары.Товар КАК Товар,
	|	ВЫБОР
	|		КОГДА НЕ ТЧТовары.Товар.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА ТЧТовары.Товар.НаименованиеПолное
	|		ИНАЧЕ ТЧТовары.Товар.Наименование
	|	КОНЕЦ КАК ТоварНаименование,
	|	ТЧТовары.Товар.Артикул КАК ТоварАртикул,
	|	ТЧТовары.Товар.Код КАК ТоварКод,
	|	ТЧТовары.Товар.Производитель КАК ТоварПроизводитель,
	|	ТЧТовары.Колво КАК Количество,
	|	ТЧТовары.Цена КАК Цена,
	|	ТЧТовары.Ссылка КАК Ссылка,
	|	""шт."" КАК ЕдиницаИзмерения,
	|	ТЧТовары.Ссылка.Склад КАК Склад,
	|	ТЧТовары.СуммаПоступления КАК Сумма,
	|	ТЧТовары.Товар.Бренд.Представление КАК ТоварБренд,
	|	ТЧТовары.Товар.НомерПроизводителя КАК ТоварНомерПроизводителя
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	Документ.ПоступлениеЗапчастей.Таблица КАК ТЧТовары
	|ГДЕ
	|	ТЧТовары.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Товары.НомерСтроки КАК НомерСтроки,
	|	ВТ_Товары.Товар КАК Товар,
	|	ВТ_Товары.ТоварНаименование КАК ТоварНаименование,
	|	ВТ_Товары.ТоварАртикул КАК ТоварАртикул,
	|	ВТ_Товары.ТоварКод КАК ТоварКод,
	|	ВТ_Товары.ТоварПроизводитель КАК ТоварПроизводитель,
	|	ВТ_Товары.ТоварБренд КАК ТоварБренд,
	|	ВТ_Товары.Количество КАК Количество,
	|	ВТ_Товары.Цена КАК Цена,
	|	ВТ_Товары.Сумма КАК Сумма,
	|	ВТ_Товары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	МестаХранения.МестоХранения КАК МестоХранения,
	|	ВТ_Товары.Ссылка КАК Ссылка,
	|	ВТ_Товары.ТоварНомерПроизводителя КАК ТоварНомерПроизводителя
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_МестаХраненияНоменклатуры.СрезПоследних КАК МестаХранения
	|		ПО ВТ_Товары.Товар = МестаХранения.Номенклатура
	|			И ВТ_Товары.Склад = МестаХранения.Склад
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Шапка      	= РезультатЗапроса[0].Выбрать();
	ВыборкаПоТоварам = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Возврат Новый Структура("Шапка,Товары",
		Шапка,
		ВыборкаПоТоварам);
		
КонецФункции // ПолучитьДанныеПечатиПеремещениеТоваров()


// Функция выполняет расчет рублевых сумм для вывода таблиц документа на печать
//
Функция ПодготовитьТаблицуДокументаДляПечати(ВыборкаСтрок, ТаблицаПоТоварам)

	ТаблицаПоТоварам.Очистить();

	ВалютаРегламентированногоУчета   = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	МассивРаспределения = Новый Массив;

	СуммаВзаиморасчетов 	= 0;
	СуммаВзаиморасчетовНДС 	= 0;
	ПерваяСтрокаДокумента 	= Истина;
	СуммаВключаетНДС 		= Неопределено;
	РасчетыВУсловныхЕдиницах= Неопределено;
	ДатаДокумента			= Неопределено;

	Пока ВыборкаСтрок.Следующий() Цикл
		
		СтрокаТаблицы = ТаблицаПоТоварам.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыборкаСтрок);
		
		Если ПерваяСтрокаДокумента Тогда

			СуммаВключаетНДС 			= ВыборкаСтрок.СуммаВключаетНДС;
			РасчетыВУсловныхЕдиницах 	= ВыборкаСтрок.РасчетыВУсловныхЕдиницах;
			ДатаДокумента				= ВыборкаСтрок.ДатаДокумента;
			
			НуженПересчетВРубли = Ложь;
			
			//Если ВыборкаСтрок.Проведен 
			//	И (ВыборкаСтрок.РасчетыВУсловныхЕдиницах
			//	ИЛИ (ВыборкаСтрок.ВалютаДокумента <> ВалютаРегламентированногоУчета И ВыборкаСтрок.ДатаДокумента >= '20090101000000')) Тогда
			//	НуженПересчетВРубли = Истина;
			//КонецЕсли;
			
			ПерваяСтрокаДокумента = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаПоТоварам;

КонецФункции




#КонецОбласти 

#Область Проведение

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументОбъект, ПараметрыПроведения, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	
		
	Запрос = Новый Запрос();
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ТоварыОстатки.Номенклатура) КАК НоменклатураПредставление,
	|	ТоварыОстатки.Склад КАК Склад,
	|	ТоварыОстатки.Номенклатура КАК Товар,
	|	ТоварыОстатки.Автомобиль КАК Автомобиль,
	|	ТоварыОстатки.Партия КАК Партия,
	|	ТоварыОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыВТранзитнойЗоне.Остатки(, Распоряжение = &Ссылка) КАК ТоварыОстатки
	|ГДЕ
	|	ЕСТЬNULL(ТоварыОстатки.КоличествоОстаток, 0) < 0";
	
	//Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда

		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			// определим индекс строки табличной части для отображения баллона
			ПараметрыПоискаСтроки = Новый Структура("Товар,Партия,Автомобиль");
			ЗаполнитьЗначенияСвойств(ПараметрыПоискаСтроки, Выборка);
			СтрокиТабличнойЧасти = ДокументОбъект.Таблица.НайтиСтроки(ПараметрыПоискаСтроки);
			
			Поле = "";
			НомерСтроки = 0;
			
			Если СтрокиТабличнойЧасти.Количество() <> 0 Тогда
				
				НомерСтроки = СтрокиТабличнойЧасти[0].НомерСтроки;
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "Количество");
				
			КонецЕсли;
			
			ПрефиксСообщения = "";
			
			Если НомерСтроки <> 0 Тогда
				ПрефиксСообщения =  СтрШаблон("Строка %1: ", НомерСтроки);
			КонецЕсли;
				
			ТекстСообщения = СтрШаблон(
				"%1Недостаточно %2 (%3) в транзитной зоне %4. Нехватка: %5",
				ПрефиксСообщения, 
				Выборка.НоменклатураПредставление,
				Выборка.Партия,
				Выборка.Склад,
				-Выборка.Количество);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, Поле, "Объект", Отказ);
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры // ВыполнитьКонтроль()


#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли