
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Параметры.Свойство("Автозаполнение") Тогда
		Объект.Владелец						= Параметры.Владелец;
		Объект.Наименование					= Параметры.Наименование;
		Объект.Должность					= Параметры.Должность;
		Объект.ПравоПодписиПоДоверенности	= Параметры.ПравоПодписиПоДоверенности;
		Объект.ДатаНачала					= Параметры.ДатаНачала;
		Объект.ДокументПраваПодписи			= Параметры.ДокументПраваПодписи;
		Объект.НомерДокументаПраваПодписи	= Параметры.НомерДокументаПраваПодписи;
		Объект.ДатаДокументаПраваПодписи	= Параметры.ДатаДокументаПраваПодписи;
	КонецЕсли;
	
	ПриСозданииЧтенииНаСервере();
	
	
	//СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
//	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
//		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
//		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
//	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	УстановитьОснованиеПраваПодписи(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)


КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

//	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	Оповестить("Запись_ФизическиеЛица", , Объект.ФизическоеЛицо);
	Оповестить("Запись_ОтветственныеЛицаОрганизаций", , Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

//	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОтветственногоЛицаПриИзменении(Элемент)
	
	Объект.ПравоПодписиПоДоверенности = Булево(ВидОтветственногоЛица);
	
	УстановитьОснованиеПраваПодписи();
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	
	НаименованиеЗаполнитьСписокВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственноеЛицоПриИзменении(Элемент)
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьСсылкаПриИзменении(Элемент)
	
	
	Если Объект.ПравоПодписиПоДоверенности Тогда
		НаименованиеЗаполнитьСписокВыбора();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ДокументПраваПодписиПриИзменении(Элемент)
	
	УстановитьОснованиеПраваПодписи();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДокументаПраваПодписиПриИзменении(Элемент)
	
	УстановитьОснованиеПраваПодписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаДокументаПраваПодписиПриИзменении(Элемент)
	
	УстановитьОснованиеПраваПодписи();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
//	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ВидОтветственногоЛица = Число(Объект.ПравоПодписиПоДоверенности);
	
	НаименованиеЗаполнитьСписокВыбора(Ложь);
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Форма.Элементы.ГруппаДокументПраваПодписи.Доступность = (Форма.ВидОтветственногоЛица = 1);
	
КонецПроцедуры


#Область ЗаполнениеСписковВыбора

&НаСервере
Процедура ДолжностиЗаполнитьСписокВыбора()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ОтветственныеЛицаОрганизаций.Должность КАК Должность
	|ИЗ
	|	Справочник.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|ГДЕ
	|	ОтветственныеЛицаОрганизаций.Должность <> """"
	|	И ОтветственныеЛицаОрганизаций.ОтветственноеЛицо = &ОтветственноеЛицо
	|	И НЕ ОтветственныеЛицаОрганизаций.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Должность";
	
	Запрос.УстановитьПараметр("ОтветственноеЛицо", Объект.ОтветственноеЛицо);
	
	МассивДолжностей = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Должность");
	Элементы.ДолжностьСтрока.СписокВыбора.ЗагрузитьЗначения(МассивДолжностей);
	
КонецПроцедуры

&НаСервере
Процедура НаименованиеЗаполнитьСписокВыбора(ОчищатьПоле = Истина)
	
	Если ОчищатьПоле Тогда
		Объект.Наименование = "";
	КонецЕсли;
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
		
		ФамилияИнициалы = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Объект.ФизическоеЛицо, Объект.ДатаНачала);
		
		Если Объект.ПравоПодписиПоДоверенности Тогда
			
			Если ЗначениеЗаполнено(Объект.ОснованиеПраваПодписи) Тогда
				Элементы.Наименование.СписокВыбора.Добавить(ФамилияИнициалы + ", " + Объект.ОснованиеПраваПодписи);
				
				Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
					КадровыеДанные = дт_Зарплата.ПолучитьКадровыеДанные(Объект.ФизическоеЛицо, , Объект.Владелец);
					
					Если КадровыеДанные <> Неопределено И ЗначениеЗаполнено(КадровыеДанные[0].Должность) Тогда
						Элементы.Наименование.СписокВыбора.Добавить(ФамилияИнициалы + ", " + КадровыеДанные[0].Должность + ", "
							+ Объект.ОснованиеПраваПодписи);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Элементы.Наименование.СписокВыбора.Добавить(ФамилияИнициалы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьОснованиеПраваПодписи(ОчищатьНаименование = Истина)
	
	Если Объект.ПравоПодписиПоДоверенности Тогда
		Объект.ОснованиеПраваПодписи =
			Объект.ДокументПраваПодписи 
			+ ?(ПустаяСтрока(Объект.НомерДокументаПраваПодписи), "", " № " + Объект.НомерДокументаПраваПодписи)
			+ ?(НЕ ЗначениеЗаполнено(Объект.ДатаДокументаПраваПодписи),  "", " " + НСтр("ru = 'от'") + " " + Формат(Объект.ДатаДокументаПраваПодписи, "ДЛФ=D") + " " + НСтр("ru = 'г.'"));
	Иначе
		Объект.ОснованиеПраваПодписи = "";
	КонецЕсли;
	
	НаименованиеЗаполнитьСписокВыбора(ОчищатьНаименование);
	
КонецПроцедуры


#КонецОбласти
