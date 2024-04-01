
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПоказатьРегистры();
	
	// СтандартныеПодсистемы.Печать
	//УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	//ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	//СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	//ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	//МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	//Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	//МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЗаписьДокументаИзФормы", Истина);
	
	//МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	//МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	//СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;	
КонецПроцедуры


&НаСервере
Процедура ДатаПриИзмененииСервер()

	Если дт_Нумерация.ГодИзменен(Объект.Ссылка, Объект.Дата) Тогда
		Объект.Номер = "";
	КонецЕсли;

КонецПроцедуры // ДатаПриИзмененииСервер()

#КонецОбласти

#Область ОбработчикиСобытий

// Подключаемый обработчик события "ПриНачалеРедактирования" таблицы формы.
//
&НаКлиенте
Процедура Подключаемый_ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Период = Объект.Дата;
		ЗаполнитьЗначенияСвойств(Элемент.ТекущиеДанные, Новый Структура("Организация", Организация));
	КонецЕсли;

КонецПроцедуры

#Область ОбработчикиКоманд

&НаКлиенте
Процедура НастройкаСоставаРегистров(Команда)

	СписокИспользуемыхРегистров = Новый СписокЗначений;

	Для Каждого Строка Из Объект.ТаблицаРегистров Цикл
		СписокИспользуемыхРегистров.Добавить(Строка.Имя);
	КонецЦикла;

	ОткрытьФорму("Документ.КорректировкаРегистров.Форма.ФормаВыбораРегистра",
		Новый Структура("СписокИспользуемыхРегистров", СписокИспользуемыхРегистров),,,,, 
		Новый ОписаниеОповещения("НастройкаСоставаРегистровЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСоставаРегистровЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
        
        ОбработатьИзменениеРегистров(Результат);
        
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	//ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
	ПараметрыЗаписи = СтруктураПараметровЗаписиОбъекта();
	ПараметрыЗаписи.ЕстьВопросыПередЗаписью = Ложь;
	
	//Если ДействиеПослеЗаписи <> Неопределено Тогда
	//	ПараметрыЗаписи.Вставить("ДействиеПослеЗаписи", ДействиеПослеЗаписи);
	//КонецЕсли;
	
	ЗаписатьОбъект(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	//ОбщегоНазначенияУТКлиент.ЗаписатьИЗакрыть(ЭтаФорма);
	
	ПараметрыЗаписи = СтруктураПараметровЗаписиОбъекта();
	ПараметрыЗаписи.ЕстьВопросыПередЗаписью = Ложь;
	
	//Если ДействиеПослеЗаписи <> Неопределено Тогда
	//	ПараметрыЗаписи.Вставить("ДействиеПослеЗаписи", ДействиеПослеЗаписи);
	//КонецЕсли;
	
	ЗаписатьОбъектИЗакрыть(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Функция СоздатьСтраницу(ИмяСтраницы, Заголовок, Родитель)

	НовыйЭлемент = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Родитель);
	НовыйЭлемент.Вид                      = ВидГруппыФормы.Страница;
	НовыйЭлемент.Заголовок                = Заголовок;
	НовыйЭлемент.РастягиватьПоВертикали   = Истина;
	НовыйЭлемент.РастягиватьПоГоризонтали = Истина;

	Возврат НовыйЭлемент;

КонецФункции

&НаСервере
Функция ПолучитьИмяСтраницыРегистра(ИмяРегистра)

	Возврат "Страница" + ИмяРегистра;

КонецФункции

&НаСервере
Процедура УдалитьСтраницуРегистра(ИмяРегистра)

	Элементы.Удалить(Элементы.Найти(ПолучитьИмяСтраницыРегистра(ИмяРегистра)));

КонецПроцедуры

Функция СоздатьСвязиПараметровВыбора(ИсходныйМассив, ПутьКДанным)

	НовыйМассив = Новый Массив;
	Для Каждого Элемент Из ИсходныйМассив Цикл

		НовыйМассив.Добавить(Новый СвязьПараметраВыбора(Элемент.Имя, ПутьКДанным + "." + Элемент.ПутьКДанным, Элемент.ИзменениеЗначения));

	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(НовыйМассив);

КонецФункции

&НаСервере
// Процедура создает таблицу формы.
//
Функция СоздатьТаблицуФормыРегистра(ИмяРегистра, КолонкиТаблицы, Родитель)

	ТаблицаФормы = Элементы.Добавить("ТаблицаДвижений" + ИмяРегистра, Тип("ТаблицаФормы"), Родитель);
	ТаблицаФормы.ПутьКДанным      = "Объект.Движения." + ИмяРегистра;
	Родитель.ПутьКДаннымЗаголовка = ТаблицаФормы.ПутьКДанным + ".КоличествоСтрок";

	МассивДобавленныхПолей = Новый Массив;
	Для Каждого Колонка Из КолонкиТаблицы Цикл

		ПолеФормы = Элементы.Добавить(ТаблицаФормы.Имя + Колонка.Имя, Тип("ПолеФормы"), ТаблицаФормы);
		ПолеФормы.ПутьКДанным           = ТаблицаФормы.ПутьКДанным + "." + Колонка.Имя;
		ПолеФормы.Заголовок             = Колонка.Заголовок;
		ПолеФормы.Вид                   = ВидПоляФормы.ПолеВвода;

		МассивДобавленныхПолей.Добавить(ПолеФормы);

	КонецЦикла;

	Счетчик = 0;
	Для Каждого ПолеФормы Из МассивДобавленныхПолей Цикл

		Если КолонкиТаблицы[Счетчик].СвязиПараметровВыбора <> Неопределено И  КолонкиТаблицы[Счетчик].СвязиПараметровВыбора.Количество() > 0 Тогда

			ПолеФормы.СвязиПараметровВыбора = СоздатьСвязиПараметровВыбора(КолонкиТаблицы[Счетчик].СвязиПараметровВыбора,
									 "Элементы." + ТаблицаФормы.Имя + ".ТекущиеДанные");
		КонецЕсли;

		Счетчик = Счетчик + 1;
	
	КонецЦикла;

	Возврат ТаблицаФормы;

КонецФункции

&НаСервере
// Функция создает таблицу значений по регистру.
//
Функция СоздатьМассивПолейРегистра(МенеджерРегистра, МетаданныеРегистра)

	ТаблицаРегистра = МенеджерРегистра.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	ТаблицаРегистра.Колонки.Удалить("Регистратор");
	Если ТаблицаРегистра.Колонки.Найти("МоментВремени") <> Неопределено Тогда
		ТаблицаРегистра.Колонки.Удалить("МоментВремени");
	КонецЕсли;

	МассивКолонок = Новый Массив;
	Для Каждого Колонка Из ТаблицаРегистра.Колонки Цикл

		ИнформацияОКолонке = Новый Структура("Имя, Заголовок, СвязиПараметровВыбора",
				Колонка.Имя);

		МассивКолонок.Добавить(ИнформацияОКолонке);

	КонецЦикла;

	// Обновление заголовков колонок таблицы по синонимам полей регистра.
	МассивПолейРегистра = Новый Массив;
	МассивПолейРегистра.Добавить("Измерения");
	МассивПолейРегистра.Добавить("Ресурсы");
	МассивПолейРегистра.Добавить("Реквизиты");

	Для Каждого ВидПоля Из МассивПолейРегистра Цикл
		Для Каждого Поле Из МетаданныеРегистра[ВидПоля] Цикл
			Для Каждого ЭлементМассива Из МассивКолонок Цикл

				Если ЭлементМассива.Имя = Поле.Имя Тогда

					ЭлементМассива.Заголовок             = Поле.Синоним;
					ЭлементМассива.СвязиПараметровВыбора = Поле.СвязиПараметровВыбора;

				КонецЕсли;

			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

	Возврат МассивКолонок;

КонецФункции

&НаСервере
// Процедура управляет созданием таблицы на форме для регистра.
//
Процедура ПоказатьТаблицуРегистраНаСтранице(Знач СтрокаТЧ)

	Если Метаданные.РегистрыНакопления.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда

		СтраницаРегистра      = Элементы.НастройкаРегистровНакопления;
		МенеджерРегистра      = РегистрыНакопления[СтрокаТЧ.Имя];
		МетаданныеРегистра    = Метаданные.РегистрыНакопления[СтрокаТЧ.Имя];
		РегистрИмеетПолеПериод= Истина;

	ИначеЕсли Метаданные.РегистрыСведений.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда

		СтраницаРегистра      = Элементы.НастройкаРегистровСведений;
		МенеджерРегистра      = РегистрыСведений[СтрокаТЧ.Имя];
		МетаданныеРегистра    = Метаданные.РегистрыСведений[СтрокаТЧ.Имя];

		РегистрИмеетПолеПериод = МетаданныеРегистра.ПериодичностьРегистраСведений 
									<> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;

	Иначе

		Возврат;

	КонецЕсли;

	МассивКолонок = СоздатьМассивПолейРегистра(МенеджерРегистра, МетаданныеРегистра);

	СтраницаДляРегистра = СоздатьСтраницу(ПолучитьИмяСтраницыРегистра(СтрокаТЧ.Имя),
				МетаданныеРегистра.Синоним,
				СтраницаРегистра);

	ТаблицаФормы = СоздатьТаблицуФормыРегистра(СтрокаТЧ.Имя, МассивКолонок, СтраницаДляРегистра);

	Если РегистрИмеетПолеПериод Тогда
		ТаблицаФормы.УстановитьДействие("ПриНачалеРедактирования", "Подключаемый_ТаблицаПриНачалеРедактирования");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПоказатьРегистры()

	Для Каждого СтрокаТаб Из Объект.ТаблицаРегистров Цикл

		ПоказатьТаблицуРегистраНаСтранице(СтрокаТаб);

	КонецЦикла;

КонецПроцедуры

&НаСервере
// Процедура служит для включения/исключение регистров из списка редактируемых.
//
Процедура ОбработатьИзменениеРегистров(СписокРегистров)

	Для Каждого Элемент Из СписокРегистров Цикл

		// Нужно добавить новый регистр.
		Если Элемент.Пометка Тогда

			СтрокаТЧ = Объект.ТаблицаРегистров.Добавить();
			СтрокаТЧ.Имя = Элемент.Значение;

			ПоказатьТаблицуРегистраНаСтранице(СтрокаТЧ);

		Иначе

			Для Каждого Строка Из Объект.ТаблицаРегистров.НайтиСтроки(Новый Структура("Имя", Элемент.Значение)) Цикл
				Объект.ТаблицаРегистров.Удалить(Строка);
			КонецЦикла;

			Объект.Движения[Элемент.Значение].Очистить();
			УдалитьСтраницуРегистра(Элемент.Значение);

		КонецЕсли;

	КонецЦикла;

	Модифицированность = Истина;

КонецПроцедуры


&НаКлиенте
Функция ЗаписатьОбъект(ПараметрыЗаписи)
	
	Перем Проведен;
	
	ОчиститьСообщения();
	
	
	Если Не ПараметрыЗаписи.ЕстьВопросыПередЗаписью Тогда
		Если Не Объект.Свойство("Проведен", Проведен) Тогда
			Проведен =  Ложь;
		КонецЕсли;
		
		Если Проведен Тогда
			ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение;
		КонецЕсли;
		
		//НачатьЗамерВремениЗаписиОбъекта(Форма, ПараметрыЗаписи);
	КонецЕсли;
	
	Возврат Записать(ПараметрыЗаписи);
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьОбъектИЗакрыть(ПараметрыЗаписи)
	
	ПараметрыЗаписи.ПринудительноЗакрытьФорму = Истина;
	ОчиститьСообщения();
	
	Если ПараметрыЗаписи.ЕстьВопросыПередЗаписью Тогда
		ПараметрыЗаписи.НовыйОбъект = Не ЗначениеЗаполнено(Объект.Ссылка);
		ЭтаФорма.ПринудительноЗакрытьФорму = ПараметрыЗаписи.ПринудительноЗакрытьФорму;
		ЭтаФорма.Записать(ПараметрыЗаписи);
	Иначе
		Если ЗаписатьОбъект(ПараметрыЗаписи) Тогда
			ЭтаФорма.Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураПараметровЗаписиОбъекта()
	
	ПараметрыЗаписи = Новый Структура;
	
	ПараметрыЗаписи.Вставить("ЕстьВопросыПередЗаписью", Ложь);
	ПараметрыЗаписи.Вставить("НовыйОбъект", Ложь);
	ПараметрыЗаписи.Вставить("ПринудительноЗакрытьФорму", Ложь);
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Запись);
	ПараметрыЗаписи.Вставить("РежимПроведения", РежимПроведенияДокумента.Неоперативный);
	
	Возврат ПараметрыЗаписи;
	
КонецФункции



#КонецОбласти


