#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость =
			РегламентныеЗаданияСервер.РаботаСВнешнимиРесурсамиЗаблокирована();
		
		Элементы.ГруппаОбработкаРегламентныеИФоновыеЗадания.Видимость =
			Пользователи.ЭтоПолноправныйПользователь(, Истина);
	Иначе
		Элементы.ГруппаОбработкаРегламентныеИФоновыеЗадания.Видимость = Ложь;
		Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами") Тогда
		Элементы.ГруппаОбработкаУправлениеИтогамиИАгрегатамиОткрыть.Видимость =
			  Пользователи.ЭтоПолноправныйПользователь()
			И Не ОбщегоНазначения.РазделениеВключено();
	Иначе
		Элементы.ГруппаОбработкаУправлениеИтогамиИАгрегатамиОткрыть.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость =
			  Пользователи.ЭтоПолноправныйПользователь(, Истина)
			И Не ОбщегоНазначения.РазделениеВключено()
			И Не ОбщегоНазначенияКлиентСервер.КлиентПодключенЧерезВебСервер()
			И ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент();
		
		ОбновитьНастройкиРезервногоКопирования();
	Иначе
		Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		Элементы.ГруппаОценкаПроизводительности.Видимость =
			Пользователи.ЭтоПолноправныйПользователь(, Истина);
	Иначе
		Элементы.ГруппаОценкаПроизводительности.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		Элементы.ГруппаОбработкаГрупповоеИзменениеОбъектов.Видимость =
			Пользователи.ЭтоПолноправныйПользователь();
	Иначе
		Элементы.ГруппаОбработкаГрупповоеИзменениеОбъектов.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПоискИУдалениеДублей") Тогда
		Элементы.ГруппаПоискИУдалениеДублей.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		Элементы.ГруппаДополнительныеОтчетыИОбработки.Видимость =
			НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	Иначе
		Элементы.ГруппаДополнительныеОтчетыИОбработки.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		Элементы.ГруппаУстановкаОбновлений.Видимость =
			  Пользователи.ЭтоПолноправныйПользователь(, Истина)
			И Не ОбщегоНазначения.ЭтоАвтономноеРабочееМесто()
			И Не ОбщегоНазначения.РазделениеВключено()
			И Не ОбщегоНазначенияКлиентСервер.КлиентПодключенЧерезВебСервер()
			И ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент();
	Иначе
		Элементы.ГруппаУстановкаОбновлений.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
		МодульОблачныйАрхив.ПанельАдминистрированияБСП_ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		Если Элементы.Найти("ПравилПроверкиУчета") <> Неопределено Тогда
			Элементы.ПравилаПроверкиУчета.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.ОбслуживаниеПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_ПриОткрытии(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытаФормаНастройкиРезервногоКопирования"
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		ОбновитьНастройкиРезервногоКопирования();
	ИначеЕсли ИмяСобытия = "РазрешенаРаботаСВнешнимиРесурсами" Тогда
		Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыполнятьЗамерыПроизводительностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДетализироватьОбновлениеИБВЖурналеРегистрацииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#Область ИнтернетПоддержкаПользователей_ОблачныйАрхив

&НаКлиенте
Процедура ОблачныйАрхивОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Истина;

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ОбработкаНавигационнойСсылки(
			ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка, Новый Структура);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СпособРезервногоКопированияПриИзменении(Элемент)

	// В зависимости от состояния, вывести правильную страницу.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_СпособРезервногоКопированияПриИзменении(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазблокироватьРаботуСВнешнимиРесурсами(Команда)
	РазблокироватьРаботуСВнешнимиРесурсамиНаСервере();
	Оповестить("РазрешенаРаботаСВнешнимиРесурсами");
КонецПроцедуры

&НаКлиенте
Процедура ОтложеннаяОбработкаДанных(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзПанелиАдминистрирования", Истина);
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОтложенногоОбновленияИБ", ПараметрыФормы);
КонецПроцедуры

#Область ИнтернетПоддержкаПользователей_ОблачныйАрхив

&НаКлиенте
Процедура ПодключитьСервисОблачныйАрхив(Команда)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПодключитьСервисОблачныйАрхив();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОблачныйАрхивВосстановлениеИзРезервнойКопииНажатие(Элемент)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ВосстановлениеИзРезервнойКопии();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОблачныйАрхивНастройкаРезервногоКопированияНажатие(Элемент)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.НастройкаРезервногоКопирования();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, НеобходимоОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую.
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности")
		И (РеквизитПутьКДанным = "НаборКонстант.ВыполнятьЗамерыПроизводительности"
		Или РеквизитПутьКДанным = "") Тогда
			ЭлементОбработкаОценкаПроизводительности = Элементы.Найти("ОбработкаОценкаПроизводительности");
			ЭлементОбработкаНастройкиОценкиПроизводительности = Элементы.Найти("ОбработкаНастройкиОценкиПроизводительности");
			Если (ЭлементОбработкаОценкаПроизводительности <> Неопределено И ЭлементОбработкаНастройкиОценкиПроизводительности <> Неопределено И НаборКонстант.Свойство("ВыполнятьЗамерыПроизводительности")) Тогда
				ЭлементОбработкаОценкаПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
				ЭлементОбработкаНастройкиОценкиПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
			КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиРезервногоКопирования()
	
	Если Не ОбщегоНазначения.РазделениеВключено()
	   И Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		МодульРезервноеКопированиеИБСервер = ОбщегоНазначения.ОбщийМодуль("РезервноеКопированиеИБСервер");
		Элементы.НастройкаРезервногоКопированияИБ.РасширеннаяПодсказка.Заголовок = МодульРезервноеКопированиеИБСервер.ТекущаяНастройкаРезервногоКопирования();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РазблокироватьРаботуСВнешнимиРесурсамиНаСервере()
	Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	МодульРегламентныеЗаданияСлужебный = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСлужебный");
	МодульРегламентныеЗаданияСлужебный.РазрешитьРаботуСВнешнимиРесурсами();
КонецПроцедуры

#Область ИнтернетПоддержкаПользователей_ОблачныйАрхив

&НаКлиенте
Процедура Подключаемый_ПроверитьСостояниеОблачногоАрхива()

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОблачныйАрхивКлиент");
		МодульОблачныйАрхивКлиент.ПанельАдминистрированияБСП_ПроверитьСостояниеОблачногоАрхива(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти