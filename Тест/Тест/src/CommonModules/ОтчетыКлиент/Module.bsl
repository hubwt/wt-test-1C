#Область ПрограммныйИнтерфейс

// Запускает процесс формирования отчета в форме отчета.
//  После завершения формирования вызывается ОбработчикЗавершения.
//
// Параметры:
//   ФормаОтчета - УправляемаяФорма - Форма отчета.
//   ОбработчикЗавершения - ОбработчикОповещения - Обработчик, который будет вызван после формирования отчета.
//     В 1й параметр процедуры, указанной в ОбработчикЗавершения,
//     передается параметр: ОтчетСформирован (Булево) - Признак того, что отчет был успешно сформирован.
//
Процедура СформироватьОтчет(ФормаОтчета, ОбработчикЗавершения = Неопределено) Экспорт
	Если ТипЗнч(ОбработчикЗавершения) = Тип("ОписаниеОповещения") Тогда
		ФормаОтчета.ОбработчикПослеФормированияНаКлиенте = ОбработчикЗавершения;
	КонецЕсли;
	ФормаОтчета.ПодключитьОбработчикОжидания("Сформировать", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. РассылкаОтчетовКлиентПереопределяемый.ПриАктивизацииСтрокиНастройки.
Процедура ПриАктивизацииСтрокиНастройки(Отчет, КомпоновщикНастроекКД, ИдентификаторКД, ТолькоПросмотрЗначения) Экспорт
	
КонецПроцедуры

// См. РассылкаОтчетовКлиентПереопределяемый.ПриНачалеВыбораНастройки.
Процедура ПриНачалеВыбораНастройки(Отчет, КомпоновщикНастроекКД, ИдентификаторКД, СтандартнаяОбработка, ОбработчикРезультата) Экспорт
	
КонецПроцедуры

// См. РассылкаОтчетовКлиентПереопределяемый.ПриОчисткеНастройки.
Процедура ПриОчисткеНастройки(Отчет, КомпоновщикНастроекКД, ИдентификаторКД, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Методы работы с СКД из формы отчета.

Функция ПараметрыВыбораОтбора(Форма, Элемент) Экспорт
	ИдентификаторЭлемента = Прав(Элемент.Имя, 32);
	
	ЭлементКД = Форма.НайтиПользовательскуюНастройкуЭлемента(ИдентификаторЭлемента);
	Если ЭлементКД = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ДополнительныеНастройки = Форма.НайтиДополнительныеНастройкиЭлемента(ИдентификаторЭлемента);
	Если ДополнительныеНастройки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура("Представление, ЗначенияДляВыбора, ЗначенияДляВыбораЗаполнены, БыстрыйВыбор,
	|ОграничиватьВыборУказаннымиЗначениями, ОписаниеТипов, ВводСписком");
	ЗаполнитьЗначенияСвойств(Результат, ДополнительныеНастройки);
	
	Если ТипЗнч(ЭлементКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Значение = ЭлементКД.ПравоеЗначение;
		Условие  = ЭлементКД.ВидСравнения;
	Иначе
		Значение = ЭлементКД.Значение;
		Условие  = ?(Результат.ВводСписком, ВидСравненияКомпоновкиДанных.ВСписке, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	ВыборГруппИЭлементов = ОтчетыКлиентСервер.ПривестиЗначениеКТипуИспользованиеГруппИЭлементов(Условие, ДополнительныеНастройки.ВыборГруппИЭлементов);
	
	// Стандартные параметры формы.
	Результат.Вставить("ЗакрыватьПриВыборе",            Истина);
	Результат.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	Результат.Вставить("Отбор",                         Новый Структура);
	// Стандартные параметры формы выбора (см. Расширение управляемой формы для динамического списка).
	Результат.Вставить("ВыборГруппИЭлементов",          ВыборГруппИЭлементов);
	Результат.Вставить("МножественныйВыбор",            Ложь);
	Результат.Вставить("РежимВыбора",                   Истина);
	// Предполагаемые реквизиты.
	Результат.Вставить("РежимОткрытияОкна",             РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Результат.Вставить("РазрешитьНачалоПеретаскивания", Ложь);
	
	Результат.Вставить("ПутьКФорме", ДополнительныеНастройки.ФормаВыбора);
	
	Результат.Вставить("Значение",   Значение);
	Результат.Вставить("Отмеченные", ОтчетыКлиентСервер.ЗначенияСписком(Значение));
	Результат.Вставить("ПараметрыВыбора", Новый Массив);
	Результат.Вставить("КлючУникальности", ИдентификаторЭлемента);
	
	// Фиксированные параметры выбора и связи от скрытых ведущих (предопределенные в текущем контексте).
	Для Каждого ПараметрВыбора Из ДополнительныеНастройки.ПараметрыВыбора Цикл
		Если ПустаяСтрока(ПараметрВыбора.Имя) Тогда
			Продолжить;
		КонецЕсли;
		Если Результат.ВводСписком Тогда
			Результат.ПараметрыВыбора.Добавить(ПараметрВыбора);
		Иначе
			Если ВРег(Лев(ПараметрВыбора.Имя, 6)) = ВРег("Отбор.") Тогда
				Результат.Отбор.Вставить(Сред(ПараметрВыбора.Имя, 7), ПараметрВыбора.Значение);
			Иначе
				Результат.Вставить(ПараметрВыбора.Имя, ПараметрВыбора.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Динамические связи от ведущих.
	Связи = Форма.ОтключаемыеСвязи.НайтиСтроки(Новый Структура("ПодчиненныйИдентификаторВФорме", ИдентификаторЭлемента));
	Для Каждого Связь Из Связи Цикл
		Если Не ЗначениеЗаполнено(Связь.ВедущийИдентификаторВФорме) Тогда
			Продолжить;
		КонецЕсли;
		ВедущийНастройкаКД = Форма.НайтиПользовательскуюНастройкуЭлемента(Связь.ВедущийИдентификаторВФорме);
		Если Не ВедущийНастройкаКД.Использование Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(ВедущийНастройкаКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗначениеВедущего = ВедущийНастройкаКД.ПравоеЗначение;
			УсловиеВедущего  = ВедущийНастройкаКД.ВидСравнения;
		Иначе
			ЗначениеВедущего = ВедущийНастройкаКД.Значение;
			ДополнительноВедущего = Форма.НайтиДополнительныеНастройкиЭлемента(Связь.ВедущийИдентификаторВФорме);
			Если ДополнительноВедущего.ВводСписком Тогда
				УсловиеВедущего = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				УсловиеВедущего = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ЗначениеВедущего) Тогда
			Продолжить;
		КонецЕсли;
		ТипЗначенияВедущего = ТипЗнч(ЗначениеВедущего);
		
		Если Связь.ТипСвязи = "ПоТипу" Тогда
			Если УсловиеВедущего <> ВидСравненияКомпоновкиДанных.Равно
				И УсловиеВедущего <> ВидСравненияКомпоновкиДанных.ВИерархии Тогда
				Продолжить;
			КонецЕсли;
			Если ТипЗнч(Связь.ПодчиненныйИмяПараметра) = Тип("Число") И Связь.ПодчиненныйИмяПараметра > 0 Тогда
				ТипСубконто = ВариантыОтчетовВызовСервера.ТипСубконто(ЗначениеВедущего, Связь.ПодчиненныйИмяПараметра);
				Если ТипЗнч(ТипСубконто) = Тип("ОписаниеТипов") Тогда
					ФильтрПоТипам = ТипСубконто.Типы();
				Иначе
					Продолжить;
				КонецЕсли;
			Иначе
				ФильтрПоТипам = Новый Массив;
				ФильтрПоТипам.Добавить(ТипЗначенияВедущего);
			КонецЕсли;
			ВычитаемыеТипы = Результат.ОписаниеТипов.Типы();
			ОписанияТиповПересекаются = Ложь;
			Для Каждого ТипКоторыйНадоОставить Из ФильтрПоТипам Цикл
				Индекс = ВычитаемыеТипы.Найти(ТипКоторыйНадоОставить);
				Если Индекс <> Неопределено Тогда
					ВычитаемыеТипы.Удалить(Индекс);
					ОписанияТиповПересекаются = Истина;
				КонецЕсли;
			КонецЦикла;
			Если ОписанияТиповПересекаются Тогда
				Результат.ОписаниеТипов = Новый ОписаниеТипов(Результат.ОписаниеТипов, , ВычитаемыеТипы);
			КонецЕсли;
		ИначеЕсли Связь.ТипСвязи = "ПоМетаданным" Или Связь.ТипСвязи = "ПараметровВыбора" Тогда
			Если Не ЗначениеЗаполнено(Связь.ПодчиненныйИмяПараметра) Тогда
				Продолжить;
			КонецЕсли;
			Если Связь.ТипСвязи = "ПоМетаданным" И Не Связь.ВедущийТип.СодержитТип(ТипЗначенияВедущего) Тогда
				Продолжить;
			КонецЕсли;
			Если Результат.ВводСписком Тогда
				Результат.ПараметрыВыбора.Добавить(Новый ПараметрВыбора(Связь.ПодчиненныйИмяПараметра, ЗначениеВедущего));
			Иначе
				Если ВРег(Лев(Связь.ПодчиненныйИмяПараметра, 6)) = ВРег("Отбор.") Тогда
					Результат.Отбор.Вставить(Сред(Связь.ПодчиненныйИмяПараметра, 7), ЗначениеВедущего);
				Иначе
					Результат.Вставить(Связь.ПодчиненныйИмяПараметра, ЗначениеВедущего);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Процедура СписокКомпоновщикаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = ПараметрыВыбораОтбора(Форма, Элемент);
	Если ПараметрыВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Форма", Форма);
	ПараметрыОбработчика.Вставить("ИдентификаторЭлемента", Прав(Элемент.Имя, 32));
	Обработчик = Новый ОписаниеОповещения("СписокКомпоновщикаЗавершениеВыбора", ЭтотОбъект, ПараметрыОбработчика);
	
	Блокировать = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыВыбора, ЭтотОбъект, , , , Обработчик, Блокировать);
КонецПроцедуры

Процедура СписокКомпоновщикаЗавершениеВыбора(РезультатВыбора, ПараметрыОбработчика) Экспорт
	Если ТипЗнч(РезультатВыбора) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	Форма = ПараметрыОбработчика.Форма;
	
	ИдентификаторЭлемента = ПараметрыОбработчика.ИдентификаторЭлемента;
	
	ПользовательскаяНастройкаКД = Форма.НайтиПользовательскуюНастройкуЭлемента(ИдентификаторЭлемента);
	ДополнительныеНастройки = Форма.НайтиДополнительныеНастройкиЭлемента(ИдентификаторЭлемента);
	
	// Загрузка выбранных значений в 2 списка.
	СписокЗначенийВСКД = Новый СписокЗначений;
	ЗаполнятьЗначенияДляВыбора = Не ДополнительныеНастройки.ОграничиватьВыборУказаннымиЗначениями
		Или Не ДополнительныеНастройки.ЗначенияДляВыбораЗаполнены;
	Если ЗаполнятьЗначенияДляВыбора Тогда
		ЗначенияДляВыбора = Новый СписокЗначений;
	КонецЕсли;
	Для Каждого ЭлементСпискаВФорме Из РезультатВыбора Цикл
		ЗначениеВФорме = ЭлементСпискаВФорме.Значение;
		Если ЗаполнятьЗначенияДляВыбора И ЗначенияДляВыбора.НайтиПоЗначению(ЗначениеВФорме) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ЗначенияДляВыбора.Добавить(), ЭлементСпискаВФорме, "Значение, Представление");
		КонецЕсли;
		Если ЭлементСпискаВФорме.Пометка Тогда
			ОтчетыКлиентСервер.ДобавитьУникальноеЗначениеВСписок(СписокЗначенийВСКД, ЗначениеВФорме, ЭлементСпискаВФорме.Представление, Истина);
		КонецЕсли;
	КонецЦикла;
	Если ЗаполнятьЗначенияДляВыбора Тогда
		ДополнительныеНастройки.ЗначенияДляВыбора = ЗначенияДляВыбора;
		ДополнительныеНастройки.ЗначенияДляВыбораЗаполнены = Истина;
	КонецЕсли;
	Если ТипЗнч(ПользовательскаяНастройкаКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ПользовательскаяНастройкаКД.ПравоеЗначение = СписокЗначенийВСКД;
	Иначе
		ПользовательскаяНастройкаКД.Значение = СписокЗначенийВСКД;
	КонецЕсли;
	
	// Включение флажка Использование.
	ПользовательскаяНастройкаКД.Использование = Истина;
	
	Форма.ПользовательскиеНастройкиМодифицированы = Истина;
КонецПроцедуры

Процедура ИзменитьВидСравнения(Форма, ИдентификаторЭлемента, ОбработчикРезультата) Экспорт
	ПользовательскаяНастройкаКД = Форма.НайтиПользовательскуюНастройкуЭлемента(ИдентификаторЭлемента);
	Если ПользовательскаяНастройкаКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДополнительныеНастройки = Форма.НайтиДополнительныеНастройкиЭлемента(ИдентификаторЭлемента);
	Если ДополнительныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнформацияОТипах = ОтчетыКлиентСервер.АнализТипов(ДополнительныеНастройки.ОписаниеТипов, Ложь);
	
	Список = Новый СписокЗначений;
	
	Если ИнформацияОТипах.ОграниченнойДлины Тогда
		
		Список.Добавить(ВидСравненияКомпоновкиДанных.Равно);
		Список.Добавить(ВидСравненияКомпоновкиДанных.НеРавно);
		
		Список.Добавить(ВидСравненияКомпоновкиДанных.ВСписке);
		Список.Добавить(ВидСравненияКомпоновкиДанных.НеВСписке);
		
		Если ИнформацияОТипах.СодержитОбъектныеТипы Тогда
			
			Список.Добавить(ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии); // НСтр("ru = 'В списке включая подчиненные'")
			Список.Добавить(ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии); // НСтр("ru = 'Не в списке включая подчиненные'").
			
			Список.Добавить(ВидСравненияКомпоновкиДанных.ВИерархии); // НСтр("ru = 'В группе'")
			Список.Добавить(ВидСравненияКомпоновкиДанных.НеВИерархии); // НСтр("ru = 'Не в группе'")
			
		КонецЕсли;
		
		Если ИнформацияОТипах.КоличествоПримитивныхТипов > 0 Тогда
			
			Список.Добавить(ВидСравненияКомпоновкиДанных.Меньше);
			Список.Добавить(ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			
			Список.Добавить(ВидСравненияКомпоновкиДанных.Больше);
			Список.Добавить(ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИнформацияОТипах.СодержитТипСтрока Тогда
		
		Список.Добавить(ВидСравненияКомпоновкиДанных.Содержит);
		Список.Добавить(ВидСравненияКомпоновкиДанных.НеСодержит);
		
		Список.Добавить(ВидСравненияКомпоновкиДанных.Подобно);
		Список.Добавить(ВидСравненияКомпоновкиДанных.НеПодобно);
		
		Список.Добавить(ВидСравненияКомпоновкиДанных.НачинаетсяС);
		Список.Добавить(ВидСравненияКомпоновкиДанных.НеНачинаетсяС);
		
	КонецЕсли;
	
	Если ИнформацияОТипах.ОграниченнойДлины Тогда
		
		Список.Добавить(ВидСравненияКомпоновкиДанных.Заполнено);
		Список.Добавить(ВидСравненияКомпоновкиДанных.НеЗаполнено);
		
	КонецЕсли;
	
	ТекущийЭлемент = Список.НайтиПоЗначению(ПользовательскаяНастройкаКД.ВидСравнения);
	
	Контекст = Новый Структура;
	Контекст.Вставить("Форма", Форма);
	Контекст.Вставить("ИдентификаторЭлемента", ИдентификаторЭлемента);
	Контекст.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	
	Обработчик = Новый ОписаниеОповещения("ИзменитьВидСравненияЗавершение", ЭтотОбъект, Контекст);
	ФормаЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Условие отбора поля ""%1""'"), ДополнительныеНастройки.Представление);
	
	Список.ПоказатьВыборЭлемента(Обработчик, ФормаЗаголовок, ТекущийЭлемент);
КонецПроцедуры

Процедура ИзменитьВидСравненияЗавершение(ЭлементСписка, Контекст) Экспорт
	Если ЭлементСписка = Неопределено Тогда
		Результат = Неопределено;
	Иначе
		Результат = ЭлементСписка.Значение;
		ПользовательскаяНастройкаКД = Контекст.Форма.НайтиПользовательскуюНастройкуЭлемента(Контекст.ИдентификаторЭлемента);
		ПользовательскаяНастройкаКД.ВидСравнения = Результат;
	КонецЕсли;
	
	Если Контекст.ОбработчикРезультата <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработчикРезультата, Результат);
	КонецЕсли;
КонецПроцедуры

Процедура ЗначениеКомпоновщикаНачалоВыбора(Форма, Элемент, ЗначенияДляВыбора, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = ПараметрыВыбораОтбора(Форма, Элемент);
	Если ПараметрыВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыбора.Вставить("МножественныйВыбор", Ложь);
	
	Контекст = Новый Структура;
	Контекст.Вставить("Элемент",         Элемент);
	Контекст.Вставить("Форма",           Форма);
	Контекст.Вставить("Идентификатор",   Прав(Элемент.Имя, 32));
	Контекст.Вставить("ПараметрыВыбора", ПараметрыВыбора);
	
	// Полное имя формы выбора.
	// Свойство "ФормаВыбора" недоступно на клиенте даже для чтения,
	//   поэтому для хранения предустановленных имен форм выбора используется коллекция БыстрыйПоискИменОбъектовМетаданных.
	Если ЗначениеЗаполнено(ПараметрыВыбора.ПутьКФорме) Тогда
		Обработчик = Новый ОписаниеОповещения("ЗначениеКомпоновщикаЗавершениеВыбора", ЭтотОбъект, Контекст);
		ОткрытьФорму(
			ПараметрыВыбора.ПутьКФорме,
			ПараметрыВыбора,
			Контекст.Форма,
			,
			,
			,
			Обработчик,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		// Выбор типа из списка.
		Обработчик = Новый ОписаниеОповещения("ЗначениеКомпоновщикаПоказатьВыборСсылкиПослеВыбораТипа", ЭтотОбъект, Контекст);
		СписокВыбора = Новый СписокЗначений;
		СписокВыбора.ЗагрузитьЗначения(ПараметрыВыбора.ОписаниеТипов.Типы());
		Если СписокВыбора.Количество() = 1 Тогда // Один тип - выбор не требуется.
			ВыполнитьОбработкуОповещения(Обработчик, СписокВыбора[0]);
		Иначе
			Форма.ПоказатьВыборИзМеню(Обработчик, СписокВыбора);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ЗначениеКомпоновщикаПоказатьВыборСсылкиПослеВыбораТипа(ПутьКФормеИлиЭлементСписка, Контекст) Экспорт
	Если ТипЗнч(ПутьКФормеИлиЭлементСписка) <> Тип("ЭлементСпискаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ЗначениеКомпоновщикаЗавершениеВыбора", ЭтотОбъект, Контекст);
	ПараметрыВыбора = Контекст.ПараметрыВыбора;
	
	Тип = ПутьКФормеИлиЭлементСписка.Значение;
	ПараметрыВыбораТипа = ВариантыОтчетовВызовСервера.ПараметрыВыбораТипа(Тип, ПараметрыВыбора);
	Если ПараметрыВыбораТипа = Неопределено Тогда
		ВыбратьЗначениеПримитивногоТипа(
			Контекст.Форма,
			Тип,
			ПараметрыВыбора.ОписаниеТипов,
			ПараметрыВыбора.Значение,
			ПараметрыВыбора.Представление,
			Обработчик);
	ИначеЕсли ПараметрыВыбораТипа.БыстрыйВыбор Тогда
		Контекст.Форма.ПоказатьВыборИзМеню(Обработчик, ПараметрыВыбораТипа.ЗначенияДляВыбора);
	Иначе
		ОткрытьФорму(
			ПараметрыВыбораТипа.ПутьКФорме,
			ПараметрыВыбора,
			Контекст.Форма,
			,
			,
			,
			Обработчик,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗначениеКомпоновщикаЗавершениеВыбора(СсылкаИлиЭлементСписка, Контекст) Экспорт
	Если ТипЗнч(СсылкаИлиЭлементСписка) = Тип("ЭлементСпискаЗначений") Тогда
		Ссылка = СсылкаИлиЭлементСписка.Значение;
	Иначе
		Ссылка = СсылкаИлиЭлементСписка;
	КонецЕсли;
	Если Не Контекст.ПараметрыВыбора.ОписаниеТипов.СодержитТип(ТипЗнч(Ссылка)) Или Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Форма = Контекст.Форма;
	
	ЭлементКД = Форма.НайтиПользовательскуюНастройкуЭлемента(Контекст.Идентификатор);
	ДополнительныеНастройки = Форма.НайтиДополнительныеНастройкиЭлемента(Контекст.Идентификатор);
	
	Если ТипЗнч(ЭлементКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ЭлементКД.ПравоеЗначение = Ссылка;
	Иначе
		ЭлементКД.Значение = Ссылка;
	КонецЕсли;
	
	ЭлементКД.Использование = Истина; // Включение флажка.
	
	ОтразитьИзмененияВПодчиненных(Форма, Контекст.Идентификатор, ЭлементКД);
	
	Форма.ПользовательскиеНастройкиМодифицированы = Истина;
КонецПроцедуры

Процедура ВыбратьПериод(Форма, КнопкаВыбораИмя) Экспорт
	ЗначениеИмя = СтрЗаменить(КнопкаВыбораИмя, "_КнопкаВыбора_", "_Значение_");
	ИдентификаторЭлемента = Прав(КнопкаВыбораИмя, 32);
	
	Значение = Форма[ЗначениеИмя];
	
	Контекст = Новый Структура;
	Контекст.Вставить("Форма", Форма);
	Контекст.Вставить("ЗначениеИмя", ЗначениеИмя);
	Контекст.Вставить("ИдентификаторЭлемента", ИдентификаторЭлемента);
	Обработчик = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект, Контекст);
	
	СтандартнаяОбработка = Истина;
	ОтчетыКлиентПереопределяемый.ПриНажатииКнопкиВыбораПериода(Форма, Значение, СтандартнаяОбработка, Обработчик);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = Значение;
	Диалог.Показать(Обработчик);
КонецПроцедуры

Процедура ВыбратьПериодЗавершение(Период, Контекст) Экспорт
	Если ТипЗнч(Период) <> Тип("СтандартныйПериод") Тогда
		Возврат;
	КонецЕсли;
	
	Контекст.Форма[Контекст.ЗначениеИмя] = Период;
	
	ЭлементКД = Контекст.Форма.НайтиПользовательскуюНастройкуЭлемента(Контекст.ИдентификаторЭлемента);
	Если ТипЗнч(ЭлементКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ЭлементКД.ПравоеЗначение = Период;
	ИначеЕсли ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		ЭлементКД.Значение = Период;
	КонецЕсли;
	ЭлементКД.Использование = Истина;
	
	Контекст.Форма.ПользовательскиеНастройкиМодифицированы = Истина;
КонецПроцедуры

Процедура ВыбратьЗначениеПримитивногоТипа(Форма, ТипЗначения, ОписаниеТипов, ТекущееЗначение, ПредставлениеПоля, Обработчик) Экспорт
	СписокВыбора = Новый СписокЗначений;
	Если ТипЗначения = Тип("ВидДвиженияБухгалтерии") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокВыбора, ВидДвиженияБухгалтерии);
	ИначеЕсли ТипЗначения = Тип("ВидДвиженияНакопления") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокВыбора, ВидДвиженияНакопления);
	ИначеЕсли ТипЗначения = Тип("ВидПериодаРегистраРасчета") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокВыбора, ВидПериодаРегистраРасчета);
	ИначеЕсли ТипЗначения = Тип("ВидСчета") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокВыбора, ВидСчета);
	ИначеЕсли ТипЗначения = Тип("ВидТочкиМаршрутаБизнесПроцесса") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СписокВыбора, ВидТочкиМаршрутаБизнесПроцесса);
	ИначеЕсли ТипЗначения = Тип("Число") Тогда
		ПоказатьВводЧисла(
			Обработчик,
			ТекущееЗначение,
			ПредставлениеПоля,
			ОписаниеТипов.КвалификаторыЧисла.Разрядность,
			ОписаниеТипов.КвалификаторыЧисла.РазрядностьДробнойЧасти);
		Возврат;
	ИначеЕсли ТипЗначения = Тип("Строка") Тогда
		ПоказатьВводСтроки(
			Обработчик,
			ТекущееЗначение,
			ПредставлениеПоля,
			ОписаниеТипов.КвалификаторыСтроки.Длина,
			ОписаниеТипов.КвалификаторыСтроки.Длина = 0 Или ОписаниеТипов.КвалификаторыСтроки.Длина > 100);
		Возврат;
	ИначеЕсли ТипЗначения = Тип("Дата") Тогда
		ПоказатьВводДаты(
			Обработчик,
			ТекущееЗначение,
			ПредставлениеПоля,
			ОписаниеТипов.КвалификаторыДаты.ЧастиДаты);
		Возврат;
	Иначе
		ПоказатьВводЗначения(
			Обработчик,
			ТекущееЗначение,
			ПредставлениеПоля,
			ОписаниеТипов);
		Возврат;
	КонецЕсли;
	Форма.ПоказатьВыборИзМеню(Обработчик, СписокВыбора);
КонецПроцедуры

Процедура ОтразитьИзмененияВПодчиненных(Форма, ИдентификаторЭлемента, НастройкаКомпоновкиДанныхВедущего) Экспорт
	
	// Очистка значений при изменении значения.
	Найденные = Форма.ОтключаемыеСвязи.НайтиСтроки(Новый Структура("ВедущийИдентификаторВФорме", ИдентификаторЭлемента));
	Для Каждого Связь Из Найденные Цикл
		Если Не ЗначениеЗаполнено(Связь.ПодчиненныйИдентификаторВФорме) Тогда
			Продолжить;
		КонецЕсли;
		Если Связь.ТипСвязи = "ПараметровВыбора" Тогда
			Если Связь.ПодчиненныйДействие = РежимИзмененияСвязанногоЗначения.Очищать Тогда
				ОчиститьЗначениеПодчиненного(Форма, НастройкаКомпоновкиДанныхВедущего, Связь.ПодчиненныйИдентификаторВФорме);
			КонецЕсли;
		Иначе
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьЗначениеПодчиненного(Форма, НастройкаКомпоновкиДанныхВедущего, ИдентификаторПодчиненногоВФорме)
	ПодчиненныйНастройкаКД = Форма.НайтиПользовательскуюНастройкуЭлемента(ИдентификаторПодчиненногоВФорме);
	ПодчиненныйДополнительно = Форма.НайтиДополнительныеНастройкиЭлемента(ИдентификаторПодчиненногоВФорме);
	Если ПодчиненныйДополнительно = Неопределено Или ПодчиненныйНастройкаКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкаКомпоновкиДанныхВедущего.Использование Тогда
		Если ПодчиненныйДополнительно.ВводСписком Тогда
			Если ТипЗнч(ПодчиненныйНастройкаКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				ПодчиненныйНастройкаКД.Значение = Новый СписокЗначений;
			ИначеЕсли ТипЗнч(ПодчиненныйНастройкаКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				ПодчиненныйНастройкаКД.ПравоеЗначение = Новый СписокЗначений;
			КонецЕсли;
		Иначе
			Если ТипЗнч(ПодчиненныйНастройкаКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				ПодчиненныйНастройкаКД.Значение = Неопределено;
			ИначеЕсли ТипЗнч(ПодчиненныйНастройкаКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				ПодчиненныйНастройкаКД.ПравоеЗначение = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ПодчиненныйДополнительно.БыстрыйВыбор
		И Не ПодчиненныйДополнительно.ОграничиватьВыборУказаннымиЗначениями Тогда
		ПодчиненныйДополнительно.ЗначенияДляВыбораЗаполнены = Ложь;
		ПодчиненныйДополнительно.ЗначенияДляВыбора.Очистить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти