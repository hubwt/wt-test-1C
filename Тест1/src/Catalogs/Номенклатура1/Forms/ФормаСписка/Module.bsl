//#Область ОбработчикиСобытийФормы

//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	
//	// СтандартныеПодсистемы.ПодключаемыеКоманды
//	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
//	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
//	
//	Если Параметры.Свойство("Заголовок") Тогда
//		Заголовок = Параметры.Заголовок;
//	КонецЕсли;
//	
//	Если Параметры.Свойство("ВидОтображенияТаблицы") Тогда
//		// В некоторых случаях нужно открывать список номенклатуры с отбором по списку элементов.
//		// В этом случае иерархический список выглядит плохо - в нем выводятся все группы справочника, даже если в них нет элементов.
//		// Поэтому для таких случаев можно переопределить отображение списка: вместо иерархического использовать плоскую таблицу.
//		Элементы.Список.Отображение = Параметры.ВидОтображенияТаблицы;
//	КонецЕсли;
//	
//	// СтандартныеПодсистемы.ВерсионированиеОбъектов
//	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
//	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
//	
//	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Номенклатура);
//	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
//	
//	УстановитьУсловноеОформление();
//	
//	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
//	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
//	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
//		ЭтаФорма,
//		"БП.Справочник.Номенклатура",
//		"ФормаСписка",
//		НСтр("ru='Новости: Номенклатура'"),
//		ИдентификаторыСобытийПриОткрытии
//	);
//	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
//	
//	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
//	
//	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
//	РаботаСНоменклатурой.ПриСозданииНаСервереФормаСпискаНоменклатуры(
//		ЭтотОбъект,
//		Элементы.ГруппаКомандыРаботаСНоменклатурой,
//		Элементы.Список,,
//		Новый Структура("ДобавитьКомандыСопоставления", Ложь));
//	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
//	
//	РаботаСНоменклатуройБП.ЗаполнитьРеквизитыФормыДляРаботыСервиса(ЭтотОбъект);
//	
//	ИспользоватьПодключаемоеОборудование = ПравоДоступа("Чтение", Метаданные.Справочники.ПодключаемоеОборудование);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПриОткрытии(Отказ)
//	
//	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
//	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
//	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
//	
//	Если ИспользоватьПодключаемоеОборудование Тогда
//		ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
//		
//		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
//			Неопределено,
//			ЭтотОбъект,
//			ПоддерживаемыеТипыПодключаемогоОборудования);
//	КонецЕсли;
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
//	
//	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
//	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
//	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
//	
//	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
//	Если ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().ЗагрузкаНоменклатуры Тогда
//		Если Параметр.СозданныеОбъекты.Количество() > 0 Тогда
//			Элементы.Список.ТекущаяСтрока = Параметр.СозданныеОбъекты[0].Номенклатура;
//		КонецЕсли;
//	ИначеЕсли ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().СопоставлениеНоменклатуры Тогда
//		Элементы.Список.Обновить();
//	КонецЕсли;
//	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
//	
//	// ПодключаемоеОборудование
//	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
//		Если  ИмяСобытия = "ScanData" Тогда
//			ДанныеСоСканера = МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
//			Если ДанныеСоСканера.Количество() > 0 Тогда
//				НайтиПоШтрихкоду(ДанныеСоСканера[0]);
//			КонецЕсли;
//		КонецЕсли;
//	КонецЕсли;
//	// Конец ПодключаемоеОборудование
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПриЗакрытии(ЗавершениеРаботы)
//	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
//КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

//&НаКлиенте
//Процедура СписокПриАктивизацииСтроки(Элемент)
//	
//	// СтандартныеПодсистемы.ПодключаемыеКоманды
//	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
//	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
//	
//КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиКомандФормы

//&НаКлиенте
//Процедура ПоказатьКонтекстныеНовости(Команда)

//	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
//		ЭтаФорма,
//		Команда
//	);

//КонецПроцедуры

//&НаКлиенте
//Процедура ИзменитьВыделенные(Команда)
//	
//	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

//КонецПроцедуры

//// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
//&НаКлиенте
//Процедура Подключаемый_ВыполнитьКомандуРаботаСНоменклатурой(Команда)
//	РаботаСНоменклатуройКлиент.ВыполнитьПодключаемуюКоманду(ЭтотОбъект, Команда);
//КонецПроцедуры

//&НаКлиенте
//Процедура Подключаемый_ВыборРаботаСНоменклатурой(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
//	РаботаСНоменклатуройКлиент.ВыборВТаблицеФормы(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
//КонецПроцедуры
//// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой

//&НаКлиенте
//Процедура ПоискПоШтрихкоду(Команда)
//	
//	НайтиПоШтрихкоду();
//	
//КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиСобытийТаблицыФормыСписок

//&НаКлиенте
//Процедура СписокПриИзменении(Элемент)
//	
//	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
//	
//	Если НЕ Группа Тогда
//		КлючеваяОперация = "СозданиеФормыНоменклатура";
//		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
//	КонецЕсли;

//КонецПроцедуры

//&НаКлиенте
//Процедура СписокПередНачаломИзменения(Элемент, Отказ)
//	
//	Если НЕ Элемент.ТекущиеДанные.ЭтоГруппа Тогда
//		КлючеваяОперация = "ОткрытиеФормыНоменклатура";
//		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
//	КонецЕсли;
//	
//КонецПроцедуры

//&НаСервере
//Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
//	
//	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
//	
//КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункцииБСП

//// СтандартныеПодсистемы.ПодключаемыеКоманды
//&НаКлиенте
//Процедура Подключаемый_ВыполнитьКоманду(Команда)
//	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
//КонецПроцедуры

//&НаСервере
//Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
//	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
//КонецПроцедуры

//&НаКлиенте
//Процедура Подключаемый_ОбновитьКоманды()
//	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
//КонецПроцедуры
//// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//#КонецОбласти

//#Область СлужебныеФункцииИПроцедуры

//// Процедура показывает новости, требующие прочтения (важные и очень важные)
////
//// Параметры:
////  Нет
////
//&НаКлиенте
//Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

//	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
//	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
//	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

//	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

//КонецПроцедуры

//&НаСервере
//Процедура УстановитьУсловноеОформление()
//	
//	ТекущаяДатаПользователя = ОбщегоНазначения.ТекущаяДатаПользователя();
//	
//	Для Каждого ВидСтавки Из Перечисления.ВидыСтавокНДС Цикл
//		
//		ЭлементУО = УсловноеОформление.Элементы.Добавить();

//		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВидСтавкиНДС");

//		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
//			"Список.ВидСтавкиНДС", ВидСравненияКомпоновкиДанных.Равно, ВидСтавки);

//		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст",
//			Строка(Перечисления.СтавкиНДС.СтавкаНДС(ВидСтавки, ТекущаяДатаПользователя)));
//		
//	КонецЦикла;
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура НайтиПоШтрихкоду(ДополнительныеПараметры = Неопределено)
//	
//	Если ДополнительныеПараметры = Неопределено Тогда
//		ДополнительныеПараметры = Новый Структура;
//	КонецЕсли;
//	ДополнительныеПараметры.Вставить("ТекстВопроса", НСтр("ru = 'Хотите поискать в сервисе 1С:Номенклатура?'"));
//	
//	Оповещение = Новый ОписаниеОповещения("НайтиПоШтрихкодуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
//	РаботаСНоменклатуройКлиентБП.НайтиПоШтрихкоду(Оповещение);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура НайтиПоШтрихкодуЗавершение(Результат, ДополнительныеПараметры) Экспорт
//	
//	Перем РезультатШтрихкод, РезультатИдентификатор, РезультатНоменклатура;
//	
//	Если ТипЗнч(Результат) = Тип("Структура") Тогда
//		Результат.Свойство("Штрихкод", РезультатШтрихкод);
//		Результат.Свойство("Идентификатор", РезультатИдентификатор);
//		Результат.Свойство("Номенклатура", РезультатНоменклатура);
//		
//		Результат.Свойство("СервисАктивен", СервисАктивен);
//		Результат.Свойство("ИнтернетПоддержкаПодключена", ИнтернетПоддержкаПодключена);
//	КонецЕсли;
//	
//	Если ЗначениеЗаполнено(РезультатНоменклатура) Тогда
//		Элементы.Список.ТекущаяСтрока = РезультатНоменклатура;
//		ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", Новый Структура("Ключ", РезультатНоменклатура));
//	ИначеЕсли ЗначениеЗаполнено(РезультатИдентификатор) Тогда 
//		ПараметрыСоздания = Новый Структура;
//		ПараметрыСоздания.Вставить("ИдентификаторСервиса", РезультатИдентификатор);
//		ПараметрыСоздания.Вставить("Штрихкод", РезультатШтрихкод);
//		ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыСоздания);
//	Иначе 
//		ПоказатьПредупреждение(, СтрШаблон(НСтр("ru = 'По штрихкоду %1 номенклатура не найдена.'"), РезультатШтрихкод));
//	КонецЕсли;
//	
//КонецПроцедуры

//#КонецОбласти