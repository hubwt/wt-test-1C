
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекДата", НачалоДня(ТекущаяДата()));
	
	///+ГомзМА 03.10.2023
	СписокСотрудники.Параметры.УстановитьЗначениеПараметра("ТекДата", НачалоДня(ТекущаяДата()));
	///-ГомзМА 03.10.2023
	
	УстановитьУсловноеОформление();
	
	УстановитьВидимость();
	
	///+ГомзМА 09.10.2023
	ЗаполнитьПодвал();
	///-ГомзМА 09.10.2023
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОстаткиБалансИзменение" Тогда
		
		Элементы.Список.Обновить();

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьСуммуИтого();
	
КонецПроцедуры


#КонецОбласти
#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура КомандаОплачено(Команда)
	
	ИзменитьПризнакОплаченоКлиент(ПредопределенноеЗначение("Перечисление.СостоянияВзаиморасчетов.Оплачено"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНеОплачено(Команда)
	
	ИзменитьПризнакОплаченоКлиент(ПредопределенноеЗначение("Перечисление.СостоянияВзаиморасчетов.Долг"));
	
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьПризнакОплаченоКлиент(СостояниеУстановить)

	Отказ = Ложь;
	ДокументыКИзменению = Новый Массив();
	
	Для каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		
		ТекСтрока = Элементы.Список.ДанныеСтроки(СтрокаСписка);
		Если ТекСтрока.СостояниеРасчетов <> СостояниеУстановить Тогда
			ДокументыКИзменению.Добавить(СтрокаСписка);	
		КонецЕсли;	
		
	КонецЦикла;
	
	Если ДокументыКИзменению.Количество() <> 0 Тогда
		
		ИзменитьПризнакОплачено(ДокументыКИзменению, СостояниеУстановить, Отказ);
		Элементы.Список.Обновить();
		
	КонецЕсли;
	

КонецПроцедуры // ИзменитьПризнакОплаченоКлиент()

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИзменитьПризнакОплачено(ДокументыКИзменению, СостояниеУстановить, Отказ = Ложь)
	
	Для каждого ДокументСсылка Из ДокументыКИзменению Цикл
	
		ДокОбъект = ДокументСсылка.ПолучитьОбъект();
		
		Попытка
			ДокОбъект.Заблокировать();
			ДокОбъект.СостояниеРасчетов = СостояниеУстановить;
			ДокОбъект.ОбменДанными.Загрузка = Истина;
			ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон("Не удалось изменить состояние расчетов %1. %2",
					ДокОбъект,
					ОписаниеОшибки()),
				,
				,
				,
				Отказ
			);
		КонецПопытки;
			
	
	КонецЦикла;

КонецПроцедуры // ИзменитьПризнакОплачено()


&НаКлиенте
Процедура ОбновитьСуммуИтого()

	//ВыделенныеСтроки = Новый Массив();
	//Для каждого СтрокаТаблицы Из Элементы.Список.ВыделенныеСтроки Цикл
	//
	//	ВыделенныеСтроки.Добавить(СтрокаТаблицы);	
	//
	//КонецЦикла; 
	СуммаИтого = дт_ОбщегоНазначенияВызовСервера.ПолучитьСуммуДокументов(Элементы.Список.ВыделенныеСтроки);	

КонецПроцедуры // ОбновитьСуммуИтого()

&НаСервере
Процедура УстановитьВидимость()
	
	ИспользоватьЗаказНарядВнутренний = ПолучитьФункциональнуюОпцию("дт_ИспользоватьЗаказНарядВнутренний");
	ИспользоватьАвтосервис = ИспользоватьЗаказНарядВнутренний ИЛИ ПолучитьФункциональнуюОпцию("дт_ИспользоватьАвтосервис");
	
	Элементы.Организация.Видимость = ИспользоватьАвтосервис;
	Элементы.Клиент.Видимость = ИспользоватьАвтосервис;
	Элементы.Инициатор.Видимость = ИспользоватьЗаказНарядВнутренний;
	Элементы.НомерУПД.Видимость = ИспользоватьАвтосервис;
	Элементы.ДатаУПД.Видимость = ИспользоватьАвтосервис;
	Элементы.СостояниеРасчетов.Видимость = ИспользоватьАвтосервис;
	Элементы.ДнейДоОплаты.Видимость = ИспользоватьАвтосервис;
	Элементы.ВидОперации.Видимость = Ложь; //ИспользоватьАвтосервис И ИспользоватьЗаказНарядВнутренний;
	Элементы.СуммаДокумента.Видимость = ИспользоватьАвтосервис;
	Элементы.СуммаОплачено.Видимость = ИспользоватьАвтосервис;
	Элементы.СуммаРаботы.Видимость = ИспользоватьАвтосервис;
	Элементы.СуммаТовары.Видимость = ИспользоватьАвтосервис;
	Элементы.СуммаТоварыНаКомиссии.Видимость = ИспользоватьАвтосервис;
	Элементы.СуммаАгентские.Видимость = ИспользоватьАвтосервис;
	Элементы.КоличествоВремяПлан.Видимость = ИспользоватьЗаказНарядВнутренний;
	Элементы.КоличествоВремяФакт.Видимость = ИспользоватьЗаказНарядВнутренний;
	
	// Подвал
	Элементы.СуммаИтого.Видимость = ИспользоватьАвтосервис;
	
КонецПроцедуры 
	
&НаСервере
Процедура УстановитьУсловноеОформление()
	
		// СостояниеРасчетов
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "СостояниеРасчетов",
		ВидСравненияКомпоновкиДанных.Равно, ПредопределенноеЗначение(
			"Перечисление.СостоянияВзаиморасчетов.Долг"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоРозовый);
			
	// ДнейДоОплаты
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДнейДоОплаты");
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ВыделятьОтрицательные", Истина);
	
	
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	// Состояние ВРаботе
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "Состояние",
		ВидСравненияКомпоновкиДанных.Равно, ПредопределенноеЗначение(
			"Перечисление.СостоянияЗаказНаряда.ВРаботе"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоРозовый);
			 
	// Состояние Предварительный
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "Состояние",
		ВидСравненияКомпоновкиДанных.Равно, 
		ПредопределенноеЗначение("Перечисление.СостоянияЗаказНаряда.Предварительный")
	);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.БледноЗеленый);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудникиПриАктивизацииСтроки(Элемент)
	
	///+ГомзМА 03.10.2023
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьСуммуИтого();
	///-ГомзМА 03.10.2023
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодвал()

	///+ГомзМА 09.10.2023
	Схема = Элементы.СписокСотрудники.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
    Настройки = Элементы.СписокСотрудники.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
    МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиДата.ГоризонтальноеПоложениеВПодвале    	 		 = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиСуммаДокумента.ГоризонтальноеПоложениеВПодвале    	 = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиСуммаРаботы.ГоризонтальноеПоложениеВПодвале 	  	 = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиСуммаТовары.ГоризонтальноеПоложениеВПодвале 		 = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиКоличествоВремяПлан.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиКоличествоВремяФакт.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиКоличествоТоваров.ГоризонтальноеПоложениеВПодвале 	 = ГоризонтальноеПоложениеЭлемента.Право;
	
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиДата.ТекстПодвала 						 			 = Формат(Результат.Количество(),"ЧДЦ=0; ЧН=-");
    ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиСуммаДокумента.ТекстПодвала 						 = Формат(Результат.Итог("СуммаДокумента"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиСуммаРаботы.ТекстПодвала  							 = Формат(Результат.Итог("СуммаРаботы"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиСуммаТовары.ТекстПодвала     						 = Формат(Результат.Итог("СуммаТовары"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиКоличествоВремяПлан.ТекстПодвала 	    			 = Формат(Результат.Итог("КоличествоВремяПлан"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиКоличествоВремяФакт.ТекстПодвала 	    			 = Формат(Результат.Итог("КоличествоВремяФакт"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиКоличествоТоваров.ТекстПодвала 	    			 = Формат(Результат.Итог("КоличествоТоваров"),"ЧДЦ=0; ЧН=-");
	

	//Схема = Элементы.СписокСотрудникиИсполнители.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	//Настройки = Элементы.СписокСотрудникиИсполнители.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	//КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	//МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	//ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	//ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	//ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	//Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	//
	//ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиИсполнителиВремяФакт.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	//ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиИсполнителиВремяНорм.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	//
	//ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиИсполнителиВремяФакт.ТекстПодвала = Формат(Результат.Итог("ВремяФакт"),"ЧДЦ=0; ЧН=-");
	//ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиИсполнителиВремяНорм.ТекстПодвала = Формат(Результат.Итог("ВремяНорм"),"ЧДЦ=0; ЧН=-");
	
	//ВремяФактПодвал = 0;
	//ВремяНормПодвал = 0;
	//
	//Для каждого СтрокаТЧ Из СписокСотрудники Цикл
	//	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиИсполнителиВремяФакт.ТекстПодвала = ВремяФактПодвал + СтрокаТЧ.ВремяФакт;	
	//	ЭтотОбъект.ЭтаФорма.Элементы.СписокСотрудникиИсполнителиВремяНорм.ТекстПодвала = ВремяНормПодвал + СтрокаТЧ.ВремяНорм;
	//КонецЦикла;
	///-ГомзМА 09.10.2023

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудникиПриИзменении(Элемент)
	
	ЗаполнитьПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьПодвал();
	
КонецПроцедуры

	
#КонецОбласти


